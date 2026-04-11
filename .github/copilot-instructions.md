# Copilot Instructions — ME-REST-Store

## Big Picture Architecture

This repo is a **Mass Effect 3 ASI plugin** split into three loosely coupled layers:

1. **C++ ASI (`SFS_Core_ASI/`)** — the game injection layer. `SFSCoreASI.dll` (renamed `.asi`) hooks UE3's `ProcessEvent` via Microsoft Detours. On `DLL_PROCESS_ATTACH` it extracts and launches the Go sidecar, then initialises the WebView2 overlay.
2. **Go HTTP sidecar (`SFS_Core_ASI/SFSWebserver/`)** — a self-contained local server (`127.0.0.1:6060`). Compiled to `SFSWebserver.exe`, then **embedded as Windows resource `IDR_RESTSIDECAREXE` (ID 102)** inside the ASI via `SFSCoreASI.rc`. On first run, the ASI extracts it next to itself before launching.
3. **WebView2 overlay (`SFS_Core_ASI/OverlayHost.h/.cpp`)** — runs on its own dedicated thread. Creates a `WS_EX_TOPMOST | WS_EX_NOACTIVATE` popup window that renders `http://localhost:6060/spectreportal/`. The toggle tab appears after the first `IsPrivateMatch` ProcessEvent fires.

**Data flow:**
```
ME3 game → ProcessEvent hook → IsPrivateMatch → OverlayHost::ShowToggleOnly()
WebView2 browser → HTTP GET/POST/DELETE → SFSWebserver → BoltDB file
ASI C++ code → GET /store?key=&value= / /retrieve?key= / /delete?key= (raw KV store)
```

There are also two independent ASIs (`ME3ClientMessageExposer_v2/`, `OmniStore/`) that are unrelated to the sidecar/overlay feature. The `Dashboard/` folder is a third-party project used only as an asset/code reference — ignore it entirely.

---

## Build Workflows

### Go sidecar (primary development target)
```cmd
cd SFS_Core_ASI\SFSWebserver
go build -ldflags="-s -w" -o ../SFSWebserver.exe .
```
The VS Code task **"SFSWebserver: Build"** runs this automatically.

### Full plugin build (two manual steps — no automation between them)
1. Build the Go sidecar (above) → produces `SFS_Core_ASI/SFSWebserver.exe`.
2. Rebuild the Visual Studio solution (`FemShep-ME3-ASI-Plugins.sln`) — this picks up the new `.exe` and re-embeds it as resource `IDR_RESTSIDECAREXE` (ID 102) inside the ASI.

There is no script or build event linking the two steps; they must be run in order manually.

### C++ ASI
Open `FemShep-ME3-ASI-Plugins.sln` in Visual Studio. The `.asi` output is renamed from the built DLL via `DLL2ASI.bat` in the Release/Debug folders.

### WebView2 dependency
`OverlayHost.cpp` requires the WebView2 NuGet package (`packages/Microsoft.Web.WebView2.*`). The runtime must be installed on the player's machine; `IsWebView2RuntimeInstalled()` in `OverlayHost.cpp` guards initialization.

---

## Go Server Conventions

- **All UI API routes return HTML partials, not JSON.** HTMX fetches the fragment and swaps it into the DOM. Never add a JSON response for UI interactions.
- BoltDB bucket-per-entity: `sfs` (raw KV), `teams`, `bots`. Each bucket has its own Go file with the pattern `ensureXBucket` / `listX` / `createX` / `deleteX`.
- Entity IDs: 16-char random hex strings from `newID()` in `util.go`.
- `CharacterDef` is a **compile-time static catalog** in `characters.go` — never stored in the DB. Persisted `Bot.CharacterID` resolves at render time via `CharacterByID()`.
- All templates and static assets are embedded via `//go:embed` — no external files needed at runtime. Add new HTML files under `templates/partials/` and register the template name used by `ExecuteTemplate`.

## UI Template Conventions

- `spectreportal.html` is the full-page shell; all other `.html` files are HTMX partials.
- **Template names match the `define` block name**, not the filename (e.g., `{{define "team_list"}}` → called as `ExecuteTemplate(w, "team_list", ...)`).
- Alpine.js handles ephemeral local state only (active tab, modal open/close). HTMX handles all server round-trips.
- Styling uses Tailwind CSS utility classes via CDN with an ME3-themed palette (`me-blue: #00aaff`).

## Spectre Progression System (XP, Levels, Skill Points)

### Data model (`model/spectre.go`)
- `XP int` — cumulative XP total, persisted; starts at 0.
- `Level int` — current level, persisted; **always starts at 1** (never 0). `MigrateSkills()` upgrades old records with `Level == 0` to `Level = 1`.
- `SkillPoints int` — unspent points; starts at `InitialSkillPoints = 10`.
- `SkillLevels map[string]int` — keyed by `SkillDef.ID`; absent key means level 0.

### XP curve (`model/xp.go`)
- Level 1 starts at **100,000 XP**.
- XP required to move from level N to N+1: `round(250000 × 1.0157031729^(N−1))`.
- `XPForLevel(n int) int` — returns the total cumulative XP threshold to reach level n.
- `xpToNext(n int) int` — returns the XP gap between level n and n+1.
- `LevelForXP(xp int) int` — reverse lookup; returns 0 if XP < 100,000 (i.e. below level 1 threshold).

### Skill catalog (`model/spectreSkills.go`)
- 12 `SkillDef` entries: `Pistols`, `SMGs`, `AssaultRifles`, `Shotguns`, `SniperRifles`, `MeleeCombat`, `Gadgets`, `Tech`, `Biotics`, `Barrier` (BarrierOnly), `Shielding` (ShieldOnly), `SpectreTraining`.
- `MaxSkillLevel = 10` per skill. Each level costs 1 skill point.
- `BarrierOnly: true` / `ShieldOnly: true` — the UI conditionally shows one or the other based on the Spectre's `ShieldType`.
- The catalog is a compile-time static slice — never stored in DB. `SkillByID(id)` resolves at render time.

### Granting XP (`controllers/spectres.go`)
- `GrantXPToActive(db, xpAmount) (GrantXPResult, error)` — finds the active spectre, adds XP, recalculates level via `LevelForXP`, awards **1 skill point per level gained**, and persists.
- `GrantXPResult` carries `.Spectre` (updated) and `.LevelsGained int`.
- Returns `fmt.Errorf("no active spectre")` when nothing is active (caller maps to HTTP 404).

### ME3 integration endpoint
- `GET /grantXP?XP=<amount>` in `controllers/me3Integration/me3_integration_controller.go`.
- Returns JSON: `{ xp, level, levelsGained, skillPoints, xpToNextLevel }`.
- 400 for missing/non-positive XP, 404 for no active spectre, 500 for DB errors.

### UI (`controllers/spectre_skills.go` + `templates/partials/character_card_sheet.html`)
- `SkillView` / `SkillSegment` — view types built by `spectreSkillViews(s, spectreID)`.
- Each segment button fires `hx-post` to `/api/spectres/{id}/skill/{skillId}/set/{level}`.
- Routes also exist for `.../up` and `.../down` (delta ±1).
- Hover descriptions use `$store.tooltip.show(title, desc, $el)` — same pattern as power evolutions.
- Segment CSS: `.skill-segment`, `.skill-segment-filled` (green `rgb(76,225,125)`), `.skill-segment-empty`.
- The character name header always shows **"Level X"** in `#00aaff` blue alongside the name.

---

## C++ / Overlay Conventions

- **Never put C++ objects with destructors in the same function as `__try`** — see the `onAttach` / `onAttachImpl` split in `SFSCoreASI.cpp`.
- The overlay window uses `WS_EX_NOACTIVATE` to prevent stealing focus from the game's D3D window. Do not parent the overlay to the game HWND (breaks fullscreen).
- Overlay state is driven by `PostMessage` across threads — never call `ShowWindow` directly from the game thread.
- `g_overlayShown` is a `std::atomic<bool>` guarding the one-shot `ShowToggleOnly()` call on the first `IsPrivateMatch`.

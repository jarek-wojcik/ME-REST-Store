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

## C++ / Overlay Conventions

- **Never put C++ objects with destructors in the same function as `__try`** — see the `onAttach` / `onAttachImpl` split in `SFSCoreASI.cpp`.
- The overlay window uses `WS_EX_NOACTIVATE` to prevent stealing focus from the game's D3D window. Do not parent the overlay to the game HWND (breaks fullscreen).
- Overlay state is driven by `PostMessage` across threads — never call `ShowWindow` directly from the game thread.
- `g_overlayShown` is a `std::atomic<bool>` guarding the one-shot `ShowToggleOnly()` call on the first `IsPrivateMatch`.

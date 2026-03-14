# UI Development Context — SFSWebserver

This document summarises the full state of the Go HTTP sidecar's web UI so that
development can be resumed in a fresh session without losing context.

---

## 1. What the UI Is

A local web UI served at `http://127.0.0.1:6060/spectreportal/` by
`SFSWebserver.exe`.  It is a single-page app rendered inside the WebView2
overlay that the ASI injects over Mass Effect 3.  The UI manages **Strike Teams
of Bots** — each Bot has a selectable character portrait, a selectable weapon,
and (not yet implemented) a set of up to 5 powers with A/B evolution choices.

There are three tabs in the shell: **Spectre**, **Strike Teams**, and
**Mission Parameters**.  Only Strike Teams is functional; the other two are empty
placeholders.

---

## 2. Technology Stack

| Layer | Library | Version | Notes |
|---|---|---|---|
| Server | Go standard `net/http` | 1.22+ | Method-prefixed routes (`"GET /path/{id}"`), `r.PathValue()` |
| Templates | `html/template` | stdlib | All templates parsed as one shared set via `ParseFS` |
| Persistence | BoltDB `go.etcd.io/bbolt` | latest | Separate buckets per entity type |
| Asset embedding | `embed.FS` | stdlib | Both `templates/` and `static/` baked into binary |
| Frontend reactivity | Alpine.js | 3.14.8 (CDN) | Ephemeral local state only (tab switching, modal open/close) |
| Server interactions | HTMX | 2.0.4 (CDN) | Every server round-trip — `hx-get/post/delete`, `hx-target`, `hx-swap` |
| Styling | Tailwind CSS | CDN | Custom ME3 theme colours configured inline |

**Tailwind custom palette:**

```js
colors: {
    'me-blue':   '#00aaff',
    'me-dark':   '#0a0e1a',
    'me-panel':  '#111827',
    'me-border': '#1e3a5f',
    'me-accent': '#0d47a1',
}
```

---

## 3. Source File Inventory

All files live under `SFS_Core_ASI/SFSWebserver/`.

### Go source files

| File | Purpose |
|---|---|
| `SFSWebserver.go` | Entry point, route registration, render helpers, legacy `/store` / `/retrieve` / `/delete` KV API |
| `teams.go` | `Team` struct, BoltDB CRUD (`listTeams`, `createTeam`, `deleteTeam`, `ensureTeamsBucket`) |
| `bots.go` | `Bot` struct, `BotView`, BoltDB CRUD (`listBotsForTeam`, `createBot`, `updateBotCharacter`, `updateBotWeapon`, `deleteBot`, `botViews()`) |
| `characters.go` | Static `CharacterDef` catalog (56 entries), `CharacterByID()`, plus the `Bot` / `PowerSlot` types |
| `weapons.go` | Static `WeaponDef` catalog (63 entries across 5 categories), `WeaponByID()` |
| `util.go` | Shared `newID()` — generates a 16-char random hex string used as entity IDs |

### Key types

```go
// Persisted in BoltDB:
type Team struct {
    ID   string `json:"id"`
    Name string `json:"name"`
}

type Bot struct {
    ID          string      `json:"id"`
    TeamID      string      `json:"teamId"`
    CharacterID string      `json:"characterId"` // references CharacterDef.ID
    WeaponID    string      `json:"weaponId"`     // references WeaponDef.ID; "" = none
    Powers      []PowerSlot `json:"powers"`       // up to 5 slots (not yet used in UI)
}

type PowerSlot struct {
    PowerID   string    `json:"powerId"`
    Evolution [3]string `json:"evolution"` // each: "A" or "B" per rank
}

// Compile-time static catalogs (NOT stored in BoltDB):
type CharacterDef struct {
    ID          string // e.g. "AdeptHumanMale"
    Name        string // e.g. "Human Adept Male"
    PictureFile string // filename in /static/assets/characters/
}

type WeaponDef struct {
    ID          string // e.g. "Pistol_Carnifex"
    Name        string // e.g. "M-6 Carnifex"
    Category    string // "Pistol", "Assault Rifle", "Shotgun", "SMG", "Sniper Rifle"
    PictureFile string // filename in /static/assets/weapons/
}

// Render-time view models (never persisted):
type BotView struct {
    Bot
    CharDef   *CharacterDef
    WeaponDef *WeaponDef // nil when WeaponID == ""
}
```

### BoltDB buckets

| Bucket key | Stores |
|---|---|
| `"sfs"` | Legacy raw KV pairs (used by C++ ASI via `/store` / `/retrieve` / `/delete`) |
| `"teams"` | JSON-encoded `Team` values, keyed by `Team.ID` |
| `"bots"` | JSON-encoded `Bot` values, keyed by `Bot.ID`; no index — team filtered by full scan |

### Embed directives

```go
//go:embed templates
var templateFS embed.FS

//go:embed static
var staticFS embed.FS
```

Static assets are served at `/static/` via `fs.Sub` + `http.FS`:

```go
staticSub, _ := fs.Sub(staticFS, "static")
http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.FS(staticSub))))
```

---

## 4. Template Architecture

Templates are parsed as **one shared set** so partials can call each other:

```go
tmpl := template.Must(template.New("").ParseFS(templateFS,
    "templates/*.html",
    "templates/partials/*.html",
))
```

Each file uses a `{{define "name"}}` block.  The name is what
`ExecuteTemplate(w, "name", data)` references.

### Template inventory

| File | Define name | Purpose |
|---|---|---|
| `templates/spectreportal.html` | `spectreportal` | Full page shell — `<html>`, CDN scripts, tab bar, tab panels, modal overlay |
| `templates/partials/team_list.html` | `team_list` | Teams sidebar + bot panel layout; HTMX swap target `#teams-panel` (outerHTML) |
| `templates/partials/bot_panel.html` | `bot_panel` | Vertical list of bot cards + Add Bot dashed button; swap target `#bot-panel` (innerHTML) |
| `templates/partials/bot_card.html` | `bot_card` | Single bot card; horizontal layout: portrait column + right section; swap target `#bot-card-{id}` (outerHTML) |
| `templates/partials/character_selector.html` | `character_selector` | Modal content — 3-column grid of character portraits; injected into `#modal-body` (innerHTML) |
| `templates/partials/weapon_selector.html` | `weapon_selector` | Modal content — 3-column grid of weapons (image + name + category); injected into `#modal-body` (innerHTML) |

### Modal pattern

`spectreportal.html` defines a modal overlay using Alpine.js state:

```html
<div x-data="{ activeTab: 'spectre', modalOpen: false }"
     @keydown.escape.window="modalOpen=false">

    <!-- ... tabs ... -->

    <!-- Modal backdrop -->
    <div x-show="modalOpen" x-cloak
         class="fixed inset-0 z-50 ..."
         @click.self="modalOpen=false">

        <!-- Modal panel   h-[80vh] is critical for scroll to work -->
        <div class="... flex flex-col h-[80vh]">
            <div id="modal-body" class="overflow-y-auto flex-1 min-h-0">
                <!-- HTMX injects either character_selector or weapon_selector here -->
            </div>
        </div>
    </div>
</div>
```

**Critical:** `h-[80vh]` on the panel establishes a fixed height so that
`overflow-y-auto` on the inner div actually scrolls.  `min-h-0` on the inner div
prevents flex children from overflowing their parent.  (`max-h` alone does not
work for this pattern.)

Opening a selector:

```html
<!-- on the portrait button inside bot_card -->
hx-get="/api/characters/selector?botId={{.Bot.ID}}"
hx-target="#modal-body"
hx-swap="innerHTML"
@click="modalOpen=true"
```

Selecting an item closes the modal by adding `@click="modalOpen=false"` directly
on each selector item, then HTMX replaces `#bot-card-{id}` (outerHTML) with the
updated card returned by the server.

---

## 5. HTTP API

All UI endpoints return **HTML partials**, never JSON.

| Method | Path | Returns |
|---|---|---|
| `GET` | `/spectreportal/` | Full page (`spectreportal` template) |
| `GET` | `/static/*` | Embedded static assets |
| `GET` | `/api/teams` | `team_list` partial |
| `POST` | `/api/teams` | `team_list` partial (after create); form field: `name` |
| `DELETE` | `/api/teams/{id}` | `team_list` partial (after delete) |
| `GET` | `/api/teams/{id}/bots` | `bot_panel` partial |
| `POST` | `/api/teams/{id}/bots` | `bot_panel` partial (after add default bot) |
| `DELETE` | `/api/bots/{id}` | Empty 200 (HTMX outerHTML swap removes the card) |
| `GET` | `/api/characters/selector?botId={id}` | `character_selector` partial |
| `POST` | `/api/bots/{id}/character/{charId}` | `bot_card` partial (updated card) |
| `GET` | `/api/weapons/selector?botId={id}` | `weapon_selector` partial |
| `POST` | `/api/bots/{id}/weapon/{weaponId}` | `bot_card` partial (updated card) |
| `GET` | `/health` | `ok\n` text |
| `GET` | `/store?key=&value=` | Legacy KV write |
| `GET` | `/retrieve?key=` | Legacy KV read |
| `GET` | `/allKeys` | Legacy KV list |
| `GET` | `/delete?key=` | Legacy KV delete |

### Render helpers

Three closures inside `main()` centralise partial rendering:

```go
renderTeams(w http.ResponseWriter)
renderBotPanel(w http.ResponseWriter, teamID string)
renderBotCard(w http.ResponseWriter, bot Bot)   // resolves CharDef + WeaponDef from catalogs
```

---

## 6. Static Assets

```
static/
  assets/
    characters/   56 × *.webp   — character portraits (e.g. AdeptHumanMale.webp)
    weapons/      63 × *.webp   — weapon images, organised as flat files with category prefix
                                   e.g. Pistol_Carnifex.webp, AssaultRifle_M96Mattock.webp
```

URL pattern:
- Characters: `/static/assets/characters/{CharacterDef.PictureFile}`
- Weapons: `/static/assets/weapons/{WeaponDef.PictureFile}`

Convenience methods on each catalog type:

```go
func (c CharacterDef) PictureURL() string { return "/static/assets/characters/" + c.PictureFile }
func (w WeaponDef)    PictureURL() string { return "/static/assets/weapons/"    + w.PictureFile }
```

---

## 7. Build

```cmd
cd SFS_Core_ASI\SFSWebserver
go build -ldflags="-s -w" -o ../SFSWebserver.exe .
```

- Output lands in `SFS_Core_ASI/SFSWebserver.exe` (alongside `SFSCoreASI.cpp`).
- The VS Code task **"SFSWebserver: Build"** (`.vscode/tasks.json`) runs this command automatically and is the default build task.
- The `go-build` script in the same folder runs the same command.
- After building the Go binary, the Visual Studio solution (`FemShep-ME3-ASI-Plugins.sln`) must be rebuilt separately — it picks up the new `.exe` and re-embeds it as Windows resource `IDR_RESTSIDECAREXE` (ID 102) inside `SFSCoreASI.dll`.

---

## 8. HTMX Swap Patterns Summary

| What changes | `hx-target` | `hx-swap` |
|---|---|---|
| Whole team sidebar (team added/deleted) | `#teams-panel` | `outerHTML` |
| Bot list inside selected team | `#bot-panel` | `innerHTML` |
| Single bot card (character or weapon changed) | `#bot-card-{id}` | `outerHTML` |
| Modal inner content (selector opened) | `#modal-body` | `innerHTML` |

---

## 9. What Is Not Yet Implemented

### Powers (highest priority next step)

Per the original `Bot UI.md` spec, each bot has 1–5 power slots.  Each
`PowerSlot` stores a `PowerID` and an `Evolution [3]string` (each element `"A"`
or `"B"` for ranks 1–3).

The `PowerSlot` type already exists in `characters.go` and `Bot.Powers
[]PowerSlot` is stored in BoltDB, but:

- There is **no `PowerDef` catalog** — needs to be created (powers per character,
  with picture file, name, and brief description of the A/B branches per rank).
- There is **no power slot UI** on the bot card.
- There is **no power selector modal**.

**Planned selector flow (two-step modal):**
1. User clicks a power slot picture → modal shows the character-list grid.
2. User clicks a character → modal replaces with that character's power list.
3. User clicks a power → modal closes, bot card re-renders with the new power.

### Spectre tab

Content placeholder only.  Intended for character management (Armor, Spectre
Weapon Mods, character-level passive powers).

### Mission Parameters tab

Content placeholder only.

---

## 10. Known Design Decisions and Pitfalls

- **All UI routes return HTML, never JSON.** HTMX fragments are the contract.
  Do not add JSON responses for UI interactions.

- **Catalog data is never stored in BoltDB.** Only IDs are stored (`CharacterID`,
  `WeaponID`, `PowerID`).  Catalog data is resolved at render time via `CharacterByID()`,
  `WeaponByID()`, etc.

- **Template names must match the `{{define}}` block**, not the filename.
  `ExecuteTemplate(w, "team_list", ...)` maps to `{{define "team_list"}}`.

- **`h-[80vh]` on the modal panel is not optional.** Changing it to `max-h-[80vh]`
  breaks scrolling in the selector grids because flex children won't shrink below
  their natural size without an explicit height anchor.

- **`min-h-0` on flex children that need to scroll** is required for the same
  reason.

- **Alpine.js manages only local/ephemeral state** (which tab is active, whether
  the modal is open).  All persistent state goes through HTMX + the Go server.

- **`WS_EX_NOACTIVATE` means no keyboard in WebView2 by default.**  The overlay
  window intentionally never activates (to avoid minimising ME3 in exclusive
  fullscreen).  See `KEYBOARD_BUG_CONTEXT.md` in this folder — the fix is
  `ICoreWebView2Controller::MoveFocus(COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC)`
  after showing the overlay.

- **Bot card delete returns an empty 200.**  HTMX replaces the card element
  (`hx-swap="outerHTML"`) with empty content, which removes it from the DOM.
  No partial re-render of the whole panel is needed.

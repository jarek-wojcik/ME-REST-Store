# Spectre UI — WIP State

> Machine-optimized reference. Describes all changes introduced to add the Spectre dashboard and decouple the shared card template from bot-specific routing.

---

## Motivation

`bot_card.html` and the three selector partials (`character_selector`, `weapon_selector`, `weapon_mod_selector`) originally hard-coded `/api/bots/{id}/...` paths and `#bot-card-{id}` element IDs. The Spectre entity reuses the same card template. All routing was lifted out of templates into pre-computed Go fields.

---

## New / Changed Files

### `model/spectre.go` *(new)*
```go
type Spectre struct {
    ID           string      `json:"id"`
    Name         string      `json:"name"`
    CharacterID  string      `json:"characterId"`
    WeaponID     string      `json:"weaponId"`
    WeaponMod1ID string      `json:"weaponMod1Id"`
    WeaponMod2ID string      `json:"weaponMod2Id"`
    Powers       []PowerSlot `json:"powers"`
}
```
Structurally identical to `Bot` (minus `TeamID`). Stored in BoltDB bucket `"spectres"`.

---

### `bots.go` *(changed)*

#### `CardURLs` struct — shared by `BotView` and `SpectreView`
```go
type CardURLs struct {
    CardID            string // e.g. "bot-card-abc" or "spectre-card-abc"
    DeleteURL         string // DELETE endpoint
    DeleteConfirm     string // hx-confirm message text
    CharSelectorURL   string // GET opens character selector modal
    WeaponSelectorURL string // GET opens weapon selector modal
    Mod1SelectorURL   string // GET opens mod slot 1 selector modal
    Mod2SelectorURL   string // GET opens mod slot 2 selector modal
    PowerBaseURL      string // prefix: /api/{bots|spectres}/{id}/power
}
```
Embedded (not named field) in both `BotView` and `SpectreView`.

#### `PowerSlotView` — added field
```go
SlotBaseURL string  // e.g. "/api/bots/abc/power/0"
```
Computed by `powerViews(slots []PowerSlot, powerBaseURL string)` — signature changed to accept `powerBaseURL`.

#### `botURLs(botID string) CardURLs`
```
CardID:            "bot-card-{id}"
DeleteURL:         "/api/bots/{id}"
DeleteConfirm:     "Remove this bot?"
CharSelectorURL:   "/api/characters/selector?entityId={id}&kind=bot"
WeaponSelectorURL: "/api/weapons/selector?entityId={id}&kind=bot"
Mod1SelectorURL:   "/api/weapon-mods/selector?entityId={id}&kind=bot&slot=1"
Mod2SelectorURL:   "/api/weapon-mods/selector?entityId={id}&kind=bot&slot=2"
PowerBaseURL:      "/api/bots/{id}/power"
```

---

### `spectres.go` *(new)*

#### `SpectreView`
```go
type SpectreView struct {
    model.Spectre
    CharDef       *model.CharacterDef
    WeaponDef     *model.WeaponDef
    WeaponMod1Def *model.WeaponModDef
    WeaponMod2Def *model.WeaponModDef
    PowerViews    []PowerSlotView
    CardURLs                          // embedded
}
```

#### `spectreURLs(spectreID string) CardURLs`
```
CardID:            "spectre-card-{id}"
DeleteURL:         "/api/spectres/{id}"
DeleteConfirm:     "Remove this spectre?"
CharSelectorURL:   "/api/characters/selector?entityId={id}&kind=spectre"
WeaponSelectorURL: "/api/weapons/selector?entityId={id}&kind=spectre"
Mod1SelectorURL:   "/api/weapon-mods/selector?entityId={id}&kind=spectre&slot=1"
Mod2SelectorURL:   "/api/weapon-mods/selector?entityId={id}&kind=spectre&slot=2"
PowerBaseURL:      "/api/spectres/{id}/power"
```

#### DB functions (bucket `"spectres"`)
| Function | Signature |
|---|---|
| `ensureSpectresBucket` | `(db) error` |
| `listSpectres` | `(db) ([]Spectre, error)` |
| `getSpectre` | `(db, id) (Spectre, error)` |
| `createSpectre` | `(db, name) (Spectre, error)` — defaults to `AdeptHumanMale` |
| `deleteSpectre` | `(db, id) (bool, error)` |
| `updateSpectreCharacter` | `(db, id, charID) (Spectre, error)` — resets powers |
| `updateSpectreWeapon` | `(db, id, weaponID) (Spectre, error)` |
| `updateSpectreWeaponMod` | `(db, id, slot, modID) (Spectre, error)` |
| `updateSpectrePowerRank` | `(db, id, slotIdx, rank) (Spectre, error)` |
| `updateSpectrePowerEvolution` | `(db, id, slotIdx, evoIdx, choice) (Spectre, error)` |
| `updateSpectrePowerRankAndEvo` | `(db, id, slotIdx, rank, evoIdx, choice) (Spectre, error)` |
| `spectreViews` | `([]Spectre) []SpectreView` |

---

### `SFSWebserver.go` *(changed)*

#### Bucket init
`ensureSpectresBucket(db)` called at startup alongside bots/teams.

#### New render helpers
- `renderSpectreCard(w, Spectre)` — executes `"bot_card"` template with a `SpectreView`
- `renderSpectreList(w)` — executes `"spectre_list"` template with `map["Spectres"]spectreViews(...)`

#### Selector handlers — breaking changes
All three selectors now use `entityId` + `kind` query params instead of `botId`:

| Handler | Old params | New params |
|---|---|---|
| `GET /api/characters/selector` | `?botId=` | `?entityId=&kind=` |
| `GET /api/weapons/selector` | `?botId=` | `?entityId=&kind=` |
| `GET /api/weapon-mods/selector` | `?botId=&slot=` | `?entityId=&kind=&slot=` |

`kind` values: `"bot"` (default), `"spectre"`. Weapon-mod selector fetches weapon ID from the appropriate bucket based on `kind`.

Template data keys changed:
- Character selector: `BotID` → `CharPostURLBase`, `TargetID`
- Weapon selector: `BotID` → `WeaponPostURLBase`, `TargetID`
- Weapon mod selector: `BotID`/`Slot` → `ModPostURLBase`, `ModClearURL`, `TargetID`, `Slot`

#### New spectre routes
| Method | Path | Response |
|---|---|---|
| `GET` | `/api/spectres` | `spectre_list` partial (full panel) |
| `POST` | `/api/spectres` | form: `name`; returns `spectre_list` |
| `DELETE` | `/api/spectres/{id}` | returns `spectre_list` |
| `GET` | `/api/spectres/{id}/card` | `bot_card` partial for this spectre |
| `POST` | `/api/spectres/{id}/character/{charId}` | returns `bot_card` |
| `POST` | `/api/spectres/{id}/weapon/{weaponId}` | returns `bot_card` |
| `POST` | `/api/spectres/{id}/mod/{slot}/{modId}` | `slot` 1\|2; `modId` "none" clears; returns `bot_card` |
| `POST` | `/api/spectres/{id}/power/{slot}/rank/{rank}` | returns `bot_card` |
| `POST` | `/api/spectres/{id}/power/{slot}/evo/{evoIdx}/{choice}` | returns `bot_card` |
| `POST` | `/api/spectres/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}` | returns `bot_card` |

---

### Templates *(changed)*

#### `templates/partials/bot_card.html`
All hard-coded `/api/bots/...` paths and `#bot-card-{id}` IDs replaced with `CardURLs` fields:

| Was | Now |
|---|---|
| `id="bot-card-{{.Bot.ID}}"` | `id="{{.CardID}}"` |
| `hx-delete="/api/bots/{{.Bot.ID}}"` | `hx-delete="{{.DeleteURL}}"` |
| `hx-confirm="Remove this bot?"` | `hx-confirm="{{.DeleteConfirm}}"` |
| `hx-get="/api/characters/selector?botId=..."` | `hx-get="{{.CharSelectorURL}}"` |
| `hx-get="/api/weapons/selector?botId=..."` | `hx-get="{{.WeaponSelectorURL}}"` |
| `hx-get="/api/weapon-mods/selector?botId=...&slot=1"` | `hx-get="{{.Mod1SelectorURL}}"` |
| `hx-get="/api/weapon-mods/selector?botId=...&slot=2"` | `hx-get="{{.Mod2SelectorURL}}"` |
| `hx-target="#bot-card-{{$.Bot.ID}}"` (all power buttons) | `hx-target="#{{$.CardID}}"` |
| `/api/bots/{id}/power/{slot}/rank/...` | `{{$pv.SlotBaseURL}}/rank/...` |
| `/api/bots/{id}/power/{slot}/rankevo/...` | `{{$pv.SlotBaseURL}}/rankevo/...` |

Template name `"bot_card"` is unchanged — it now renders both bots and spectres.

#### `templates/partials/character_selector.html`
- Removed `{{$botID := $.BotID}}` capture variable
- `hx-post="/api/bots/{{$botID}}/character/{{.ID}}"` → `hx-post="{{$.CharPostURLBase}}/{{.ID}}"`
- `hx-target="#bot-card-{{$botID}}"` → `hx-target="#{{$.TargetID}}"`

#### `templates/partials/weapon_selector.html`
- Removed `{{$botID := $.BotID}}`
- `hx-post="/api/bots/{{$botID}}/weapon/{{.ID}}"` → `hx-post="{{$.WeaponPostURLBase}}/{{.ID}}"`
- `hx-target="#bot-card-{{$botID}}"` → `hx-target="#{{$.TargetID}}"`

#### `templates/partials/weapon_mod_selector.html`
- Clear button: `hx-post="/api/bots/{{$.BotID}}/mod/{{$.Slot}}/none"` → `hx-post="{{$.ModClearURL}}"`
- Mod button: `hx-post="/api/bots/{{$.BotID}}/mod/{{$.Slot}}/{{.ID}}"` → `hx-post="{{$.ModPostURLBase}}/{{.ID}}"`
- Both targets: `#bot-card-{{$.BotID}}` → `#{{$.TargetID}}`

#### `templates/partials/spectre_list.html` *(new)*
Defines template `"spectre_list"`. Renders full `#spectres-panel` div with:
- Left `<aside>` (w-48): add-spectre form, scrollable list of `SpectreView` rows (name + CharDef.Name subtitle, delete button via `hx-delete`)
- Each row: `hx-get="/api/spectres/{id}/card"` targets `#spectre-card-panel`
- Right `#spectre-card-panel`: empty-state placeholder until a row is clicked
- Template data: `map["Spectres"][]SpectreView`

#### `templates/spectreportal.html`
Spectre tab `div` now contains:
```html
<div hx-get="/api/spectres" hx-trigger="load" hx-swap="outerHTML">…</div>
```
Replaced the `"— Content coming soon —"` placeholder.

---

## Invariants

- `"bot_card"` template is the single card renderer for both bots and spectres. Do not create a `"spectre_card"` template.
- `SpectreView` must satisfy all fields accessed by `"bot_card"`: `CardID`, `DeleteURL`, `DeleteConfirm`, `CharSelectorURL`, `WeaponSelectorURL`, `Mod1SelectorURL`, `Mod2SelectorURL`, all `*Def` fields, `PowerViews[]` with `SlotBaseURL`.
- The weapon-mod selector uses `kind` to look up the correct bucket; add new entity kinds there if adding future entity types.
- `powerViews(slots, powerBaseURL)` is the single source of `SlotBaseURL` — do not compute it elsewhere.

---

## Phase 2 — Borrowed Power & Per-Slot Power Change *(added session 2)*

### Motivation
Spectres are player operatives that can take one power from any character class (borrowed power) and can freely swap any of their five base powers. Bots have fixed powers (no swap, no borrow). All new UI is gated by `IsSpectre bool` on `CardURLs` / `ChangePowerURL string` on `PowerSlotView` so `"bot_card"` remains the single renderer for both entity types.

---

### `model/spectre.go` *(changed)*
Added field:
```go
BorrowedPower *PowerSlot `json:"borrowedPower,omitempty"`
```
`omitempty` — existing DB records deserialise without error. `nil` = no borrowed power set.

---

### `bots.go` *(changed)*

#### `CardURLs` — new fields
```go
IsSpectre             bool   // gates borrow/change UI in bot_card
HasBorrowedPower      bool   // true when BorrowedPower != nil; hides the Add button
AddPowerURL           string // GET /api/spectres/{id}/borrowed-power/selector
ClearBorrowedPowerURL string // DELETE /api/spectres/{id}/borrowed-power
```

#### `PowerSlotView` — new field
```go
IsBorrowedPower bool   // true for the appended borrowed-power entry
ChangePowerURL  string // GET: opens change-power flow for this slot; empty for bots
```

---

### `spectres.go` *(changed)*

#### `spectreURLs()` — new CardURLs fields populated
```
IsSpectre:             true
AddPowerURL:           "/api/spectres/{id}/borrowed-power/selector"
ClearBorrowedPowerURL: "/api/spectres/{id}/borrowed-power"
```
`HasBorrowedPower` is set **after** calling `spectreURLs()` at both call sites (`renderSpectreCard`, `spectreViews`) as `urls.HasBorrowedPower = s.BorrowedPower != nil`.

#### `spectrePowerViews(s Spectre, urls CardURLs) []PowerSlotView` *(new, replaces inline powerViews call)*
- Calls `powerViews(s.Powers, urls.PowerBaseURL)` for normal slots.
- Sets `ChangePowerURL = /api/spectres/{id}/power/{slotIdx}/change/selector` on each normal slot.
- If `s.BorrowedPower != nil`, appends one extra `PowerSlotView` with:
  - `SlotBaseURL     = "/api/spectres/{id}/borrowed-power"` (rank/rankevo routes work unchanged)
  - `IsBorrowedPower = true`
  - `ChangePowerURL  = "/api/spectres/{id}/borrowed-power/selector"` (re-enters borrow flow to replace)

#### New DB functions
| Function | Signature | Notes |
|---|---|---|
| `updateSpectrePowerID` | `(db, id, slotIdx, powerID) (Spectre, error)` | Replaces `Powers[slotIdx]` with `DefaultPower(powerID)` (rank 0, evo AAA) |
| `addSpectreBorrowedPower` | `(db, id, powerID) (Spectre, error)` | Sets/replaces `BorrowedPower` with `DefaultPower(powerID)` |
| `clearSpectreBorrowedPower` | `(db, id) (Spectre, error)` | Sets `BorrowedPower = nil` |
| `updateSpectreBorrowedPowerRank` | `(db, id, rank) (Spectre, error)` | Sets `BorrowedPower.Rank` |
| `updateSpectreBorrowedPowerRankAndEvo` | `(db, id, rank, evoIdx, choice) (Spectre, error)` | Atomically sets rank + evo on `BorrowedPower` |

---

### `SFSWebserver.go` *(changed)*

#### Startup logging
- `setupLogging()` opens `SFSWebserver.log` beside the exe and tees all `log.*` output to both file and stdout.
- All `panic(err)` replaced with `log.Fatalf("[FATAL] ...")`.
- `template.Must(...)` replaced with explicit parse + `log.Fatalf` that prints the failing template name and line.
- `ListenAndServe` error is now fatal-logged instead of silently ignored.
- Step-by-step `[INFO]` messages: args, db path+port, DB open, buckets ready, templates parsed, listening address.

#### New routes — borrowed power
| Method | Path | Handler |
|---|---|---|
| `GET` | `/api/spectres/{id}/borrowed-power/selector` | renders `spectre_borrow_char` with `Heading="Borrow a Power"`, `FromCharURLBase=/api/spectres/{id}/borrowed-power` |
| `GET` | `/api/spectres/{id}/borrowed-power/from-char/{charId}` | renders `spectre_borrow_power` with `PostURLBase=.../borrowed-power/add`, `TargetCardID=spectre-card-{id}` |
| `POST` | `/api/spectres/{id}/borrowed-power/add/{powerID}` | calls `addSpectreBorrowedPower`; returns card |
| `DELETE` | `/api/spectres/{id}/borrowed-power` | calls `clearSpectreBorrowedPower`; returns card |
| `POST` | `/api/spectres/{id}/borrowed-power/rank/{rank}` | calls `updateSpectreBorrowedPowerRank`; returns card |
| `POST` | `/api/spectres/{id}/borrowed-power/rankevo/{rank}/{evoIdx}/{choice}` | calls `updateSpectreBorrowedPowerRankAndEvo`; returns card |

#### New routes — per-slot change
| Method | Path | Handler |
|---|---|---|
| `GET` | `/api/spectres/{id}/power/{slot}/change/selector` | renders `spectre_borrow_char` with `Heading="Change Power"`, `FromCharURLBase=/api/spectres/{id}/power/{slot}/change` |
| `GET` | `/api/spectres/{id}/power/{slot}/change/from-char/{charId}` | renders `spectre_borrow_power` with `PostURLBase=.../change/set`, `TargetCardID=spectre-card-{id}`, `BackURL` → change selector |
| `POST` | `/api/spectres/{id}/power/{slot}/change/set/{powerID}` | calls `updateSpectrePowerID`; returns card |

---

### Templates *(changed/new)*

#### `templates/partials/bot_card.html` *(changed)*
Power name column is now a flex-col div instead of a bare `<span>`. Additional conditional elements rendered when `$pv.IsBorrowedPower` or `$pv.ChangePowerURL != ""`:

```
[Power Name]
[Borrowed]           ← only if IsBorrowedPower
[Remove]             ← only if IsBorrowedPower; hx-delete ClearBorrowedPowerURL
[Change]             ← only if ChangePowerURL != "" (spectres only); hx-get ChangePowerURL → modal
```

"Borrow Power" `+` button after the powers grid: rendered only when `{{if and .IsSpectre (not .HasBorrowedPower)}}` — disappears once a borrowed power is set.

#### `templates/partials/spectre_borrow_char.html` *(new — generic character picker)*
Template `"spectre_borrow_char"`. Accepts:
- `Heading string` — displayed as modal title ("Borrow a Power" or "Change Power")
- `FromCharURLBase string` — each character button does `hx-get="{{$.FromCharURLBase}}/from-char/{{.ID}}"` → loads power picker
- `Groups []CharacterGroup` — same grouped-character data as `character_selector`

Renders the same tabbed character grid as `character_selector` but stays in-modal (no `@click="modalOpen=false"`).

#### `templates/partials/spectre_borrow_power.html` *(new — generic power picker)*
Template `"spectre_borrow_power"`. Accepts:
- `CharDef *CharacterDef` — character portrait + name in header
- `Powers []*PowerDef` — the 5 powers for the chosen character
- `BackURL string` — back-chevron button `hx-get` target (returns to character picker)
- `PostURLBase string` — each power button does `hx-post="{{$.PostURLBase}}/{{.ID}}"` → commits selection
- `TargetCardID string` — `hx-target="#{{$.TargetCardID}}"` on each power button

Power icon: `w-16 h-16` div with `background-size:384px 128px; background-position:0px 0px` — matches the rank-1 tile from `bot_card.html` exactly.

---

## Updated Invariants

- `spectrePowerViews(s, urls)` is the single source of `PowerSlotView` for spectres. Never call `powerViews(s.Powers, ...)` directly for a spectre.
- `HasBorrowedPower` must be set on `urls` **after** `spectreURLs()` at every `renderSpectreCard` call site and inside `spectreViews()`.
- `spectre_borrow_char` and `spectre_borrow_power` are generic — they serve both the borrow flow and the change-slot flow. Do not hard-code entity IDs or route prefixes inside them; all routing comes from template data.
- The borrowed-power slot's rank/evo buttons use the same `SlotBaseURL`-based paths as normal slots. The only difference is `SlotBaseURL = /api/spectres/{id}/borrowed-power` instead of `.../power/{n}`.
- `updateSpectrePowerID` resets rank and all evolutions to defaults. The UI shows rank 0 immediately after a slot change.
- `ChangePowerURL` is empty (`""`) for all bot `PowerSlotView` entries. The `{{if $pv.ChangePowerURL}}` guard in `bot_card.html` ensures the Change button is never rendered for bots.

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

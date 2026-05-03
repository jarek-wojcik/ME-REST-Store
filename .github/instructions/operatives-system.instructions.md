---
applyTo: "**/spectre*.go, **/spectre*.html, **/character_card*.html"
---

# Operatives System — Technical Reference

## Overview

Operatives (internally "spectres") are standalone player-character loadouts. Each operative has a name, a chosen ME3 character class, skill levels, power builds, weapons, consumables, and XP/level progression. They exist independently of strike teams — an operative can be assigned to at most one team, but lives in the global roster.

---

## Data Model

**File:** `model/spectre.go`

```
Spectre {
  ID                    string       // 16-char random hex
  Name                  string
  CharacterID           string       // CharacterDef.ID (e.g. "AdeptHumanMale")
  AppearanceCharacterID string       // visual-only override portrait
  AppearancePawnType    PawnType     // pawn type from the appearance character
  VoiceCharacterID      string       // qualified voice archetype path
  VoiceKitID            string       // KitName used by ME3
  HeavyMeleeCharID      string       // qualified heavy-melee archetype path
  LightMeleeCharID      string       // qualified light-melee archetype path
  DodgeCharID           string       // qualified dodge archetype path
  ShieldType            string       // "Shield" | "Barrier" (empty = Shield)
  Weapons               []WeaponSlot // up to 5 slots
  ArmorConsumableID     string
  WeaponConsumableID    string
  AmmoConsumableID      string
  GearConsumableID      string
  Powers                []PowerSlot  // 5 slots (0–4)
  BorrowedPower         *PowerSlot   // optional 6th power from another class
  UseHelmet             bool
  UseHeadgear           bool
  PreferredSpecies      string       // filters appearance selector
  Active                bool         // at most one operative is active
  XP                    int          // cumulative XP
  Level                 int          // 1-based; never 0 (migrated via MigrateSkills)
  SkillLevels           map[string]int
  SkillPoints           int
  SkillCapstoneChoices  map[string]map[string]int
  TeamID                string       // empty = standalone; non-empty = in a team
  SortOrder             int64        // unix nanoseconds at creation time; newest-first ordering
}
```

**Default values on creation (`createSpectre`):**
- `SortOrder = time.Now().UnixNano()` — ensures newest operatives always appear first
- `Powers` = 5 empty `PowerSlot{}` values
- `Level = 1`, `SkillPoints = model.InitialSkillPoints`
- `SkillLevels = make(map[string]int)`
- `PreferredSpecies = "Human"`

---

## Persistence

BoltDB bucket: `spectres`

Key = `Spectre.ID` (16-char hex). Values are JSON-encoded `Spectre` structs.

**Read helpers (`controllers/spectres.go`):**
- `listSpectres(db)` — standalone spectres only (`TeamID == ""`), sorted **newest first** by `SortOrder` descending.
- `listSpectresForTeam(db, teamID)` — team members only, sorted by `SortOrder` ascending (slot order within the team).
- `getSpectre(db, id)` — single fetch by ID; calls `MigrateWeapons()` and `MigrateSkills()` on load.

**Write helpers:**
- `createSpectre(db, name)` — creates with defaults; sets `SortOrder = time.Now().UnixNano()`.
- `duplicateSpectre(db, id)` — full copy, new ID, name suffixed with `" (Copy)"`, `TeamID` cleared.
- `renameSpectre(db, id, name)` — updates `Name` in-place.
- `deleteSpectre(db, id)` — removes from bucket; returns `(teamID, existed, err)` so callers know which team to refresh.

---

## HTTP API

All routes are registered in `controllers/spectre_controller.go` via `SpectreController.Register()`.

| Method   | Path                                           | Description |
|----------|------------------------------------------------|-------------|
| `GET`    | `/api/spectres`                                | Returns `spectre_list` partial (full left+right panel). |
| `POST`   | `/api/spectres`                                | Create operative (default name "New Operative"). Returns `spectre_list` with the new operative's card pre-loaded. |
| `POST`   | `/api/spectres/{id}/duplicate`                 | Clone operative as standalone. Returns updated list. |
| `DELETE` | `/api/spectres/{id}`                           | Remove operative. `?from=team` returns `bot_panel`; otherwise returns list. |
| `GET`    | `/api/spectres/{id}/card`                      | Returns `character_card_sheet` partial for `#spectre-card-panel`. `?from=team` returns `character_card` instead. |
| `POST`   | `/api/spectres/{id}/character/{charId}`        | Change operative's character class. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/appearance/{charId}`       | Set visual appearance override. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/voice/{charId}`            | Set voice archetype. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/heavy-melee/{charId}`      | Set heavy melee archetype. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/light-melee/{charId}`      | Set light melee archetype. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/dodge/{charId}`            | Set dodge archetype. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/rename`                    | Form field `name`. Returns updated card sheet + OOB sidebar. |
| `POST`   | `/api/spectres/{id}/active/toggle`             | Toggle active flag (exclusive — deactivates all others). Returns updated card sheet + OOB sidebar. |
| `POST`   | `/api/spectres/{id}/weapon/add/{weaponId}`     | Append a new weapon slot. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/weapon/{idx}/{weaponId}`   | Replace weapon in slot `idx`. Returns updated card sheet. |
| `DELETE` | `/api/spectres/{id}/weapon/{idx}`              | Remove weapon slot `idx`. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/power/{slot}/{rank}`       | Set power rank. Returns updated card sheet. |
| `POST`   | `/api/spectres/{id}/power/{slot}/evo/{rank}/{choice}` | Set power evolution (A/B). Returns updated card sheet. |

---

## Render Helpers

All in `controllers/spectre_controller.go`:

```
renderList(w)
  → calls renderListWithCard(w, "")

renderListWithCard(w, selectedID)
  → loads all standalone spectres
  → if selectedID != "": builds a SpectreView for that operative via buildCardSheetView()
  → executes template "spectre_list" with { Spectres, SelectedView }

buildCardSheetView(s Spectre) SpectreView
  → resolves CharDef, AppearanceCharDef, VoiceDef, MeleeDefs, DodgeDef
  → builds WeaponViews, PowerViews, SkillViews, XP fields
  → pre-computes all CardURLs via spectreURLs(id)
  → called from both renderListWithCard() and renderCardSheet()

renderCardSheet(w, s)
  → builds SpectreView via buildCardSheetView(); executes "character_card_sheet"

renderCard(w, s, fromTeam)
  → fromTeam=false → renderCardSheet (full RPG sheet)
  → fromTeam=true  → executes "character_card" (compact team card)
```

---

## Templates

| Template name            | File                                            | Target element       |
|--------------------------|-------------------------------------------------|----------------------|
| `spectre_sidebar_inner`  | `partials/spectre_list.html`                    | inside `#spectre-sidebar` |
| `spectre_sidebar_oob`    | `partials/spectre_list.html`                    | OOB swap into `#spectre-sidebar` |
| `spectre_list`           | `partials/spectre_list.html`                    | `#spectres-panel` (full tab) |
| `character_card_sheet`   | `partials/character_card_sheet.html`            | `#spectre-card-panel` |
| `character_card`         | `partials/character_card.html`                  | `#spectre-card-panel` (team context) |

### `spectre_list` template data
```
{
  Spectres     []SpectreView   // all standalone operatives, newest first
  SelectedView *SpectreView    // non-nil when a card should be pre-loaded (e.g. after create)
}
```

### List sidebar behaviour
- **Filter input**: Alpine `x-model="filter"` on a local `x-data` scope. Each row has `data-name="{{.Spectre.Name}}"` and `x-show="!filter || $el.dataset.name.toLowerCase().includes(filter.toLowerCase())"`. Filtering is client-side — no server round-trip.
- **`+` button**: `hx-post="/api/spectres"` → triggers creation of a "New Operative" and re-renders the whole panel with the new card pre-selected.
- **Row click**: `hx-get="/api/spectres/{id}/card"` → swaps `#spectre-card-panel`.
- **Delete icon**: appears on row hover; `hx-delete` with `hx-confirm`. `onclick="event.stopPropagation()"` prevents the row click from firing.
- **Duplicate icon**: appears on row hover; `hx-post=".../duplicate"` → returns updated `#spectres-panel`.
- **Active state**: active operatives render their name in `text-green-400`.

---

## Key Conventions

- `spectreURLs(id)` pre-computes all route strings (CardURLs) for a standalone operative. `teamSpectreURLs(id)` does the same for a team member (different delete target and no `SetActiveURL`).
- The `CardURLs` struct is embedded in `SpectreView` so templates never construct URLs themselves.
- `SortOrder` is always unix nanoseconds (int64). The `time` package is the only source of truth — never derive ordering from ID strings.
- Operatives with `TeamID != ""` are excluded from `listSpectres`. Do not render them in the standalone list.

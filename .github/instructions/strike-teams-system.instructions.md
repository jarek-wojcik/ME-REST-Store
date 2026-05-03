---
applyTo: "**/teams*.go, **/teams*.html, **/team_list*.html, **/bot_panel*.html, **/team_spectre*.html"
---

# Strike Teams System — Technical Reference

## Overview

Strike Teams group operatives into named squads of up to `maxSquadSize` members (configurable, default 4). At most one team is "active" at a time — the active team is what ME3's `IsPrivateMatch` event syncs against. Teams are managed from the Strike Teams tab; clicking a team loads its bot panel alongside the sidebar.

---

## Data Models

### Team

**File:** `model/team.go`

```
Team {
  ID        string  // 16-char random hex
  Name      string
  Active    bool    // exclusive — only one team active at a time
  CreatedAt int64   // unix nanoseconds; newest-first ordering
}
```

`CreatedAt` is set to `time.Now().UnixNano()` on `createTeam`. `listTeams` sorts by `CreatedAt` descending (newest team at top of sidebar).

### Member slots — TeamSlotView

Not persisted. Built at render time in `controllers/spectres.go`:

```
TeamSlotView {
  Filled bool
  TeamID string
  View   SpectreView  // only valid when Filled == true
}
```

`buildTeamSlots(teamID, spectres, maxSize)` pads the list to `max(maxSize, len(existing))` slots so reducing the squad size cap never hides existing members — only prevents new additions beyond the limit.

---

## Persistence

BoltDB bucket: `teams`

Key = `Team.ID`. Values are JSON-encoded `Team` structs.

**Read helpers (`controllers/teams.go`):**
- `listTeams(db)` — all teams, sorted **newest first** by `CreatedAt`.
- `getTeam(db, id)` — single fetch by ID.

**Write helpers:**
- `createTeam(db, name)` — sets `CreatedAt = time.Now().UnixNano()`.
- `renameTeam(db, id, name)` — updates `Name` in-place.
- `toggleTeamActive(db, id)` — flips `Active`; when activating, deactivates all other teams atomically in the same BoltDB transaction.
- `deleteTeam(db, id)` — removes from bucket; returns `(existed, err)`. Caller must unassign all team spectres first (see `DELETE /api/teams/{id}`).

---

## HTTP API — Teams

All routes are registered in `controllers/teams_controller.go` via `TeamsController.Register()`.

| Method   | Path                            | Description |
|----------|---------------------------------|-------------|
| `GET`    | `/api/teams`                    | Returns `team_list` partial (full tab). |
| `POST`   | `/api/teams`                    | Create team (default name "New Team"). Returns `team_list` with the new team's bot panel pre-loaded. |
| `DELETE` | `/api/teams/{id}`               | Delete team and unassign all its spectres. Returns updated `team_list`. |
| `POST`   | `/api/teams/{id}/rename`        | Form field `name`. Returns updated `bot_panel` + OOB sidebar refresh. |
| `POST`   | `/api/teams/{id}/active/toggle` | Toggle active flag (exclusive). Returns updated `bot_panel` + OOB sidebar. |

## HTTP API — Team Spectres

Registered in `controllers/spectre_controller.go` (same controller handles both standalone and team-member spectres).

| Method   | Path                                         | Description |
|----------|----------------------------------------------|-------------|
| `GET`    | `/api/teams/{id}/spectres`                   | Returns `bot_panel` for the team. |
| `POST`   | `/api/teams/{id}/spectres`                   | Create new team spectre with default character. Returns updated `bot_panel`. |
| `GET`    | `/api/teams/{id}/spectres/picker`            | Opens the spectre picker modal. `?step=existing` shows roster picker; `?step=class` shows character selector. |
| `POST`   | `/api/teams/{id}/spectres/class/{charId}`    | Create a new team spectre with the given character class. Returns updated `bot_panel`. |
| `POST`   | `/api/teams/{id}/spectres/pick/{spectreId}`  | Assign an existing standalone operative to the team. Returns updated `bot_panel`. |
| `DELETE` | `/api/teams/{id}/spectres/{spectreId}`       | Unassign (not delete) a spectre from the team. Returns updated `bot_panel`. |

**Capacity enforcement:** `createTeamSpectre` and `assignSpectreToTeam` both check `len(existing) >= maxSize` and return an error if the team is full. The error message includes the actual limit. HTTP 409 is returned to the client.

---

## Squad Size Setting

**Key:** `"maxSquadSize"` in the BoltDB `settings` bucket.  
**Default:** `4`  
**Clamp:** 1–10  

```go
// controllers/settings.go
const DefaultMaxSquadSize = 4
func GetMaxSquadSize(db *bolt.DB) int  // reads setting, falls back to 4, clamps 1–10
```

**Route:** `POST /api/settings/maxSquadSize` — form field `value` (int). Validates 1–10, persists, returns HTTP 204 with header `HX-Trigger: squadSizeChanged`.

**UI reaction:** The `bot_panel` root div listens for the `squadSizeChanged` custom event (triggered by HTMX on the `<body>`) and re-fetches its own content:
```html
hx-trigger="squadSizeChanged from:body"
```

---

## Render Helpers

All in `controllers/teams_controller.go`:

```
renderList(w)
  → calls renderListWithPanel(w, "")

renderListWithPanel(w, selectedTeamID)
  → loads all teams
  → if selectedTeamID != "": fetches team + its spectres; builds botPanel data map
  → executes "team_list" with { Teams, BotPanel }
    BotPanel is nil when no team is selected; template uses {{if .BotPanel}} guard

renderSidebarOOB(w)
  → executes "team_sidebar_oob" — appended to response for HTMX OOB swap
  → refreshes team name colour (green = active) after any active-state change
```

In `controllers/spectre_controller.go`:

```
renderBotPanel(w, teamID)
  → fetches team + spectres for teamID
  → executes "bot_panel" with { TeamID, TeamName, Slots, TeamActive }
```

---

## Templates

| Template name         | File                                   | Target element     |
|-----------------------|----------------------------------------|--------------------|
| `team_sidebar_inner`  | `partials/team_list.html`              | inside `#team-sidebar` |
| `team_sidebar_oob`    | `partials/team_list.html`              | OOB swap into `#team-sidebar` |
| `team_list`           | `partials/team_list.html`              | `#teams-panel` (full tab) |
| `bot_panel`           | `partials/bot_panel.html`              | `#bot-panel` |
| `team_spectre_summary`| `partials/team_spectre_summary.html`   | inside `bot_panel` overview column |
| `team_add_picker`     | `partials/team_add_picker.html`        | modal overlay |

### `team_list` template data
```
{
  Teams    []Team          // all teams, newest first
  BotPanel map[string]any  // nil = no team selected; non-nil = pre-loaded panel data
}
```

### `bot_panel` template data
```
{
  TeamID     string
  TeamName   string
  Slots      []TeamSlotView
  TeamActive bool
}
```

---

## Bot Panel Layout

```
<div x-data="{ openSlot: '<first filled CardID>' }">    ← Alpine root; tracks which portrait is expanded
  <div class="flex flex-col w-fit">                       ← outer wrapper; w-fit so border spans both columns

    <!-- Header row (border top+bottom) -->
    <div x-data="{ renaming: false }">
      <span x-show="!renaming">TeamName</span>           ← display mode
      <form x-show="renaming" hx-post=".../rename">      ← inline rename form
        <input x-ref="teamNameInput" />
        Save / Cancel
      </form>
      <button @click="renaming=true; $nextTick(...)">Rename</button>
      <button hx-post=".../active/toggle">Active toggle</button>
    </div>

    <!-- Columns -->
    <div class="flex flex-row">

      <!-- Portrait stack (128px wide) -->
      <div>
        {{range .Slots}}
          <!-- Filled: portrait card with name bar + remove button -->
          <!-- Empty:  "+ Add Operative" button → picker step=existing -->
        {{end}}
      </div>

      <!-- Overview panel (w-fit) -->
      <div>
        {{range .Slots}}{{if .Filled}}
          <div x-show="openSlot === '...'">              ← visible only when portrait is selected
            {{template "team_spectre_summary" .View}}
          </div>
        {{end}}{{end}}
      </div>

    </div>
  </div>
</div>
```

### Portrait card click behaviour
Alpine `openSlot` state is toggled on click:
```js
openSlot = (openSlot === cardID ? null : cardID)
```
Clicking the same portrait collapses the overview; clicking a different one swaps it.

### Default open slot
Computed by a Go template variable before the Alpine root is rendered:
```go
{{$firstID := ""}}
{{range .Slots}}{{if and .Filled (eq $firstID "")}}{{$firstID = .View.CardID}}{{end}}{{end}}
<div x-data="{ openSlot: '{{$firstID}}' }">
```
If the team has no members `$firstID` is `""` and no overview is shown.

---

## Key Conventions

- When deleting a team, all its spectres must be **unassigned** (not deleted) first. The `DELETE /api/teams/{id}` handler calls `unassignSpectreFromTeam` on each member before deleting the team record.
- `toggleTeamActive` deactivates all other teams in the **same BoltDB transaction** — it is atomic.
- `buildTeamSlots` always renders `max(maxSize, len(existing))` rows. Reducing `maxSquadSize` never hides members; it only prevents adding new ones beyond the new cap.
- The rename form uses `hx-target="#bot-panel"` + `c.renderSidebarOOB(w)` so both the panel title and the sidebar label update in one response.
- `TeamName` must be passed explicitly in every `bot_panel` render — it is not re-fetched from DB automatically. If a handler renders `bot_panel` without setting `"TeamName"` the header will be blank.

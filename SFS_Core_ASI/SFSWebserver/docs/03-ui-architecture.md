# UI Architecture

The Spectre Portal UI is a server-rendered single-page application. There is no JavaScript build step, no bundler, and no separate frontend project. Everything is served by the Go HTTP server from embedded templates.

---

## Rendering Model

```
Browser                     Go server
  │                              │
  │── GET /spectreportal/ ──────>│  Renders spectreportal.html (full page shell)
  │<────────────────────────────│
  │                              │
  │  (page load, HTMX fires)    │
  │── GET /api/teams ──────────>│  Renders team_list.html partial
  │<────── HTML fragment ───────│  HTMX swaps it into #teams-panel slot
  │                              │
  │  (user adds team)           │
  │── POST /api/teams ─────────>│  Creates team, renders updated team_list.html
  │<────── HTML fragment ───────│  HTMX swaps outerHTML of #teams-panel
```

The server always returns **HTML**, never JSON, for UI interactions. HTMX swaps the returned fragment into the DOM. This eliminates the need for a JavaScript data layer entirely.

---

## Responsibilities by Layer

### `spectreportal.html` — Page Shell
- Declares `x-data="{ activeTab: 'spectre' }"` (Alpine root state)
- Renders the sticky header, logo, and three tab buttons
- Each tab content area is an Alpine `x-show` block — switching tabs is instant, no server round-trip
- The Strike Teams tab contains an HTMX trigger that fetches `/api/teams` on page load

### `partials/team_list.html` — Strike Teams Panel
- Rendered by the server and returned as a fragment
- Contains the full two-column layout: team sidebar + bot panel placeholder
- Always has `id="teams-panel"` so HTMX can consistently target `outerHTML` for full re-renders after mutations (add/delete)
- The right-side `#bot-panel` is a stable slot for future bot card content

### Alpine.js
Used only for **local, ephemeral UI state** that does not need to be persisted:
- Active tab (`activeTab`)
- Modal open/close state (future)
- Highlighted selections (future)

### HTMX
Used for all **server interactions** that change persisted data or load new content:
- Initial team list load on page open
- Creating a team (POST → re-render)
- Deleting a team (DELETE → re-render)
- Loading bots for a selected team (GET → swap bot panel)

### Tailwind CSS
All styling uses Tailwind utility classes via CDN. The ME3-themed custom palette is defined in a `tailwind.config` inline script:

| Token | Hex | Usage |
|---|---|---|
| `me-blue` | `#00aaff` | Active tabs, accents, borders |
| `me-dark` | `#0a0e1a` | Page background |
| `me-panel` | `#111827` | Header, card surfaces |
| `me-border` | `#1e3a5f` | Dividers, input borders |
| `me-accent` | `#0d47a1` | Button fill, hover states |

---

## Adding a New Tab's Content

1. Create `templates/partials/<section>.html` with a stable root `id`.
2. Add `//go:embed templates/partials/<section>.html` and parse the template in `SFSWebserver.go`.
3. Register the required API routes.
4. In `spectreportal.html`, add `hx-get="/api/<section>" hx-trigger="load"` inside the corresponding `x-show` tab div.

---

## Generic Card Component Design

Bot cards and Character cards share the same template shape. The server passes a `CardData` struct to the template:

```go
type CardSlot struct {
    Label         string      // e.g. "Weapon", "Armor"
    Current       Selectable  // anything with ID/Name/PictureURL
    SelectorRoute string      // e.g. "/selector/weapons"
}

type CardData struct {
    Portrait Selectable
    Slots    []CardSlot   // bot gets [weapon]; character gets [armor, mod1, mod2]
    Powers   []PowerSlot
}
```

One `card.html` template iterates `Slots` generically — the card layout is identical regardless of whether it is a bot or a character. Different data, same template.

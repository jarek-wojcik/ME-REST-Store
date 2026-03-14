# API Routes

All routes are registered in `SFSWebserver.go` and served on `127.0.0.1:<port>` (loopback only).

Routes that serve the UI return **HTML fragments** (HTMX partials). Legacy key/value routes return plain text.

---

## UI Routes

### `GET /spectreportal/`
Serves the full Spectre Portal page shell.

**Response:** `text/html` — renders `templates/spectreportal.html`

---

## Teams API

All team routes return the re-rendered `team_list.html` partial on success, so HTMX can swap the full panel in one step.

### `GET /api/teams`
Returns the current team list panel.

**Response:** `text/html` — partial `#teams-panel`

---

### `POST /api/teams`
Creates a new team.

**Form body:**

| Field | Required | Description |
|---|---|---|
| `name` | Yes | Display name for the team (trimmed, max 40 chars recommended) |

**Responses:**

| Status | Body |
|---|---|
| `200` | Updated `#teams-panel` HTML partial |
| `400` | `missing name` |
| `500` | `create failed` |

---

### `DELETE /api/teams/{id}`
Deletes a team by its ID.

**Path parameter:** `id` — the team's hex ID

**Responses:**

| Status | Body |
|---|---|
| `200` | Updated `#teams-panel` HTML partial |
| `404` | `not found` |
| `500` | `delete failed` |

---

### `GET /api/teams/{id}/bots`
Returns the bot panel content for a specific team.

**Path parameter:** `id` — the team's hex ID

**Response:** `text/html` — bot card grid fragment (placeholder until bot cards are implemented)

---

## Legacy Key/Value Store

These routes pre-date the UI and are used by the ASI plugin layer directly.

### `GET /health`
Liveness check.
**Response:** `200 ok`

### `GET /store?key=&value=`
Stores a key/value pair in the `sfs` bucket.
**Response:** `200 stored` / `400 missing key` / `500 write failed`

### `GET /retrieve?key=`
Fetches a value by key.
**Response:** `200 <value>` / `400 missing key` / `404 not found` / `500 read failed`

### `GET /allKeys`
Returns all key:value pairs as a comma-separated list.
**Response:** `200 key1:val1,key2:val2,...`

### `GET /delete?key=`
Deletes a key.
**Response:** `200 deleted` / `400 missing key` / `404 not found` / `500 delete failed`

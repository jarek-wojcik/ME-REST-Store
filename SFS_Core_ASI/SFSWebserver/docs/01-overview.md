# SFSWebserver — Overview

SFSWebserver is a lightweight HTTP server embedded inside the Mass Effect 3 mod toolchain. It runs locally on the player's machine (`127.0.0.1:6060`) and exposes:

- A **key/value store** backed by BoltDB (used by the ASI plugin layer via simple HTTP calls).
- A **web UI** (`/spectreportal/`) for managing Strike Teams, Spectre characters, and Mission Parameters.

The server is compiled to a single self-contained Windows executable (`SFSWebserver.exe`). All HTML templates are baked into the binary at compile time via Go's `//go:embed` directive — no external files are required at runtime.

---

## Technology Stack

| Layer | Library | Why |
|---|---|---|
| HTTP server | Go `net/http` stdlib | Zero deps, sufficient for local use |
| Persistent store | [BoltDB (bbolt)](https://github.com/etcd-io/bbolt) | Embedded, single-file, no separate DB process |
| HTML rendering | Go `html/template` stdlib | Server-side, safe escaping, no build step |
| UI reactivity | [Alpine.js 3.x](https://alpinejs.dev/) (CDN) | Manages local state (active tab, modals) with minimal JS |
| Partial updates | [HTMX 2.x](https://htmx.org/) (CDN) | Fetches and swaps HTML fragments without writing JavaScript |
| Styling | [Tailwind CSS](https://tailwindcss.com/) (CDN) | Utility classes, no build pipeline |

---

## Project Layout

```
SFSWebserver/
├── go-build                  # Build script
├── go.mod / go.sum           # Go module files
├── SFSWebserver.go           # HTTP server entrypoint and route registration
├── teams.go                  # Team model + BoltDB helpers
├── templates/
│   ├── spectreportal.html    # Full-page shell (tabs, header)
│   └── partials/
│       └── team_list.html    # Strike Teams panel (HTMX partial)
└── docs/                     # This documentation
```

---

## Default Configuration

| Setting | Default | Override |
|---|---|---|
| Port | `6060` | `SFSWebserver.exe <port>` |
| DB file | `%USERPROFILE%\Documents\BioWare\Mass Effect 3\sfsdatabase.db` | `SFSWebserver.exe <port> <path>` |

The database directory is created automatically on first run.

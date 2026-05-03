package controllers

import (
	"net/http"
	"strconv"
	"strings"

	bolt "go.etcd.io/bbolt"
)

// SettingsController handles HTTP routes for portal settings.
type SettingsController struct {
	db *bolt.DB
}

func NewSettingsController(db *bolt.DB) *SettingsController {
	return &SettingsController{db: db}
}

func (c *SettingsController) Register() {
	// POST /api/settings/scale
	// Persists the UI scale value. Expects form field "scale" (float 0.5–2.0).
	// Returns 204 No Content — the zoom is already applied client-side by Alpine.
	http.HandleFunc("POST /api/settings/scale", func(w http.ResponseWriter, r *http.Request) {
		raw := strings.TrimSpace(r.FormValue("scale"))
		f, err := strconv.ParseFloat(raw, 64)
		if err != nil || f < 0.5 || f > 2.0 {
			respondText(w, 400, "invalid scale value\n")
			return
		}
		val := strconv.FormatFloat(f, 'f', -1, 64)
		if err := SetSetting(c.db, "scale", val); err != nil {
			respondText(w, 500, "db error\n")
			return
		}
		w.WriteHeader(http.StatusNoContent)
	})

	// POST /api/settings/maxSquadSize
	// Persists the max operatives per strike team. Expects form field "maxSquadSize" (int 1–10).
	// Returns 204 No Content.
	http.HandleFunc("POST /api/settings/maxSquadSize", func(w http.ResponseWriter, r *http.Request) {
		raw := strings.TrimSpace(r.FormValue("maxSquadSize"))
		n, err := strconv.Atoi(raw)
		if err != nil || n < 1 || n > 10 {
			respondText(w, 400, "invalid value: must be 1–10\n")
			return
		}
		if err := SetSetting(c.db, "maxSquadSize", strconv.Itoa(n)); err != nil {
			respondText(w, 500, "db error\n")
			return
		}
		w.Header().Set("HX-Trigger", "squadSizeChanged")
		w.WriteHeader(http.StatusNoContent)
	})
}

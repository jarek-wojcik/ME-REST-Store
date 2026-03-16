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
}

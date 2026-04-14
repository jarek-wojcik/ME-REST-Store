package controllers

import (
	"encoding/json"
	"html/template"
	"net/http"
	"strconv"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const missionParamsBucket = "missionSettings"
const missionParamsKey = "config"

// MissionParamsController handles HTTP routes for configuring match
// parameters (map, difficulty, wave count, enemy faction, etc.).
type MissionParamsController struct {
	db   *bolt.DB
	tmpl *template.Template
}

func NewMissionParamsController(db *bolt.DB, tmpl *template.Template) *MissionParamsController {
	return &MissionParamsController{db: db, tmpl: tmpl}
}

func (c *MissionParamsController) load() (model.MissionSettings, error) {
	var ms model.MissionSettings
	err := c.db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(missionParamsBucket))
		if b == nil {
			return nil
		}
		v := b.Get([]byte(missionParamsKey))
		if v == nil {
			return nil
		}
		return json.Unmarshal(v, &ms)
	})
	return ms, err
}

func (c *MissionParamsController) save(ms model.MissionSettings) error {
	return c.db.Update(func(tx *bolt.Tx) error {
		b, err := tx.CreateBucketIfNotExists([]byte(missionParamsBucket))
		if err != nil {
			return err
		}
		v, err := json.Marshal(ms)
		if err != nil {
			return err
		}
		return b.Put([]byte(missionParamsKey), v)
	})
}

func (c *MissionParamsController) render(w http.ResponseWriter, ms model.MissionSettings) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "mission_params", ms)
}

// Register wires mission-parameter routes onto the default mux.
func (c *MissionParamsController) Register() {
	// GET /api/missionParams
	// Returns the mission parameters partial.
	http.HandleFunc("GET /api/missionParams", func(w http.ResponseWriter, r *http.Request) {
		ms, err := c.load()
		if err != nil {
			respondText(w, http.StatusInternalServerError, "db error\n")
			return
		}
		c.render(w, ms)
	})

	// POST /api/missionParams
	// Persists mission parameters from form values and returns the updated partial.
	http.HandleFunc("POST /api/missionParams", func(w http.ResponseWriter, r *http.Request) {
		// Load existing settings so fields absent from the form are preserved.
		ms, err := c.load()
		if err != nil {
			respondText(w, http.StatusInternalServerError, "db error\n")
			return
		}
		ms.DisableObjectiveWaves = r.FormValue("disableObjectiveWaves") == "on"
		if n, err := strconv.Atoi(r.FormValue("maxEnemies")); err == nil && n >= 0 {
			ms.MaxEnemies = n
		} else {
			ms.MaxEnemies = 0
		}
		if n, err := strconv.Atoi(r.FormValue("maxEnemiesPerSpawnPoint")); err == nil && n >= 0 {
			ms.MaxEnemiesPerSpawnPoint = n
		} else {
			ms.MaxEnemiesPerSpawnPoint = 0
		}
		if err := c.save(ms); err != nil {
			respondText(w, http.StatusInternalServerError, "db error\n")
			return
		}
		c.render(w, ms)
	})
}

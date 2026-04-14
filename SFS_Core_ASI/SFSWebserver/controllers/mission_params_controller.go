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

// missionParamsViewData is the template data model for the mission_params partial.
// EnabledEnemiesMap is a set derived from MissionSettings.EnabledEnemies so the
// template can check membership with {{index .EnabledEnemiesMap "archetype"}}.
type missionParamsViewData struct {
	model.MissionSettings
	EnabledEnemiesMap map[string]bool
}

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
	vm := missionParamsViewData{
		MissionSettings:   ms,
		EnabledEnemiesMap: make(map[string]bool, len(ms.EnabledEnemies)),
	}
	for _, e := range ms.EnabledEnemies {
		vm.EnabledEnemiesMap[e] = true
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "mission_params", vm)
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
		if err := r.ParseForm(); err != nil {
			respondText(w, http.StatusInternalServerError, "form parse error\n")
			return
		}
		// Load existing settings so unrelated fields are preserved across partial saves.
		ms, err := c.load()
		if err != nil {
			respondText(w, http.StatusInternalServerError, "db error\n")
			return
		}
		ms.DisableObjectiveWaves = r.FormValue("disableObjectiveWaves") == "on"
		if n, err := strconv.Atoi(r.FormValue("startWave")); err == nil && n >= 1 && n <= 10 {
			ms.StartWave = n
		} else {
			ms.StartWave = 1
		}
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
		ms.EnabledEnemies = r.Form["enabledEnemies"]
		if ms.EnabledEnemies == nil {
			ms.EnabledEnemies = []string{}
		}
		if err := c.save(ms); err != nil {
			respondText(w, http.StatusInternalServerError, "db error\n")
			return
		}
		c.render(w, ms)
	})
}

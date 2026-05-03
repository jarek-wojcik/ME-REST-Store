package me3integration

import (
	"encoding/json"
	"net/http"
	"strings"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const missionSettingsBucket = "missionSettings"
const missionSettingsKey = "config"

// Me3MissionSettingsController exposes the mission settings endpoint for the
// ME3 game layer.
type Me3MissionSettingsController struct {
	db *bolt.DB
}

// NewMe3MissionSettingsController creates a mission settings controller backed
// by the given BoltDB.
func NewMe3MissionSettingsController(db *bolt.DB) *Me3MissionSettingsController {
	return &Me3MissionSettingsController{db: db}
}

// loadMissionSettings reads the persisted MissionSettings from BoltDB.
// If no settings have been saved yet, the zero-value defaults are returned.
func (c *Me3MissionSettingsController) loadMissionSettings() (model.MissionSettings, error) {
	var ms model.MissionSettings
	err := c.db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(missionSettingsBucket))
		if b == nil {
			return nil
		}
		v := b.Get([]byte(missionSettingsKey))
		if v == nil {
			return nil
		}
		return json.Unmarshal(v, &ms)
	})
	return ms, err
}

// saveMissionSettings persists the given MissionSettings to BoltDB.
func (c *Me3MissionSettingsController) saveMissionSettings(ms model.MissionSettings) error {
	return c.db.Update(func(tx *bolt.Tx) error {
		b, err := tx.CreateBucketIfNotExists([]byte(missionSettingsBucket))
		if err != nil {
			return err
		}
		v, err := json.Marshal(ms)
		if err != nil {
			return err
		}
		return b.Put([]byte(missionSettingsKey), v)
	})
}

// Register wires the mission settings routes onto the default mux.
func (c *Me3MissionSettingsController) Register() {
	// GET /missionSettings
	// Returns the current MissionSettings as JSON.
	// Use ?simpleJson=true for a flat key:value plain-text response.
	// Use ?faction=Reapers (or Cerberus, Geth, Collectors) to restrict enemy
	// lists to that faction when crossFactionEnemies is false.
	http.HandleFunc("GET /missionSettings", func(w http.ResponseWriter, r *http.Request) {
		ms, err := c.loadMissionSettings()
		if err != nil {
			respondJSON(w, http.StatusInternalServerError, map[string]string{"error": "db error"})
			return
		}
		if faction := r.URL.Query().Get("faction"); !ms.CrossFactionEnemies && faction != "" {
			ms = filterByFaction(ms, faction)
		}
		if r.URL.Query().Get("simpleJson") == "true" {
			respondSimpleJSON(w, http.StatusOK, ms)
			return
		}
		respondJSON(w, http.StatusOK, ms)
	})

	// POST /missionSettings
	// Persists a full MissionSettings object.
	// Request body: JSON-encoded MissionSettings.
	http.HandleFunc("POST /missionSettings", func(w http.ResponseWriter, r *http.Request) {
		var ms model.MissionSettings
		if err := json.NewDecoder(r.Body).Decode(&ms); err != nil {
			respondJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid JSON"})
			return
		}
		if err := c.saveMissionSettings(ms); err != nil {
			respondJSON(w, http.StatusInternalServerError, map[string]string{"error": "db error"})
			return
		}
		if r.URL.Query().Get("simpleJson") == "true" {
			respondSimpleJSON(w, http.StatusOK, ms)
			return
		}
		respondJSON(w, http.StatusOK, ms)
	})
}

// filterByFaction returns a copy of ms with EnabledEnemies and EnemyRatios
// restricted to entries whose archetype path contains the faction name.
// e.g. faction="Reapers" matches "Char_Enemies.Archetypes.Reapers.Husk".
func filterByFaction(ms model.MissionSettings, faction string) model.MissionSettings {
	lower := strings.ToLower(faction)

	var enabled []string
	for _, e := range ms.EnabledEnemies {
		if strings.Contains(strings.ToLower(e), lower) {
			enabled = append(enabled, e)
		}
	}
	ms.EnabledEnemies = enabled

	ratios := make(map[string]int)
	for k, v := range ms.EnemyRatios {
		if strings.Contains(strings.ToLower(k), lower) {
			ratios[k] = v
		}
	}
	ms.EnemyRatios = ratios

	return ms
}

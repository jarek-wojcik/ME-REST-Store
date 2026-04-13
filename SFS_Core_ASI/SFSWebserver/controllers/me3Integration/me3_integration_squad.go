package me3integration

import (
	"encoding/json"
	"net/http"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const teamsBucket = "teams"

// Me3SquadController exposes the active strike team endpoint for the ME3 game layer.
type Me3SquadController struct {
	db *bolt.DB
}

// NewMe3SquadController creates a squad controller backed by the given BoltDB.
func NewMe3SquadController(db *bolt.DB) *Me3SquadController {
	return &Me3SquadController{db: db}
}

// StrikeTeamResponse pairs a Team with its member Spectres.
type StrikeTeamResponse struct {
	model.Team
	Spectres []model.Spectre `json:"spectres"`
}

// activeStrikeTeam returns the active team and all spectres belonging to it,
// or nil if no team is currently set as active.
func (c *Me3SquadController) activeStrikeTeam() (*StrikeTeamResponse, error) {
	var result *StrikeTeamResponse
	err := c.db.View(func(tx *bolt.Tx) error {
		tb := tx.Bucket([]byte(teamsBucket))
		if tb == nil {
			return nil
		}

		// Find the active team.
		var activeTeam *model.Team
		if err := tb.ForEach(func(_, v []byte) error {
			var t model.Team
			if err := json.Unmarshal(v, &t); err != nil {
				return err
			}
			if t.Active {
				cp := t
				activeTeam = &cp
			}
			return nil
		}); err != nil {
			return err
		}
		if activeTeam == nil {
			return nil
		}

		// Collect spectres belonging to the active team.
		sb := tx.Bucket([]byte(spectresBucket))
		var spectres []model.Spectre
		if sb != nil {
			if err := sb.ForEach(func(_, v []byte) error {
				var s model.Spectre
				if err := json.Unmarshal(v, &s); err != nil {
					return err
				}
				if s.TeamID == activeTeam.ID {
					spectres = append(spectres, s)
				}
				return nil
			}); err != nil {
				return err
			}
		}

		result = &StrikeTeamResponse{Team: *activeTeam, Spectres: spectres}
		return nil
	})
	return result, err
}

// Register wires the strike team routes onto the default mux.
func (c *Me3SquadController) Register() {
	// GET /activeStrikeTeam
	// Returns the active Team and its Spectres as JSON.
	// Returns 404 if no team is set as active.
	// Use ?simpleJson=true for a flat key:value plain-text response.
	http.HandleFunc("GET /activeStrikeTeam", func(w http.ResponseWriter, r *http.Request) {
		team, err := c.activeStrikeTeam()
		if err != nil {
			respondJSON(w, http.StatusInternalServerError, map[string]string{"error": "db error"})
			return
		}
		if team == nil {
			respondNotFound(w, "no active strike team")
			return
		}
		for i := range team.Spectres {
			team.Spectres[i].AppearancePawnType = model.PawnType(appearancePawnType(&team.Spectres[i]))
			qualifySpectre(&team.Spectres[i])
		}
		if r.URL.Query().Get("simpleJson") == "true" {
			respondSimpleJSON(w, http.StatusOK, team)
			return
		}
		respondJSON(w, http.StatusOK, team)
	})
}

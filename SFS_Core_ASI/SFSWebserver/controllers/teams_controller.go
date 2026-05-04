package controllers

import (
	"html/template"
	"net/http"
	"strings"

	bolt "go.etcd.io/bbolt"
)

// TeamsController handles all HTTP routes for the team resource.
type TeamsController struct {
	db   *bolt.DB
	tmpl *template.Template
}

func NewTeamsController(db *bolt.DB, tmpl *template.Template) *TeamsController {
	return &TeamsController{db: db, tmpl: tmpl}
}

func (c *TeamsController) renderList(w http.ResponseWriter) {
	c.renderListWithPanel(w, "")
}

func (c *TeamsController) renderListWithPanel(w http.ResponseWriter, selectedTeamID string) {
	teams, err := listTeams(c.db)
	if err != nil {
		respondText(w, 500, "db error\n")
		return
	}
	var botPanel map[string]any
	if selectedTeamID != "" {
		if team, err := getTeam(c.db, selectedTeamID); err == nil {
			spectres, _ := listSpectresForTeam(c.db, selectedTeamID)
			botPanel = map[string]any{
				"TeamID":     selectedTeamID,
				"TeamName":   team.Name,
				"Slots":      buildTeamSlots(selectedTeamID, spectres, GetMaxSquadSize(c.db), GetEditOperativesFromTeam(c.db)),
				"TeamActive": team.Active,
			}
		}
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "team_list", map[string]any{
		"Teams":          teams,
		"BotPanel":       botPanel,
		"SelectedTeamID": selectedTeamID,
	})
}

func (c *TeamsController) renderSidebarOOB(w http.ResponseWriter) {
	teams, _ := listTeams(c.db)
	_ = c.tmpl.ExecuteTemplate(w, "team_sidebar_oob", map[string]any{
		"Teams":          teams,
		"SelectedTeamID": "",
	})
}

// Register wires all team-related HTTP routes onto the default mux.
func (c *TeamsController) Register() {
	// GET /api/teams
	// Returns the team list HTML partial (used by HTMX on initial tab load).
	http.HandleFunc("GET /api/teams", func(w http.ResponseWriter, r *http.Request) {
		c.renderList(w)
	})

	// POST /api/teams
	// Creates a new team with a default name. Returns the updated team list with the new team selected.
	http.HandleFunc("POST /api/teams", func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			name = "New Team"
		}
		t, err := createTeam(c.db, name)
		if err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderListWithPanel(w, t.ID)
	})

	// DELETE /api/teams/{id}
	// Deletes a team by ID. Returns the updated team list partial.
	http.HandleFunc("DELETE /api/teams/{id}", func(w http.ResponseWriter, r *http.Request) {
		id := r.PathValue("id")

		// Unassign any spectres belonging to this team first.
		if teamSpectres, err := listSpectresForTeam(c.db, id); err == nil {
			for _, s := range teamSpectres {
				if _, err := unassignSpectreFromTeam(c.db, s.ID); err != nil {
					respondText(w, 500, "unassign failed\n")
					return
				}
			}
		}

		existed, err := deleteTeam(c.db, id)
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		c.renderList(w)
	})

	// POST /api/teams/{id}/rename
	// Renames a team. Form field: name. Returns the updated bot_panel.
	http.HandleFunc("POST /api/teams/{id}/rename", func(w http.ResponseWriter, r *http.Request) {
		id := r.PathValue("id")
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			respondText(w, 400, "missing name\n")
			return
		}
		team, err := renameTeam(c.db, id, name)
		if err != nil {
			respondText(w, 500, "rename failed\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		spectres, _ := listSpectresForTeam(c.db, id)
		_ = c.tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
			"TeamID":     id,
			"TeamName":   team.Name,
			"Slots":      buildTeamSlots(id, spectres, GetMaxSquadSize(c.db), GetEditOperativesFromTeam(c.db)),
			"TeamActive": team.Active,
		})
		c.renderSidebarOOB(w)
	})

	// POST /api/teams/{id}/active/toggle
	// Toggles the active flag (exclusive). Returns updated bot panel + OOB sidebar.
	http.HandleFunc("POST /api/teams/{id}/active/toggle", func(w http.ResponseWriter, r *http.Request) {
		id := r.PathValue("id")
		team, err := toggleTeamActive(c.db, id)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		// Primary: re-render the bot panel with the updated active state.
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		spectres, _ := listSpectresForTeam(c.db, id)
		_ = c.tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
			"TeamID":     id,
			"Slots":      buildTeamSlots(id, spectres, GetMaxSquadSize(c.db), GetEditOperativesFromTeam(c.db)),
			"TeamActive": team.Active,
		})
		// OOB: refresh the sidebar so team name colours update.
		c.renderSidebarOOB(w)
	})
}

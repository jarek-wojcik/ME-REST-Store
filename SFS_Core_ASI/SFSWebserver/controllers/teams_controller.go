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
	teams, err := listTeams(c.db)
	if err != nil {
		respondText(w, 500, "db error\n")
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "team_list", map[string]any{"Teams": teams})
}

func (c *TeamsController) renderSidebarOOB(w http.ResponseWriter) {
	teams, _ := listTeams(c.db)
	_ = c.tmpl.ExecuteTemplate(w, "team_sidebar_oob", map[string]any{"Teams": teams})
}

// Register wires all team-related HTTP routes onto the default mux.
func (c *TeamsController) Register() {
	// GET /api/teams
	// Returns the team list HTML partial (used by HTMX on initial tab load).
	http.HandleFunc("GET /api/teams", func(w http.ResponseWriter, r *http.Request) {
		c.renderList(w)
	})

	// POST /api/teams
	// Creates a new team. Form field: name. Returns the updated team list partial.
	http.HandleFunc("POST /api/teams", func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			respondText(w, 400, "missing name\n")
			return
		}
		if _, err := createTeam(c.db, name); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderList(w)
	})

	// DELETE /api/teams/{id}
	// Deletes a team by ID. Returns the updated team list partial.
	http.HandleFunc("DELETE /api/teams/{id}", func(w http.ResponseWriter, r *http.Request) {
		id := r.PathValue("id")
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
			"Bots":       teamSpectreViews(spectres),
			"TeamActive": team.Active,
		})
		// OOB: refresh the sidebar so team name colours update.
		c.renderSidebarOOB(w)
	})
}

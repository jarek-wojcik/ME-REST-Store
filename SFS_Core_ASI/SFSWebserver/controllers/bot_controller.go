package controllers

import (
	"fmt"
	"html/template"
	"net/http"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

// BotController handles all HTTP routes for the bot (squad teammate) resource.
type BotController struct {
	db   *bolt.DB
	tmpl *template.Template
}

func NewBotController(db *bolt.DB, tmpl *template.Template) *BotController {
	return &BotController{db: db, tmpl: tmpl}
}

func (c *BotController) renderPanel(w http.ResponseWriter, teamID string) {
	bots, err := listBotsForTeam(c.db, teamID)
	if err != nil {
		respondText(w, 500, "db error\n")
		return
	}
	team, _ := getTeam(c.db, teamID)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
		"TeamID":     teamID,
		"Bots":       botViews(bots),
		"TeamActive": team.Active,
	})
}

func (c *BotController) renderCard(w http.ResponseWriter, bot model.Bot) {
	def := model.CharacterByID(bot.CharacterID)
	if def == nil {
		def = &model.CharacterCatalog[0]
	}
	urls := botURLs(bot.ID)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "bot_card", BotView{
		Bot:           bot,
		Name:          def.Name,
		CharDef:       def,
		WeaponDef:     model.WeaponByID(bot.WeaponID),
		WeaponMod1Def: model.WeaponModByID(bot.WeaponMod1ID),
		WeaponMod2Def: model.WeaponModByID(bot.WeaponMod2ID),
		PowerViews:    powerViews(bot.Powers, urls.PowerBaseURL),
		CardURLs:      urls,
	})
}

// Register wires all bot-related HTTP routes onto the default mux.
func (c *BotController) Register() {
	// GET /api/teams/{id}/bots
	http.HandleFunc("GET /api/teams/{id}/bots", func(w http.ResponseWriter, r *http.Request) {
		c.renderPanel(w, r.PathValue("id"))
	})

	// POST /api/teams/{id}/bots
	// Creates a default bot (Human Adept Male) and returns the updated bot panel.
	http.HandleFunc("POST /api/teams/{id}/bots", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		bot, err := createBot(c.db, teamID, "AdeptHumanMale")
		if err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		w.Header().Set("HX-Trigger", `{"botCreated":{"id":"bot-card-`+bot.ID+`"}}`)
		c.renderPanel(w, teamID)
	})

	// DELETE /api/bots/{id}
	http.HandleFunc("DELETE /api/bots/{id}", func(w http.ResponseWriter, r *http.Request) {
		teamID, existed, err := deleteBot(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		c.renderPanel(w, teamID)
	})

	// POST /api/bots/{id}/character/{charId}
	http.HandleFunc("POST /api/bots/{id}/character/{charId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		bot, err := updateBotCharacter(c.db, botID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderPanel(w, bot.TeamID)
	})

	// POST /api/bots/{id}/weapon/{weaponId}
	http.HandleFunc("POST /api/bots/{id}/weapon/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		bot, err := updateBotWeapon(c.db, botID, weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, bot)
	})

	// POST /api/bots/{id}/mod/{slot}/{modId}
	http.HandleFunc("POST /api/bots/{id}/mod/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		slotStr := r.PathValue("slot")
		modID := r.PathValue("modId")
		var slot int
		switch slotStr {
		case "1":
			slot = 1
		case "2":
			slot = 2
		default:
			respondText(w, 400, "slot must be 1 or 2\n")
			return
		}
		if modID != "none" && model.WeaponModByID(modID) == nil {
			respondText(w, 400, "unknown mod\n")
			return
		}
		if modID == "none" {
			modID = ""
		}
		bot, err := updateBotWeaponMod(c.db, botID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}
	// Atomically sets rank AND one evolution choice (used for evo-cell clicks at ranks 4–6).
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, rank, evoIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 4 || rank > 6 {
			respondText(w, 400, "rank must be 4–6\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("evoIdx"), &evoIdx); err != nil || evoIdx < 0 || evoIdx > 2 {
			respondText(w, 400, "evoIdx must be 0–2\n")
			return
		}
		choice := r.PathValue("choice")
		if choice != "A" && choice != "B" {
			respondText(w, 400, "choice must be A or B\n")
			return
		}
		bot, err := updateBotPowerRankAndEvo(c.db, botID, slotIdx, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/rank/{rank}
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, rank int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		bot, err := updateBotPowerRank(c.db, botID, slotIdx, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/evo/{evoIdx}/{choice}
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/evo/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, evoIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("evoIdx"), &evoIdx); err != nil || evoIdx < 0 || evoIdx > 2 {
			respondText(w, 400, "evoIdx must be 0–2\n")
			return
		}
		choice := r.PathValue("choice")
		if choice != "A" && choice != "B" {
			respondText(w, 400, "choice must be A or B\n")
			return
		}
		bot, err := updateBotPowerEvolution(c.db, botID, slotIdx, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, bot)
	})
}

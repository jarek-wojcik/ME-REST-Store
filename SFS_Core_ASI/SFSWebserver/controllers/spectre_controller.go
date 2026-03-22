package controllers

import (
	"fmt"
	"html/template"
	"net/http"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

// SpectreController handles all HTTP routes for the spectre (player character) resource.
type SpectreController struct {
	db   *bolt.DB
	tmpl *template.Template
}

func NewSpectreController(db *bolt.DB, tmpl *template.Template) *SpectreController {
	return &SpectreController{db: db, tmpl: tmpl}
}

func (c *SpectreController) renderCard(w http.ResponseWriter, s model.Spectre) {
	def := model.CharacterByID(s.CharacterID)
	if def == nil {
		def = &model.CharacterCatalog[0]
	}
	var urls CardURLs
	if s.TeamID != "" {
		urls = teamSpectreURLs(s.ID)
	} else {
		urls = spectreURLs(s.ID)
		urls.IsActive = s.Active
	}
	urls.HasBorrowedPower = s.BorrowedPower != nil
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "character_card", SpectreView{
		Spectre:             s,
		CharDef:             def,
		AppearanceCharDef:   model.CharacterByID(s.AppearanceCharacterID),
		WeaponDef:           model.WeaponByID(s.WeaponID),
		WeaponMod1Def:       model.WeaponModByID(s.WeaponMod1ID),
		WeaponMod2Def:       model.WeaponModByID(s.WeaponMod2ID),
		Weapon2Def:          model.WeaponByID(s.Weapon2ID),
		Weapon2Mod1Def:      model.WeaponModByID(s.Weapon2Mod1ID),
		Weapon2Mod2Def:      model.WeaponModByID(s.Weapon2Mod2ID),
		ArmorConsumableDef:  model.ConsumableByID(s.ArmorConsumableID),
		WeaponConsumableDef: model.ConsumableByID(s.WeaponConsumableID),
		AmmoConsumableDef:   model.ConsumableByID(s.AmmoConsumableID),
		GearConsumableDef:   model.ConsumableByID(s.GearConsumableID),
		PowerViews:          spectrePowerViews(s, urls),
		CardURLs:            urls,
	})
}

func (c *SpectreController) renderBotPanel(w http.ResponseWriter, teamID string) {
	team, err := getTeam(c.db, teamID)
	if err != nil {
		// Team no longer exists — fall back to the spectre list.
		c.renderList(w)
		return
	}
	spectres, _ := listSpectresForTeam(c.db, teamID)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
		"TeamID":     teamID,
		"Bots":       teamSpectreViews(spectres),
		"TeamActive": team.Active,
	})
}

func (c *SpectreController) renderList(w http.ResponseWriter) {
	spectres, err := listSpectres(c.db)
	if err != nil {
		respondText(w, 500, "db error\n")
		return
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "spectre_list", map[string]any{
		"Spectres": spectreViews(spectres),
	})
}

// Register wires all spectre-related HTTP routes onto the default mux.
func (c *SpectreController) Register() {
	// GET /api/spectres
	// Returns the spectre list partial (full left+right panel).
	http.HandleFunc("GET /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		c.renderList(w)
	})

	// POST /api/spectres
	// Creates a new spectre. Form field: name. Returns updated spectre list.
	http.HandleFunc("POST /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		name := r.FormValue("name")
		if name == "" {
			respondText(w, 400, "missing name\n")
			return
		}
		if _, err := createSpectre(c.db, name); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderList(w)
	})

	// DELETE /api/spectres/{id}[?from=team]
	// Removes a spectre. If ?from=team is set, returns the updated bot panel;
	// otherwise (including spectre-tab deletes) returns the updated spectre list.
	http.HandleFunc("DELETE /api/spectres/{id}", func(w http.ResponseWriter, r *http.Request) {
		teamID, existed, err := deleteSpectre(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		if r.URL.Query().Get("from") == "team" && teamID != "" {
			c.renderBotPanel(w, teamID)
		} else {
			c.renderList(w)
		}
	})

	// GET /api/teams/{id}/spectres
	// Returns the bot_panel partial for a team's spectres.
	http.HandleFunc("GET /api/teams/{id}/spectres", func(w http.ResponseWriter, r *http.Request) {
		c.renderBotPanel(w, r.PathValue("id"))
	})

	// POST /api/teams/{id}/spectres
	// Creates a new spectre in the given team using the default character.
	// Returns the updated bot_panel.
	http.HandleFunc("POST /api/teams/{id}/spectres", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		const defaultChar = "AdeptHumanMale"
		if _, err := createTeamSpectre(c.db, teamID, defaultChar); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderBotPanel(w, teamID)
	})

	// GET /api/teams/{id}/spectres/picker[?step=existing|class]
	// Returns the add-spectre picker partial (team_add_picker) into #bot-panel.
	// ?step=existing — shows the roster of unassigned spectres to pick from.
	// ?step=class    — renders the character_selector modal for building a new spectre.
	// (no step)      — shows the initial two-choice screen.
	http.HandleFunc("GET /api/teams/{id}/spectres/picker", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		switch r.URL.Query().Get("step") {
		case "existing":
			all, _ := listSpectres(c.db)
			var standalone []model.Spectre
			for _, s := range all {
				if s.TeamID == "" {
					standalone = append(standalone, s)
				}
			}
			// Group spectres by CharDef.SubClass
			type SpectreGroup struct {
				SubClass string
				Spectres []SpectreView
			}
			subClassOrder := []string{"Soldier", "Adept", "Sentinel", "Engineer", "Vanguard", "Infiltrator", "Squadmate"}
			buckets := make(map[string][]SpectreView)
			for _, s := range standalone {
				def := model.CharacterByID(s.CharacterID)
				if def == nil {
					def = &model.CharacterCatalog[0]
				}
				view := SpectreView{
					Spectre:           s,
					CharDef:           def,
					AppearanceCharDef: model.CharacterByID(s.AppearanceCharacterID),
				}
				buckets[def.SubClass] = append(buckets[def.SubClass], view)
			}
			var groups []SpectreGroup
			for _, sc := range subClassOrder {
				if spectres, ok := buckets[sc]; ok {
					groups = append(groups, SpectreGroup{SubClass: sc, Spectres: spectres})
				}
			}
			_ = c.tmpl.ExecuteTemplate(w, "team_add_existing", map[string]any{
				"TeamID": teamID,
				"Groups": groups,
			})
		case "class":
			_ = c.tmpl.ExecuteTemplate(w, "character_selector", map[string]any{
				"CharPostURLBase": "/api/teams/" + teamID + "/spectres/class",
				"TargetID":        "bot-panel",
				"TargetSwap":      "innerHTML",
				"Groups":          model.GroupedCharacters(),
			})
		default:
			_ = c.tmpl.ExecuteTemplate(w, "team_add_picker", map[string]any{
				"TeamID": teamID,
			})
		}
	})

	// POST /api/teams/{id}/spectres/class/{charId}
	// Creates a new spectre in the team with the specified character class.
	// Returns the updated bot_panel.
	http.HandleFunc("POST /api/teams/{id}/spectres/class/{charId}", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		if _, err := createTeamSpectre(c.db, teamID, charID); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderBotPanel(w, teamID)
	})

	// POST /api/teams/{id}/spectres/pick/{spectreId}
	// Assigns an existing standalone spectre to the team.
	// Returns the updated bot_panel.
	http.HandleFunc("POST /api/teams/{id}/spectres/pick/{spectreId}", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		spectreID := r.PathValue("spectreId")
		if _, err := assignSpectreToTeam(c.db, spectreID, teamID); err != nil {
			respondText(w, 500, "assign failed\n")
			return
		}
		c.renderBotPanel(w, teamID)
	})

	// DELETE /api/teams/{id}/spectres/{spectreId}
	// Removes a spectre from the team without deleting it — TeamID is cleared.
	// Returns the updated bot_panel.
	http.HandleFunc("DELETE /api/teams/{id}/spectres/{spectreId}", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		spectreID := r.PathValue("spectreId")
		if _, err := unassignSpectreFromTeam(c.db, spectreID); err != nil {
			respondText(w, 500, "unassign failed\n")
			return
		}
		c.renderBotPanel(w, teamID)
	})

	// GET /api/spectres/{id}/card
	// Returns the character_card partial for a single spectre (loads the right panel).
	http.HandleFunc("GET /api/spectres/{id}/card", func(w http.ResponseWriter, r *http.Request) {
		s, err := getSpectre(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 404, "not found\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/character/{charId}
	http.HandleFunc("POST /api/spectres/{id}/character/{charId}", func(w http.ResponseWriter, r *http.Request) {
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		s, err := updateSpectreCharacter(c.db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/appearance/{charId}
	// Changes the portrait image only; base class, powers, and loadout are unchanged.
	http.HandleFunc("POST /api/spectres/{id}/appearance/{charId}", func(w http.ResponseWriter, r *http.Request) {
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		s, err := updateSpectreAppearance(c.db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/rename
	// Renames a spectre. Form body: name=<new name>. Returns the updated card.
	http.HandleFunc("POST /api/spectres/{id}/rename", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseForm(); err != nil {
			respondText(w, 400, "bad form\n")
			return
		}
		name := r.FormValue("name")
		if name == "" {
			respondText(w, 400, "name required\n")
			return
		}
		s, err := updateSpectreName(c.db, r.PathValue("id"), name)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)

		// OOB refresh both roster sidebar and team panel (if currently on team)
		spectres, _ := listSpectres(c.db)
		_ = c.tmpl.ExecuteTemplate(w, "spectre_sidebar_oob", map[string]any{
			"Spectres": spectreViews(spectres),
		})
		if s.TeamID != "" {
			team, err := getTeam(c.db, s.TeamID)
			if err == nil {
				teamSpectres, _ := listSpectresForTeam(c.db, s.TeamID)
				_ = c.tmpl.ExecuteTemplate(w, "bot_panel_oob", map[string]any{
					"TeamID":     s.TeamID,
					"Bots":       teamSpectreViews(teamSpectres),
					"TeamActive": team.Active,
				})
			}
		}
	})

	// POST /api/spectres/{id}/weapon/none
	http.HandleFunc("POST /api/spectres/{id}/weapon/none", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreWeapon(c.db, r.PathValue("id"), "")
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/weapon/{weaponId}
	http.HandleFunc("POST /api/spectres/{id}/weapon/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := updateSpectreWeapon(c.db, r.PathValue("id"), weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/weapon2/none
	http.HandleFunc("POST /api/spectres/{id}/weapon2/none", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreWeapon2(c.db, r.PathValue("id"), "")
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/weapon2/{weaponId}
	http.HandleFunc("POST /api/spectres/{id}/weapon2/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := updateSpectreWeapon2(c.db, r.PathValue("id"), weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/mod/{slot}/{modId}
	http.HandleFunc("POST /api/spectres/{id}/mod/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		s, err := updateSpectreWeaponMod(c.db, spectreID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/mod2/{slot}/{modId} — mod slots for second weapon
	http.HandleFunc("POST /api/spectres/{id}/mod2/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slotStr := r.PathValue("slot")
		modID := r.PathValue("modId")
		var slot int
		switch slotStr {
		case "1":
			slot = 1
		case "2":
			slot = 2
		default:
			respondText(w, 400, "invalid slot\n")
			return
		}
		if modID == "none" {
			modID = ""
		}
		s, err := updateSpectreWeapon2Mod(c.db, spectreID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		s, err := updateSpectrePowerRankAndEvo(c.db, spectreID, slotIdx, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/rank/{rank}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var slotIdx, rank int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		s, err := updateSpectrePowerRank(c.db, spectreID, slotIdx, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/evo/{evoIdx}/{choice}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/evo/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		s, err := updateSpectrePowerEvolution(c.db, spectreID, slotIdx, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// GET /api/spectres/{id}/borrowed-power/selector
	// Returns the borrow-power character picker partial (step 1 of the flow).
	http.HandleFunc("GET /api/spectres/{id}/borrowed-power/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_char", map[string]any{
			"Heading":         "Borrow a Power",
			"FromCharURLBase": "/api/spectres/" + spectreID + "/borrowed-power",
			"Groups":          model.GroupedCharacters(),
		})
	})

	// GET /api/spectres/{id}/borrowed-power/from-char/{charId}
	// Returns the power picker for the selected source character (step 2).
	http.HandleFunc("GET /api/spectres/{id}/borrowed-power/from-char/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		charDef := model.CharacterByID(charID)
		if charDef == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		var powers []*model.PowerDef
		for _, pid := range charDef.PowerIDs {
			if pid != "" {
				powers = append(powers, model.PowerByID(pid))
			}
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_power", map[string]any{
			"CharDef":      charDef,
			"Powers":       powers,
			"BackURL":      "/api/spectres/" + spectreID + "/borrowed-power/selector",
			"PostURLBase":  "/api/spectres/" + spectreID + "/borrowed-power/add",
			"TargetCardID": "spectre-card-" + spectreID,
		})
	})

	// POST /api/spectres/{id}/borrowed-power/add/{powerID}
	// Persists the chosen borrowed power and returns the refreshed spectre card.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/add/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		powerID := r.PathValue("powerID")
		if model.PowerByID(powerID) == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		s, err := addSpectreBorrowedPower(c.db, spectreID, powerID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// DELETE /api/spectres/{id}/borrowed-power
	// Removes the borrowed power slot and returns the refreshed spectre card.
	http.HandleFunc("DELETE /api/spectres/{id}/borrowed-power", func(w http.ResponseWriter, r *http.Request) {
		s, err := clearSpectreBorrowedPower(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/borrowed-power/rank/{rank}
	// Sets the rank of the borrowed power slot.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var rank int
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		s, err := updateSpectreBorrowedPowerRank(c.db, spectreID, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/borrowed-power/rankevo/{rank}/{evoIdx}/{choice}
	// Atomically sets rank and evolution choice on the borrowed power slot.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var rank, evoIdx int
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
		s, err := updateSpectreBorrowedPowerRankAndEvo(c.db, spectreID, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// GET /api/spectres/{id}/power/{slot}/change/selector
	// Opens the character picker for changing one normal power slot.
	http.HandleFunc("GET /api/spectres/{id}/power/{slot}/change/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slot := r.PathValue("slot")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_char", map[string]any{
			"Heading":         "Change Power",
			"FromCharURLBase": "/api/spectres/" + spectreID + "/power/" + slot + "/change",
			"Groups":          model.GroupedCharacters(),
		})
	})

	// GET /api/spectres/{id}/power/{slot}/change/from-char/{charId}
	// Returns the power picker for the selected source character.
	http.HandleFunc("GET /api/spectres/{id}/power/{slot}/change/from-char/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slot := r.PathValue("slot")
		charID := r.PathValue("charId")
		charDef := model.CharacterByID(charID)
		if charDef == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		var powers []*model.PowerDef
		for _, pid := range charDef.PowerIDs {
			if pid != "" {
				powers = append(powers, model.PowerByID(pid))
			}
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_power", map[string]any{
			"CharDef":      charDef,
			"Powers":       powers,
			"BackURL":      "/api/spectres/" + spectreID + "/power/" + slot + "/change/selector",
			"PostURLBase":  "/api/spectres/" + spectreID + "/power/" + slot + "/change/set",
			"TargetCardID": "spectre-card-" + spectreID,
		})
	})

	// POST /api/spectres/{id}/power/{slot}/change/set/{powerID}
	// Replaces the power in the given slot and returns the refreshed spectre card.
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/change/set/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		powerID := r.PathValue("powerID")
		var slotIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if model.PowerByID(powerID) == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		s, err := updateSpectrePowerID(c.db, spectreID, slotIdx, powerID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})

	// POST /api/spectres/{id}/active/toggle
	// Toggles the active flag. Returns the updated card (primary) + OOB sidebar refresh.
	http.HandleFunc("POST /api/spectres/{id}/active/toggle", func(w http.ResponseWriter, r *http.Request) {
		s, err := toggleSpectreActive(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
		spectres, _ := listSpectres(c.db)
		_ = c.tmpl.ExecuteTemplate(w, "spectre_sidebar_oob", map[string]any{
			"Spectres": spectreViews(spectres),
		})
	})

	// POST /api/spectres/{id}/consumable/{category}/{consumableId}
	// Sets one of the four consumable slots on a spectre. Use consumableId "none" to clear.
	http.HandleFunc("POST /api/spectres/{id}/consumable/{category}/{consumableId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		categoryStr := r.PathValue("category")
		consumableID := r.PathValue("consumableId")

		var category model.ConsumableCategory
		switch categoryStr {
		case "armor":
			category = model.ConsumableCategoryArmor
		case "weapon":
			category = model.ConsumableCategoryWeapon
		case "ammo":
			category = model.ConsumableCategoryAmmo
		case "gear":
			category = model.ConsumableCategoryGear
		default:
			respondText(w, 400, "category must be armor, weapon, ammo, or gear\n")
			return
		}
		if consumableID == "none" {
			consumableID = ""
		} else if model.ConsumableByID(consumableID) == nil {
			respondText(w, 400, "unknown consumable\n")
			return
		}
		s, err := updateSpectreConsumable(c.db, spectreID, category, consumableID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s)
	})
}

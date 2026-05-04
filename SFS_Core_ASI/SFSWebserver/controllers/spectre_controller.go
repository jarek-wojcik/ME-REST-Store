package controllers

import (
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"

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

func (c *SpectreController) renderCard(w http.ResponseWriter, s model.Spectre, fromTeam bool) {
	// Standalone spectres use the new RPG character sheet layout.
	if !fromTeam {
		c.renderCardSheet(w, s)
		return
	}
	def := model.CharacterByID(s.CharacterID)
	if def == nil {
		def = &model.CharacterCatalog[0]
	}
	var urls CardURLs
	urls = teamSpectreURLs(s.ID)
	urls.HasBorrowedPower = s.BorrowedPower != nil
	appearanceDef := model.CharacterByID(s.AppearanceCharacterID)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "character_card", SpectreView{
		Spectre:             s,
		CharDef:             def,
		AppearanceCharDef:   appearanceDef,
		ShowHelmetToggle:    def.HasHelmet || (appearanceDef != nil && appearanceDef.HasHelmet),
		ShowHeadgearToggle:  def.HasHeadgear || (appearanceDef != nil && appearanceDef.HasHeadgear),
		WeaponViews:         weaponSlotViews(s.ID, s.Weapons),
		ArmorConsumableDef:  model.ConsumableByID(s.ArmorConsumableID),
		WeaponConsumableDef: model.ConsumableByID(s.WeaponConsumableID),
		AmmoConsumableDef:   model.ConsumableByID(s.AmmoConsumableID),
		GearConsumableDef:   model.ConsumableByID(s.GearConsumableID),
		PowerViews:          spectrePowerViews(s, urls),
		CardURLs:            urls,
	})
}

// xpProgressPct returns the 0-100 percentage of XP progress toward the next
// level threshold. For level 1, the base is 0 (not 100k) so that characters
// below the level-1 gate still show meaningful bar progress.
func xpProgressPct(level, xp int) int {
	var base int
	if level >= 2 {
		base = model.XPForLevel(level)
	}
	next := model.XPForLevel(level + 1)
	gap := next - base
	if gap <= 0 {
		return 100
	}
	pct := (xp - base) * 100 / gap
	if pct < 0 {
		return 0
	}
	if pct > 100 {
		return 100
	}
	return pct
}

// formatXP returns xp formatted with thousand-separator commas.
func formatXP(xp int) string {
	s := fmt.Sprintf("%d", xp)
	for i := len(s) - 3; i > 0; i -= 3 {
		s = s[:i] + "," + s[i:]
	}
	return s
}

// renderCardSheet renders a standalone spectre using the character-sheet template.
func (c *SpectreController) renderCardSheet(w http.ResponseWriter, s model.Spectre) {
	def := model.CharacterByID(s.CharacterID)
	if def == nil {
		def = &model.CharacterCatalog[0]
	}
	urls := spectreURLs(s.ID)
	urls.HasBorrowedPower = s.BorrowedPower != nil
	urls.IsActive = s.Active
	if s.PreferredSpecies != "" {
		urls.AppearanceSelectorURL += "&species=" + s.PreferredSpecies
	}
	appearanceDef := model.CharacterByID(s.AppearanceCharacterID)
	voiceDef := model.CharacterByQualifiedPath(s.VoiceCharacterID)
	heavyMeleeDef := model.CharacterByQualifiedPath(s.HeavyMeleeCharID)
	lightMeleeDef := model.CharacterByQualifiedPath(s.LightMeleeCharID)
	dodgeDef := model.CharacterByQualifiedPath(s.DodgeCharID)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "character_card_sheet", SpectreView{
		Mode:                "Operative",
		Spectre:             s,
		CharDef:             def,
		AppearanceCharDef:   appearanceDef,
		VoiceCharDef:        voiceDef,
		HeavyMeleeCharDef:   heavyMeleeDef,
		LightMeleeCharDef:   lightMeleeDef,
		DodgeCharDef:        dodgeDef,
		ShowHelmetToggle:    def.HasHelmet || (appearanceDef != nil && appearanceDef.HasHelmet),
		ShowHeadgearToggle:  def.HasHeadgear || (appearanceDef != nil && appearanceDef.HasHeadgear),
		WeaponViews:         weaponSlotViews(s.ID, s.Weapons),
		ArmorConsumableDef:  model.ConsumableByID(s.ArmorConsumableID),
		WeaponConsumableDef: model.ConsumableByID(s.WeaponConsumableID),
		AmmoConsumableDef:   model.ConsumableByID(s.AmmoConsumableID),
		GearConsumableDef:   model.ConsumableByID(s.GearConsumableID),
		PowerViews:          spectrePowerViews(s, urls),
		SkillViews:          spectreSkillViews(s, s.ID),
		XPProgressPct:       xpProgressPct(s.Level, s.XP),
		XPDisplay:           formatXP(s.XP),
		XPNextLevelDisplay:  formatXP(model.XPForLevel(s.Level + 1)),
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
	maxSize := GetMaxSquadSize(c.db)
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
		"TeamID":     teamID,
		"TeamName":   team.Name,
		"Slots":      buildTeamSlots(teamID, spectres, maxSize, GetEditOperativesFromTeam(c.db)),
		"TeamActive": team.Active,
	})
}

func (c *SpectreController) renderList(w http.ResponseWriter) {
	c.renderListWithCard(w, "")
}

func (c *SpectreController) renderListWithCard(w http.ResponseWriter, selectedID string) {
	spectres, err := listSpectres(c.db)
	if err != nil {
		respondText(w, 500, "db error\n")
		return
	}
	var selectedView *SpectreView
	if selectedID != "" {
		for _, s := range spectres {
			if s.ID == selectedID {
				v := c.buildCardSheetView(s)
				selectedView = &v
				break
			}
		}
	}
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_ = c.tmpl.ExecuteTemplate(w, "spectre_list", map[string]any{
		"Spectres":     spectreViews(spectres),
		"SelectedView": selectedView,
		"SelectedID":   selectedID,
	})
}

// buildCardSheetView constructs the SpectreView used by the character_card_sheet template.
func (c *SpectreController) buildCardSheetView(s model.Spectre) SpectreView {
	def := model.CharacterByID(s.CharacterID)
	if def == nil {
		def = &model.CharacterCatalog[0]
	}
	urls := spectreURLs(s.ID)
	urls.HasBorrowedPower = s.BorrowedPower != nil
	urls.IsActive = s.Active
	if s.PreferredSpecies != "" {
		urls.AppearanceSelectorURL += "&species=" + s.PreferredSpecies
	}
	appearanceDef := model.CharacterByID(s.AppearanceCharacterID)
	voiceDef := model.CharacterByQualifiedPath(s.VoiceCharacterID)
	heavyMeleeDef := model.CharacterByQualifiedPath(s.HeavyMeleeCharID)
	lightMeleeDef := model.CharacterByQualifiedPath(s.LightMeleeCharID)
	dodgeDef := model.CharacterByQualifiedPath(s.DodgeCharID)
	return SpectreView{
		Mode:                "Operative",
		Spectre:             s,
		CharDef:             def,
		AppearanceCharDef:   appearanceDef,
		VoiceCharDef:        voiceDef,
		HeavyMeleeCharDef:   heavyMeleeDef,
		LightMeleeCharDef:   lightMeleeDef,
		DodgeCharDef:        dodgeDef,
		ShowHelmetToggle:    def.HasHelmet || (appearanceDef != nil && appearanceDef.HasHelmet),
		ShowHeadgearToggle:  def.HasHeadgear || (appearanceDef != nil && appearanceDef.HasHeadgear),
		WeaponViews:         weaponSlotViews(s.ID, s.Weapons),
		ArmorConsumableDef:  model.ConsumableByID(s.ArmorConsumableID),
		WeaponConsumableDef: model.ConsumableByID(s.WeaponConsumableID),
		AmmoConsumableDef:   model.ConsumableByID(s.AmmoConsumableID),
		GearConsumableDef:   model.ConsumableByID(s.GearConsumableID),
		PowerViews:          spectrePowerViews(s, urls),
		SkillViews:          spectreSkillViews(s, s.ID),
		XPProgressPct:       xpProgressPct(s.Level, s.XP),
		XPDisplay:           formatXP(s.XP),
		XPNextLevelDisplay:  formatXP(model.XPForLevel(s.Level + 1)),
		CardURLs:            urls,
	}
}

// Register wires all spectre-related HTTP routes onto the default mux.
func (c *SpectreController) Register() {
	// GET /api/spectres
	// Returns the spectre list partial (full left+right panel).
	http.HandleFunc("GET /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		c.renderList(w)
	})

	// POST /api/spectres
	// Creates a new spectre with a default name. Returns updated spectre list with the new card selected.
	http.HandleFunc("POST /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			name = "New Operative"
		}
		s, err := createSpectre(c.db, name)
		if err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		c.renderListWithCard(w, s.ID)
	})

	// POST /api/spectres/{id}/duplicate
	// Creates a full copy of the spectre as a new standalone operative.
	// Returns the updated spectre list.
	http.HandleFunc("POST /api/spectres/{id}/duplicate", func(w http.ResponseWriter, r *http.Request) {
		if _, err := duplicateSpectre(c.db, r.PathValue("id")); err != nil {
			respondText(w, 500, "duplicate failed\n")
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
		if _, err := createTeamSpectre(c.db, teamID, defaultChar, GetMaxSquadSize(c.db)); err != nil {
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
		if _, err := createTeamSpectre(c.db, teamID, charID, GetMaxSquadSize(c.db)); err != nil {
			if strings.Contains(err.Error(), "team is full") {
				respondText(w, 409, err.Error()+"\n")
				return
			}
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
		if _, err := assignSpectreToTeam(c.db, spectreID, teamID, GetMaxSquadSize(c.db)); err != nil {
			if strings.Contains(err.Error(), "team is full") {
				respondText(w, 409, err.Error()+"\n")
				return
			}
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
		fromTeam := r.URL.Query().Get("from") == "team"
		c.renderCard(w, s, fromTeam)
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
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/voice/{charId}
	// Sets the voice archetype for the spectre, stored as RootPath.ArchetypeID.
	// The portrait/character class are not affected.
	http.HandleFunc("POST /api/spectres/{id}/voice/{charId}", func(w http.ResponseWriter, r *http.Request) {
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		s, err := updateSpectreVoice(c.db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/heavy-melee/{charId}
	// Sets the heavy melee archetype override, stored as RootPath.ArchetypeID.
	// Only characters with HasUniqueHeavyMelee are valid; other fields are unchanged.
	// When the chosen character has BuggedHeavyMelee set, a warning is shown first;
	// the player can still confirm the assignment via ?force=1.
	http.HandleFunc("POST /api/spectres/{id}/heavy-melee/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		def := model.CharacterByID(charID)
		if def == nil || !def.HasUniqueHeavyMelee {
			respondText(w, 400, "unknown or ineligible character\n")
			return
		}
		if def.BuggedHeavyMelee && r.URL.Query().Get("force") != "1" {
			respondBuggedOverride(w, c.tmpl, def.Name+" Heavy Melee", def.BuggedCustomActionMessage,
				"/api/spectres/"+spectreID+"/heavy-melee/"+charID+"?force=1",
				"spectre-card-"+spectreID)
			return
		}
		s, err := updateSpectreHeavyMelee(c.db, spectreID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/light-melee/{charId}
	// Sets the light melee archetype override, stored as RootPath.ArchetypeID.
	// Only characters with HasUniqueLightMelee are valid; other fields are unchanged.
	// When the chosen character has BuggedLightMelee set, a warning is shown first;
	// the player can still confirm the assignment via ?force=1.
	http.HandleFunc("POST /api/spectres/{id}/light-melee/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		def := model.CharacterByID(charID)
		if def == nil || !def.HasUniqueLightMelee {
			respondText(w, 400, "unknown or ineligible character\n")
			return
		}
		if def.BuggedLightMelee && r.URL.Query().Get("force") != "1" {
			respondBuggedOverride(w, c.tmpl, def.Name+" Light Melee", def.BuggedCustomActionMessage,
				"/api/spectres/"+spectreID+"/light-melee/"+charID+"?force=1",
				"spectre-card-"+spectreID)
			return
		}
		s, err := updateSpectreLightMelee(c.db, spectreID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/dodge/{charId}
	// Sets the dodge archetype override, stored as RootPath.ArchetypeID.
	// Only characters with HasUniqueDodge are valid; other fields are unchanged.
	// When the chosen character has BuggedDodge set, a warning is shown first;
	// the player can still confirm the assignment via ?force=1.
	http.HandleFunc("POST /api/spectres/{id}/dodge/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		def := model.CharacterByID(charID)
		if def == nil || !def.HasUniqueDodge {
			respondText(w, 400, "unknown or ineligible character\n")
			return
		}
		if def.BuggedDodge && r.URL.Query().Get("force") != "1" {
			respondBuggedOverride(w, c.tmpl, def.Name+" Dodge", def.BuggedCustomActionMessage,
				"/api/spectres/"+spectreID+"/dodge/"+charID+"?force=1",
				"spectre-card-"+spectreID)
			return
		}
		s, err := updateSpectreDodge(c.db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)

		// OOB refresh both roster sidebar and team panel (if currently on team)
		spectres, _ := listSpectres(c.db)
		_ = c.tmpl.ExecuteTemplate(w, "spectre_sidebar_oob", map[string]any{
			"Spectres":   spectreViews(spectres),
			"SelectedID": "",
		})
		if s.TeamID != "" {
			team, err := getTeam(c.db, s.TeamID)
			if err == nil {
				teamSpectres, _ := listSpectresForTeam(c.db, s.TeamID)
				_ = c.tmpl.ExecuteTemplate(w, "bot_panel_oob", map[string]any{
					"TeamID":     s.TeamID,
					"Bots":       teamSpectreViews(teamSpectres, GetEditOperativesFromTeam(c.db)),
					"TeamActive": team.Active,
				})
			}
		}
	})

	// POST /api/spectres/{id}/weapon/add/{weaponId}
	// Appends a new weapon slot (max 5 total).
	http.HandleFunc("POST /api/spectres/{id}/weapon/add/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := addSpectreWeapon(c.db, r.PathValue("id"), weaponID)
		if err != nil {
			respondText(w, 400, err.Error()+"\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/weapon/{idx}/{weaponId}
	// Sets the weapon at an existing slot index. Use weaponId "none" to clear.
	http.HandleFunc("POST /api/spectres/{id}/weapon/{idx}/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		idx, err := strconv.Atoi(r.PathValue("idx"))
		if err != nil || idx < 0 {
			respondText(w, 400, "invalid weapon index\n")
			return
		}
		weaponID := r.PathValue("weaponId")
		if weaponID == "none" {
			weaponID = ""
		} else if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := setSpectreWeapon(c.db, r.PathValue("id"), idx, weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// DELETE /api/spectres/{id}/weapon/{idx}
	// Removes the weapon slot at the given index entirely.
	http.HandleFunc("DELETE /api/spectres/{id}/weapon/{idx}", func(w http.ResponseWriter, r *http.Request) {
		idx, err := strconv.Atoi(r.PathValue("idx"))
		if err != nil || idx < 0 {
			respondText(w, 400, "invalid weapon index\n")
			return
		}
		s, err := removeSpectreWeapon(c.db, r.PathValue("id"), idx)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/weapon/{idx}/firemode/{mode}
	// Sets the fire mode (Semi, Burst, FullAuto) for the weapon at the given slot index.
	http.HandleFunc("POST /api/spectres/{id}/weapon/{idx}/firemode/{mode}", func(w http.ResponseWriter, r *http.Request) {
		idx, err := strconv.Atoi(r.PathValue("idx"))
		if err != nil || idx < 0 {
			respondText(w, 400, "invalid weapon index\n")
			return
		}
		var mode model.FireMode
		switch r.PathValue("mode") {
		case "Semi":
			mode = model.FireModeSemi
		case "Burst":
			mode = model.FireModeBurst
		case "FullAuto":
			mode = model.FireModeFullAuto
		default:
			respondText(w, 400, "mode must be Semi, Burst, or FullAuto\n")
			return
		}
		s, err := setSpectreWeaponFireMode(c.db, r.PathValue("id"), idx, mode)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/weapon/{idx}/mod/{slot}/{modId}
	// Sets mod slot 1 or 2 for the weapon at the given index.
	http.HandleFunc("POST /api/spectres/{id}/weapon/{idx}/mod/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		wIdx, err := strconv.Atoi(r.PathValue("idx"))
		if err != nil || wIdx < 0 {
			respondText(w, 400, "invalid weapon index\n")
			return
		}
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
		s, err := setSpectreWeaponMod(c.db, spectreID, wIdx, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
	})

	// DELETE /api/spectres/{id}/power/{slot}
	// Clears the power from the specified slot and returns the refreshed spectre card.
	http.HandleFunc("DELETE /api/spectres/{id}/power/{slot}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var slotIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		s, err := clearSpectrePower(c.db, spectreID, slotIdx)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
	})

	// GET /api/spectres/{id}/borrowed-power/selector
	// Returns the flat power-picker partial filtered to Active-typed powers only.
	http.HandleFunc("GET /api/spectres/{id}/borrowed-power/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_power_flat", map[string]any{
			"Heading":      "Borrow an Active Power",
			"Powers":       model.AllPowersWithSourceOfType(model.PowerTypeActive),
			"PostURLBase":  "/api/spectres/" + spectreID + "/borrowed-power/add",
			"TargetCardID": "spectre-card-" + spectreID,
		})
	})

	// GET /api/spectres/{id}/borrowed-power/from-char/{charId}
	// Returns the power picker for the selected source character (step 2),
	// filtered to Active-typed powers only.
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
			if pid == "" {
				continue
			}
			pd := model.PowerByID(pid)
			if pd != nil && pd.Type == model.PowerTypeActive {
				powers = append(powers, pd)
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

	// POST /api/spectres/{id}/borrowed-power/add/{charId}/{powerID}
	// Persists the chosen borrowed power and returns the refreshed spectre card.
	// Only Active-typed powers may be borrowed.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/add/{charId}/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		powerID := r.PathValue("powerID")
		pd := model.PowerByID(powerID)
		if pd == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		if pd.Type != model.PowerTypeActive {
			respondText(w, 400, "only Active powers may be borrowed\n")
			return
		}
		s, err := addSpectreBorrowedPower(c.db, spectreID, powerID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// DELETE /api/spectres/{id}/borrowed-power
	// Removes the borrowed power slot and returns the refreshed spectre card.
	http.HandleFunc("DELETE /api/spectres/{id}/borrowed-power", func(w http.ResponseWriter, r *http.Request) {
		s, err := clearSpectreBorrowedPower(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
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
		c.renderCard(w, s, false)
	})

	// GET /api/spectres/{id}/power/{slot}/change/selector
	// Opens the flat power-picker for changing one normal power slot.
	// The optional ?type= query param (Active, Passive, MeleePassive) restricts the list.
	http.HandleFunc("GET /api/spectres/{id}/power/{slot}/change/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slot := r.PathValue("slot")
		typeFilter := model.PowerType(r.URL.Query().Get("type"))
		var powers []model.PowerWithSource
		var heading string
		switch typeFilter {
		case model.PowerTypePassive:
			powers = model.AllPowersWithSourceOfType(model.PowerTypePassive)
			heading = "Change Passive Power"
		case model.PowerTypeMeleePassive:
			powers = model.AllPowersWithSourceOfType(model.PowerTypeMeleePassive)
			heading = "Change Melee Passive Power"
		default:
			powers = model.AllPowersWithSourceOfType(model.PowerTypeActive)
			heading = "Change Active Power"
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "spectre_borrow_power_flat", map[string]any{
			"Heading":      heading,
			"Powers":       powers,
			"PostURLBase":  "/api/spectres/" + spectreID + "/power/" + slot + "/change/set",
			"TargetCardID": "spectre-card-" + spectreID,
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

	// POST /api/spectres/{id}/power/{slot}/change/set/{charId}/{powerID}
	// Replaces the power in the given slot and returns the refreshed spectre card.
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/change/set/{charId}/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		powerID := r.PathValue("powerID")
		var slotIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		pd := model.PowerByID(powerID)
		if pd == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		// Enforce type constraints for the fixed passive slots.
		requiredType := powerTypeForSlot(slotIdx)
		if requiredType != "" && pd.Type != requiredType {
			respondText(w, 400, "power type does not match slot\n")
			return
		}
		s, err := updateSpectrePowerID(c.db, spectreID, slotIdx, powerID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/active/toggle
	// Toggles the active flag. Returns the updated card (primary) + OOB sidebar refresh.
	http.HandleFunc("POST /api/spectres/{id}/active/toggle", func(w http.ResponseWriter, r *http.Request) {
		s, err := toggleSpectreActive(c.db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
		spectres, _ := listSpectres(c.db)
		_ = c.tmpl.ExecuteTemplate(w, "spectre_sidebar_oob", map[string]any{
			"Spectres":   spectreViews(spectres),
			"SelectedID": "",
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
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/visual/{choice}
	// Toggles helmet or headgear visual (mutually exclusive). choice: helmet | headgear.
	// Clicking the already-active choice clears both (toggle off).
	http.HandleFunc("POST /api/spectres/{id}/visual/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		choice := r.PathValue("choice")
		if choice != "helmet" && choice != "headgear" {
			respondText(w, 400, "choice must be helmet or headgear\n")
			return
		}
		s, err := setSpectreVisual(c.db, spectreID, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/shield-type
	// Sets the ShieldType field. Form field: shieldType = "Shield" | "Barrier".
	http.HandleFunc("POST /api/spectres/{id}/shield-type", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseForm(); err != nil {
			respondText(w, 400, "bad form\n")
			return
		}
		shieldType := r.FormValue("shieldType")
		if shieldType != "Shield" && shieldType != "Barrier" {
			respondText(w, 400, "shieldType must be Shield or Barrier\n")
			return
		}
		s, err := updateSpectreShieldType(c.db, r.PathValue("id"), shieldType)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/species
	// Sets the PreferredSpecies filter used by the appearance selector.
	// Form field: species = species name, or empty string for "Any".
	http.HandleFunc("POST /api/spectres/{id}/species", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseForm(); err != nil {
			respondText(w, 400, "bad form\n")
			return
		}
		s, err := updateSpectrePreferredSpecies(c.db, r.PathValue("id"), r.FormValue("species"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		c.renderCard(w, s, false)
	})

	c.RegisterSkillRoutes()
}

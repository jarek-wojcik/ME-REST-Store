package controllers

import (
	"html/template"
	"net/http"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

// SelectorsController handles the shared character, weapon, and weapon-mod
// picker endpoints used by both bot and spectre cards.
type SelectorsController struct {
	db   *bolt.DB
	tmpl *template.Template
}

func NewSelectorsController(db *bolt.DB, tmpl *template.Template) *SelectorsController {
	return &SelectorsController{db: db, tmpl: tmpl}
}

// Register wires all selector routes onto the default mux.
func (c *SelectorsController) Register() {
	// GET /api/characters/selector?entityId={id}&kind={bot|spectre|spectre-appearance}
	// Returns the character selector grid partial for use in the modal.
	http.HandleFunc("GET /api/characters/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		if entityID == "" {
			respondText(w, 400, "missing entityId\n")
			return
		}
		var charPostURLBase, targetID, targetSwap string
		switch kind {
		case "spectre":
			charPostURLBase = "/api/spectres/" + entityID + "/character"
			targetID = "spectre-card-" + entityID
			targetSwap = "outerHTML"
		case "spectre-appearance":
			charPostURLBase = "/api/spectres/" + entityID + "/appearance"
			targetID = "spectre-card-" + entityID
			targetSwap = "outerHTML"
		default: // "bot"
			charPostURLBase = "/api/bots/" + entityID + "/character"
			targetID = "bot-panel"
			targetSwap = "innerHTML"
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "character_selector", map[string]any{
			"CharPostURLBase": charPostURLBase,
			"TargetID":        targetID,
			"TargetSwap":      targetSwap,
			"Groups":          model.GroupedCharacters(),
		})
	})

	// GET /api/weapons/selector?entityId={id}&kind={bot|spectre|spectre-weapon2}
	// Returns the weapon selector grid partial for use in the modal.
	http.HandleFunc("GET /api/weapons/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		if entityID == "" {
			respondText(w, 400, "missing entityId\n")
			return
		}
		var weaponPostURLBase, targetID string
		switch kind {
		case "spectre":
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon"
			targetID = "spectre-card-" + entityID
		case "spectre-weapon2":
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon2"
			targetID = "spectre-card-" + entityID
		default: // "bot"
			weaponPostURLBase = "/api/bots/" + entityID + "/weapon"
			targetID = "bot-card-" + entityID
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "weapon_selector", map[string]any{
			"WeaponPostURLBase": weaponPostURLBase,
			"TargetID":          targetID,
			"Groups":            model.GroupedWeapons(),
		})
	})

	// GET /api/weapon-mods/selector?entityId={id}&kind={bot|spectre|spectre-weapon2}&slot={1|2}
	// Returns the weapon mod selector grid partial for use in the modal.
	// Only mods compatible with the entity's currently equipped weapon are shown;
	// universal mods (WeaponTypeAny) are always included.
	http.HandleFunc("GET /api/weapon-mods/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		slot := r.URL.Query().Get("slot")
		kind := r.URL.Query().Get("kind")
		if entityID == "" || (slot != "1" && slot != "2") {
			respondText(w, 400, "missing or invalid entityId/slot\n")
			return
		}
		var weaponID string
		switch kind {
		case "spectre":
			if sv, err := getSpectre(c.db, entityID); err == nil {
				weaponID = sv.WeaponID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		case "spectre-weapon2":
			if sv, err := getSpectre(c.db, entityID); err == nil {
				weaponID = sv.Weapon2ID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		default: // "bot"
			if bv, err := getBot(c.db, entityID); err == nil {
				weaponID = bv.WeaponID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		}
		weaponDef := model.WeaponByID(weaponID)
		var filtered []model.WeaponModDef
		for _, mod := range model.WeaponModCatalog {
			if mod.WeaponType == model.WeaponTypeAny {
				filtered = append(filtered, mod)
			} else if weaponDef != nil && mod.WeaponType == weaponDef.Category {
				filtered = append(filtered, mod)
			}
		}
		var modPostURLBase, targetID string
		switch kind {
		case "spectre":
			modPostURLBase = "/api/spectres/" + entityID + "/mod/" + slot
			targetID = "spectre-card-" + entityID
		case "spectre-weapon2":
			modPostURLBase = "/api/spectres/" + entityID + "/mod2/" + slot
			targetID = "spectre-card-" + entityID
		default: // "bot"
			modPostURLBase = "/api/bots/" + entityID + "/mod/" + slot
			targetID = "bot-card-" + entityID
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "weapon_mod_selector", map[string]any{
			"ModPostURLBase": modPostURLBase,
			"ModClearURL":    modPostURLBase + "/none",
			"TargetID":       targetID,
			"Slot":           slot,
			"Mods":           filtered,
		})
	})
}

package controllers

import (
	"html/template"
	"net/http"
	"strconv"

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
	// GET /api/characters/selector?entityId={id}&kind={spectre|spectre-appearance|spectre-voice}
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
		case "spectre-appearance":
			charPostURLBase = "/api/spectres/" + entityID + "/appearance"
			targetID = "spectre-card-" + entityID
			targetSwap = "outerHTML"
		case "spectre-voice":
			charPostURLBase = "/api/spectres/" + entityID + "/voice"
			targetID = "spectre-card-" + entityID
			targetSwap = "outerHTML"
		default: // "spectre"
			charPostURLBase = "/api/spectres/" + entityID + "/character"
			targetID = "spectre-card-" + entityID
			targetSwap = "outerHTML"
		}
		species := r.URL.Query().Get("species")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		if kind == "spectre-appearance" {
			_ = c.tmpl.ExecuteTemplate(w, "appearance_selector", map[string]any{
				"Title":           "Select Appearance",
				"CharPostURLBase": charPostURLBase,
				"TargetID":        targetID,
				"TargetSwap":      targetSwap,
				"Characters":      model.AppearanceCharacters(species),
			})
		} else if kind == "spectre-voice" {
			_ = c.tmpl.ExecuteTemplate(w, "appearance_selector", map[string]any{
				"Title":           "Select Voice",
				"CharPostURLBase": charPostURLBase,
				"TargetID":        targetID,
				"TargetSwap":      targetSwap,
				"Characters":      model.AppearanceCharacters(""), // no species filter for voices
			})
		} else {
			_ = c.tmpl.ExecuteTemplate(w, "character_selector", map[string]any{
				"CharPostURLBase": charPostURLBase,
				"TargetID":        targetID,
				"TargetSwap":      targetSwap,
				"Groups":          model.GroupedCharactersBySpecies(species),
			})
		}
	})

	// GET /api/weapons/selector?entityId={id}&kind={spectre-add|spectre-weapon}&weaponIdx={n}
	// kind=spectre-add   → opens picker to append a new weapon slot
	// kind=spectre-weapon → opens picker to replace weapon at slot weaponIdx
	http.HandleFunc("GET /api/weapons/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		if entityID == "" {
			respondText(w, 400, "missing entityId\n")
			return
		}
		var weaponPostURLBase, targetID string
		switch kind {
		case "spectre-add":
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon/add"
			targetID = "spectre-card-" + entityID
		case "spectre-weapon":
			idxStr := r.URL.Query().Get("weaponIdx")
			if _, err := strconv.Atoi(idxStr); err != nil {
				respondText(w, 400, "missing or invalid weaponIdx\n")
				return
			}
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon/" + idxStr
			targetID = "spectre-card-" + entityID
		default:
			respondText(w, 400, "unknown kind\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "weapon_selector", map[string]any{
			"WeaponPostURLBase": weaponPostURLBase,
			"TargetID":          targetID,
			"Groups":            model.GroupedWeapons(),
		})
	})

	// GET /api/weapon-mods/selector?entityId={id}&kind=spectre-weapon&weaponIdx={n}&slot={1|2}
	// Only mods compatible with the entity's currently equipped weapon are shown;
	// universal mods (WeaponTypeAny) are always included.
	http.HandleFunc("GET /api/weapon-mods/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		slot := r.URL.Query().Get("slot")
		kind := r.URL.Query().Get("kind")
		idxStr := r.URL.Query().Get("weaponIdx")
		if entityID == "" || (slot != "1" && slot != "2") {
			respondText(w, 400, "missing or invalid entityId/slot\n")
			return
		}
		wIdx, err := strconv.Atoi(idxStr)
		if err != nil || wIdx < 0 {
			respondText(w, 400, "missing or invalid weaponIdx\n")
			return
		}
		var weaponID string
		if kind == "spectre-weapon" {
			sv, err := getSpectre(c.db, entityID)
			if err != nil {
				respondText(w, 404, "entity not found\n")
				return
			}
			if wIdx < len(sv.Weapons) {
				weaponID = sv.Weapons[wIdx].WeaponID
			}
		} else {
			respondText(w, 400, "unknown kind\n")
			return
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
		modPostURLBase := "/api/spectres/" + entityID + "/weapon/" + idxStr + "/mod/" + slot
		targetID := "spectre-card-" + entityID
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "weapon_mod_selector", map[string]any{
			"ModPostURLBase": modPostURLBase,
			"ModClearURL":    modPostURLBase + "/none",
			"TargetID":       targetID,
			"Slot":           slot,
			"Mods":           filtered,
		})
	})

	// GET /api/consumables/selector?entityId={id}&kind=spectre&category={armor|weapon|ammo|gear}
	// Returns the consumable selector grid partial for use in the modal.
	http.HandleFunc("GET /api/consumables/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		categoryStr := r.URL.Query().Get("category")
		if entityID == "" || categoryStr == "" {
			respondText(w, 400, "missing entityId or category\n")
			return
		}

		var consumableCategory model.ConsumableCategory
		switch categoryStr {
		case "armor":
			consumableCategory = model.ConsumableCategoryArmor
		case "weapon":
			consumableCategory = model.ConsumableCategoryWeapon
		case "ammo":
			consumableCategory = model.ConsumableCategoryAmmo
		case "gear":
			consumableCategory = model.ConsumableCategoryGear
		default:
			respondText(w, 400, "category must be armor, weapon, ammo, or gear\n")
			return
		}

		var postURLBase, targetID string
		switch kind {
		case "spectre":
			postURLBase = "/api/spectres/" + entityID + "/consumable/" + categoryStr
			targetID = "spectre-card-" + entityID
		default: // "spectre"
			postURLBase = "/api/spectres/" + entityID + "/consumable/" + categoryStr
			targetID = "spectre-card-" + entityID
		}

		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = c.tmpl.ExecuteTemplate(w, "consumable_selector", map[string]any{
			"ConsumablePostURLBase": postURLBase,
			"ConsumableClearURL":    postURLBase + "/none",
			"TargetID":              targetID,
			"CategoryTitle":         string(consumableCategory),
			"Consumables":           model.ConsumablesByCategory(consumableCategory),
		})
	})
}

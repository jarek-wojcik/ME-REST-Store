package me3integration

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"strings"

	"sfswebserver/controllers"
	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const (
	spectresBucket = "spectres"
	teamsBucket    = "teams"
)

// Me3IntegrationController exposes read-only JSON endpoints for the ME3 game
// layer to query the currently active character and strike team.
type Me3IntegrationController struct {
	db *bolt.DB
}

// NewMe3IntegrationController creates a controller backed by the given BoltDB.
func NewMe3IntegrationController(db *bolt.DB) *Me3IntegrationController {
	return &Me3IntegrationController{db: db}
}

// activeSpectre returns the spectre whose Active flag is true, or nil if none.
func (c *Me3IntegrationController) activeSpectre() (*model.Spectre, error) {
	var found *model.Spectre
	err := c.db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var s model.Spectre
			if err := json.Unmarshal(v, &s); err != nil {
				return err
			}
			if s.Active {
				cp := s
				found = &cp
			}
			return nil
		})
	})
	return found, err
}

// StrikeTeamResponse pairs a Team with its member Spectres.
type StrikeTeamResponse struct {
	model.Team
	Spectres []model.Spectre `json:"spectres"`
}

// activeStrikeTeam returns the active team and all spectres belonging to it,
// or nil if no team is currently set as active.
func (c *Me3IntegrationController) activeStrikeTeam() (*StrikeTeamResponse, error) {
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

// qualifiedConsumablePath returns the fully-qualified UE3 game effect class path for a
// consumable ID, or an empty string when the consumable has no path (Core items)
// or the ID is not found in the catalog.
func qualifiedConsumablePath(id string) string {
	if id == "" {
		return ""
	}
	if def := model.ConsumableByID(id); def != nil {
		return def.Path
	}
	return ""
}

// qualifiedCharacterID returns "RootPath.ArchetypeID" for a character, or the bare id
// when the character is not found or its RootPath is empty (e.g. Jack/Liara whose ID
// already encodes the full path). ArchetypeID falls back to ID when not set.
func qualifiedCharacterID(id string) string {
	if id == "" {
		return ""
	}
	if def := model.CharacterByID(id); def != nil && def.RootPath != "" {
		archetypeID := def.ArchetypeID
		if archetypeID == "" {
			archetypeID = def.ID
		}
		return def.RootPath + "." + archetypeID
	}
	return id
}

// qualifiedWeaponID returns "RootPath.ID" for a weapon, or the bare id when not found.
func qualifiedWeaponID(id string) string {
	if id == "" {
		return ""
	}
	if def := model.WeaponByID(id); def != nil {
		return def.RootPath + ".SFXWeapon_" + id
	}
	return id
}

// qualifiedModID returns "RootPath.ID" for a weapon mod, or the bare id when not found.
func qualifiedModID(id string) string {
	if id == "" {
		return ""
	}
	if def := model.WeaponModByID(id); def != nil {
		return def.RootPath + "." + id
	}
	return id
}

// pawnTypeForCharacter resolves the PawnType for a given character ID.
func pawnTypeForCharacter(characterID string) string {
	if def := model.CharacterByID(characterID); def != nil {
		return string(def.GetPawnType())
	}
	return string(model.PawnTypePlayerMP)
}

// appearancePawnType returns the PawnType for the appearance character,
// falling back to the base character when no appearance override is set.
func appearancePawnType(s *model.Spectre) string {
	if s.AppearanceCharacterID != "" {
		return pawnTypeForCharacter(s.AppearanceCharacterID)
	}
	return pawnTypeForCharacter(s.CharacterID)
}

// qualifySpectre expands all bare IDs on s to their fully-qualified
// "RootPath.ID" forms so that JSON and simpleJson responses contain the same
// qualified values as the flat response.
// Must be called AFTER AppearancePawnType is set (lookup uses the raw CharacterID).
func qualifySpectre(s *model.Spectre) {
	s.CharacterID = qualifiedCharacterID(s.CharacterID)
	s.AppearanceCharacterID = qualifiedCharacterID(s.AppearanceCharacterID)
	for i := range s.Weapons {
		s.Weapons[i].WeaponID = qualifiedWeaponID(s.Weapons[i].WeaponID)
		s.Weapons[i].Mod1ID = qualifiedModID(s.Weapons[i].Mod1ID)
		s.Weapons[i].Mod2ID = qualifiedModID(s.Weapons[i].Mod2ID)
	}
	for i := range s.Powers {
		if def := model.PowerByID(s.Powers[i].PowerID); def != nil {
			s.Powers[i].PowerID = def.RootPath + "." + s.Powers[i].PowerID
		}
	}
	if s.BorrowedPower != nil {
		if def := model.PowerByID(s.BorrowedPower.PowerID); def != nil {
			s.BorrowedPower.PowerID = def.RootPath + "." + s.BorrowedPower.PowerID
		}
	}
	s.ArmorConsumableID = qualifiedConsumablePath(s.ArmorConsumableID)
	s.WeaponConsumableID = qualifiedConsumablePath(s.WeaponConsumableID)
	s.AmmoConsumableID = qualifiedConsumablePath(s.AmmoConsumableID)
	s.GearConsumableID = qualifiedConsumablePath(s.GearConsumableID)
}

func respondJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

// respondSimpleJSON serialises v as a flat list of key:value lines.
// Nested objects use dot-notation (borrowedPower.rank:6).
// Arrays use bracket-notation (powers[0].powerId:X).
// No quotes, braces, brackets, commas, or extra whitespace are emitted.
// Keys within each object are sorted alphabetically for stable output.
func respondSimpleJSON(w http.ResponseWriter, status int, v any) {
	b, err := json.Marshal(v)
	if err != nil {
		http.Error(w, "marshal error", http.StatusInternalServerError)
		return
	}
	// Decode with UseNumber so int64 values (e.g. sortOrder) are not
	// converted to float64 and rendered in scientific notation.
	var generic interface{}
	dec := json.NewDecoder(bytes.NewReader(b))
	dec.UseNumber()
	if err := dec.Decode(&generic); err != nil {
		http.Error(w, "decode error", http.StatusInternalServerError)
		return
	}
	var sb strings.Builder
	flattenValue("", generic, &sb)
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(status)
	_, _ = fmt.Fprint(w, sb.String())
}

// flattenValue recursively writes prefix:value lines into sb.
func flattenValue(prefix string, v interface{}, sb *strings.Builder) {
	switch val := v.(type) {
	case map[string]interface{}:
		keys := make([]string, 0, len(val))
		for k := range val {
			keys = append(keys, k)
		}
		sort.Strings(keys)
		for _, k := range keys {
			subPrefix := k
			if prefix != "" {
				subPrefix = prefix + "." + k
			}
			flattenValue(subPrefix, val[k], sb)
		}
	case []interface{}:
		for i, item := range val {
			flattenValue(fmt.Sprintf("%s[%d]", prefix, i), item, sb)
		}
	case nil:
		// omit null/absent fields
	default:
		sb.WriteString(prefix + ":" + fmt.Sprint(val) + "\n")
	}
}

// flattenSpectreOrdered writes a spectre's flat key:value lines in the order:
//  1. Identity & appearance: id, name, characterId, appearanceCharId,
//     appearanceHelmet, appearanceHeadgear, appearancePawnType
//  2. Progression: level, xp, shieldType, skillLevels.*, skillPoints
//  3. Powers
//  4. Weapons
//  5. Consumables: armorConsumableId, weaponConsumableId, ammoConsumableId, gearConsumableId
//
// Any keys not listed explicitly are emitted last, sorted alphabetically.
func flattenSpectreOrdered(s *model.Spectre, w http.ResponseWriter, status int) {
	b, err := json.Marshal(s)
	if err != nil {
		http.Error(w, "marshal error", http.StatusInternalServerError)
		return
	}
	var m map[string]interface{}
	dec := json.NewDecoder(bytes.NewReader(b))
	dec.UseNumber()
	if err := dec.Decode(&m); err != nil {
		http.Error(w, "decode error", http.StatusInternalServerError)
		return
	}

	var sb strings.Builder

	emitKey := func(k string) {
		if v, ok := m[k]; ok {
			flattenValue(k, v, &sb)
		}
	}

	// 1. Identity & appearance.
	for _, k := range []string{
		"id", "name", "active",
		"characterId", "appearanceCharId", "appearancePawnType",
		"appearanceHelmet", "appearanceHeadgear",
	} {
		emitKey(k)
	}

	// 2. Progression.
	for _, k := range []string{"level", "xp", "shieldType", "skillLevels", "skillPoints"} {
		emitKey(k)
	}

	// 3. Powers.
	emitKey("powers")

	// 4. Weapons.
	emitKey("weapons")

	// 5. Consumables.
	for _, k := range []string{
		"armorConsumableId", "weaponConsumableId", "ammoConsumableId", "gearConsumableId",
	} {
		emitKey(k)
	}

	// Remaining keys not covered above, sorted.
	known := map[string]bool{
		"id": true, "name": true, "active": true,
		"characterId": true, "appearanceCharId": true, "appearancePawnType": true,
		"appearanceHelmet": true, "appearanceHeadgear": true,
		"level": true, "xp": true, "shieldType": true, "skillLevels": true, "skillPoints": true,
		"powers": true, "weapons": true,
		"armorConsumableId": true, "weaponConsumableId": true,
		"ammoConsumableId": true, "gearConsumableId": true,
	}
	var rest []string
	for k := range m {
		if !known[k] {
			rest = append(rest, k)
		}
	}
	sort.Strings(rest)
	for _, k := range rest {
		flattenValue(k, m[k], &sb)
	}

	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(status)
	_, _ = fmt.Fprint(w, sb.String())
}

func respondNotFound(w http.ResponseWriter, msg string) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusNotFound)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": msg})
}

// Register wires the ME3 integration routes onto the default mux.
func (c *Me3IntegrationController) Register() {
	// GET /activeCharacter
	// Returns the active Spectre as JSON.
	// Returns 404 if no spectre is set as active.
	http.HandleFunc("GET /activeCharacter", func(w http.ResponseWriter, r *http.Request) {
		spectre, err := c.activeSpectre()
		if err != nil {
			respondJSON(w, http.StatusInternalServerError, map[string]string{"error": "db error"})
			return
		}
		if spectre == nil {
			respondNotFound(w, "no active character")
			return
		}
		spectre.AppearancePawnType = model.PawnType(appearancePawnType(spectre))
		qualifySpectre(spectre)
		// Remove skill levels that are 0 — they add noise without meaning.
		for k, v := range spectre.SkillLevels {
			if v == 0 {
				delete(spectre.SkillLevels, k)
			}
		}
		if r.URL.Query().Get("simpleJson") == "true" {
			flattenSpectreOrdered(spectre, w, http.StatusOK)
			return
		}
		respondJSON(w, http.StatusOK, spectre)
	})

	// GET /activeStrikeTeam
	// Returns the active Team and its Spectres as JSON.
	// Returns 404 if no team is set as active.
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

	// GET /grantXP?XP=<amount>
	// Awards XP to the currently active spectre, advancing their level (and
	// granting skill points) as warranted by the XP curve.
	// Returns a JSON object with the updated spectre and levels gained.
	http.HandleFunc("GET /grantXP", func(w http.ResponseWriter, r *http.Request) {
		xpStr := r.URL.Query().Get("XP")
		if xpStr == "" {
			respondJSON(w, http.StatusBadRequest, map[string]string{"error": "XP parameter is required"})
			return
		}
		xpAmount, err := strconv.Atoi(xpStr)
		if err != nil || xpAmount <= 0 {
			respondJSON(w, http.StatusBadRequest, map[string]string{"error": "XP must be a positive integer"})
			return
		}
		result, err := controllers.GrantXPToActive(c.db, xpAmount)
		if err != nil {
			status := http.StatusInternalServerError
			if err.Error() == "no active spectre" {
				status = http.StatusNotFound
			}
			respondJSON(w, status, map[string]string{"error": err.Error()})
			return
		}
		respondJSON(w, http.StatusOK, map[string]any{
			"xp":            result.Spectre.XP,
			"level":         result.Spectre.Level,
			"levelsGained":  result.LevelsGained,
			"skillPoints":   result.Spectre.SkillPoints,
			"xpToNextLevel": model.XPForLevel(result.Spectre.Level + 1),
		})
	})
}

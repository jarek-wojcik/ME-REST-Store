package me3integration

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strings"

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

func flatPower(p model.PowerSlot) string {
	powerID := p.PowerID
	if def := model.PowerByID(p.PowerID); def != nil {
		powerID = def.RootPath + "." + p.PowerID
	}
	return fmt.Sprintf("%s:%d:%s:%s:%s:%s", powerID, p.Rank, p.Evolution[0], p.Evolution[1], p.Evolution[2], p.KitID)
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

// spectreToFlat serialises a Spectre as a single pipe-delimited line.
// Format: id|name|characterId|appearanceCharId|w0Id|w0Mod1|w0Mod2|w0FireMode|w1Id|w1Mod1|w1Mod2|w1FireMode|w2Id|w2Mod1|w2Mod2|w2FireMode|w3Id|w3Mod1|w3Mod2|w3FireMode|w4Id|w4Mod1|w4Mod2|w4FireMode|power0|power1|power2|power3|power4|borrowedPower|armorConsumableId|weaponConsumableId|ammoConsumableId|gearConsumableId|pawnType
// Weapon/mod/power ID fields are qualified as "RootPath.ID".
// Power fields use the sub-format: rootPath.powerId:rank:evo0:evo1:evo2  (empty string when slot absent)
// Weapon slots are always emitted as 5 groups of 4 fields (padded with empty strings).
func spectreToFlat(s *model.Spectre) string {
	weaponFields := make([]string, 20) // 5 slots × 4 fields
	for i := range s.Weapons {
		if i >= 5 {
			break
		}
		weaponFields[i*4+0] = qualifiedWeaponID(s.Weapons[i].WeaponID)
		weaponFields[i*4+1] = qualifiedModID(s.Weapons[i].Mod1ID)
		weaponFields[i*4+2] = qualifiedModID(s.Weapons[i].Mod2ID)
		weaponFields[i*4+3] = string(s.Weapons[i].FireMode)
	}
	powers := make([]string, 5)
	for i := range powers {
		if i < len(s.Powers) {
			powers[i] = flatPower(s.Powers[i])
		}
	}
	borrowed := ""
	if s.BorrowedPower != nil {
		borrowed = flatPower(*s.BorrowedPower)
	}
	fields := []string{
		s.ID, s.Name, qualifiedCharacterID(s.CharacterID), qualifiedCharacterID(s.AppearanceCharacterID),
	}
	fields = append(fields, weaponFields...)
	fields = append(fields, powers[0], powers[1], powers[2], powers[3], powers[4])
	fields = append(fields,
		borrowed,
		qualifiedConsumablePath(s.ArmorConsumableID), qualifiedConsumablePath(s.WeaponConsumableID), qualifiedConsumablePath(s.AmmoConsumableID), qualifiedConsumablePath(s.GearConsumableID),
		appearancePawnType(s),
		fmt.Sprintf("%t", s.UseHelmet),
		fmt.Sprintf("%t", s.UseHeadgear),
	)
	return strings.Join(fields, "|")
}

// teamSpectreToFlat serialises a strike-team Spectre as a single pipe-delimited line.
// Same format as spectreToFlat.
func teamSpectreToFlat(s model.Spectre) string {
	return spectreToFlat(&s)
}

// strikeTeamToFlat serialises a StrikeTeamResponse as newline-separated lines.
// Line 0: teamId|teamName
// Lines 1-N: one spectre per line (teamSpectreToFlat format)
func strikeTeamToFlat(r *StrikeTeamResponse) string {
	lines := make([]string, 0, 1+len(r.Spectres))
	lines = append(lines, r.ID+"|"+r.Name)
	for _, s := range r.Spectres {
		lines = append(lines, teamSpectreToFlat(s))
	}
	return strings.Join(lines, "\n")
}

func respondFlat(w http.ResponseWriter, text string) {
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	_, _ = fmt.Fprint(w, text)
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

func respondNotFound(w http.ResponseWriter, msg string) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusNotFound)
	_ = json.NewEncoder(w).Encode(map[string]string{"error": msg})
}

// Register wires the ME3 integration routes onto the default mux.
func (c *Me3IntegrationController) Register() {
	// GET /activeCharacter[?flat=true]
	// Returns the active Spectre as JSON, or as a flat pipe-delimited string when flat=true.
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
		if r.URL.Query().Get("flat") == "true" {
			respondFlat(w, spectreToFlat(spectre))
			return
		}
		spectre.AppearancePawnType = model.PawnType(appearancePawnType(spectre))
		qualifySpectre(spectre)
		if r.URL.Query().Get("simpleJson") == "true" {
			respondSimpleJSON(w, http.StatusOK, spectre)
			return
		}
		respondJSON(w, http.StatusOK, spectre)
	})

	// GET /activeStrikeTeam[?flat=true]
	// Returns the active Team and its Bots as JSON, or as newline-separated flat lines when flat=true.
	// Line 0: teamId|teamName  Lines 1-N: one bot per line (id|characterId|weaponId|mod1|mod2|power0..power4)
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
		if r.URL.Query().Get("flat") == "true" {
			respondFlat(w, strikeTeamToFlat(team))
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

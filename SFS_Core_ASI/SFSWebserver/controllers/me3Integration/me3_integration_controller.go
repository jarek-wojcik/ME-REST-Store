package me3integration

import (
	"encoding/json"
	"fmt"
	"net/http"
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
		return def.RootPath + "." + id
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
	return fmt.Sprintf("%s:%d:%s:%s:%s", powerID, p.Rank, p.Evolution[0], p.Evolution[1], p.Evolution[2])
}

// spectreToFlat serialises a Spectre as a single pipe-delimited line.
// Format: id|name|characterId|appearanceCharId|weaponId|weaponMod1Id|weaponMod2Id|weapon2Id|weapon2Mod1Id|weapon2Mod2Id|power0|power1|power2|power3|power4|borrowedPower
// Weapon/mod/power ID fields are qualified as "RootPath.ID".
// Power fields use the sub-format: rootPath.powerId:rank:evo0:evo1:evo2  (empty string when slot absent)
func spectreToFlat(s *model.Spectre) string {
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
	return strings.Join([]string{
		s.ID, s.Name, qualifiedCharacterID(s.CharacterID), qualifiedCharacterID(s.AppearanceCharacterID),
		qualifiedWeaponID(s.WeaponID), qualifiedModID(s.WeaponMod1ID), qualifiedModID(s.WeaponMod2ID),
		qualifiedWeaponID(s.Weapon2ID), qualifiedModID(s.Weapon2Mod1ID), qualifiedModID(s.Weapon2Mod2ID),
		powers[0], powers[1], powers[2], powers[3], powers[4],
		borrowed,
		s.ArmorConsumableID, s.WeaponConsumableID, s.AmmoConsumableID, s.GearConsumableID,
	}, "|")
}

// teamSpectreToFlat serialises a strike-team Spectre as a single pipe-delimited line.
// Format: id|name|characterId|appearanceCharId|weaponId|weaponMod1Id|weaponMod2Id|weapon2Id|weapon2Mod1Id|weapon2Mod2Id|power0|power1|power2|power3|power4|borrowedPower
// Weapon/mod/power ID fields are qualified as "RootPath.ID".
func teamSpectreToFlat(s model.Spectre) string {
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
	return strings.Join([]string{
		s.ID, s.Name, qualifiedCharacterID(s.CharacterID), qualifiedCharacterID(s.AppearanceCharacterID),
		qualifiedWeaponID(s.WeaponID), qualifiedModID(s.WeaponMod1ID), qualifiedModID(s.WeaponMod2ID),
		qualifiedWeaponID(s.Weapon2ID), qualifiedModID(s.Weapon2Mod1ID), qualifiedModID(s.Weapon2Mod2ID),
		powers[0], powers[1], powers[2], powers[3], powers[4],
		borrowed,
		s.ArmorConsumableID, s.WeaponConsumableID, s.AmmoConsumableID, s.GearConsumableID,
	}, "|")
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
		respondJSON(w, http.StatusOK, team)
	})
}

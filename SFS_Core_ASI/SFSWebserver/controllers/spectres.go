package controllers

import (
	"encoding/json"
	"fmt"
	"sort"
	"time"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const spectresBucket = "spectres"

// ---------------------------------------------------------------------------
// Shared view structs (used by both SpectreView and team-spectre rendering)
// ---------------------------------------------------------------------------

// CardURLs holds all pre-computed endpoint and element-ID strings for a card
// view. Embedding this in a card view struct keeps templates free of routing
// logic and makes the same template reusable for both standalone spectres and
// strike-team members.
type CardURLs struct {
	CardID                      string // HTML element id, e.g. "spectre-card-abc123"
	DeleteURL                   string // DELETE endpoint for this entity
	DeleteTarget                string // hx-target for the delete button, e.g. "#spectres-panel" or "#bot-panel"
	DeleteConfirm               string // hx-confirm message shown before deletion
	CharSelectorURL             string // GET: opens character selector modal
	WeaponSelectorURL           string // GET: opens weapon selector modal
	Mod1SelectorURL             string // GET: opens weapon mod 1 selector modal
	Mod2SelectorURL             string // GET: opens weapon mod 2 selector modal
	PowerBaseURL                string // prefix for power rank/evo routes
	HasBorrowedPower            bool   // true when a borrowed power is already set
	AddPowerURL                 string // GET: opens the borrow-power character picker
	ClearBorrowedPowerURL       string // DELETE: removes the borrowed power slot
	AppearanceSelectorURL       string // GET: opens character selector for appearance-only change
	RenameURL                   string // POST: renames the entity; form field "name"
	Weapon2SelectorURL          string // GET: opens weapon selector for second weapon slot
	Weapon2Mod1SelectorURL      string // GET: opens weapon mod selector for second weapon mod 1
	Weapon2Mod2SelectorURL      string // GET: opens weapon mod selector for second weapon mod 2
	WeaponClearURL              string // POST: clears weapon
	Weapon2ClearURL             string // POST: clears second weapon
	ArmorConsumableClearURL     string // POST: clears armor consumable
	WeaponConsumableClearURL    string // POST: clears weapon consumable
	AmmoConsumableClearURL      string // POST: clears ammo consumable
	GearConsumableClearURL      string // POST: clears gear consumable
	SetActiveURL                string // POST: toggles active state; empty string hides the button
	IsActive                    bool   // true when this entity is currently active
	ArmorConsumableSelectorURL  string // GET: opens armor consumable selector modal
	WeaponConsumableSelectorURL string // GET: opens weapon consumable selector modal
	AmmoConsumableSelectorURL   string // GET: opens ammo consumable selector modal
	GearConsumableSelectorURL   string // GET: opens gear consumable selector modal
}

// PowerSlotView pairs a persisted PowerSlot with its resolved PowerDef and
// flattened evolution fields for easy template access.
type PowerSlotView struct {
	model.PowerSlot
	PowerDef        *model.PowerDef // nil if PowerID is empty or unknown
	SlotIdx         int             // 0–4, used in API route paths
	Evo0            string          // Evolution[0]: "A" or "B" (rank 4 choice)
	Evo1            string          // Evolution[1]: "A" or "B" (rank 5 choice)
	Evo2            string          // Evolution[2]: "A" or "B" (rank 6 choice)
	SlotBaseURL     string          // e.g. "/api/spectres/abc123/power/0"
	IsBorrowedPower bool            // true for the borrowed-power slot
	ChangePowerURL  string          // GET: opens power-change flow for this slot
}

// SpectreView pairs a persisted Spectre with resolved catalog definitions.
// It is structurally compatible with the "character_card" template because all
// bot-specific routing was replaced by the embedded CardURLs fields.
type SpectreView struct {
	model.Spectre
	CharDef             *model.CharacterDef
	AppearanceCharDef   *model.CharacterDef // visual override portrait; nil means use CharDef image
	WeaponDef           *model.WeaponDef
	WeaponMod1Def       *model.WeaponModDef
	WeaponMod2Def       *model.WeaponModDef
	Weapon2Def          *model.WeaponDef     // second weapon slot
	Weapon2Mod1Def      *model.WeaponModDef  // mod slot 1 for second weapon
	Weapon2Mod2Def      *model.WeaponModDef  // mod slot 2 for second weapon
	ArmorConsumableDef  *model.ConsumableDef // equipped armor consumable; nil when slot is empty
	WeaponConsumableDef *model.ConsumableDef // equipped weapon consumable; nil when slot is empty
	AmmoConsumableDef   *model.ConsumableDef // equipped ammo consumable; nil when slot is empty
	GearConsumableDef   *model.ConsumableDef // equipped gear consumable; nil when slot is empty
	PowerViews          []PowerSlotView
	CardURLs
}

// spectreURLs returns pre-computed CardURLs for a standalone spectre.
func spectreURLs(spectreID string) CardURLs {
	base := "/api/spectres/" + spectreID
	return CardURLs{
		CardID:                      "spectre-card-" + spectreID,
		DeleteURL:                   base,
		DeleteTarget:                "#spectres-panel",
		DeleteConfirm:               "Remove this spectre?",
		CharSelectorURL:             "/api/characters/selector?entityId=" + spectreID + "&kind=spectre",
		WeaponSelectorURL:           "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre",
		Mod1SelectorURL:             "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=1",
		Mod2SelectorURL:             "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=2",
		PowerBaseURL:                base + "/power",
		AddPowerURL:                 base + "/borrowed-power/selector",
		ClearBorrowedPowerURL:       base + "/borrowed-power",
		AppearanceSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-appearance",
		RenameURL:                   base + "/rename",
		Weapon2SelectorURL:          "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre-weapon2",
		Weapon2Mod1SelectorURL:      "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon2&slot=1",
		Weapon2Mod2SelectorURL:      "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon2&slot=2",
		WeaponClearURL:              base + "/weapon/none",
		Weapon2ClearURL:             base + "/weapon2/none",
		ArmorConsumableClearURL:     base + "/consumable/armor/none",
		WeaponConsumableClearURL:    base + "/consumable/weapon/none",
		AmmoConsumableClearURL:      base + "/consumable/ammo/none",
		GearConsumableClearURL:      base + "/consumable/gear/none",
		SetActiveURL:                base + "/active/toggle",
		ArmorConsumableSelectorURL:  "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=armor",
		WeaponConsumableSelectorURL: "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=weapon",
		AmmoConsumableSelectorURL:   "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=ammo",
		GearConsumableSelectorURL:   "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=gear",
	}
}

// teamSpectreURLs returns CardURLs for a spectre that is a strike-team member.
// SetActiveURL is empty (team members don't have an individual active toggle).
// DeleteTarget points at #bot-panel so the team panel refreshes after deletion.
// DeleteURL includes ?from=team so the server knows to render the bot panel
// rather than the standalone spectre list.
func teamSpectreURLs(spectreID string) CardURLs {
	base := "/api/spectres/" + spectreID
	return CardURLs{
		CardID:                      "spectre-card-" + spectreID,
		DeleteURL:                   base + "?from=team",
		DeleteTarget:                "#bot-panel",
		DeleteConfirm:               "Remove this spectre from the team?",
		CharSelectorURL:             "/api/characters/selector?entityId=" + spectreID + "&kind=spectre",
		WeaponSelectorURL:           "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre",
		Mod1SelectorURL:             "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=1",
		Mod2SelectorURL:             "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=2",
		PowerBaseURL:                base + "/power",
		AddPowerURL:                 base + "/borrowed-power/selector",
		ClearBorrowedPowerURL:       base + "/borrowed-power",
		AppearanceSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-appearance",
		RenameURL:                   base + "/rename",
		Weapon2SelectorURL:          "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre-weapon2",
		Weapon2Mod1SelectorURL:      "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon2&slot=1",
		Weapon2Mod2SelectorURL:      "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon2&slot=2",
		WeaponClearURL:              base + "/weapon/none",
		Weapon2ClearURL:             base + "/weapon2/none",
		ArmorConsumableClearURL:     base + "/consumable/armor/none",
		WeaponConsumableClearURL:    base + "/consumable/weapon/none",
		AmmoConsumableClearURL:      base + "/consumable/ammo/none",
		GearConsumableClearURL:      base + "/consumable/gear/none",
		SetActiveURL:                "", // team members don't have an individual active toggle
		ArmorConsumableSelectorURL:  "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=armor",
		WeaponConsumableSelectorURL: "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=weapon",
		AmmoConsumableSelectorURL:   "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=ammo",
		GearConsumableSelectorURL:   "/api/consumables/selector?entityId=" + spectreID + "&kind=spectre&category=gear",
	}
}

// EnsureSpectresBucket creates the spectres bucket if it does not exist.
func EnsureSpectresBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(spectresBucket))
		return err
	})
}

// MigrateBotsToSpectres reads any entries in the legacy "bots" bucket and
// copies them into the spectres bucket as Spectre records. Already-migrated
// entries (same ID already present in spectres) are skipped. The bots bucket
// is left intact so older builds can still open the database.
func MigrateBotsToSpectres(db *bolt.DB) error {
	const legacyBotsBucket = "bots"
	return db.Update(func(tx *bolt.Tx) error {
		bb := tx.Bucket([]byte(legacyBotsBucket))
		if bb == nil {
			return nil // nothing to migrate
		}
		sb, err := tx.CreateBucketIfNotExists([]byte(spectresBucket))
		if err != nil {
			return err
		}
		return bb.ForEach(func(k, v []byte) error {
			// Skip if already present in the spectres bucket.
			if sb.Get(k) != nil {
				return nil
			}
			// Bot JSON keys are compatible with Spectre JSON keys.
			var s model.Spectre
			if jsonErr := json.Unmarshal(v, &s); jsonErr != nil {
				return nil // skip corrupted entries rather than aborting
			}
			// Set Name from CharacterDef since bots had no Name field.
			if s.Name == "" {
				if def := model.CharacterByID(s.CharacterID); def != nil {
					s.Name = def.Name
				} else {
					s.Name = s.CharacterID
				}
			}
			data, err := json.Marshal(s)
			if err != nil {
				return err
			}
			return sb.Put(k, data)
		})
	})
}

// defaultPowersForChar builds the initial []PowerSlot for a character.
func defaultPowersForChar(charID string) []model.PowerSlot {
	char := model.CharacterByID(charID)
	if char == nil {
		return []model.PowerSlot{}
	}
	var slots []model.PowerSlot
	for _, pid := range char.PowerIDs {
		if pid != "" {
			slots = append(slots, model.DefaultPower(pid))
		}
	}
	if slots == nil {
		return []model.PowerSlot{}
	}
	return slots
}

// powerViews resolves PowerDef, flattens evolutions, and pre-computes
// per-slot URL prefixes for use in templates.
func powerViews(slots []model.PowerSlot, powerBaseURL string) []PowerSlotView {
	views := make([]PowerSlotView, len(slots))
	for i, ps := range slots {
		views[i] = PowerSlotView{
			PowerSlot:   ps,
			PowerDef:    model.PowerByID(ps.PowerID),
			SlotIdx:     i,
			Evo0:        ps.Evolution[0],
			Evo1:        ps.Evolution[1],
			Evo2:        ps.Evolution[2],
			SlotBaseURL: fmt.Sprintf("%s/%d", powerBaseURL, i),
		}
	}
	return views
}

// listSpectres returns all standalone spectres (TeamID == "") in insertion order.
func listSpectres(db *bolt.DB) ([]model.Spectre, error) {
	var spectres []model.Spectre
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var s model.Spectre
			if err := json.Unmarshal(v, &s); err != nil {
				return err
			}
			spectres = append(spectres, s)
			return nil
		})
	})
	return spectres, err
}

// listSpectresForTeam returns all spectres with the given TeamID, sorted by
// creation order (SortOrder ascending).
func listSpectresForTeam(db *bolt.DB, teamID string) ([]model.Spectre, error) {
	var spectres []model.Spectre
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var s model.Spectre
			if err := json.Unmarshal(v, &s); err != nil {
				return err
			}
			if s.TeamID == teamID {
				spectres = append(spectres, s)
			}
			return nil
		})
	})
	sort.Slice(spectres, func(i, j int) bool {
		return spectres[i].SortOrder < spectres[j].SortOrder
	})
	return spectres, err
}

// getSpectre fetches a single spectre by ID.
func getSpectre(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		return json.Unmarshal(v, &s)
	})
	return s, err
}

// createSpectre persists a new spectre with the given name.
func createSpectre(db *bolt.DB, name string) (model.Spectre, error) {
	const defaultChar = "AdeptHumanMale"
	s := model.Spectre{
		ID:          newID(),
		Name:        name,
		CharacterID: defaultChar,
		Powers:      defaultPowersForChar(defaultChar),
	}
	data, err := json.Marshal(s)
	if err != nil {
		return model.Spectre{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// createTeamSpectre persists a new spectre as a member of the given team.
func createTeamSpectre(db *bolt.DB, teamID, charID string) (model.Spectre, error) {
	char := model.CharacterByID(charID)
	if char == nil {
		return model.Spectre{}, fmt.Errorf("unknown character: %s", charID)
	}
	s := model.Spectre{
		ID:          newID(),
		Name:        char.Name,
		CharacterID: charID,
		TeamID:      teamID,
		SortOrder:   time.Now().UnixNano(),
		Powers:      defaultPowersForChar(charID),
	}
	data, err := json.Marshal(s)
	if err != nil {
		return model.Spectre{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// unassignSpectreFromTeam clears the TeamID and SortOrder of a spectre,
// returning it to the standalone roster.
func unassignSpectreFromTeam(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.TeamID = ""
		s.SortOrder = 0
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// assignSpectreToTeam moves a standalone spectre into the given team by setting
// its TeamID and a SortOrder based on the current time.
func assignSpectreToTeam(db *bolt.DB, spectreID, teamID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.TeamID = teamID
		s.SortOrder = time.Now().UnixNano()
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// deleteSpectre removes a spectre by ID.
// Returns the spectre's TeamID (empty string for standalone spectres),
// whether it existed, and any error.
func deleteSpectre(db *bolt.DB, spectreID string) (teamID string, existed bool, err error) {
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return nil
		}
		var s model.Spectre
		if jsonErr := json.Unmarshal(v, &s); jsonErr != nil {
			return jsonErr
		}
		teamID = s.TeamID
		existed = true
		if err := b.Delete([]byte(spectreID)); err != nil {
			return err
		}
		// Also purge from the legacy "bots" bucket so that
		// MigrateBotsToSpectres cannot resurrect this entry on restart.
		if bb := tx.Bucket([]byte("bots")); bb != nil {
			_ = bb.Delete([]byte(spectreID))
		}
		return nil
	})
	return teamID, existed, err
}

// updateSpectreCharacter changes the character and resets powers.
func updateSpectreCharacter(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.CharacterID = charID
		s.Powers = defaultPowersForChar(charID)
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreWeapon changes the equipped weapon.
func updateSpectreWeapon(db *bolt.DB, spectreID, weaponID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.WeaponID = weaponID
		if weaponID == "" {
			s.WeaponMod1ID = ""
			s.WeaponMod2ID = ""
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreWeaponMod changes a weapon mod slot (1 or 2).
func updateSpectreWeaponMod(db *bolt.DB, spectreID string, slot int, modID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		switch slot {
		case 1:
			s.WeaponMod1ID = modID
		case 2:
			s.WeaponMod2ID = modID
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// updateSpectreWeapon2 changes the second equipped weapon.
func updateSpectreWeapon2(db *bolt.DB, spectreID, weaponID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.Weapon2ID = weaponID
		if weaponID == "" {
			s.Weapon2Mod1ID = ""
			s.Weapon2Mod2ID = ""
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreWeapon2Mod changes a mod slot (1 or 2) for the second weapon.
func updateSpectreWeapon2Mod(db *bolt.DB, spectreID string, slot int, modID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		switch slot {
		case 1:
			s.Weapon2Mod1ID = modID
		case 2:
			s.Weapon2Mod2ID = modID
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// updateSpectreName changes just the display name of a spectre.
func updateSpectreName(db *bolt.DB, spectreID, name string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.Name = name
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreAppearance sets the appearance character override without
// changing the base class, powers, or any other loadout data.
func updateSpectreAppearance(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.AppearanceCharacterID = charID
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerRank sets the rank (0–6) of one power slot.
func updateSpectrePowerRank(db *bolt.DB, spectreID string, slotIdx, rank int) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		s.Powers[slotIdx].Rank = rank
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerEvolution sets an A/B evolution choice.
func updateSpectrePowerEvolution(db *bolt.DB, spectreID string, slotIdx, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		s.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerRankAndEvo atomically sets rank and an evolution choice.
func updateSpectrePowerRankAndEvo(db *bolt.DB, spectreID string, slotIdx, rank, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		// Never downgrade an already-upgraded power by changing a lower-tier evolution
		if s.Powers[slotIdx].Rank < rank {
			s.Powers[slotIdx].Rank = rank
		}
		s.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerID replaces the PowerID of a normal power slot and resets
// its rank and evolution to defaults. Used by the per-slot "Change" flow.
func updateSpectrePowerID(db *bolt.DB, spectreID string, slotIdx int, powerID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		s.Powers[slotIdx] = model.DefaultPower(powerID)
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// addSpectreBorrowedPower sets (or replaces) the borrowed power slot.
func addSpectreBorrowedPower(db *bolt.DB, spectreID, powerID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		slot := model.DefaultPower(powerID)
		s.BorrowedPower = &slot
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// clearSpectreBorrowedPower removes the borrowed power slot.
func clearSpectreBorrowedPower(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.BorrowedPower = nil
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreBorrowedPowerRank sets the rank of the borrowed power slot.
func updateSpectreBorrowedPowerRank(db *bolt.DB, spectreID string, rank int) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if s.BorrowedPower == nil {
			return fmt.Errorf("no borrowed power set")
		}
		s.BorrowedPower.Rank = rank
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreBorrowedPowerRankAndEvo atomically sets rank and an evolution
// choice on the borrowed power slot.
func updateSpectreBorrowedPowerRankAndEvo(db *bolt.DB, spectreID string, rank, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if s.BorrowedPower == nil {
			return fmt.Errorf("no borrowed power set")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		// Preserve the highest achieved rank when updating a lower rank evolution.
		if s.BorrowedPower.Rank < rank {
			s.BorrowedPower.Rank = rank
		}
		s.BorrowedPower.Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreConsumable sets one of the four consumable slots on a spectre
// and returns the updated spectre. An empty consumableID clears the slot.
func updateSpectreConsumable(db *bolt.DB, spectreID string, category model.ConsumableCategory, consumableID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		switch category {
		case model.ConsumableCategoryArmor:
			s.ArmorConsumableID = consumableID
		case model.ConsumableCategoryWeapon:
			s.WeaponConsumableID = consumableID
		case model.ConsumableCategoryAmmo:
			s.AmmoConsumableID = consumableID
		case model.ConsumableCategoryGear:
			s.GearConsumableID = consumableID
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// toggleSpectreActive flips the Active flag for a spectre.
func toggleSpectreActive(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.Active = !s.Active
		// If activating, deactivate all other spectres in the same transaction.
		if s.Active {
			if err := b.ForEach(func(k, val []byte) error {
				if string(k) == spectreID {
					return nil
				}
				var other model.Spectre
				if err := json.Unmarshal(val, &other); err != nil {
					return err
				}
				if !other.Active {
					return nil
				}
				other.Active = false
				data, err := json.Marshal(other)
				if err != nil {
					return err
				}
				return b.Put(k, data)
			}); err != nil {
				return err
			}
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// spectrePowerViews builds the full []PowerSlotView for a spectre, including
// the borrowed power as the last entry when one is set.
func spectrePowerViews(s model.Spectre, urls CardURLs) []PowerSlotView {
	base := "/api/spectres/" + s.ID
	normal := powerViews(s.Powers, urls.PowerBaseURL)
	for i := range normal {
		normal[i].ChangePowerURL = base + fmt.Sprintf("/power/%d/change/selector", i)
	}
	if s.BorrowedPower == nil {
		return normal
	}
	bp := *s.BorrowedPower
	borrowedView := PowerSlotView{
		PowerSlot:       bp,
		PowerDef:        model.PowerByID(bp.PowerID),
		SlotIdx:         len(s.Powers),
		Evo0:            bp.Evolution[0],
		Evo1:            bp.Evolution[1],
		Evo2:            bp.Evolution[2],
		SlotBaseURL:     base + "/borrowed-power",
		IsBorrowedPower: true,
		ChangePowerURL:  base + "/borrowed-power/selector",
	}
	return append(normal, borrowedView)
}

// spectreViews resolves catalog definitions for each spectre.
func spectreViews(spectres []model.Spectre) []SpectreView {
	views := make([]SpectreView, 0, len(spectres))
	for _, s := range spectres {
		def := model.CharacterByID(s.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := spectreURLs(s.ID)
		urls.HasBorrowedPower = s.BorrowedPower != nil
		urls.IsActive = s.Active
		views = append(views, SpectreView{
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
	return views
}

// teamSpectreViews resolves catalog definitions for strike-team spectres.
// It uses teamSpectreURLs (no active toggle, delete targets #bot-panel).
func teamSpectreViews(spectres []model.Spectre) []SpectreView {
	views := make([]SpectreView, 0, len(spectres))
	for _, s := range spectres {
		def := model.CharacterByID(s.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := teamSpectreURLs(s.ID)
		urls.HasBorrowedPower = s.BorrowedPower != nil
		views = append(views, SpectreView{
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
	return views
}

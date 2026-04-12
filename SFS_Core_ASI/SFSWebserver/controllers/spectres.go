package controllers

import (
	"encoding/json"
	"fmt"
	"sort"
	"strconv"
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
	PowerBaseURL                string // prefix for power rank/evo routes
	HasBorrowedPower            bool   // true when a borrowed power is already set
	AddPowerURL                 string // GET: opens the borrow-power character picker
	ClearBorrowedPowerURL       string // DELETE: removes the borrowed power slot
	AppearanceSelectorURL       string // GET: opens character selector for appearance-only change
	VoiceSelectorURL            string // GET: opens character selector for voice selection
	HeavyMeleeSelectorURL       string // GET: opens character selector for heavy melee override
	LightMeleeSelectorURL       string // GET: opens character selector for light melee override
	DodgeSelectorURL            string // GET: opens character selector for dodge override
	RenameURL                   string // POST: renames the entity; form field "name"
	AddWeaponURL                string // GET: opens weapon selector for a new (appended) weapon slot
	ArmorConsumableClearURL     string // POST: clears armor consumable
	WeaponConsumableClearURL    string // POST: clears weapon consumable
	AmmoConsumableClearURL      string // POST: clears ammo consumable
	GearConsumableClearURL      string // POST: clears gear consumable
	SetActiveURL                string // POST: toggles active state; empty string hides the button
	IsActive                    bool   // true when this entity is currently active
	VisualHelmetURL             string // POST: toggle UseHelmet (clears UseHeadgear)
	VisualHeadgearURL           string // POST: toggle UseHeadgear (clears UseHelmet)
	ArmorConsumableSelectorURL  string // GET: opens armor consumable selector modal
	WeaponConsumableSelectorURL string // GET: opens weapon consumable selector modal
	AmmoConsumableSelectorURL   string // GET: opens ammo consumable selector modal
	GearConsumableSelectorURL   string // GET: opens gear consumable selector modal
}

// PowerSlotView pairs a persisted PowerSlot with its resolved PowerDef and
// flattened evolution fields for easy template access.
type PowerSlotView struct {
	model.PowerSlot
	PowerDef                *model.PowerDef // nil if PowerID is empty or unknown
	SlotIdx                 int             // 0–4, used in API route paths
	Evo0                    string          // Evolution[0]: "A" or "B" (rank 4 choice)
	Evo1                    string          // Evolution[1]: "A" or "B" (rank 5 choice)
	Evo2                    string          // Evolution[2]: "A" or "B" (rank 6 choice)
	SlotBaseURL             string          // e.g. "/api/spectres/abc123/power/0"
	IsBorrowedPower         bool            // true for the borrowed-power slot (has real power)
	IsBorrowSlotPlaceholder bool            // true when slot 4 exists but no borrowed power is set yet
	IsPassive               bool            // true when the slot is a passive slot (by position, not power type)
	IsFirstPassive          bool            // true for the first passive slot in display order (triggers section header)
	ChangePowerURL          string          // GET: opens power-change flow for this slot
	ClearPowerURL           string          // DELETE: clears this power slot (empty when slot is already empty or non-clearable)
}

// WeaponSlotView pairs a persisted WeaponSlot with resolved catalog defs and
// the pre-computed API URLs for that specific slot index.
type WeaponSlotView struct {
	model.WeaponSlot
	SlotIdx             int                 // 0–4
	WeaponDef           *model.WeaponDef    // nil when slot is empty
	Mod1Def             *model.WeaponModDef // nil when mod 1 is empty
	Mod2Def             *model.WeaponModDef // nil when mod 2 is empty
	WeaponSelectorURL   string              // GET: opens weapon selector for this slot
	Mod1SelectorURL     string              // GET: opens mod 1 selector for this slot
	Mod2SelectorURL     string              // GET: opens mod 2 selector for this slot
	WeaponClearURL      string              // POST: clears the weapon in this slot (keeps slot)
	RemoveURL           string              // DELETE: removes this slot entirely
	FireModeSemiURL     string              // POST: sets fire mode to Semi
	FireModeBurstURL    string              // POST: sets fire mode to Burst
	FireModeFullAutoURL string              // POST: sets fire mode to FullAuto
}

// SpectreView pairs a persisted Spectre with resolved catalog definitions.
// It is structurally compatible with the "character_card" template because all
// bot-specific routing was replaced by the embedded CardURLs fields.
type SpectreView struct {
	model.Spectre
	CharDef             *model.CharacterDef
	AppearanceCharDef   *model.CharacterDef // visual override portrait; nil means use CharDef image
	VoiceCharDef        *model.CharacterDef // voice archetype; nil means no voice override
	HeavyMeleeCharDef   *model.CharacterDef // heavy melee archetype override; nil means no override
	LightMeleeCharDef   *model.CharacterDef // light melee archetype override; nil means no override
	DodgeCharDef        *model.CharacterDef // dodge archetype override; nil means no override
	ShowHelmetToggle    bool                // true when base or appearance class has HasHelmet
	ShowHeadgearToggle  bool                // true when base or appearance class has HasHeadgear
	WeaponViews         []WeaponSlotView
	ArmorConsumableDef  *model.ConsumableDef // equipped armor consumable; nil when slot is empty
	WeaponConsumableDef *model.ConsumableDef // equipped weapon consumable; nil when slot is empty
	AmmoConsumableDef   *model.ConsumableDef // equipped ammo consumable; nil when slot is empty
	GearConsumableDef   *model.ConsumableDef // equipped gear consumable; nil when slot is empty
	PowerViews          []PowerSlotView
	SkillViews          []SkillView
	XPProgressPct       int    // 0-100, progress toward next level threshold
	XPDisplay           string // formatted total XP, e.g. "12,345"
	XPNextLevelDisplay  string // formatted XP threshold for next level, e.g. "350,000"
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
		PowerBaseURL:                base + "/power",
		AddPowerURL:                 base + "/borrowed-power/selector",
		ClearBorrowedPowerURL:       base + "/borrowed-power",
		AppearanceSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-appearance",
		VoiceSelectorURL:            "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-voice",
		HeavyMeleeSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-heavy-melee",
		LightMeleeSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-light-melee",
		DodgeSelectorURL:            "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-dodge",
		RenameURL:                   base + "/rename",
		AddWeaponURL:                "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre-add",
		ArmorConsumableClearURL:     base + "/consumable/armor/none",
		WeaponConsumableClearURL:    base + "/consumable/weapon/none",
		AmmoConsumableClearURL:      base + "/consumable/ammo/none",
		GearConsumableClearURL:      base + "/consumable/gear/none",
		SetActiveURL:                base + "/active/toggle",
		VisualHelmetURL:             base + "/visual/helmet",
		VisualHeadgearURL:           base + "/visual/headgear",
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
		PowerBaseURL:                base + "/power",
		AddPowerURL:                 base + "/borrowed-power/selector",
		ClearBorrowedPowerURL:       base + "/borrowed-power",
		AppearanceSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-appearance",
		VoiceSelectorURL:            "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-voice",
		HeavyMeleeSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-heavy-melee",
		LightMeleeSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-light-melee",
		DodgeSelectorURL:            "/api/characters/selector?entityId=" + spectreID + "&kind=spectre-dodge",
		RenameURL:                   base + "/rename",
		AddWeaponURL:                "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre-add",
		ArmorConsumableClearURL:     base + "/consumable/armor/none",
		WeaponConsumableClearURL:    base + "/consumable/weapon/none",
		AmmoConsumableClearURL:      base + "/consumable/ammo/none",
		GearConsumableClearURL:      base + "/consumable/gear/none",
		SetActiveURL:                "", // team members don't have an individual active toggle
		VisualHelmetURL:             base + "/visual/helmet",
		VisualHeadgearURL:           base + "/visual/headgear",
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
	kitID := char.KitQualifiedPath()
	var slots []model.PowerSlot
	for _, pid := range char.PowerIDs {
		if pid != "" {
			slot := model.DefaultPower(pid)
			slot.KitID = kitID
			slots = append(slots, slot)
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
			s.MigrateWeapons()
			s.MigrateSkills()
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
			s.MigrateWeapons()
			s.MigrateSkills()
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
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.MigrateWeapons()
		s.MigrateSkills()
		return nil
	})
	return s, err
}

// createSpectre persists a new spectre with the given name.
// Power slots are intentionally empty — the user fills them in on the sheet.
func createSpectre(db *bolt.DB, name string) (model.Spectre, error) {
	const defaultChar = "AdeptHumanMale"
	s := model.Spectre{
		ID:          newID(),
		Name:        name,
		CharacterID: defaultChar,
		Powers:      []model.PowerSlot{{}, {}, {}, {}, {}},
		SkillLevels: make(map[string]int),
		SkillPoints: model.InitialSkillPoints,
		Level:       1,
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

// duplicateSpectre creates a full copy of an existing spectre (new ID, same
// loadout) as a standalone operative. The copy's name gets " (Copy)" appended.
func duplicateSpectre(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var src model.Spectre
	if err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &src); err != nil {
			return err
		}
		src.MigrateWeapons()
		return nil
	}); err != nil {
		return model.Spectre{}, err
	}

	// Build the copy: new ID, standalone (no team), not active, new name.
	cp := src
	cp.ID = newID()
	cp.Name = src.Name + " (Copy)"
	cp.Active = false
	cp.TeamID = ""
	cp.SortOrder = 0

	// Deep-copy slices so the original is not aliased.
	if src.Weapons != nil {
		cp.Weapons = make([]model.WeaponSlot, len(src.Weapons))
		copy(cp.Weapons, src.Weapons)
	}
	if src.Powers != nil {
		cp.Powers = make([]model.PowerSlot, len(src.Powers))
		copy(cp.Powers, src.Powers)
	}
	if src.BorrowedPower != nil {
		bp := *src.BorrowedPower
		cp.BorrowedPower = &bp
	}

	data, err := json.Marshal(cp)
	if err != nil {
		return model.Spectre{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		return b.Put([]byte(cp.ID), data)
	})
	return cp, err
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
		SkillLevels: make(map[string]int),
		SkillPoints: model.InitialSkillPoints,
		Level:       1,
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

// addSpectreWeapon appends a new weapon slot (max 5). Returns an error if the
// weapon limit is already reached.
func addSpectreWeapon(db *bolt.DB, spectreID, weaponID string) (model.Spectre, error) {
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
		s.MigrateWeapons()
		if len(s.Weapons) >= 5 {
			return fmt.Errorf("weapon limit reached (max 5)")
		}
		s.Weapons = append(s.Weapons, model.WeaponSlot{WeaponID: weaponID})
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// setSpectreWeapon sets the weapon at an existing slot index. Clears mods when
// weaponID is empty.
func setSpectreWeapon(db *bolt.DB, spectreID string, idx int, weaponID string) (model.Spectre, error) {
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
		s.MigrateWeapons()
		if idx < 0 || idx >= len(s.Weapons) {
			return fmt.Errorf("invalid weapon index")
		}

		// Check if weapon category changed - if so, clear mods
		oldWeaponID := s.Weapons[idx].WeaponID
		oldWeapon := model.WeaponByID(oldWeaponID)
		newWeapon := model.WeaponByID(weaponID)

		s.Weapons[idx].WeaponID = weaponID

		// Clear mods if: weapon is being cleared (weaponID == "")
		// OR if weapon category changed (e.g., pistol -> assault rifle)
		if weaponID == "" || (oldWeapon != nil && newWeapon != nil && oldWeapon.Category != newWeapon.Category) {
			s.Weapons[idx].Mod1ID = ""
			s.Weapons[idx].Mod2ID = ""
		}

		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// setSpectreWeaponMod sets mod slot 1 or 2 for a weapon at the given index.
func setSpectreWeaponMod(db *bolt.DB, spectreID string, weaponIdx, modSlot int, modID string) (model.Spectre, error) {
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
		s.MigrateWeapons()
		if weaponIdx < 0 || weaponIdx >= len(s.Weapons) {
			return fmt.Errorf("invalid weapon index")
		}
		switch modSlot {
		case 1:
			s.Weapons[weaponIdx].Mod1ID = modID
		case 2:
			s.Weapons[weaponIdx].Mod2ID = modID
		default:
			return fmt.Errorf("invalid mod slot: must be 1 or 2")
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// removeSpectreWeapon removes the weapon slot at the given index.
func removeSpectreWeapon(db *bolt.DB, spectreID string, idx int) (model.Spectre, error) {
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
		s.MigrateWeapons()
		if idx < 0 || idx >= len(s.Weapons) {
			return fmt.Errorf("invalid weapon index")
		}
		s.Weapons = append(s.Weapons[:idx], s.Weapons[idx+1:]...)
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// setSpectreWeaponFireMode sets the fire mode for the weapon at the given slot index.
func setSpectreWeaponFireMode(db *bolt.DB, spectreID string, idx int, mode model.FireMode) (model.Spectre, error) {
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
		s.MigrateWeapons()
		if idx < 0 || idx >= len(s.Weapons) {
			return fmt.Errorf("invalid weapon index")
		}
		s.Weapons[idx].FireMode = mode
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

// updateSpectreVoice sets the voice archetype for a spectre, stored as the
// fully-qualified RootPath.ArchetypeID path so the game can use it directly.
func updateSpectreVoice(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	def := model.CharacterByID(charID)
	qualifiedID := charID
	if def != nil {
		qualifiedID = def.KitQualifiedPath()
	}
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
		s.VoiceCharacterID = qualifiedID
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreHeavyMelee sets the heavy melee archetype override for a spectre,
// stored as the fully-qualified RootPath.ArchetypeID path.
func updateSpectreHeavyMelee(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	def := model.CharacterByID(charID)
	qualifiedID := charID
	if def != nil {
		qualifiedID = def.KitQualifiedPath()
	}
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
		s.HeavyMeleeCharID = qualifiedID
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreLightMelee sets the light melee archetype override for a spectre,
// stored as the fully-qualified RootPath.ArchetypeID path.
func updateSpectreLightMelee(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	def := model.CharacterByID(charID)
	qualifiedID := charID
	if def != nil {
		qualifiedID = def.KitQualifiedPath()
	}
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
		s.LightMeleeCharID = qualifiedID
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreDodge sets the dodge archetype override for a spectre,
// stored as the fully-qualified RootPath.ArchetypeID path.
func updateSpectreDodge(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	def := model.CharacterByID(charID)
	qualifiedID := charID
	if def != nil {
		qualifiedID = def.KitQualifiedPath()
	}
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
		s.DodgeCharID = qualifiedID
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
// charID is the source character the power was selected from; it is used to
// populate KitID so the ME3 client can prime the correct DLC package.
func updateSpectrePowerID(db *bolt.DB, spectreID string, slotIdx int, powerID, charID string) (model.Spectre, error) {
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
		slot := model.DefaultPower(powerID)
		if char := model.CharacterByID(charID); char != nil {
			slot.KitID = char.KitQualifiedPath()
		}
		s.Powers[slotIdx] = slot
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// addSpectreBorrowedPower sets (or replaces) the borrowed power slot.
// charID is the source character the power was selected from; it is used to
// populate KitID so the ME3 client can prime the correct DLC package.
func addSpectreBorrowedPower(db *bolt.DB, spectreID, powerID, charID string) (model.Spectre, error) {
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
		if char := model.CharacterByID(charID); char != nil {
			slot.KitID = char.KitQualifiedPath()
		}
		s.BorrowedPower = &slot
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// clearSpectrePower clears the PowerID and resets the specified power slot.
func clearSpectrePower(db *bolt.DB, spectreID string, slotIdx int) (model.Spectre, error) {
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
		s.Powers[slotIdx] = model.PowerSlot{}
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

// updateSpectreShieldType sets the ShieldType field ("Shield" or "Barrier").
func updateSpectreShieldType(db *bolt.DB, spectreID, shieldType string) (model.Spectre, error) {
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
		s.ShieldType = shieldType
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePreferredSpecies sets the PreferredSpecies field used to filter
// the appearance character selector.
func updateSpectrePreferredSpecies(db *bolt.DB, spectreID, species string) (model.Spectre, error) {
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
		s.PreferredSpecies = species
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// GrantXPResult reports what changed when XP is awarded.
type GrantXPResult struct {
	Spectre      model.Spectre
	LevelsGained int // number of levels gained in this grant (0 = no level-up)
}

// GrantXPToActive finds the active spectre, adds xpAmount, advances its level
// as many times as the new total warrants, and awards one skill point per level
// gained. Returns the updated spectre and how many levels were gained.
func GrantXPToActive(db *bolt.DB, xpAmount int) (GrantXPResult, error) {
	var result GrantXPResult
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("no spectres bucket")
		}
		// Find the active spectre's key and value.
		var key []byte
		var s model.Spectre
		if err := b.ForEach(func(k, v []byte) error {
			var tmp model.Spectre
			if err := json.Unmarshal(v, &tmp); err != nil {
				return err
			}
			if tmp.Active {
				key = append([]byte{}, k...)
				s = tmp
			}
			return nil
		}); err != nil {
			return err
		}
		if key == nil {
			return fmt.Errorf("no active spectre")
		}
		s.MigrateWeapons()
		s.MigrateSkills()

		oldLevel := model.LevelForXP(s.XP)
		s.XP += xpAmount
		newLevel := model.LevelForXP(s.XP)

		levelsGained := newLevel - oldLevel
		if levelsGained < 0 {
			levelsGained = 0
		}
		s.Level = newLevel
		s.SkillPoints += levelsGained

		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		result = GrantXPResult{Spectre: s, LevelsGained: levelsGained}
		return b.Put(key, data)
	})
	return result, err
}

// isPassivePower reports whether a PowerDef is passive-typed (Passive or MeleePassive).
func isPassivePower(pd *model.PowerDef) bool {
	if pd == nil {
		return false
	}
	return pd.Type == model.PowerTypePassive || pd.Type == model.PowerTypeMeleePassive
}

// powerTypeForSlot returns the required PowerType for a fixed-position slot,
// or an empty string when the slot has no type constraint.
// Slot 3 = MPPassive; slot 4 = MPMeleePassive.
func powerTypeForSlot(slotIdx int) model.PowerType {
	switch slotIdx {
	case 3:
		return model.PowerTypePassive
	case 4:
		return model.PowerTypeMeleePassive
	default:
		return model.PowerTypeActive
	}
}

// spectrePowerViews builds the full []PowerSlotView for a spectre.
// Display order: active slots (0-2), borrowed power or placeholder (slot 4 visually),
// then passive slots (3-4 in DB). Slot position — not power type — determines the bucket
// so that empty slots still land in the correct group.
func spectrePowerViews(s model.Spectre, urls CardURLs) []PowerSlotView {
	base := "/api/spectres/" + s.ID

	var activeViews, passiveViews []PowerSlotView
	for i, ps := range s.Powers {
		pd := model.PowerByID(ps.PowerID)
		// Use slot index to classify — isPassivePower(nil) would mis-classify empty passive slots.
		isSlotPassive := i >= 3
		requiredType := powerTypeForSlot(i)
		typeParam := "?type=" + string(requiredType)
		v := PowerSlotView{
			PowerSlot:      ps,
			PowerDef:       pd,
			SlotIdx:        i,
			Evo0:           ps.Evolution[0],
			Evo1:           ps.Evolution[1],
			Evo2:           ps.Evolution[2],
			SlotBaseURL:    fmt.Sprintf("%s/%d", urls.PowerBaseURL, i),
			IsPassive:      isSlotPassive,
			ChangePowerURL: base + fmt.Sprintf("/power/%d/change/selector%s", i, typeParam),
		}
		if pd != nil {
			v.ClearPowerURL = fmt.Sprintf("%s/power/%d", base, i)
		}
		if isSlotPassive {
			passiveViews = append(passiveViews, v)
		} else {
			activeViews = append(activeViews, v)
		}
	}

	// Always add position 4: either the real borrowed power or an empty placeholder.
	// This ensures the slot — and the passive separator — are always visible.
	if s.BorrowedPower != nil {
		bp := *s.BorrowedPower
		activeViews = append(activeViews, PowerSlotView{
			PowerSlot:       bp,
			PowerDef:        model.PowerByID(bp.PowerID),
			SlotIdx:         len(s.Powers),
			Evo0:            bp.Evolution[0],
			Evo1:            bp.Evolution[1],
			Evo2:            bp.Evolution[2],
			SlotBaseURL:     base + "/borrowed-power",
			IsBorrowedPower: true,
			ChangePowerURL:  base + "/borrowed-power/selector",
		})
	} else {
		activeViews = append(activeViews, PowerSlotView{
			SlotIdx:                 len(s.Powers),
			IsBorrowSlotPlaceholder: true,
			ChangePowerURL:          urls.AddPowerURL,
		})
	}

	// Mark the first passive slot so the template can render a section header.
	if len(passiveViews) > 0 {
		passiveViews[0].IsFirstPassive = true
	}

	return append(activeViews, passiveViews...)
}

// weaponSlotViews builds a WeaponSlotView for each weapon slot, resolving
// catalog defs and pre-computing per-slot API URLs.
func weaponSlotViews(spectreID string, weapons []model.WeaponSlot) []WeaponSlotView {
	base := "/api/spectres/" + spectreID
	views := make([]WeaponSlotView, len(weapons))
	for i, ws := range weapons {
		idxStr := strconv.Itoa(i)
		fmBase := base + "/weapon/" + idxStr + "/firemode/"
		views[i] = WeaponSlotView{
			WeaponSlot:          ws,
			SlotIdx:             i,
			WeaponDef:           model.WeaponByID(ws.WeaponID),
			Mod1Def:             model.WeaponModByID(ws.Mod1ID),
			Mod2Def:             model.WeaponModByID(ws.Mod2ID),
			WeaponSelectorURL:   "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre-weapon&weaponIdx=" + idxStr,
			Mod1SelectorURL:     "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon&weaponIdx=" + idxStr + "&slot=1",
			Mod2SelectorURL:     "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre-weapon&weaponIdx=" + idxStr + "&slot=2",
			WeaponClearURL:      base + "/weapon/" + idxStr + "/none",
			RemoveURL:           base + "/weapon/" + idxStr,
			FireModeSemiURL:     fmBase + "Semi",
			FireModeBurstURL:    fmBase + "Burst",
			FireModeFullAutoURL: fmBase + "FullAuto",
		}
	}
	return views
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
		appearanceDef := model.CharacterByID(s.AppearanceCharacterID)
		views = append(views, SpectreView{
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
		appearanceDef3 := model.CharacterByID(s.AppearanceCharacterID)
		views = append(views, SpectreView{
			Spectre:             s,
			CharDef:             def,
			AppearanceCharDef:   appearanceDef3,
			ShowHelmetToggle:    def.HasHelmet || (appearanceDef3 != nil && appearanceDef3.HasHelmet),
			ShowHeadgearToggle:  def.HasHeadgear || (appearanceDef3 != nil && appearanceDef3.HasHeadgear),
			WeaponViews:         weaponSlotViews(s.ID, s.Weapons),
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

// setSpectreVisual sets UseHelmet or UseHeadgear on a spectre (mutually exclusive).
// Calling with the already-active choice clears both (toggle off).
func setSpectreVisual(db *bolt.DB, spectreID, choice string) (model.Spectre, error) {
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
		switch choice {
		case "helmet":
			if s.UseHelmet {
				s.UseHelmet = false
			} else {
				s.UseHelmet = true
				s.UseHeadgear = false
			}
		case "headgear":
			if s.UseHeadgear {
				s.UseHeadgear = false
			} else {
				s.UseHeadgear = true
				s.UseHelmet = false
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

package model

// PawnType describes how a character is spawned in ME3 multiplayer.
type PawnType string

const (
	PawnTypePlayerMP PawnType = "PlayerMP"
	PawnTypePawn     PawnType = "Pawn"
	PawnTypeHenchman PawnType = "Henchman"
)

// FireMode describes the firing mode of an equipped weapon.
type FireMode string

const (
	FireModeSemi     FireMode = "Semi"
	FireModeBurst    FireMode = "Burst"
	FireModeFullAuto FireMode = "FullAuto"
)

// WeaponSlot holds one equipped weapon and its two mod slots.
type WeaponSlot struct {
	WeaponID string   `json:"weaponId"`
	Mod1ID   string   `json:"mod1Id,omitempty"`
	Mod2ID   string   `json:"mod2Id,omitempty"`
	FireMode FireMode `json:"fireMode,omitempty"`
}

// Spectre is a single N7/Spectre character loadout.
// Unlike a Bot it belongs to no team — it is a standalone slot for the
// player's own operatives.
type Spectre struct {
	ID                    string       `json:"id"`
	Name                  string       `json:"name"`
	CharacterID           string       `json:"characterId"`
	AppearanceCharacterID string       `json:"appearanceCharId,omitempty"`   // visual override; base class unchanged
	AppearancePawnType    PawnType     `json:"appearancePawnType,omitempty"` // pawn type derived from the character class
	Weapons               []WeaponSlot `json:"weapons,omitempty"`            // up to 5 weapon slots
	ArmorConsumableID     string       `json:"armorConsumableId,omitempty"`  // equipped armor consumable
	WeaponConsumableID    string       `json:"weaponConsumableId,omitempty"` // equipped weapon consumable
	AmmoConsumableID      string       `json:"ammoConsumableId,omitempty"`   // equipped ammo consumable
	GearConsumableID      string       `json:"gearConsumableId,omitempty"`   // equipped gear consumable
	Powers                []PowerSlot  `json:"powers"`
	BorrowedPower         *PowerSlot   `json:"borrowedPower,omitempty"` // one borrowed power from another character class
	UseHelmet             bool         `json:"appearanceHelmet"`        // render helmet on next spawn
	UseHeadgear           bool         `json:"appearanceHeadgear"`      // render headgear on next spawn
	Active                bool         `json:"active,omitempty"`        // whether this spectre is set as active
	ShieldType            string       `json:"shieldType,omitempty"`    // "Shield" or "Barrier"; empty defaults to "Shield"
	TeamID                string       `json:"teamId,omitempty"`        // non-empty for strike-team members
	SortOrder             int64        `json:"sortOrder,omitempty"`     // creation time (unix nanos) for ordering within a team

	// Deprecated individual weapon fields — read-only for migration purposes.
	// Populated only when reading old DB records; never written after migration.
	LegacyWeaponID    string `json:"weaponId,omitempty"`
	LegacyWeaponMod1  string `json:"weaponMod1Id,omitempty"`
	LegacyWeaponMod2  string `json:"weaponMod2Id,omitempty"`
	LegacyWeapon2ID   string `json:"weapon2Id,omitempty"`
	LegacyWeapon2Mod1 string `json:"weapon2Mod1Id,omitempty"`
	LegacyWeapon2Mod2 string `json:"weapon2Mod2Id,omitempty"`
}

// MigrateWeapons converts legacy individual weapon fields into the Weapons
// slice. Must be called after unmarshalling an old record. No-op if Weapons
// is already populated.
func (s *Spectre) MigrateWeapons() {
	if len(s.Weapons) > 0 {
		return
	}
	if s.LegacyWeaponID != "" {
		s.Weapons = append(s.Weapons, WeaponSlot{
			WeaponID: s.LegacyWeaponID,
			Mod1ID:   s.LegacyWeaponMod1,
			Mod2ID:   s.LegacyWeaponMod2,
		})
	}
	if s.LegacyWeapon2ID != "" {
		s.Weapons = append(s.Weapons, WeaponSlot{
			WeaponID: s.LegacyWeapon2ID,
			Mod1ID:   s.LegacyWeapon2Mod1,
			Mod2ID:   s.LegacyWeapon2Mod2,
		})
	}
	// Clear legacy fields so they are not re-written to DB.
	s.LegacyWeaponID = ""
	s.LegacyWeaponMod1 = ""
	s.LegacyWeaponMod2 = ""
	s.LegacyWeapon2ID = ""
	s.LegacyWeapon2Mod1 = ""
	s.LegacyWeapon2Mod2 = ""
}

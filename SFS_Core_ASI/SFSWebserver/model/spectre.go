package model

// Spectre is a single N7/Spectre character loadout.
// Unlike a Bot it belongs to no team — it is a standalone slot for the
// player's own operatives.
type Spectre struct {
	ID                    string      `json:"id"`
	Name                  string      `json:"name"`
	CharacterID           string      `json:"characterId"`
	AppearanceCharacterID string      `json:"appearanceCharId,omitempty"` // visual override; base class unchanged
	WeaponID              string      `json:"weaponId"`
	WeaponMod1ID          string      `json:"weaponMod1Id"`
	WeaponMod2ID          string      `json:"weaponMod2Id"`
	Weapon2ID             string      `json:"weapon2Id,omitempty"`     // second weapon slot (spectres only)
	Weapon2Mod1ID         string      `json:"weapon2Mod1Id,omitempty"` // mod slot 1 for second weapon
	Weapon2Mod2ID         string      `json:"weapon2Mod2Id,omitempty"` // mod slot 2 for second weapon
	Powers                []PowerSlot `json:"powers"`
	BorrowedPower         *PowerSlot  `json:"borrowedPower,omitempty"` // one borrowed power from another character class
	Active                bool        `json:"active,omitempty"`        // whether this spectre is set as active
}

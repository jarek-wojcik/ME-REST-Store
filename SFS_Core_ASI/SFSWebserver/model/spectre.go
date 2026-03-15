package model

// Spectre is a single N7/Spectre character loadout.
// Unlike a Bot it belongs to no team — it is a standalone slot for the
// player's own operatives.
type Spectre struct {
	ID           string      `json:"id"`
	Name         string      `json:"name"`
	CharacterID  string      `json:"characterId"`
	WeaponID     string      `json:"weaponId"`
	WeaponMod1ID string      `json:"weaponMod1Id"`
	WeaponMod2ID string      `json:"weaponMod2Id"`
	Powers       []PowerSlot `json:"powers"`
}

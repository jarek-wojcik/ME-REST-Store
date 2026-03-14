package main

// WeaponSlot identifies which slot a weapon mod occupies.
// Mods with the same WeaponSlot are mutually exclusive on a given bot slot.
type WeaponSlot string

const (
	WeaponSlotMagazine  WeaponSlot = "Magazine"
	WeaponSlotMelee     WeaponSlot = "Melee"
	WeaponSlotPower     WeaponSlot = "Power"
	WeaponSlotStability WeaponSlot = "Stability"
	WeaponSlotScope     WeaponSlot = "Scope"
	WeaponSlotDamage    WeaponSlot = "Damage"
)

// WeaponModDef is a read-only definition of a weapon modification.
// Like WeaponDef it is compiled into the binary and never stored in BoltDB.
type WeaponModDef struct {
	ID          string     // matches the asset filename stem, e.g. "AssaultRifleDamage"
	Name        string     // human-readable display name
	WeaponSlot  WeaponSlot // which slot this mod occupies
	PictureFile string     // filename inside /static/assets/weapon_mods/
}

// PictureURL returns the URL path for the weapon mod's image.
func (m WeaponModDef) PictureURL() string {
	return "/static/assets/weapon_mods/" + m.PictureFile
}

// WeaponModCatalog is the full list of available weapon modifications.
var WeaponModCatalog = []WeaponModDef{
	// ---- Assault Rifle mods -----------------------------------------------
	{ID: "AssaultRifleAccuracy", Name: "AR Precision Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "AssaultRifleAccuracy.webp"},
	{ID: "AssaultRifleDamage", Name: "AR High-Velocity Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "AssaultRifleDamage.webp"},
	{ID: "AssaultRifleSuperPen", Name: "AR Piercing Mod", WeaponSlot: WeaponSlotDamage, PictureFile: "AssaultRifleSuperPen.webp"},
	{ID: "AssaultRifleSuperScope", Name: "AR Extended Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "AssaultRifleSuperScope.webp"},

	// ---- Pistol mods -------------------------------------------------------
	{ID: "PistolHeadShot", Name: "Pistol High-Caliber Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "PistolHeadShot.webp"},
	{ID: "PistolPowerDamage_MP5", Name: "Pistol Power Magnifier", WeaponSlot: WeaponSlotDamage, PictureFile: "PistolPowerDamage_MP5.webp"},
	{ID: "PistolStability", Name: "Pistol Stability Dampener", WeaponSlot: WeaponSlotDamage, PictureFile: "PistolStability.webp"},
	{ID: "PistolSuperDamage", Name: "Pistol Piercing Mod", WeaponSlot: WeaponSlotDamage, PictureFile: "PistolSuperDamage.webp"},

	// ---- Shotgun mods -------------------------------------------------------
	{ID: "ShotgunAccuracy", Name: "Shotgun Smart Choke", WeaponSlot: WeaponSlotDamage, PictureFile: "ShotgunAccuracy.webp"},
	{ID: "ShotgunDamage", Name: "Shotgun High-Caliber Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "ShotgunDamage.webp"},
	{ID: "ShotgunDamageAndPen", Name: "Shotgun Penetration Mod", WeaponSlot: WeaponSlotDamage, PictureFile: "ShotgunDamageAndPen.webp"},
	{ID: "ShotgunMeleeDamage", Name: "Shotgun Blade Attachment", WeaponSlot: WeaponSlotMelee, PictureFile: "ShotgunMeleeDamage.webp"},
	{ID: "ShotgunReloadSpeed", Name: "Shotgun Spare Thermal Clip", WeaponSlot: WeaponSlotDamage, PictureFile: "ShotgunReloadSpeed.webp"},

	// ---- SMG mods ----------------------------------------------------------
	{ID: "SMGConstraintDamage", Name: "SMG Heat Sink", WeaponSlot: WeaponSlotDamage, PictureFile: "SMGConstraintDamage.webp"},
	{ID: "SMGPenetration", Name: "SMG Penetration Mod", WeaponSlot: WeaponSlotDamage, PictureFile: "SMGPenetration.webp"},
	{ID: "SMGPowerDamage_MP5", Name: "SMG Power Magnifier", WeaponSlot: WeaponSlotDamage, PictureFile: "SMGPowerDamage_MP5.webp"},

	// ---- Sniper Rifle mods -------------------------------------------------
	{ID: "SniperRifleAccuracy", Name: "SR Precision Scope", WeaponSlot: WeaponSlotDamage, PictureFile: "SniperRifleAccuracy.webp"},
	{ID: "SniperRifleDamageAndPen", Name: "SR High-Velocity Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "SniperRifleDamageAndPen.webp"},
	{ID: "SniperRifleSuperScope", Name: "SR Electronic Scope", WeaponSlot: WeaponSlotDamage, PictureFile: "SniperRifleSuperScope.webp"},

	// ---- Universal mods ----------------------------------------------------
	{ID: "HighCaliberBarrel", Name: "High-Caliber Barrel", WeaponSlot: WeaponSlotDamage, PictureFile: "HighCaliberBarrel.webp"},
	{ID: "MagSize", Name: "Magazine Upgrade", WeaponSlot: WeaponSlotDamage, PictureFile: "MagSize.webp"},
	{ID: "OmniBlade", Name: "OmniTool Omni-Blade", WeaponSlot: WeaponSlotMelee, PictureFile: "OmniBlade.webp"},
	{ID: "PiercingMod", Name: "Piercing Mod", WeaponSlot: WeaponSlotDamage, PictureFile: "PiercingMod.webp"},
	{ID: "Scope", Name: "Scope", WeaponSlot: WeaponSlotDamage, PictureFile: "Scope.webp"},
	{ID: "SpareThermalClip", Name: "Spare Thermal Clip", WeaponSlot: WeaponSlotDamage, PictureFile: "SpareThermalClip.webp"},
	{ID: "Stability", Name: "Stability Dampener", WeaponSlot: WeaponSlotDamage, PictureFile: "Stability.webp"},
	{ID: "UltraLight", Name: "Ultralight Materials", WeaponSlot: WeaponSlotDamage, PictureFile: "UltraLight.webp"},
}

// weaponModIndex is a map built once at startup for O(1) lookups.
var weaponModIndex = func() map[string]*WeaponModDef {
	m := make(map[string]*WeaponModDef, len(WeaponModCatalog))
	for i := range WeaponModCatalog {
		m[WeaponModCatalog[i].ID] = &WeaponModCatalog[i]
	}
	return m
}()

// WeaponModByID returns the WeaponModDef for the given ID, or nil if not found.
func WeaponModByID(id string) *WeaponModDef {
	return weaponModIndex[id]
}

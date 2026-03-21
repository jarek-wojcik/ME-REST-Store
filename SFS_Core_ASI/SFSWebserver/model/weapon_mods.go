package model

// WeaponSlot identifies which slot a weapon mod occupies.
// Mods with the same WeaponSlot are mutually exclusive on a given bot slot.
type Socket string

const (
	Barrel   Socket = "Barrel"
	Scope    Socket = "Scope"
	Blade    Socket = "Blade"
	Internal Socket = "Internal"
)

// WeaponModDef is a read-only definition of a weapon modification.
// Like WeaponDef it is compiled into the binary and never stored in BoltDB.
type WeaponModDef struct {
	ID          string
	RootPath    string     // UE3 package namespace: SFXGameContent, SFXGameContentDLC_Shared, or SFXGameContentDLC_CON_MP5
	Name        string     // human-readable display name
	Socket      Socket     // which slot this mod occupies
	WeaponType  WeaponType // compatible weapon class; WeaponTypeAny means universal
	PictureFile string     // filename inside /static/assets/weapon_mods/
}

// PictureURL returns the URL path for the weapon mod's image.
func (m WeaponModDef) PictureURL() string {
	return "/static/assets/weapon_mods/" + m.PictureFile
}

// WeaponModCatalog is the full list of available weapon modifications.
var WeaponModCatalog = []WeaponModDef{
	// ---- Assault Rifle mods (SFXGameContent) --------------------------------
	{ID: "SFXWeaponMod_AssaultRifleAccuracy", RootPath: "SFXGameContent", Name: "Precision Scope", Socket: Scope, WeaponType: WeaponTypeAssaultRifle, PictureFile: "AssaultRifleAccuracy.webp"},
	{ID: "SFXWeaponMod_AssaultRifleDamage", RootPath: "SFXGameContent", Name: "Extended Barrel", Socket: Barrel, WeaponType: WeaponTypeAssaultRifle, PictureFile: "AssaultRifleDamage.webp"},
	{ID: "SFXWeaponMod_AssaultRifleForce", RootPath: "SFXGameContent", Name: "Piercing Mod", Socket: Internal, WeaponType: WeaponTypeAssaultRifle, PictureFile: "PiercingMod.webp"},
	{ID: "SFXWeaponMod_AssaultRifleMagSize", RootPath: "SFXGameContent", Name: "Magazine Upgrade", Socket: Internal, WeaponType: WeaponTypeAssaultRifle, PictureFile: "MagSize.webp"},
	{ID: "SFXWeaponMod_AssaultRifleStability", RootPath: "SFXGameContent", Name: "Stability Dampener", Socket: Internal, WeaponType: WeaponTypeAssaultRifle, PictureFile: "Stability.webp"},

	// ---- Assault Rifle mods (SFXGameContentDLC_Shared) ----------------------
	{ID: "SFXWeaponMod_AssaultRifleMelee", RootPath: "SFXGameContentDLC_Shared", Name: "Omni-Blade", Socket: Blade, WeaponType: WeaponTypeAssaultRifle, PictureFile: "OmniBlade.webp"},
	{ID: "SFXWeaponMod_AssaultRifleSuperPen", RootPath: "SFXGameContentDLC_Shared", Name: "High-Velocity Barrel", Socket: Barrel, WeaponType: WeaponTypeAssaultRifle, PictureFile: "AssaultRifleSuperPen.webp"},
	{ID: "SFXWeaponMod_AssaultRifleSuperScope", RootPath: "SFXGameContentDLC_Shared", Name: "Thermal Scope", Socket: Scope, WeaponType: WeaponTypeAssaultRifle, PictureFile: "AssaultRifleSuperScope.webp"},

	// ---- Assault Rifle mods (SFXGameContentDLC_CON_MP5) ---------------------
	{ID: "SFXWeaponMod_AssaultRifleUltraLight_MP5", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Ultralight Materials", Socket: Internal, WeaponType: WeaponTypeAssaultRifle, PictureFile: "UltraLight.webp"},

	// ---- Pistol mods (SFXGameContent) ---------------------------------------
	{ID: "SFXWeaponMod_PistolAccuracy", RootPath: "SFXGameContent", Name: "Scope", Socket: Scope, WeaponType: WeaponTypePistol, PictureFile: "Scope.webp"},
	{ID: "SFXWeaponMod_PistolDamage", RootPath: "SFXGameContent", Name: "High Caliber Barrel", Socket: Barrel, WeaponType: WeaponTypePistol, PictureFile: "HighCaliberBarrel.webp"},
	{ID: "SFXWeaponMod_PistolMagSize", RootPath: "SFXGameContent", Name: "Magazine Upgrade", Socket: Internal, WeaponType: WeaponTypePistol, PictureFile: "MagSize.webp"},
	{ID: "SFXWeaponMod_PistolReloadSpeed", RootPath: "SFXGameContent", Name: "Piercing Mod", Socket: Internal, WeaponType: WeaponTypePistol, PictureFile: "PiercingMod.webp"},
	{ID: "SFXWeaponMod_PistolStability", RootPath: "SFXGameContent", Name: "Melee Stunner", Socket: Internal, WeaponType: WeaponTypePistol, PictureFile: "PistolStability.webp"},

	// ---- Pistol mods (SFXGameContentDLC_Shared) -----------------------------
	{ID: "SFXWeaponMod_PistolHeadShot", RootPath: "SFXGameContentDLC_Shared", Name: "Cranial Trauma System", Socket: Internal, WeaponType: WeaponTypePistol, PictureFile: "PistolHeadShot.webp"},
	{ID: "SFXWeaponMod_PistolSuperDamage", RootPath: "SFXGameContentDLC_Shared", Name: "Heavy Barrel", Socket: Barrel, WeaponType: WeaponTypePistol, PictureFile: "PistolSuperDamage.webp"},
	{ID: "SFXWeaponMod_PistolUltraLight", RootPath: "SFXGameContentDLC_Shared", Name: "Ultralight Materials", Socket: Internal, WeaponType: WeaponTypePistol, PictureFile: "UltraLight.webp"},

	// ---- Pistol mods (SFXGameContentDLC_CON_MP5) ----------------------------
	{ID: "SFXWeaponMod_PistolPowerDamage_MP5", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Power Magnifier", Socket: Scope, WeaponType: WeaponTypePistol, PictureFile: "PistolPowerDamage_MP5.webp"},

	// ---- Shotgun mods (SFXGameContent) --------------------------------------
	{ID: "SFXWeaponMod_ShotgunAccuracy", RootPath: "SFXGameContent", Name: "Smart Choke", Socket: Internal, WeaponType: WeaponTypeShotgun, PictureFile: "ShotgunAccuracy.webp"},
	{ID: "SFXWeaponMod_ShotgunDamage", RootPath: "SFXGameContent", Name: "High-Caliber Barrel", Socket: Barrel, WeaponType: WeaponTypeShotgun, PictureFile: "ShotgunDamage.webp"},
	{ID: "SFXWeaponMod_ShotgunMeleeDamage", RootPath: "SFXGameContent", Name: "Blade Attachment", Socket: Blade, WeaponType: WeaponTypeShotgun, PictureFile: "ShotgunMeleeDamage.webp"},
	{ID: "SFXWeaponMod_ShotgunReloadSpeed", RootPath: "SFXGameContent", Name: "Shredder Mod", Socket: Internal, WeaponType: WeaponTypeShotgun, PictureFile: "ShotgunReloadSpeed.webp"},
	{ID: "SFXWeaponMod_ShotgunStability", RootPath: "SFXGameContent", Name: "Spare Thermal Clip", Socket: Internal, WeaponType: WeaponTypeShotgun, PictureFile: "SpareThermalClip.webp"},

	// ---- Shotgun mods (SFXGameContentDLC_Shared) ----------------------------
	{ID: "SFXWeaponMod_ShotgunDamageAndPen", RootPath: "SFXGameContentDLC_Shared", Name: "High-Velocity Barrel", Socket: Barrel, WeaponType: WeaponTypeShotgun, PictureFile: "ShotgunDamageAndPen.webp"},
	{ID: "SFXWeaponMod_ShotgunSuperMelee", RootPath: "SFXGameContentDLC_Shared", Name: "Omni-Blade", Socket: Blade, WeaponType: WeaponTypeShotgun, PictureFile: "OmniBlade.webp"},

	// ---- Shotgun mods (SFXGameContentDLC_CON_MP5) ---------------------------
	{ID: "SFXWeaponMod_ShotgunUltraLight_MP5", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Ultralight Materials", Socket: Internal, WeaponType: WeaponTypeShotgun, PictureFile: "UltraLight.webp"},

	// ---- SMG mods (SFXGameContent) ------------------------------------------
	{ID: "SFXWeaponMod_SMGAccuracy", RootPath: "SFXGameContent", Name: "Scope", Socket: Scope, WeaponType: WeaponTypeSMG, PictureFile: "Scope.webp"},
	{ID: "SFXWeaponMod_SMGConstraintDamage", RootPath: "SFXGameContent", Name: "Heat Sink", Socket: Internal, WeaponType: WeaponTypeSMG, PictureFile: "SMGConstraintDamage.webp"},
	{ID: "SFXWeaponMod_SMGDamage", RootPath: "SFXGameContent", Name: "High-Caliber Barrel", Socket: Barrel, WeaponType: WeaponTypeSMG, PictureFile: "HighCaliberBarrel.webp"},
	{ID: "SFXWeaponMod_SMGMagSize", RootPath: "SFXGameContent", Name: "Magazine Upgrade", Socket: Internal, WeaponType: WeaponTypeSMG, PictureFile: "MagSize.webp"},
	{ID: "SFXWeaponMod_SMGStability", RootPath: "SFXGameContent", Name: "Ultralight Materials", Socket: Internal, WeaponType: WeaponTypeSMG, PictureFile: "UltraLight.webp"},

	// ---- SMG mods (SFXGameContentDLC_Shared) --------------------------------
	{ID: "SFXWeaponMod_SMGPenetration", RootPath: "SFXGameContentDLC_Shared", Name: "High-Velocity Barrel", Socket: Barrel, WeaponType: WeaponTypeSMG, PictureFile: "SMGPenetration.webp"},
	{ID: "SFXWeaponMod_SMGStabilization", RootPath: "SFXGameContentDLC_Shared", Name: "Recoil System", Socket: Internal, WeaponType: WeaponTypeSMG, PictureFile: "Stability.webp"},

	// ---- SMG mods (SFXGameContentDLC_CON_MP5) -------------------------------
	{ID: "SFXWeaponMod_SMGPowerDamage_MP5", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Power Magnifier", Socket: Scope, WeaponType: WeaponTypeSMG, PictureFile: "SMGPowerDamage_MP5.webp"},

	// ---- Sniper Rifle mods (SFXGameContent) ---------------------------------
	{ID: "SFXWeaponMod_SniperRifleAccuracy", RootPath: "SFXGameContent", Name: "Enhanced Scope", Socket: Scope, WeaponType: WeaponTypeSniperRifle, PictureFile: "SniperRifleAccuracy.webp"},
	{ID: "SFXWeaponMod_SniperRifleConstraintDamage", RootPath: "SFXGameContent", Name: "Piercing Mod", Socket: Internal, WeaponType: WeaponTypeSniperRifle, PictureFile: "PiercingMod.webp"},
	{ID: "SFXWeaponMod_SniperRifleDamage", RootPath: "SFXGameContent", Name: "Extended Barrel", Socket: Barrel, WeaponType: WeaponTypeSniperRifle, PictureFile: "SniperRifleBarrel.png"},
	{ID: "SFXWeaponMod_SniperRifleReloadSpeed", RootPath: "SFXGameContent", Name: "Spare Thermal Clip", Socket: Internal, WeaponType: WeaponTypeSniperRifle, PictureFile: "SpareThermalClip.webp"},
	//Single Player Only {ID: "SFXWeaponMod_SniperRifleTimeDilation", RootPath: "SFXGameContent", Name: "SR Time Dilation Scope", Socket: Scope, WeaponType: WeaponTypeSniperRifle, PictureFile: "SniperRifleTimeDilation.webp"},

	// ---- Sniper Rifle mods (SFXGameContentDLC_Shared) -----------------------
	{ID: "SFXWeaponMod_SniperRifleDamageAndPen", RootPath: "SFXGameContentDLC_Shared", Name: "High-Velocity Barrel", Socket: Barrel, WeaponType: WeaponTypeSniperRifle, PictureFile: "SniperRifleDamageAndPen.webp"},
	{ID: "SFXWeaponMod_SniperRifleSuperScope", RootPath: "SFXGameContentDLC_Shared", Name: "Thermal Scope", Socket: Scope, WeaponType: WeaponTypeSniperRifle, PictureFile: "SniperRifleSuperScope.webp"},

	// ---- Sniper Rifle mods (SFXGameContentDLC_CON_MP5) ----------------------
	{ID: "SFXWeaponMod_SniperRifleUltraLight_MP5", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Ultralight Materials", Socket: Internal, WeaponType: WeaponTypeSniperRifle, PictureFile: "UltraLight.webp"},
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

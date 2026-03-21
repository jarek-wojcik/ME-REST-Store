package model

import "strings"

// WeaponType identifies the class of a weapon (and is used to filter mods).
type WeaponType string

const (
	WeaponTypeAssaultRifle WeaponType = "Assault Rifle"
	WeaponTypePistol       WeaponType = "Pistol"
	WeaponTypeShotgun      WeaponType = "Shotgun"
	WeaponTypeSMG          WeaponType = "SMG"
	WeaponTypeSniperRifle  WeaponType = "Sniper Rifle"
	// WeaponTypeAny marks a mod as universal — compatible with every weapon.
	WeaponTypeAny WeaponType = ""
)

// WeaponDef is a read-only definition of a weapon available in multiplayer.
// Like CharacterDef it is compiled into the binary and never stored in BoltDB.
type WeaponDef struct {
	ID          string
	RootPath    string     // matches the asset filename stem, e.g. "AssaultRifle_Avenger"
	Name        string     // human-readable display name
	Category    WeaponType // weapon class
	PictureFile string     // filename inside /static/assets/weapons/
}

// PictureURL returns the URL path for the weapon's image.
func (w WeaponDef) PictureURL() string {
	return "/static/assets/weapons/" + w.PictureFile
}

// WeaponCatalog is the full list of available multiplayer weapons.
var WeaponCatalog = []WeaponDef{
	// ---- Assault Rifles ----------------------------------------------------
	{ID: "AssaultRifle_Adas_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Adas Anti-Synthetic Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Adas_MP.webp"},
	{ID: "AssaultRifle_Argus", RootPath: "SFXGameContent", Name: "Argus", Category: "Assault Rifle", PictureFile: "AssaultRifle_Argus.webp"},
	{ID: "AssaultRifle_Avenger", RootPath: "SFXGameContent", Name: "Avenger", Category: "Assault Rifle", PictureFile: "AssaultRifle_Avenger.webp"},
	{ID: "AssaultRifle_Cerberus", RootPath: "SFXGameContentDLC_CON_MP2", Name: "Cerberus Harrier", Category: "Assault Rifle", PictureFile: "AssaultRifle_Cerberus.webp"},
	{ID: "AssaultRifle_Cobra", RootPath: "SFXGameContent", Name: "Phaeston", Category: "Assault Rifle", PictureFile: "AssaultRifle_Cobra.webp"},
	{ID: "AssaultRifle_Collector", RootPath: "SFXGameContent", Name: "Collector Assault Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Collector.webp"},
	{ID: "AssaultRifle_Falcon", RootPath: "SFXGameContent", Name: "Falcon", Category: "Assault Rifle", PictureFile: "AssaultRifle_Falcon.webp"},
	{ID: "AssaultRifle_Geth", RootPath: "SFXGameContent", Name: "Geth Pulse Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Geth.webp"},
	{ID: "AssaultRifle_Krogan", RootPath: "SFXGameContentDLC_CON_MP1", Name: "Striker Assault Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Krogan.webp"},
	{ID: "AssaultRifle_Lancer_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Lancer", Category: "Assault Rifle", PictureFile: "AssaultRifle_Lancer_MP.webp"},
	{ID: "AssaultRifle_LMG", RootPath: "SFXGameContentDLC_CON_MP3", Name: "N7 Typhoon", Category: "Assault Rifle", PictureFile: "AssaultRifle_LMG.webp"},
	{ID: "AssaultRifle_Mattock", RootPath: "SFXGameContent", Name: "Mattock", Category: "Assault Rifle", PictureFile: "AssaultRifle_Mattock.webp"},
	{ID: "AssaultRifle_Prothean_MP", RootPath: "SFXGameContentDLC_CON_MP2", Name: "Particle Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Prothean_MP.webp"},
	{ID: "AssaultRifle_Reckoning", RootPath: "SFXGameContent", Name: "Chakram Launcher", Category: "Assault Rifle", PictureFile: "AssaultRifle_Reckoning.webp"}, //This is not in game.
	{ID: "AssaultRifle_Revenant", RootPath: "SFXGameContent", Name: "Revenant", Category: "Assault Rifle", PictureFile: "AssaultRifle_Revenant.webp"},
	{ID: "AssaultRifle_Saber", RootPath: "SFXGameContent", Name: "M-99 Saber", Category: "Assault Rifle", PictureFile: "AssaultRifle_Saber.webp"},
	{ID: "AssaultRifle_Spitfire", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Geth Spitfire", Category: "Assault Rifle", PictureFile: "AssaultRifle_Spitfire.webp"},
	{ID: "AssaultRifle_Valkyrie", RootPath: "SFXGameContent", Name: "Valkyrie", Category: "Assault Rifle", PictureFile: "AssaultRifle_Valkyrie.webp"},
	{ID: "AssaultRifle_Vindicator", RootPath: "SFXGameContent", Name: "Vindicator", Category: "Assault Rifle", PictureFile: "AssaultRifle_Vindicator.webp"},

	// ---- Pistols -----------------------------------------------------------
	{ID: "Pistol_Asari", RootPath: "SFXGameContentDLC_CON_MP3", Name: "Acolyte", Category: "Pistol", PictureFile: "Pistol_Asari.webp"},
	{ID: "Pistol_Bloodpack_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Executioner Pistol", Category: "Pistol", PictureFile: "Pistol_Bloodpack_MP.webp"},
	{ID: "Pistol_Carnifex", RootPath: "SFXGameContent", Name: "M-6 Carnifex", Category: "Pistol", PictureFile: "Pistol_Carnifex.webp"},
	{ID: "Pistol_Eagle", RootPath: "SFXGameContent", Name: "N7 Eagle", Category: "Pistol", PictureFile: "Pistol_Eagle.webp"},
	{ID: "Pistol_Ivory", RootPath: "SFXGameContent", Name: "M-77 Paladin", Category: "Pistol", PictureFile: "Pistol_Ivory.webp"},
	{ID: "Pistol_Phalanx", RootPath: "SFXGameContent", Name: "M-5 Phalanx", Category: "Pistol", PictureFile: "Pistol_Phalanx.webp"},
	{ID: "Pistol_Predator", RootPath: "SFXGameContent", Name: "M-3 Predator", Category: "Pistol", PictureFile: "Pistol_Predator.webp"},
	{ID: "Pistol_Scorpion", RootPath: "SFXGameContent", Name: "Scorpion", Category: "Pistol", PictureFile: "Pistol_Scorpion.webp"},
	{ID: "Pistol_Silencer_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "M-11 Suppressor", Category: "Pistol", PictureFile: "Pistol_Silencer_MP.webp"},
	{ID: "Pistol_Talon", RootPath: "SFXGameContent", Name: "M-358 Talon", Category: "Pistol", PictureFile: "Pistol_Talon.webp"},
	{ID: "Pistol_Thor", RootPath: "SFXGameContent", Name: "Arc Pistol", Category: "Pistol", PictureFile: "Pistol_Thor.webp"},

	// ---- Shotguns ----------------------------------------------------------
	{ID: "Shotgun_Assault", RootPath: "SFXGameContentDLC_CON_MP3", Name: "N7 Piranha", Category: "Shotgun", PictureFile: "Shotgun_Assault.webp"},
	{ID: "Shotgun_Claymore", RootPath: "SFXGameContent", Name: "M-300 Claymore", Category: "Shotgun", PictureFile: "Shotgun_Claymore.webp"},
	{ID: "Shotgun_Crusader", RootPath: "SFXGameContent", Name: "N7 Crusader", Category: "Shotgun", PictureFile: "Shotgun_Crusader.webp"},
	{ID: "Shotgun_Disciple", RootPath: "SFXGameContent", Name: "Disciple", Category: "Shotgun", PictureFile: "Shotgun_Disciple.webp"},
	{ID: "Shotgun_Eviscerator", RootPath: "SFXGameContent", Name: "M-22 Eviscerator", Category: "Shotgun", PictureFile: "Shotgun_Eviscerator.webp"},
	{ID: "Shotgun_Geth", RootPath: "SFXGameContent", Name: "Geth Plasma Shotgun", Category: "Shotgun", PictureFile: "Shotgun_Geth.webp"},
	{ID: "Shotgun_Graal", RootPath: "SFXGameContent", Name: "Graal Spike Thrower", Category: "Shotgun", PictureFile: "Shotgun_Graal.webp"},
	{ID: "Shotgun_Katana", RootPath: "SFXGameContent", Name: "M-23 Katana", Category: "Shotgun", PictureFile: "Shotgun_Katana.webp"},
	{ID: "Shotgun_Quarian", RootPath: "SFXGameContentDLC_CON_MP2", Name: "Reegar Carbine", Category: "Shotgun", PictureFile: "Shotgun_Quarian.webp"},
	{ID: "Shotgun_Raider", RootPath: "SFXGameContent", Name: "AT-12 Raider", Category: "Shotgun", PictureFile: "Shotgun_Raider.webp"},
	{ID: "Shotgun_Salarian_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Venom Shotgun", Category: "Shotgun", PictureFile: "Shotgun_Salarian_MP.webp"},
	{ID: "Shotgun_Scimitar", RootPath: "SFXGameContent", Name: "M-27 Scimitar", Category: "Shotgun", PictureFile: "Shotgun_Scimitar.webp"},
	{ID: "Shotgun_Striker", RootPath: "SFXGameContent", Name: "M-11 Wraith", Category: "Shotgun", PictureFile: "Shotgun_Striker.webp"},

	// ---- SMGs --------------------------------------------------------------
	{ID: "SMG_Bloodpack_MP", RootPath: "SFXGameContentDLC_CON_MP5", Name: "Blood Pack Punisher", Category: "SMG", PictureFile: "SMG_Bloodpack_MP.webp"},
	{ID: "SMG_Collector", RootPath: "SFXGameContentDLC_CON_MP4", Name: "Collector SMG", Category: "SMG", PictureFile: "SMG_Collector.webp"},
	{ID: "SMG_Geth", RootPath: "SFXGameContentDLC_CON_MP1", Name: "Geth Plasma SMG", Category: "SMG", PictureFile: "SMG_Geth.webp"},
	{ID: "SMG_Hornet", RootPath: "SFXGameContent", Name: "M-25 Hornet", Category: "SMG", PictureFile: "SMG_Hornet.webp"},
	{ID: "SMG_Hurricane", RootPath: "SFXGameContent", Name: "N7 Hurricane", Category: "SMG", PictureFile: "SMG_Hurricane.webp"},
	{ID: "SMG_Locust", RootPath: "SFXGameContent", Name: "M-12 Locust", Category: "SMG", PictureFile: "SMG_Locust.webp"},
	{ID: "SMG_Shuriken", RootPath: "SFXGameContent", Name: "M-4 Shuriken", Category: "SMG", PictureFile: "SMG_Shuriken.webp"},
	{ID: "SMG_Tempest", RootPath: "SFXGameContent", Name: "M-9 Tempest", Category: "SMG", PictureFile: "SMG_Tempest.webp"},

	// ---- Sniper Rifles -----------------------------------------------------
	{ID: "SniperRifle_Batarian", RootPath: "SFXGameContentDLC_CON_MP1", Name: "Kishock Harpoon Gun", Category: "Sniper Rifle", PictureFile: "SniperRifle_Batarian.webp"},
	{ID: "SniperRifle_BlackWidow", RootPath: "SFXGameContent", Name: "Black Widow", Category: "Sniper Rifle", PictureFile: "SniperRifle_BlackWidow.webp"},
	{ID: "SniperRifle_Collector", RootPath: "SFXGameContentDLC_CON_MP4", Name: "Collector Sniper Rifle", Category: "Sniper Rifle", PictureFile: "SniperRifle_Collector.webp"},
	{ID: "SniperRifle_Incisor", RootPath: "SFXGameContent", Name: "M-29 Incisor", Category: "Sniper Rifle", PictureFile: "SniperRifle_Incisor.webp"},
	{ID: "SniperRifle_Indra", RootPath: "SFXGameContent", Name: "M-90 Indra", Category: "Sniper Rifle", PictureFile: "SniperRifle_Indra.webp"},
	{ID: "SniperRifle_Javelin", RootPath: "SFXGameContent", Name: "Javelin", Category: "Sniper Rifle", PictureFile: "SniperRifle_Javelin.webp"},
	{ID: "SniperRifle_Mantis", RootPath: "SFXGameContent", Name: "M-92 Mantis", Category: "Sniper Rifle", PictureFile: "SniperRifle_Mantis.webp"},
	{ID: "SniperRifle_Raptor", RootPath: "SFXGameContent", Name: "M-13 Raptor", Category: "Sniper Rifle", PictureFile: "SniperRifle_Raptor.webp"},
	{ID: "SniperRifle_Turian", RootPath: "SFXGameContentDLC_CON_MP2", Name: "Krysae Sniper Rifle", Category: "Sniper Rifle", PictureFile: "SniperRifle_Turian.webp"},
	{ID: "SniperRifle_Valiant", RootPath: "SFXGameContent", Name: "N7 Valiant", Category: "Sniper Rifle", PictureFile: "SniperRifle_Valiant.webp"},
	{ID: "SniperRifle_Viper", RootPath: "SFXGameContent", Name: "M-97 Viper", Category: "Sniper Rifle", PictureFile: "SniperRifle_Viper.webp"},
	{ID: "SniperRifle_Widow", RootPath: "SFXGameContent", Name: "M-98 Widow", Category: "Sniper Rifle", PictureFile: "SniperRifle_Widow.webp"},
}

// weaponIndex is a map built once at startup for O(1) lookups.
var weaponIndex = func() map[string]*WeaponDef {
	m := make(map[string]*WeaponDef, len(WeaponCatalog))
	for i := range WeaponCatalog {
		m[WeaponCatalog[i].ID] = &WeaponCatalog[i]
	}
	return m
}()

// WeaponByID returns the WeaponDef for the given ID, or nil if not found.
func WeaponByID(id string) *WeaponDef {
	return weaponIndex[id]
}

// WeaponGroup holds weapons belonging to a single weapon category.
type WeaponGroup struct {
	Category string
	ID       string // safe HTML ID (no spaces)
	Weapons  []WeaponDef
}

// weaponTypeOrder defines the canonical display order for the weapon selector.
var weaponTypeOrder = []WeaponType{
	WeaponTypeAssaultRifle,
	WeaponTypeSMG,
	WeaponTypeShotgun,
	WeaponTypeSniperRifle,
	WeaponTypePistol,
}

func weaponTypeID(t WeaponType) string {
	// IDs need to be valid HTML id attributes.
	return strings.ReplaceAll(string(t), " ", "-")
}

// GroupedWeapons returns WeaponCatalog partitioned by Category,
// in the canonical weaponTypeOrder order.
func GroupedWeapons() []WeaponGroup {
	buckets := make(map[WeaponType][]WeaponDef, len(weaponTypeOrder))
	for _, w := range WeaponCatalog {
		buckets[w.Category] = append(buckets[w.Category], w)
	}
	groups := make([]WeaponGroup, 0, len(weaponTypeOrder))
	for _, wt := range weaponTypeOrder {
		if weapons, ok := buckets[wt]; ok {
			groups = append(groups, WeaponGroup{Category: string(wt), ID: weaponTypeID(wt), Weapons: weapons})
		}
	}
	return groups
}

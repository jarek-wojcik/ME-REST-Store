package main

// WeaponDef is a read-only definition of a weapon available in multiplayer.
// Like CharacterDef it is compiled into the binary and never stored in BoltDB.
type WeaponDef struct {
	ID          string // matches the asset filename stem, e.g. "AssaultRifle_Avenger"
	Name        string // human-readable display name
	Category    string // "Assault Rifle", "Pistol", "Shotgun", "SMG", "Sniper Rifle"
	PictureFile string // filename inside /static/assets/weapons/
}

// PictureURL returns the URL path for the weapon's image.
func (w WeaponDef) PictureURL() string {
	return "/static/assets/weapons/" + w.PictureFile
}

// WeaponCatalog is the full list of available multiplayer weapons.
var WeaponCatalog = []WeaponDef{
	// ---- Assault Rifles ----------------------------------------------------
	{ID: "AssaultRifle_Adas_MP", Name: "Adas Anti-Synthetic Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Adas_MP.webp"},
	{ID: "AssaultRifle_Argus", Name: "Argus", Category: "Assault Rifle", PictureFile: "AssaultRifle_Argus.webp"},
	{ID: "AssaultRifle_Avenger", Name: "Avenger", Category: "Assault Rifle", PictureFile: "AssaultRifle_Avenger.webp"},
	{ID: "AssaultRifle_Cerberus", Name: "Cerberus Harrier", Category: "Assault Rifle", PictureFile: "AssaultRifle_Cerberus.webp"},
	{ID: "AssaultRifle_Cobra", Name: "Cobra RPG", Category: "Assault Rifle", PictureFile: "AssaultRifle_Cobra.webp"},
	{ID: "AssaultRifle_Collector", Name: "Collector Assault Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Collector.webp"},
	{ID: "AssaultRifle_Falcon", Name: "Falcon", Category: "Assault Rifle", PictureFile: "AssaultRifle_Falcon.webp"},
	{ID: "AssaultRifle_Geth", Name: "Geth Pulse Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Geth.webp"},
	{ID: "AssaultRifle_Krogan", Name: "Striker", Category: "Assault Rifle", PictureFile: "AssaultRifle_Krogan.webp"},
	{ID: "AssaultRifle_Lancer_MP", Name: "Lancer", Category: "Assault Rifle", PictureFile: "AssaultRifle_Lancer_MP.webp"},
	{ID: "AssaultRifle_LMG", Name: "N7 Typhoon", Category: "Assault Rifle", PictureFile: "AssaultRifle_LMG.webp"},
	{ID: "AssaultRifle_Mattock", Name: "Mattock", Category: "Assault Rifle", PictureFile: "AssaultRifle_Mattock.webp"},
	{ID: "AssaultRifle_Prothean_MP", Name: "Prothean Particle Rifle", Category: "Assault Rifle", PictureFile: "AssaultRifle_Prothean_MP.webp"},
	{ID: "AssaultRifle_Reckoning", Name: "Reckoning", Category: "Assault Rifle", PictureFile: "AssaultRifle_Reckoning.webp"},
	{ID: "AssaultRifle_Revenant", Name: "Revenant", Category: "Assault Rifle", PictureFile: "AssaultRifle_Revenant.webp"},
	{ID: "AssaultRifle_Saber", Name: "N7 Valiant", Category: "Assault Rifle", PictureFile: "AssaultRifle_Saber.webp"},
	{ID: "AssaultRifle_Spitfire", Name: "Spitfire", Category: "Assault Rifle", PictureFile: "AssaultRifle_Spitfire.webp"},
	{ID: "AssaultRifle_Valkyrie", Name: "Valkyrie", Category: "Assault Rifle", PictureFile: "AssaultRifle_Valkyrie.webp"},
	{ID: "AssaultRifle_Vindicator", Name: "Vindicator", Category: "Assault Rifle", PictureFile: "AssaultRifle_Vindicator.webp"},

	// ---- Pistols -----------------------------------------------------------
	{ID: "Pistol_Asari", Name: "Acolyte", Category: "Pistol", PictureFile: "Pistol_Asari.webp"},
	{ID: "Pistol_Bloodpack_MP", Name: "Blood Pack Punisher", Category: "Pistol", PictureFile: "Pistol_Bloodpack_MP.webp"},
	{ID: "Pistol_Carnifex", Name: "Carnifex", Category: "Pistol", PictureFile: "Pistol_Carnifex.webp"},
	{ID: "Pistol_Eagle", Name: "Eagle", Category: "Pistol", PictureFile: "Pistol_Eagle.webp"},
	{ID: "Pistol_Ivory", Name: "Ivory", Category: "Pistol", PictureFile: "Pistol_Ivory.webp"},
	{ID: "Pistol_Phalanx", Name: "Phalanx", Category: "Pistol", PictureFile: "Pistol_Phalanx.webp"},
	{ID: "Pistol_Predator", Name: "Predator", Category: "Pistol", PictureFile: "Pistol_Predator.webp"},
	{ID: "Pistol_Scorpion", Name: "Scorpion", Category: "Pistol", PictureFile: "Pistol_Scorpion.webp"},
	{ID: "Pistol_Silencer_MP", Name: "N7 Eagle", Category: "Pistol", PictureFile: "Pistol_Silencer_MP.webp"},
	{ID: "Pistol_Talon", Name: "Talon", Category: "Pistol", PictureFile: "Pistol_Talon.webp"},
	{ID: "Pistol_Thor", Name: "Thor", Category: "Pistol", PictureFile: "Pistol_Thor.webp"},

	// ---- Shotguns ----------------------------------------------------------
	{ID: "Shotgun_Assault", Name: "N7 Crusader", Category: "Shotgun", PictureFile: "Shotgun_Assault.webp"},
	{ID: "Shotgun_Claymore", Name: "Claymore", Category: "Shotgun", PictureFile: "Shotgun_Claymore.webp"},
	{ID: "Shotgun_Crusader", Name: "Crusader", Category: "Shotgun", PictureFile: "Shotgun_Crusader.webp"},
	{ID: "Shotgun_Disciple", Name: "Disciple", Category: "Shotgun", PictureFile: "Shotgun_Disciple.webp"},
	{ID: "Shotgun_Eviscerator", Name: "Eviscerator", Category: "Shotgun", PictureFile: "Shotgun_Eviscerator.webp"},
	{ID: "Shotgun_Geth", Name: "Geth Plasma Shotgun", Category: "Shotgun", PictureFile: "Shotgun_Geth.webp"},
	{ID: "Shotgun_Graal", Name: "Graal Spike Thrower", Category: "Shotgun", PictureFile: "Shotgun_Graal.webp"},
	{ID: "Shotgun_Katana", Name: "Katana", Category: "Shotgun", PictureFile: "Shotgun_Katana.webp"},
	{ID: "Shotgun_Quarian", Name: "Reegar Carbine", Category: "Shotgun", PictureFile: "Shotgun_Quarian.webp"},
	{ID: "Shotgun_Raider", Name: "Raider", Category: "Shotgun", PictureFile: "Shotgun_Raider.webp"},
	{ID: "Shotgun_Salarian_MP", Name: "Venom Shotgun", Category: "Shotgun", PictureFile: "Shotgun_Salarian_MP.webp"},
	{ID: "Shotgun_Scimitar", Name: "Scimitar", Category: "Shotgun", PictureFile: "Shotgun_Scimitar.webp"},
	{ID: "Shotgun_Striker", Name: "Striker", Category: "Shotgun", PictureFile: "Shotgun_Striker.webp"},

	// ---- SMGs --------------------------------------------------------------
	{ID: "SMG_Bloodpack_MP", Name: "Blood Pack SMG", Category: "SMG", PictureFile: "SMG_Bloodpack_MP.webp"},
	{ID: "SMG_Collector", Name: "Collector SMG", Category: "SMG", PictureFile: "SMG_Collector.webp"},
	{ID: "SMG_Geth", Name: "Geth SMG", Category: "SMG", PictureFile: "SMG_Geth.webp"},
	{ID: "SMG_Hornet", Name: "Hornet", Category: "SMG", PictureFile: "SMG_Hornet.webp"},
	{ID: "SMG_Hurricane", Name: "Hurricane", Category: "SMG", PictureFile: "SMG_Hurricane.webp"},
	{ID: "SMG_Locust", Name: "Locust", Category: "SMG", PictureFile: "SMG_Locust.webp"},
	{ID: "SMG_Shuriken", Name: "Shuriken", Category: "SMG", PictureFile: "SMG_Shuriken.webp"},
	{ID: "SMG_Tempest", Name: "Tempest", Category: "SMG", PictureFile: "SMG_Tempest.webp"},

	// ---- Sniper Rifles -----------------------------------------------------
	{ID: "SniperRifle_Batarian", Name: "Kishock Harpoon Gun", Category: "Sniper Rifle", PictureFile: "SniperRifle_Batarian.webp"},
	{ID: "SniperRifle_BlackWidow", Name: "Black Widow", Category: "Sniper Rifle", PictureFile: "SniperRifle_BlackWidow.webp"},
	{ID: "SniperRifle_Collector", Name: "Collector Sniper Rifle", Category: "Sniper Rifle", PictureFile: "SniperRifle_Collector.webp"},
	{ID: "SniperRifle_Incisor", Name: "Incisor", Category: "Sniper Rifle", PictureFile: "SniperRifle_Incisor.webp"},
	{ID: "SniperRifle_Indra", Name: "Indra", Category: "Sniper Rifle", PictureFile: "SniperRifle_Indra.webp"},
	{ID: "SniperRifle_Javelin", Name: "Javelin", Category: "Sniper Rifle", PictureFile: "SniperRifle_Javelin.webp"},
	{ID: "SniperRifle_Mantis", Name: "Mantis", Category: "Sniper Rifle", PictureFile: "SniperRifle_Mantis.webp"},
	{ID: "SniperRifle_Raptor", Name: "Raptor", Category: "Sniper Rifle", PictureFile: "SniperRifle_Raptor.webp"},
	{ID: "SniperRifle_Turian", Name: "Kishock Harpoon Gun (Turian)", Category: "Sniper Rifle", PictureFile: "SniperRifle_Turian.webp"},
	{ID: "SniperRifle_Valiant", Name: "Valiant", Category: "Sniper Rifle", PictureFile: "SniperRifle_Valiant.webp"},
	{ID: "SniperRifle_Viper", Name: "Viper", Category: "Sniper Rifle", PictureFile: "SniperRifle_Viper.webp"},
	{ID: "SniperRifle_Widow", Name: "Widow", Category: "Sniper Rifle", PictureFile: "SniperRifle_Widow.webp"},
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

package model

// ConsumableCategory identifies the loadout slot type for a consumable.
type ConsumableCategory string

const (
	ConsumableCategoryArmor  ConsumableCategory = "Armor"
	ConsumableCategoryWeapon ConsumableCategory = "Weapon"
	ConsumableCategoryAmmo   ConsumableCategory = "Ammo"
	ConsumableCategoryGear   ConsumableCategory = "Gear"
	// ConsumableCategoryCore entries are in the catalog but not selectable
	// in the bot loadout UI — they represent the four mission consumables.
	ConsumableCategoryCore ConsumableCategory = "Core"
)

// ConsumableDef is a read-only definition of a consumable item.
// Like WeaponDef and WeaponModDef it is compiled into the binary and never
// stored in BoltDB.
type ConsumableDef struct {
	ID          string             // URL-safe CamelCase identifier
	Name        string             // human-readable display name
	Description string             // in-game description; empty for tiered consumables
	PictureFile string             // path relative to /static/assets/, e.g. "consumables/SpeedBonus.webp"
	Indexes     []int              // game inventory indexes; tiered items have one per tier
	Category    ConsumableCategory // slot type
	Path        string             // fully-qualified UE3 game effect class path, e.g. "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary"; empty for Core consumables
}

// PictureURL returns the full URL path to the consumable's image.
func (c ConsumableDef) PictureURL() string {
	return "/static/assets/" + c.PictureFile
}

// ConsumableCatalog is the full list of consumable items.
// Tiered consumables (Armor/Weapon/Ammo) list Indexes in order I→II→III(→IV).
// Gear entries have a single index; Core entries list [stock, capacity].
var ConsumableCatalog = []ConsumableDef{
	// ---- Armor consumables --------------------------------------------------
	{ID: "AdrenalineModule", Name: "Adrenaline Module", PictureFile: "consumables/SpeedBonus.webp", Indexes: []int{126, 127, 128}, Category: ConsumableCategoryArmor, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus"},
	{ID: "CyclonicModulator", Name: "Cyclonic Modulator", PictureFile: "consumables/ShieldBonus.webp", Indexes: []int{129, 130, 131, 490}, Category: ConsumableCategoryArmor, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus"},
	{ID: "PowerAmplifierModule", Name: "Power Amplifier Module", PictureFile: "consumables/PowerBonusDamage.webp", Indexes: []int{259, 260, 261, 489}, Category: ConsumableCategoryArmor, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage"},
	{ID: "PowerEfficiencyModule", Name: "Power Efficiency Module", PictureFile: "consumables/PowerBonus.webp", Indexes: []int{105, 106, 107}, Category: ConsumableCategoryArmor, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus"},
	{ID: "ShieldPowerCells", Name: "Shield Power Cells", PictureFile: "consumables/ShieldRegenBonus.webp", Indexes: []int{76, 77, 78}, Category: ConsumableCategoryArmor, Path: "SFXGameContentDLC_CON_MP1.SFXGameEffect_MatchConsumable_ShieldRegenBonus"},
	{ID: "StabilizationModule", Name: "Stabilization Module", PictureFile: "consumables/StabilityBonus.webp", Indexes: []int{73, 74, 75}, Category: ConsumableCategoryArmor, Path: "SFXGameContentDLC_CON_MP1.SFXGameEffect_MatchConsumable_StabilityBonus"},

	// ---- Weapon consumables -------------------------------------------------
	{ID: "AssaultRifleRailAmp", Name: "Assault Rifle Rail Amp", PictureFile: "consumables/WeaponDamageBonus_AssaultRifle.webp", Indexes: []int{111, 112, 113}, Category: ConsumableCategoryWeapon, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle"},
	{ID: "PistolRailAmp", Name: "Pistol Rail Amp", PictureFile: "consumables/WeaponDamageBonus_Pistol.webp", Indexes: []int{120, 121, 122}, Category: ConsumableCategoryWeapon, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol"},
	{ID: "SMGRailAmp", Name: "SMG Rail Amp", PictureFile: "consumables/WeaponDamageBonus_SMG.webp", Indexes: []int{123, 124, 125}, Category: ConsumableCategoryWeapon, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG"},
	{ID: "ShotgunRailAmp", Name: "Shotgun Rail Amp", PictureFile: "consumables/WeaponDamageBonus_Shotgun.webp", Indexes: []int{117, 118, 119}, Category: ConsumableCategoryWeapon, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun"},
	{ID: "SniperRifleRailAmp", Name: "Sniper Rifle Rail Amp", PictureFile: "consumables/WeaponDamageBonus_SniperRifle.webp", Indexes: []int{114, 115, 116}, Category: ConsumableCategoryWeapon, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle"},
	{ID: "StrengthEnhancer", Name: "Strength Enhancer", PictureFile: "consumables/MeleeDamage.webp", Indexes: []int{79, 80, 81}, Category: ConsumableCategoryWeapon, Path: "SFXGameContentDLC_CON_MP1.SFXGameEffect_MatchConsumable_MeleeDamage"},
	{ID: "TargetingVI", Name: "Targeting VI", PictureFile: "consumables/HeadshotDamage.webp", Indexes: []int{82, 83, 84}, Category: ConsumableCategoryWeapon, Path: "SFXGameContentDLC_CON_MP1.SFXGameEffect_MatchConsumable_HeadshotDamage"},

	// ---- Ammo consumables ---------------------------------------------------
	{ID: "ArmorPiercingRounds", Name: "Armor Piercing Rounds", PictureFile: "consumables/AmmoPower_ArmorPiercing.webp", Indexes: []int{96, 97, 98, 486}, Category: ConsumableCategoryAmmo, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing"},
	{ID: "CryoRounds", Name: "Cryo Rounds", PictureFile: "consumables/AmmoPower_Cryo.webp", Indexes: []int{102, 103, 104, 488}, Category: ConsumableCategoryAmmo, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo"},
	{ID: "DisruptorRounds", Name: "Disruptor Rounds", PictureFile: "consumables/AmmoPower_Disruptor.webp", Indexes: []int{93, 94, 95, 485}, Category: ConsumableCategoryAmmo, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor"},
	{ID: "DrillRounds", Name: "Drill Rounds", PictureFile: "consumables/AmmoPower_Eraser.webp", Indexes: []int{518, 523, 528}, Category: ConsumableCategoryAmmo, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_AmmoPower_Eraser"},
	{ID: "ExplosiveRounds", Name: "Explosive Rounds", PictureFile: "consumables/AmmoPower_Needler.webp", Indexes: []int{517, 522, 527}, Category: ConsumableCategoryAmmo, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_AmmoPower_Needler"},
	{ID: "IncendiaryRounds", Name: "Incendiary Rounds", PictureFile: "consumables/AmmoPower_Incendiary.webp", Indexes: []int{90, 91, 92, 484}, Category: ConsumableCategoryAmmo, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary"},
	{ID: "PhasicRounds", Name: "Phasic Rounds", PictureFile: "consumables/AmmoPower_Phasic.webp", Indexes: []int{519, 524, 529}, Category: ConsumableCategoryAmmo, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_AmmoPower_Phasic"},
	{ID: "WarpRounds", Name: "Warp Rounds", PictureFile: "consumables/AmmoPower_Warp.webp", Indexes: []int{99, 100, 101, 487}, Category: ConsumableCategoryAmmo, Path: "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp"},
	{ID: "PoloniumRounds", Name: "Polonium Rounds", PictureFile: "consumables/AmmoPower_Polonium.webp", Indexes: []int{515, 520, 525, 526}, Category: ConsumableCategoryAmmo, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_AmmoPower_Polonium"},

	// ---- Gear consumables ---------------------------------------------------
	{ID: "HydraulicJoints", Name: "Hydraulic Joints", Description: "Improve armor joints to maximize the force and damage delivered through melee blows.", PictureFile: "gear/Gear_MeleeDamage.webp", Indexes: []int{330}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_MeleeDamage"},
	{ID: "VulnerabilityVI", Name: "Vulnerability VI", Description: "Use targeting VIs to pinpoint enemy weak points. Aim will be autocorrected to maximize damage.", PictureFile: "gear/Gear_HeadshotDamage.webp", Indexes: []int{331}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_HeadshotDamage"},
	{ID: "MentalFocuser", Name: "Mental Focuser", Description: "Sharpen mental alertness and precision under stress to aid the performance of tech or biotic powers.", PictureFile: "gear/Gear_PowerBonus_Damage.webp", Indexes: []int{332}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_PowerBonus_Damage"},
	{ID: "StructuralErgonomics", Name: "Structural Ergonomics", Description: "Enhance the ability of armor to bear loads, speeding up cooldown so that powers can be used more often.", PictureFile: "gear/Gear_PowerBonus_Cooldown.webp", Indexes: []int{333}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_PowerBonus_Cooldown"},
	{ID: "ShieldBooster", Name: "Shield Booster", Description: "Amplify the power systems that generate shields to raise their effective strength.", PictureFile: "gear/Gear_ShieldStrength.webp", Indexes: []int{334}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_ShieldStrength"},
	{ID: "Multicapacitor", Name: "Multicapacitor", Description: "Add a backup power supply to the user's shields, decreasing the time before they can be brought back online.", PictureFile: "gear/Gear_ShieldRegen.webp", Indexes: []int{335}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_ShieldRegen"},
	{ID: "VibrationDamper", Name: "Vibration Damper", Description: "Decrease weapon kickback and improve firing stability by upgrading auto-targeting electronics.", PictureFile: "gear/Gear_WeaponStability.webp", Indexes: []int{336}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponStability"},
	{ID: "AssaultRifleAmp", Name: "Assault Rifle Amp", Description: "Add power to assault rifles to increase round velocity and damage.", PictureFile: "gear/Gear_WeaponDamage_AssaultRifle.webp", Indexes: []int{337}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponDamage_AssaultRifle"},
	{ID: "SniperRifleAmp", Name: "Sniper Rifle Amp", Description: "Add power to sniper rifles to increase round velocity and damage.", PictureFile: "gear/Gear_WeaponDamage_SniperRifle.webp", Indexes: []int{338}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponDamage_SniperRifle"},
	{ID: "ShotgunAmp", Name: "Shotgun Amp", Description: "Add power to shotguns to increase round velocity and damage.", PictureFile: "gear/Gear_WeaponDamage_Shotgun.webp", Indexes: []int{339}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponDamage_Shotgun"},
	{ID: "PistolAmp", Name: "Pistol Amp", Description: "Add power to pistols to increase round velocity and damage.", PictureFile: "gear/Gear_WeaponDamage_Pistol.webp", Indexes: []int{340}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponDamage_Pistol"},
	{ID: "SMGAmp", Name: "SMG Amp", Description: "Add power to submachine guns to increase round velocity and damage.", PictureFile: "gear/Gear_WeaponDamage_SMG.webp", Indexes: []int{341}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_WeaponDamage_SMG"},
	{ID: "GrenadeCapacity", Name: "Grenade Capacity", Description: "Add extra grenade storage compartments to the user's armor.", PictureFile: "gear/Gear_GrenadeCapacity.webp", Indexes: []int{343}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_GrenadeCapacity"},
	{ID: "WarfighterPackage", Name: "Warfighter Package", Description: "Deploy this modification package to increase assault rifle power and grenade storage.", PictureFile: "gear/Gear_Combo_AssaultDamageGrenadeCap.webp", Indexes: []int{344}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_AssaultDamageGrenadeCap"},
	{ID: "CommandoPackage", Name: "Commando Package", Description: "Optimize pistol and biotic amp power to increase damage.", PictureFile: "gear/Gear_Combo_PistolDamageBioticDamage.webp", Indexes: []int{345}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_PistolDamageBioticDamage"},
	{ID: "StrongholdPackage", Name: "Stronghold Package", Description: "Optimize shield strength and the speed of shield restoration.", PictureFile: "gear/Gear_Combo_ShieldStrengthShieldRegen.webp", Indexes: []int{346}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_ShieldStrengthShieldRegen"},
	{ID: "BerserkerPackage", Name: "Berserker Package", Description: "Optimize shotgun and armor hydraulic power to increase shotgun and melee damage.", PictureFile: "gear/Gear_Combo_ShotgunDamageMeleeDamage.webp", Indexes: []int{347}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_ShotgunDamageMeleeDamage"},
	{ID: "ExpertPackage", Name: "Expert Package", Description: "Optimize energy supplies with multicore VIs to increase submachine gun damage and to recharge powers faster.", PictureFile: "gear/Gear_Combo_SMGDamagePowerCooldown.webp", Indexes: []int{348}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_SMGDamagePowerCooldown"},
	{ID: "OperativePackage", Name: "Operative Package", Description: "Optimize sniper rifle and tech power damage.", PictureFile: "gear/Gear_Combo_SniperDamageTechDamage.webp", Indexes: []int{349}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP2.SFXGameEffect_MatchConsumable_Gear_Combo_SniperDamageTechDamage"},
	{ID: "CombativesUpgrade", Name: "Combatives Upgrade", Description: "Increase the lethality of the assault rifle and pistol.", PictureFile: "gear/Gear_Combo_AssaultRifleDamagePistolDamage.webp", Indexes: []int{416}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_AssaultRifleDamagePistolDamage"},
	{ID: "MartialBioticAmp", Name: "Martial Biotic Amp", Description: "Use an advanced biotic amp to increase the strength of biotic attacks, including melee damage.", PictureFile: "gear/Gear_Combo_MeleeDamageBioticDamage.webp", Indexes: []int{417}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_MeleeDamageBioticDamage"},
	{ID: "JuggernautShield", Name: "Juggernaut Shield", Description: "Use high-capacity kinetic barrier generators to provide bonuses to both shield strength and melee damage.", PictureFile: "gear/Gear_Combo_ShieldStrengthMeleeDamage.webp", Indexes: []int{418}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_ShieldStrengthMeleeDamage"},
	{ID: "ShockTrooperUpgrade", Name: "Shock Trooper Upgrade", Description: "Increase the lethality of the shotgun, and increase grenade storage.", PictureFile: "gear/Gear_Combo_ShotgunDamageGrenadeCap.webp", Indexes: []int{419}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_ShotgunDamageGrenadeCap"},
	{ID: "GuerrillaUpgrade", Name: "Guerrilla Upgrade", Description: "Increase the lethality of the sniper rifle and SMG.", PictureFile: "gear/Gear_Combo_SniperDamageSMGDamage.webp", Indexes: []int{420}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_SniperDamageSMGDamage"},
	{ID: "OmniCapacitors", Name: "Omni-Capacitors", Description: "Provide more power to tech abilities to decrease recharge time.", PictureFile: "gear/Gear_Combo_TechDamagePowerCooldown.webp", Indexes: []int{421}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_TechDamagePowerCooldown"},
	{ID: "BarrageUpgrade", Name: "Barrage Upgrade", Description: "Boost the effectiveness of all weapons by increasing stability and thermal clip capacities.", PictureFile: "gear/Gear_Combo_WeaponStabilityAmmoCapacity.webp", Indexes: []int{422}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP3.SFXGameEffect_MatchConsumable_Gear_Combo_WeaponStabilityAmmoCapacity"},
	{ID: "ThermalClipStorage", Name: "Thermal Clip Storage", Description: "Add compartments to the user's armor to increase the capacity for thermal clips without sacrificing armor integrity.", PictureFile: "gear/Gear_AmmoCapacity.webp", Indexes: []int{423}, Category: ConsumableCategoryGear, Path: "SFXGameMPContentDLC_Shared_MP.SFXGameEffect_MatchConsumable_Gear_AmmoCapacity"},
	{ID: "AdaptiveWarAmp", Name: "Adaptive War Amp", Description: "Use an advanced biotic amp to increase the strength of damaging biotic powers.", PictureFile: "gear/Gear_BioticDamage.webp", Indexes: []int{424}, Category: ConsumableCategoryGear, Path: "SFXGameMPContentDLC_Shared_MP.SFXGameEffect_MatchConsumable_Gear_BioticDamage"},
	{ID: "EngineeringKit", Name: "Engineering Kit", Description: "Install a variety of omni-tool upgrades to enhance the potency of tech attacks.", PictureFile: "gear/Gear_TechDamage.webp", Indexes: []int{425}, Category: ConsumableCategoryGear, Path: "SFXGameMPContentDLC_Shared_MP.SFXGameEffect_MatchConsumable_Gear_TechDamage"},
	{ID: "MediGelTransmitter", Name: "Medi-Gel Transmitter", Description: "Short-range transmitters control medi-gel dispensers in teammates' armor, reviving self and nearby teammates simultaneously.", PictureFile: "gear/Gear_MassMedigel.webp", Indexes: []int{436}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_Gear_MassMedigel"},
	{ID: "ArmoredCompartments", Name: "Armored Compartments", Description: "Stores additional thermal clips and missiles in armored compartments to shield them from incoming fire.", PictureFile: "gear/Gear_CobraCapacity.webp", Indexes: []int{437}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_Gear_CobraCapacity"},
	{ID: "ResponderLoadout", Name: "Responder Loadout", Description: "Optimizes shields for fast recovery and utilizes medi-gel dispensers more efficiently, increasing capacity.", PictureFile: "gear/Gear_MedigelCapacity.webp", Indexes: []int{538}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_Gear_MedigelCapacity"},
	{ID: "SurvivorLoadout", Name: "Survivor Loadout", Description: "Increases standard kinetic barriers as well as additional shield layers if available.", PictureFile: "gear/Gear_SurvivalCapacity.webp", Indexes: []int{539}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_Gear_SurvivalCapacity"},
	{ID: "AssaultLoadout", Name: "Assault Loadout", Description: "Armor capacitors boost the kinetic coil in handheld weapons for greater firing power, and larger compartments allow for more thermal clips.", PictureFile: "gear/Gear_ThermalCapacity.webp", Indexes: []int{540}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP4.SFXGameEffect_MatchConsumable_Gear_ThermalCapacity"},
	{ID: "GethScanner", Name: "Geth Scanner", Description: "Highlight enemy activity nearby with geth scanner technology. This does not stack with other target-scanning effects.", PictureFile: "gear/Gear_VisionHelmet.webp", Indexes: []int{603}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP5.SFXGameEffect_MatchConsumable_Gear_VisionHelmet"},
	{ID: "BatarianGauntlet", Name: "Batarian Gauntlet", Description: "Batarian gauntlet that turns your heavy melee into a slow, heavy-hitting attack.", PictureFile: "gear/Gear_BatarianGauntlet.webp", Indexes: []int{604}, Category: ConsumableCategoryGear, Path: "SFXGameContentDLC_CON_MP5.SFXGameEffect_MatchConsumable_Gear_BatarianGauntlet"},

	// ---- Core consumables (catalog reference only; not selectable in loadout UI) ----
	{ID: "ThermalClipPack", Name: "Thermal Clip Pack", Description: "Refills your thermal clips and grenade supply during a mission.", PictureFile: "consumables/Consumable_Ammo.webp", Indexes: []int{86, 242}, Category: ConsumableCategoryCore},
	{ID: "MediGel", Name: "Medi-Gel", Description: "Revive yourself when incapacitated in combat.", PictureFile: "consumables/Consumable_Revive.webp", Indexes: []int{87, 243}, Category: ConsumableCategoryCore},
	{ID: "CobraMissileLauncher", Name: "Cobra Missile Launcher", Description: "A one-shot missile launcher useful for taking out hardened targets.", PictureFile: "consumables/Consumable_Rocket.webp", Indexes: []int{88, 244}, Category: ConsumableCategoryCore},
	{ID: "OpsSurvivalPack", Name: "Ops Survival Pack", Description: "Emergency pack fully restores health and shields during a mission.", PictureFile: "consumables/Consumable_Shield.webp", Indexes: []int{89, 245}, Category: ConsumableCategoryCore},
}

// consumableIndex is built once at startup for O(1) lookups.
var consumableIndex = func() map[string]*ConsumableDef {
	m := make(map[string]*ConsumableDef, len(ConsumableCatalog))
	for i := range ConsumableCatalog {
		m[ConsumableCatalog[i].ID] = &ConsumableCatalog[i]
	}
	return m
}()

// ConsumableByID returns the ConsumableDef for the given ID, or nil if not found.
func ConsumableByID(id string) *ConsumableDef {
	return consumableIndex[id]
}

// ConsumablesByCategory returns all catalog entries for the given category.
func ConsumablesByCategory(category ConsumableCategory) []ConsumableDef {
	var out []ConsumableDef
	for _, c := range ConsumableCatalog {
		if c.Category == category {
			out = append(out, c)
		}
	}
	return out
}

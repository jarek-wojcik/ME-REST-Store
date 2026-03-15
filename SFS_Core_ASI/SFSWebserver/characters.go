package main

// ---------------------------------------------------------------------------
// Supporting types
// ---------------------------------------------------------------------------

// Weapon is a selectable weapon assigned to a Bot.
type Weapon struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	PictureURL string `json:"pictureUrl"`
}

// PowerSlot is one of up to 5 power slots on a Bot.
// Rank is 0–6 (how many ranks are unlocked).
// Evolution holds the A/B choice for upgrade ranks 4, 5, and 6.
type PowerSlot struct {
	PowerID   string    `json:"powerId"`
	Rank      int       `json:"rank"`      // 0–6
	Evolution [3]string `json:"evolution"` // index 0=rank4, 1=rank5, 2=rank6; each "A" or "B"
}

// Bot is a character instance assigned to a team.
// CharacterID references a CharacterDef in the catalog.
// WeaponID references a WeaponDef in the catalog.
// WeaponMod1ID / WeaponMod2ID reference WeaponModDef entries in the catalog.
// Powers holds 0–5 slots; slots are initialised from the CharacterDef
// defaults when a bot is first created.
type Bot struct {
	ID           string      `json:"id"`
	TeamID       string      `json:"teamId"`
	CharacterID  string      `json:"characterId"`
	WeaponID     string      `json:"weaponId"`
	WeaponMod1ID string      `json:"weaponMod1Id"`
	WeaponMod2ID string      `json:"weaponMod2Id"`
	Powers       []PowerSlot `json:"powers"` // up to 5
}

// ---------------------------------------------------------------------------
// Character definition (static catalog)
// ---------------------------------------------------------------------------

// CharacterDef is a read-only definition of a playable MP character class.
// It is not stored in BoltDB; it is compiled into the binary.
// PowerIDs[0-2] are the three active powers; PowerIDs[3] = MPPassive,
// PowerIDs[4] = MPMeleePassive.  An empty string means the slot is unused.
type CharacterDef struct {
	ID          string    // matches the asset filename stem, e.g. "MP_Turian0"
	Name        string    // human-readable display name
	SubClass    string    // one of: Soldier, Adept, Sentinel, Engineer, Vanguard, Infiltrator
	PictureFile string    // filename inside /static/assets/characters/
	PowerIDs    [5]string // default power IDs for this character class
}

// PictureURL returns the URL path for the character's portrait image.
func (c CharacterDef) PictureURL() string {
	return "/static/assets/characters/" + c.PictureFile
}

// ---------------------------------------------------------------------------
// Static character catalog
// ---------------------------------------------------------------------------

// CharacterCatalog is the full list of available MP character classes.
// Entries are ordered: base Human classes first, then Alliance N7, then
// alien/faction classes alphabetically by species.
var CharacterCatalog = []CharacterDef{
	// ---- Human base classes ------------------------------------------------
	{ID: "AdeptHumanFemale", Name: "Human Adept (Female)", SubClass: "Adept", PictureFile: "AdeptHumanFemale.webp",
		PowerIDs: [5]string{"Singularity", "Warp", "Shockwave", "MPPassive", "MPMeleePassive"}},
	{ID: "AdeptHumanMale", Name: "Human Adept (Male)", SubClass: "Adept", PictureFile: "AdeptHumanMale.webp",
		PowerIDs: [5]string{"Singularity", "Warp", "Shockwave", "MPPassive", "MPMeleePassive"}},
	{ID: "EngineerHumanFemale", Name: "Human Engineer (Female)", SubClass: "Engineer", PictureFile: "EngineerHumanFemale.webp",
		PowerIDs: [5]string{"CombatDrone", "Incinerate", "Overload", "MPPassive", "MPMeleePassive"}},
	{ID: "EngineerHumanMale", Name: "Human Engineer (Male)", SubClass: "Engineer", PictureFile: "EngineerHumanMale.webp",
		PowerIDs: [5]string{"CombatDrone", "Incinerate", "Overload", "MPPassive", "MPMeleePassive"}},
	{ID: "InfiltratorHumanFemale", Name: "Human Infiltrator (Female)", SubClass: "Infiltrator", PictureFile: "InfiltratorHumanFemale.webp",
		PowerIDs: [5]string{"Cloak", "CryoBlast", "StickyGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "InfiltratorHumanMale", Name: "Human Infiltrator (Male)", SubClass: "Infiltrator", PictureFile: "InfiltratorHumanMale.webp",
		PowerIDs: [5]string{"Cloak", "CryoBlast", "StickyGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "SentinelHumanFemale", Name: "Human Sentinel (Female)", SubClass: "Sentinel", PictureFile: "SentinelHumanFemale.webp",
		PowerIDs: [5]string{"TechArmor", "Warp", "Throw", "MPPassive", "MPMeleePassive"}},
	{ID: "SentinelHumanMale", Name: "Human Sentinel (Male)", SubClass: "Sentinel", PictureFile: "SentinelHumanMale.webp",
		PowerIDs: [5]string{"TechArmor", "Warp", "Throw", "MPPassive", "MPMeleePassive"}},
	{ID: "SoldierHumanFemale", Name: "Human Soldier (Female)", SubClass: "Soldier", PictureFile: "SoldierHumanFemale.webp",
		PowerIDs: [5]string{"AdrenalineRush", "ConcussiveShot", "FragGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "SoldierHumanMale", Name: "Human Soldier (Male)", SubClass: "Soldier", PictureFile: "SoldierHumanMale.webp",
		PowerIDs: [5]string{"AdrenalineRush", "ConcussiveShot", "FragGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "VanguardHumanFemale", Name: "Human Vanguard (Female)", SubClass: "Vanguard", PictureFile: "VanguardHumanFemale.webp",
		PowerIDs: [5]string{"BioticCharge", "Shockwave", "Discharge", "MPPassive", "MPMeleePassive"}},
	{ID: "VanguardHumanMale", Name: "Human Vanguard (Male)", SubClass: "Vanguard", PictureFile: "VanguardHumanMale.webp",
		PowerIDs: [5]string{"BioticCharge", "Shockwave", "Discharge", "MPPassive", "MPMeleePassive"}},

	// ---- Alliance N7 classes -----------------------------------------------
	{ID: "MP_AllianceADP", Name: "N7 Fury", SubClass: "Adept", PictureFile: "MP_AllianceADP.webp",
		PowerIDs: [5]string{"AnnihilationSphere", "DarkChannel", "Throw", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AllianceENG", Name: "N7 Demolisher", SubClass: "Engineer", PictureFile: "MP_AllianceENG.webp",
		PowerIDs: [5]string{"SupplyTurret", "EMPGrenade", "HomingGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AllianceINF", Name: "N7 Shadow", SubClass: "Infiltrator", PictureFile: "MP_AllianceINF.webp",
		PowerIDs: [5]string{"Cloak", "ElectricSlash", "ShadowStrike", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AllianceSEN", Name: "N7 Paladin", SubClass: "Sentinel", PictureFile: "MP_AllianceSEN.webp",
		PowerIDs: [5]string{"EnergyDrain", "Incinerate", "CryoCone", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AllianceSOL", Name: "N7 Destroyer", SubClass: "Soldier", PictureFile: "MP_AllianceSOL.webp",
		PowerIDs: [5]string{"DevestatorMode", "MissileLauncher", "MultiFragGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AllianceVAN", Name: "N7 Slayer", SubClass: "Vanguard", PictureFile: "MP_AllianceVAN.webp",
		PowerIDs: [5]string{"BioticCharge", "PalmBlaster", "SonicSlash", "MPPassive", "MPMeleePassive"}},

	// ---- Asari -------------------------------------------------------------
	{ID: "MP_Asari0", Name: "Asari Adept", SubClass: "Adept", PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"Stasis", "Warp", "Throw", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AsariComm", Name: "Asari Justicar", SubClass: "Adept", PictureFile: "MP_AsariComm.webp",
		PowerIDs: [5]string{"BubbleShield", "Reave", "Pull", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AsariINF", Name: "Asari Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_AsariINF.webp",
		PowerIDs: [5]string{"Cloak", "DarkChannel", "Warp", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_AsariSEN", Name: "Asari Valkyrie", SubClass: "Sentinel", PictureFile: "MP_AsariSEN.webp",
		PowerIDs: [5]string{"TechArmor", "Warp", "AnnihilationSphere", "MPPassive", "MPMeleePassive"}},
	{ID: "VanguardAsari", Name: "Asari Vanguard", SubClass: "Vanguard", PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"BioticCharge", "Stasis", "LiftGrenade", "MPPassive", "MPMeleePassive"}},

	// ---- Batarian ----------------------------------------------------------
	{ID: "MP_Batarian", Name: "Batarian Soldier", SubClass: "Soldier", PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"BatarianAttack", "BatarianArmor", "InfernoGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_BatarianADP", Name: "Batarian Adept", SubClass: "Adept", PictureFile: "MP_BatarianADP.webp",
		PowerIDs: [5]string{"Lash", "Warp", "BioticGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "SentinelBatarian", Name: "Batarian Sentinel", SubClass: "Sentinel", PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"BatarianArmor", "Shockwave_Batarian", "BatarianNet", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_BatarianVAN", Name: "Batarian Vanguard", SubClass: "Vanguard", PictureFile: "MP_BatarianVAN.webp",
		PowerIDs: [5]string{"BioticCharge", "Lash", "BatarianArmor", "MPPassive", "MPMeleePassive"}},

	// ---- Battlefield crossover ---------------------------------------------
	// {ID: "MP_BF3_INF", Name: "N7 Infiltrator (BF3)", SubClass: "Infiltrator", PictureFile: "MP_BF3_INF.webp",
	// 	PowerIDs: [5]string{"Cloak", "CryoBlast", "StickyGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_BF_HMM0", Name: "N7 Soldier (BF3)", SubClass: "Soldier", PictureFile: "MP_BF_HMM0.webp",
		PowerIDs: [5]string{"AdrenalineRush", "Carnage", "FragGrenade", "MPPassive", "MPMeleePassive"}},

	// ---- Blood Pack --------------------------------------------------------
	{ID: "MP_BloodSEN", Name: "Krogan Warlord", SubClass: "Sentinel", PictureFile: "MP_BloodSEN.webp",
		PowerIDs: [5]string{"TechArmor_Warlord", "BioticHammerModal", "TechHammerModal", "MPPassive", "MPMeleePassive"}},

	// ---- Cerberus ----------------------------------------------------------
	{ID: "MP_Cerberus", Name: "Cerberus Adept", SubClass: "Adept", PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"Singularity", "WhipSmash", "Lash", "MPPassive", "MPMeleePassive"}},
	{ID: "VanguardHumanMaleCerberus", Name: "Cerberus Vanguard", SubClass: "Vanguard", PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"BioticCharge", "WhipSmash", "Lash", "MPPassive", "MPMeleePassive"}},

	// ---- Collectors --------------------------------------------------------
	{ID: "MP_CollectADP", Name: "Collector Adept", SubClass: "Adept", PictureFile: "MP_CollectADP.webp",
		PowerIDs: [5]string{"DarkSingularity", "SeekerSwarm", "DarkChannel", "MPPassive", "MPMeleePassive"}},

	// ---- Drell -------------------------------------------------------------
	{ID: "MP_Drell0", Name: "Drell Adept", SubClass: "Adept", PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"Reave", "Pull", "BioticGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_DrellINF", Name: "Drell Assassin", SubClass: "Infiltrator", PictureFile: "MP_DrellINF.webp",
		PowerIDs: [5]string{"Cloak", "HomingGrenade", "ReconMine", "MPPassive", "MPMeleePassive"}},
	{ID: "VanguardDrell", Name: "Drell Vanguard", SubClass: "Vanguard", PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"BioticCharge", "Pull", "BioticGrenade", "MPPassive", "MPMeleePassive"}},

	// ---- Female Bot --------------------------------------------------------
	{ID: "MP_FBotINF", Name: "Infiltrator Bot", SubClass: "Infiltrator", PictureFile: "MP_FBotINF.webp",
		PowerIDs: [5]string{"Cloak", "CryoBlast", "RepairMatrix", "MPPassive", "MPMeleePassive"}},

	// ---- Geth --------------------------------------------------------------
	{ID: "MP_GethEngineer", Name: "Geth Engineer", SubClass: "Engineer", PictureFile: "MP_GethEngineer.webp",
		PowerIDs: [5]string{"GethTurret", "Supercharge", "Overload", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_GethInfiltrator", Name: "Geth Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_GethInfiltrator.webp",
		PowerIDs: [5]string{"Cloak", "ProximityMine", "Supercharge", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_GethPSLD", Name: "Geth Juggernaut", SubClass: "Soldier", PictureFile: "MP_GethPSLD.webp",
		PowerIDs: [5]string{"HexShield", "SiegePulse", "GethTurret", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_GethSLD", Name: "Geth Soldier", SubClass: "Soldier", PictureFile: "MP_GethSLD.webp",
		PowerIDs: [5]string{"Flamer", "Fortification", "Supercharge", "MPPassive", "MPMeleePassive"}},

	// ---- Krogan ------------------------------------------------------------
	{ID: "MP_Krogan0", Name: "Krogan Soldier", SubClass: "Soldier", PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"Fortification", "Carnage", "InfernoGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_KroganADP", Name: "Krogan Adept", SubClass: "Adept", PictureFile: "MP_KroganADP.webp",
		PowerIDs: [5]string{"Barrier", "Warp", "Shockwave", "MPPassive", "MPMeleePassive"}},
	{ID: "SentinelKrogan", Name: "Krogan Sentinel", SubClass: "Sentinel", PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"TechArmor_Krogan", "Incinerate", "LiftGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_KroganBM", Name: "Krogan Battlemaster", SubClass: "Vanguard", PictureFile: "MP_KroganBM.webp",
		PowerIDs: [5]string{"KroganBioticCharge", "Carnage", "Barrier", "MPPassive", "MPMeleePassive"}},

	// ---- Mercenary ---------------------------------------------------------
	{ID: "MP_MercENG", Name: "Blue Suns Engineer", SubClass: "Engineer", PictureFile: "MP_MercENG.webp",
		PowerIDs: [5]string{"CainMine", "BowModalOne", "BowModalTwo", "MPPassive", "MPMeleePassive"}},

	// ---- Quarian -----------------------------------------------------------
	{ID: "MP_Quarian0", Name: "Quarian Engineer", SubClass: "Engineer", PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"SentryTurret", "Incinerate", "CryoBlast", "MPPassive", "MPMeleePassive"}},
	{ID: "InfiltratorQuarian", Name: "Quarian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"Cloak", "StickyGrenade", "AIHacking", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_QuarianMale0", Name: "Quarian Male Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"Cloak", "Damping", "EMPGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "EngineerQuarianMale", Name: "Quarian Male Engineer", SubClass: "Engineer", PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"Damping", "Incinerate", "EMPGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_QuarianMSLD", Name: "Quarian Male Soldier", SubClass: "Soldier", PictureFile: "MP_QuarianMSLD.webp",
		PowerIDs: [5]string{"Marksman", "Damping", "Hacking", "MPPassive", "MPMeleePassive"}},

	// ---- Salarian ----------------------------------------------------------
	{ID: "EngineerSalarian", Name: "Salarian Engineer", SubClass: "Engineer", PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"EnergyDrain", "Decoy", "Incinerate", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_Salarian0", Name: "Salarian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"Cloak", "ProximityMine", "EnergyDrain", "MPPassive", "MPMeleePassive"}},

	// ---- Turian ------------------------------------------------------------
	{ID: "MP_Turian0", Name: "Turian Soldier", SubClass: "Soldier", PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"Marksman", "ConcussiveShot", "ProximityMine", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_TurianENG", Name: "Turian Engineer", SubClass: "Engineer", PictureFile: "MP_TurianENG.webp",
		PowerIDs: [5]string{"SentryTurret", "Hacking", "HomingGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_TurianINF", Name: "Turian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_TurianINF.webp",
		PowerIDs: [5]string{"Cloak", "StimPack", "Overload", "MPPassive", "MPMeleePassive"}},
	{ID: "SentinelTurian", Name: "Turian Sentinel", SubClass: "Sentinel", PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"TechArmor_Turian", "Warp", "Overload", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_TurianSLD", Name: "Turian Havoc", SubClass: "Soldier", PictureFile: "MP_TurianSLD.webp",
		PowerIDs: [5]string{"JetPackCharge", "StimPack", "CryoBlast", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_TurianVAN", Name: "Cabal Vanguard", SubClass: "Vanguard", PictureFile: "MP_TurianVAN.webp",
		PowerIDs: [5]string{"HavocStrike", "StimPack", "CryoBlast", "MPPassive", "MPMeleePassive"}},

	// ---- Volus -------------------------------------------------------------
	{ID: "MP_VolusADP", Name: "Volus Adept", SubClass: "Adept", PictureFile: "MP_VolusADP.webp",
		PowerIDs: [5]string{"Stasis", "BioticOrbs", "ShieldBoost", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_VolusENG", Name: "Volus Engineer", SubClass: "Engineer", PictureFile: "MP_VolusENG.webp",
		PowerIDs: [5]string{"ReconMine", "ProximityMine", "ShieldBoost", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_VolusENG2", Name: "Volus Engineer II", SubClass: "Sentinel", PictureFile: "MP_VolusENG2.webp",
		PowerIDs: [5]string{"Decoy_Volus", "CombatDrone", "ShieldBoost", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_VolusVAN", Name: "Volus Protector", SubClass: "Vanguard", PictureFile: "MP_VolusVAN.webp",
		PowerIDs: [5]string{"BioticCharge", "ShieldBoost", "BioticOrbs", "MPPassive", "MPMeleePassive"}},

	// ---- Vorcha ------------------------------------------------------------
	{ID: "MP_Vorcha", Name: "Vorcha Soldier", SubClass: "Soldier", PictureFile: "MP_Vorcha.webp",
		PowerIDs: [5]string{"Bloodlust", "Flamer", "Carnage", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_VorchaENG", Name: "Vorcha Engineer", SubClass: "Engineer", PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"BatarianNet", "Incinerate", "Bloodlust", "MPPassive", "MPMeleePassive"}},
	{ID: "MP_VorchaSentinel", Name: "Vorcha Sentinel", SubClass: "Sentinel", PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"Bloodlust", "Flamer", "BioticGrenade", "MPPassive", "MPMeleePassive"}},
}

// ---------------------------------------------------------------------------
// Grouping helpers
// ---------------------------------------------------------------------------

// CharacterGroup holds characters belonging to a single subclass.
type CharacterGroup struct {
	SubClass   string
	Characters []CharacterDef
}

// subClassOrder defines the canonical display order for the character selector.
var subClassOrder = []string{"Soldier", "Adept", "Sentinel", "Engineer", "Vanguard", "Infiltrator"}

// GroupedCharacters returns CharacterCatalog partitioned by SubClass,
// in the canonical subClassOrder order.
func GroupedCharacters() []CharacterGroup {
	buckets := make(map[string][]CharacterDef, len(subClassOrder))
	for _, c := range CharacterCatalog {
		buckets[c.SubClass] = append(buckets[c.SubClass], c)
	}
	groups := make([]CharacterGroup, 0, len(subClassOrder))
	for _, sc := range subClassOrder {
		if chars, ok := buckets[sc]; ok {
			groups = append(groups, CharacterGroup{SubClass: sc, Characters: chars})
		}
	}
	return groups
}

// characterIndex is a map built once at startup for O(1) lookups.
var characterIndex = func() map[string]*CharacterDef {
	m := make(map[string]*CharacterDef, len(CharacterCatalog))
	for i := range CharacterCatalog {
		m[CharacterCatalog[i].ID] = &CharacterCatalog[i]
	}
	return m
}()

// CharacterByID returns the CharacterDef for the given ID, or nil if not found.
func CharacterByID(id string) *CharacterDef {
	return characterIndex[id]
}

package model

import "sort"

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
// KitID is the fully-qualified UE3 archetype path for the character kit that
// owns this power (e.g. "BioChar_DLC_MP5_MPPlayers.Archetypes.Fembot.Fembot_Infiltrator").
// Stored so the ME3 client can prime the correct seek-free package before
// loading the power class.
type PowerSlot struct {
	PowerID   string    `json:"powerId"`
	Rank      int       `json:"rank"`      // 0–6
	Evolution [3]string `json:"evolution"` // index 0=rank4, 1=rank5, 2=rank6; each "A" or "B"
	KitID     string    `json:"kitId,omitempty"`
}

// Species identifies the biological or synthetic species of a character.
type Species string

const (
	SpeciesAndroid   Species = "Android"
	SpeciesAsari     Species = "Asari"
	SpeciesBatarian  Species = "Batarian"
	SpeciesCollector Species = "Collector"
	SpeciesDrell     Species = "Drell"
	SpeciesGeth      Species = "Geth"
	SpeciesHuman     Species = "Human"
	SpeciesKrogan    Species = "Krogan"
	SpeciesProthean  Species = "Prothean"
	SpeciesQuarian   Species = "Quarian"
	SpeciesSalarian  Species = "Salarian"
	SpeciesTurian    Species = "Turian"
	SpeciesVolus     Species = "Volus"
	SpeciesVorcha    Species = "Vorcha"
)

// ---------------------------------------------------------------------------
// Character definition (static catalog)
// ---------------------------------------------------------------------------

// CharacterDef is a read-only definition of a playable MP character class.
// It is not stored in BoltDB; it is compiled into the binary.
// PowerIDs[0-2] are the three active powers; PowerIDs[3] = MPPassive,
// PowerIDs[4] = MPMeleePassive.  An empty string means the slot is unused.
type CharacterDef struct {
	ID                  string    // matches the asset filename stem, e.g. "MP_Turian0"
	IDLook              string    // optional appearance look identifier; empty string means no override
	Name                string    // human-readable display name
	SubClass            string    // one of: Soldier, Adept, Sentinel, Engineer, Vanguard, Infiltrator
	Species             []Species // biological or synthetic species
	PictureFile         string    // filename inside /static/assets/characters/
	PowerIDs            [5]string // default power IDs for this character class
	RootPath            string    // UE3 archetype package path prefix (e.g. "BioChar_MPPlayers.Archetypes.Adept"); empty when ID already encodes the full path
	ArchetypeID         string    // last segment of the UE3 archetype path (e.g. "HumanFemale_Adept"); empty when it matches ID
	PawnType            PawnType  // how the character is spawned; defaults to PlayerMP when unset
	HasHeadgear         bool
	HasHelmet           bool
	HasUniqueLightMelee bool
	HasUniqueHeavyMelee bool
	HasUniqueDodge      bool
}

// GetPawnType returns the PawnType for this character, defaulting to PawnTypePlayerMP.
func (c CharacterDef) GetPawnType() PawnType {
	if c.PawnType == "" {
		return PawnTypePlayerMP
	}
	return c.PawnType
}

// PictureURL returns the URL path for the character's portrait image.
func (c CharacterDef) PictureURL() string {
	return "/static/assets/characters/" + c.PictureFile
}

// KitQualifiedPath returns the fully-qualified UE3 archetype path for this
// character's kit: "RootPath.ArchetypeID" (falling back to ID when ArchetypeID
// is empty). When RootPath is also empty the bare ID is returned — these are
// characters like Jack/Liara whose ID is already fully-qualified.
func (c CharacterDef) KitQualifiedPath() string {
	if c.RootPath == "" {
		return c.ID
	}
	archetypeID := c.ArchetypeID
	if archetypeID == "" {
		archetypeID = c.ID
	}
	return c.RootPath + "." + archetypeID
}

// ---------------------------------------------------------------------------
// Static character catalog
// ---------------------------------------------------------------------------

// CharacterCatalog is the full list of available MP character classes.
// Entries are ordered: base Human classes first, then Alliance N7, then
// alien/faction classes alphabetically by species.
var CharacterCatalog = []CharacterDef{
	// ---- Human base classes ------------------------------------------------
	{ID: "AdeptHumanFemale", IDLook: "HumanFemaleRecon", Name: "Human Adept (Female)", SubClass: "Adept", Species: []Species{SpeciesHuman}, PictureFile: "AdeptHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Adept"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},
	{ID: "AdeptHumanMale", IDLook: "HumanMaleRecon", Name: "Human Adept (Male)", SubClass: "Adept", Species: []Species{SpeciesHuman}, PictureFile: "AdeptHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Adept"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept"},
	{ID: "EngineerHumanFemale", IDLook: "HumanFemaleDefault", Name: "Human Engineer (Female)", SubClass: "Engineer", Species: []Species{SpeciesHuman}, PictureFile: "EngineerHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Engineer"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer", HasUniqueHeavyMelee: true},
	{ID: "EngineerHumanMale", IDLook: "HumanMaleDefault", Name: "Human Engineer (Male)", SubClass: "Engineer", Species: []Species{SpeciesHuman}, PictureFile: "EngineerHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Engineer"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorHumanFemale", IDLook: "HumanFemaleDefault", Name: "Human Infiltrator (Female)", SubClass: "Infiltrator", Species: []Species{SpeciesHuman}, PictureFile: "InfiltratorHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator", HasUniqueHeavyMelee: true},
	{ID: "InfiltratorHumanMale", IDLook: "HumanMaleDefault", Name: "Human Infiltrator (Male)", SubClass: "Infiltrator", Species: []Species{SpeciesHuman}, PictureFile: "InfiltratorHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},
	{ID: "SentinelHumanFemale", IDLook: "HumanFemaleRecon", Name: "Human Sentinel (Female)", SubClass: "Sentinel", Species: []Species{SpeciesHuman}, PictureFile: "SentinelHumanFemale.png",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel", HasUniqueHeavyMelee: true},
	{ID: "SentinelHumanMale", IDLook: "HumanMaleRecon", Name: "Human Sentinel (Male)", SubClass: "Sentinel", Species: []Species{SpeciesHuman}, PictureFile: "SentinelHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "SoldierHumanFemale", IDLook: "HumanFemaleDeathmask", Name: "Human Soldier (Female)", SubClass: "Soldier", Species: []Species{SpeciesHuman}, PictureFile: "SoldierHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier", HasUniqueHeavyMelee: true},
	{ID: "SoldierHumanMale", IDLook: "HumanMaleDeathmask", Name: "Human Soldier (Male)", SubClass: "Soldier", Species: []Species{SpeciesHuman}, PictureFile: "SoldierHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "VanguardHumanFemale", IDLook: "HumanFemaleDeathmask", Name: "Human Vanguard (Female)", SubClass: "Vanguard", Species: []Species{SpeciesHuman, SpeciesAsari}, PictureFile: "VanguardHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Discharge", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard", HasUniqueHeavyMelee: true},
	{ID: "VanguardHumanMale", IDLook: "HumanMaleDeathmask", Name: "Human Vanguard (Male)", SubClass: "Vanguard", Species: []Species{SpeciesHuman, SpeciesBatarian}, PictureFile: "VanguardHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Discharge", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Alliance N7 classes -----------------------------------------------
	{ID: "AdeptN7", IDLook: "", Name: "N7 Fury", SubClass: "Adept", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AnnihilationSphere", "SFXPowerCustomActionMP_DarkChannel2", "SFXPowerCustomActionMP_Throw_N7", "SFXPowerCustomActionMP_N7AdeptPassive", "SFXPowerCustomActionMP_N7AdeptMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Adept_N7", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},
	{ID: "EngineerN7", IDLook: "", Name: "N7 Demolisher", SubClass: "Engineer", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SupplyTurret", "SFXPowerCustomActionMP_EMPGrenade2", "SFXPowerCustomActionMP_HomingGrenade", "SFXPowerCustomActionMP_N7EngineerPassive", "SFXPowerCustomActionMP_N7EngineerMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Engineer_N7", HasUniqueHeavyMelee: true},
	{ID: "InfiltratorN7", IDLook: "", Name: "N7 Shadow", SubClass: "Infiltrator", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak_N7Infiltrator", "SFXPowerCustomActionMP_ElectricSlash", "SFXPowerCustomActionMP_ShadowStrike", "SFXPowerCustomActionMP_N7InfiltratorPassive", "SFXPowerCustomActionMP_N7InfiltratorMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Infiltrator_N7", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},
	{ID: "SentinelN7", IDLook: "", Name: "N7 Paladin", SubClass: "Sentinel", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_CryoCone", "SFXPowerCustomActionMP_N7SentinelPassive", "SFXPowerCustomActionMP_N7SentinelMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Sentinel_N7", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},
	{ID: "SoldierN7", IDLook: "", Name: "N7 Destroyer", SubClass: "Soldier", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceSOL.webp",
		PowerIDs: [5]string{"SFXPowerCustomAction_DevestatorMode", "SFXPowerCustomAction_MissileLauncher", "SFXPowerCustomAction_MultiFragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Soldier_N7", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},
	{ID: "VanguardN7", IDLook: "", Name: "N7 Slayer", SubClass: "Vanguard", Species: []Species{SpeciesHuman}, PictureFile: "MP_AllianceVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_PalmBlaster", "SFXPowerCustomActionMP_SonicSlash", "SFXPowerCustomActionMP_N7VanguardPassive", "SFXPowerCustomActionMP_N7VanguardMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Vanguard_N7", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},

	// ---- Asari -------------------------------------------------------------
	{ID: "AdeptAsari", IDLook: "AsariDefault", Name: "Asari Adept", SubClass: "Adept", Species: []Species{SpeciesAsari}, PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_AsariPassive", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept", HasUniqueHeavyMelee: true, HasUniqueDodge: true},
	{ID: "AdeptAsariCommando", IDLook: "AsariCommando", Name: "Asari Justicar", SubClass: "Adept", Species: []Species{SpeciesAsari}, PictureFile: "MP_AsariComm.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BubbleShield", "SFXPowerCustomActionMP_Reave_Asari", "SFXPowerCustomActionMP_Pull_Asari", "SFXPowerCustomActionMP_AsariCommandoPassive", "SFXPowerCustomActionMP_AsariMeleePassive_Commando"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "AsariCommando_Adept"},
	{ID: "InfiltratorAsari", IDLook: "AsariDefault", Name: "Asari Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesAsari}, PictureFile: "MP_AsariINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AsariCloak", "SFXPowerCustomActionMP_DarkChannel2", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_AsariPassive_Infiltrator", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_Asari"},
	{ID: "SentinelAsari", IDLook: "AsariDefault", Name: "Asari Valkyrie", SubClass: "Sentinel", Species: []Species{SpeciesAsari}, PictureFile: "MP_AsariSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_AnnihilationSphere", "SFXPowerCustomActionMP_AsariPassive_Sentinel", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Sentinel_Asari"},
	{ID: "VanguardAsari", IDLook: "AsariDefault", Name: "Asari Vanguard", SubClass: "Vanguard", Species: []Species{SpeciesAsari}, PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_AsariPassive", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Batarian ----------------------------------------------------------
	{ID: "SoldierBatarian", IDLook: "BatarianDefault", Name: "Batarian Soldier", SubClass: "Soldier", Species: []Species{SpeciesBatarian}, PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianAttack", "SFXPowerCustomActionMP_BatarianArmor", "SFXPowerCustomActionMP_InfernoGrenade_Batarian", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", HasUniqueHeavyMelee: true},
	{ID: "AdeptBatarian", IDLook: "BatarianDefault", Name: "Batarian Adept", SubClass: "Adept", Species: []Species{SpeciesBatarian}, PictureFile: "MP_BatarianADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept_Batarian"},
	{ID: "SentinelBatarian", IDLook: "BatarianDefault", Name: "Batarian Sentinel", SubClass: "Sentinel", Species: []Species{SpeciesBatarian}, PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianArmor", "SFXPowerCustomActionMP_Shockwave_Batarian", "SFXPowerCustomActionMP_BatarianNet", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes"},
	{ID: "VanguardBatarian", IDLook: "BatarianDefault", Name: "Batarian Vanguard", SubClass: "Vanguard", Species: []Species{SpeciesBatarian}, PictureFile: "MP_BatarianVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_BatarianArmor", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Vanguard_Batarian"},

	// ---- Battlefield crossover ---------------------------------------------
	// {ID: "MP_BF3_INF", IDLook: "", Name: "N7 Infiltrator (BF3)", SubClass: "Infiltrator", PictureFile: "MP_BF3_INF.webp",
	// 	PowerIDs: [5]string{"Cloak", "CryoBlast", "StickyGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "SoldierHumanMaleBF3", IDLook: "", Name: "N7 Soldier (BF3)", SubClass: "Soldier", Species: []Species{SpeciesHuman}, PictureFile: "MP_BF_HMM0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},

	// ---- Cerberus ----------------------------------------------------------
	{ID: "AdeptHumanMaleCerberus", IDLook: "HumanCerberus", Name: "Cerberus Adept", SubClass: "Adept", Species: []Species{SpeciesHuman}, PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomAction_WhipSmash", "SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_WhipManPassive", "SFXPowerCustomActionMP_WhipManMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "CerberusMale_Adept"},
	{ID: "VanguardHumanMaleCerberus", IDLook: "HumanCerberus", Name: "Cerberus Vanguard", SubClass: "Vanguard", Species: []Species{SpeciesHuman}, PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomAction_WhipSmash", "SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_WhipManPassive", "SFXPowerCustomActionMP_WhipManMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "CerberusMale_Vanguard", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},

	// ---- Collectors --------------------------------------------------------
	{ID: "AdeptCollector", IDLook: "", Name: "Collector Adept", SubClass: "Adept", Species: []Species{SpeciesCollector}, PictureFile: "MP_CollectADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomAction_DarkSingularity", "SFXPowerCustomActionMP_SeekerSwarm", "SFXPowerCustomActionMP_DarkChannelProthean", "SFXPowerCustomActionMP_CollectorPassive", "SFXPowerCustomActionMP_ProtheanMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Adept_Collector", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},

	// ---- Drell -------------------------------------------------------------
	{ID: "AdeptDrell", IDLook: "DrellDefault", Name: "Drell Adept", SubClass: "Adept", Species: []Species{SpeciesDrell}, PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Reave", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},
	{ID: "InfiltratorDrell", IDLook: "DrellDefault", Name: "Drell Assassin", SubClass: "Infiltrator", Species: []Species{SpeciesDrell}, PictureFile: "MP_DrellINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_HomingGrenade", "SFXPowerCustomActionMP_ReconMine", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_Drell"},
	{ID: "VanguardDrell", IDLook: "DrellDefault", Name: "Drell Vanguard", SubClass: "Vanguard", Species: []Species{SpeciesDrell}, PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Female Bot --------------------------------------------------------
	{ID: "InfiltratorFembot", IDLook: "", Name: "Infiltrator Bot", SubClass: "Infiltrator", Species: []Species{SpeciesAndroid}, PictureFile: "MP_FBotINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_FembotCloak", "SFXPowerCustomActionMP_SnapFreeze", "SFXPowerCustomActionMP_RepairMatrix", "SFXPowerCustomActionMP_FembotPassive", "SFXPowerCustomActionMP_FembotMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Infiltrator_Fembot", HasUniqueHeavyMelee: true, HasUniqueDodge: true, HasUniqueLightMelee: true},

	// ---- Geth --------------------------------------------------------------
	{ID: "EngineerGeth", IDLook: "GethEnginer", Name: "Geth Engineer", SubClass: "Engineer", Species: []Species{SpeciesGeth}, PictureFile: "MP_GethEngineer.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_GethSentryTurret", "SFXPowerCustomActionMP_Supercharge", "SFXPowerCustomActionMP_Overload_Geth", "SFXPowerCustomActionMP_GethPassive", "SFXPowerCustomActionMP_GethMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Geth_Engineer", HasUniqueDodge: true, HasUniqueLightMelee: true},
	{ID: "InfiltratorGeth", IDLook: "GethDefault", Name: "Geth Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesGeth}, PictureFile: "MP_GethInfiltrator.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak_Geth", "SFXPowerCustomActionMP_ProximityMine_Geth", "SFXPowerCustomActionMP_Supercharge", "SFXPowerCustomActionMP_GethPassive", "SFXPowerCustomActionMP_GethMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Geth_Infiltrator"},
	{ID: "SoldierGethDestroyer", IDLook: "GethJuggernaut", Name: "Geth Juggernaut", SubClass: "Soldier", Species: []Species{SpeciesGeth}, PictureFile: "MP_GethPSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_HexShield", "SFXPowerCustomActionMP_SiegePulse", "SFXPowerCustomActionMP_GethSentryTurret_MP5", "SFXPowerCustomActionMP_GethDestroyerPassive", "SFXPowerCustomActionMP_GethDestroyerMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Soldier_GethDestroyer", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},
	{ID: "SoldierGeth", IDLook: "GethDefault", Name: "Geth Soldier", SubClass: "Soldier", Species: []Species{SpeciesGeth}, PictureFile: "MP_GethSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Flamer", "SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_Supercharge", "SFXPowerCustomActionMP_GethPassive", "SFXPowerCustomActionMP_GethMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_Geth", HasUniqueHeavyMelee: true},

	// ---- Krogan ------------------------------------------------------------
	{ID: "SoldierKrogan", IDLook: "KroganDefault", Name: "Krogan Soldier", SubClass: "Soldier", Species: []Species{SpeciesKrogan}, PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_InfernoGrenade", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},
	{ID: "AdeptKrogan", IDLook: "KroganArmored", Name: "Krogan Adept", SubClass: "Adept", Species: []Species{SpeciesKrogan}, PictureFile: "MP_KroganADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Barrier", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept_Krogan"},
	{ID: "SentinelKrogan", IDLook: "KroganDefault", Name: "Krogan Sentinel", SubClass: "Sentinel", Species: []Species{SpeciesKrogan}, PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Krogan", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "VanguardKrogan", IDLook: "KroganArmored", Name: "Krogan Battlemaster", SubClass: "Vanguard", Species: []Species{SpeciesKrogan}, PictureFile: "MP_KroganBM.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge_Krogan", "SFXPowerCustomActionMP_Carnage_KroganVanguard", "SFXPowerCustomActionMP_Barrier_KroganVanguard", "SFXPowerCustomActionMP_KroganPassive_Vanguard", "SFXPowerCustomActionMP_KroganMeleePassive_Vanguard"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Krogan_Vanguard"},
	{ID: "SentinelKroganWarlord", IDLook: "KroganWarlord", Name: "Krogan Warlord", SubClass: "Sentinel", Species: []Species{SpeciesKrogan}, PictureFile: "MP_BloodSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Warlord", "SFXPowerCustomActionMP_BioticHammerModal", "SFXPowerCustomActionMP_TechHammerModal", "SFXPowerCustomActionMP_WarlordPassive", "SFXPowerCustomActionMP_WarlordMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Sentinel_KroganWarlord", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},

	// ---- Mercenary ---------------------------------------------------------
	{ID: "EngineerMerc", IDLook: "", Name: "Blue Suns Engineer", SubClass: "Engineer", Species: []Species{SpeciesHuman}, PictureFile: "MP_MercENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CainMine", "SFXPowerCustomActionMP_MercBowModalOne", "SFXPowerCustomActionMP_MercBowModalTwo", "SFXPowerCustomActionMP_MercPassive", "SFXPowerCustomActionMP_MercMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Engineer_Merc", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},

	// ---- Quarian -----------------------------------------------------------
	{ID: "EngineerQuarian", IDLook: "QuarianFemaleDefault", Name: "Quarian Engineer", SubClass: "Engineer", Species: []Species{SpeciesQuarian}, PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SentryTurret", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_FemQuarianPassive", "SFXPowerCustomActionMP_FemQuarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorQuarian", IDLook: "QuarianFemaleDefault", Name: "Quarian Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesQuarian}, PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_FemQuarianPassive", "SFXPowerCustomActionMP_FemQuarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},
	{ID: "InfiltratorQuarianMale", IDLook: "QuarianMaleDefault", Name: "Quarian Male Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesQuarian}, PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_Damping", "SFXPowerCustomAction_EMPGrenade", "SFXPowerCustomActionMP_MaleQuarianPassive", "SFXPowerCustomActionMP_MaleQuarianMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "QuarianMale_Infiltrator"},
	{ID: "EngineerQuarianMale", IDLook: "QuarianMaleDefault", Name: "Quarian Male Engineer", SubClass: "Engineer", Species: []Species{SpeciesQuarian}, PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Damping", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomAction_EMPGrenade", "SFXPowerCustomActionMP_MaleQuarianPassive", "SFXPowerCustomActionMP_MaleQuarianMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "QuarianMale_Engineer"},
	{ID: "SoldierMQuarian", IDLook: "QuarianMaleDefault", Name: "Quarian Male Soldier", SubClass: "Soldier", Species: []Species{SpeciesQuarian}, PictureFile: "MP_QuarianMSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Marksman", "SFXPowerCustomActionMP_Damping", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_MaleQuarianPassive", "SFXPowerCustomActionMP_MaleQuarianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_MQuarian"},

	// ---- Salarian ----------------------------------------------------------
	{ID: "EngineerSalarian", IDLook: "SalarianDefault", Name: "Salarian Engineer", SubClass: "Engineer", Species: []Species{SpeciesSalarian}, PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_Decoy", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_SalarianPassive", "SFXPowerCustomActionMP_SalarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorSalarian", IDLook: "SalarianDefault", Name: "Salarian Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesSalarian}, PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_SalarianPassive", "SFXPowerCustomActionMP_SalarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},

	// ---- Turian ------------------------------------------------------------
	{ID: "SoldierTurian", IDLook: "TurianDefault", Name: "Turian Soldier", SubClass: "Soldier", Species: []Species{SpeciesTurian}, PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Marksman", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_TurianPassive", "SFXPowerCustomActionMP_TurianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "EngineerTurian", IDLook: "TurianArmiger", Name: "Turian Engineer", SubClass: "Engineer", Species: []Species{SpeciesTurian}, PictureFile: "MP_TurianENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SentryTurret", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_HomingGrenade", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Turian"},
	{ID: "N7InfiltratorTurian", IDLook: "TurianArmiger", Name: "Turian Infiltrator", SubClass: "Infiltrator", Species: []Species{SpeciesTurian}, PictureFile: "MP_TurianINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TurianCloak", "SFXPowerCustomActionMP_StimPack", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_N7_Turian"},
	{ID: "SentinelTurian", IDLook: "TurianDefault", Name: "Turian Sentinel", SubClass: "Sentinel", Species: []Species{SpeciesTurian}, PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Turian", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_TurianPassive", "SFXPowerCustomActionMP_TurianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "N7SoldierTurian", IDLook: "TurianArmiger", Name: "Turian Havoc", SubClass: "Soldier", Species: []Species{SpeciesTurian}, PictureFile: "MP_TurianSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_JetPackCharge", "SFXPowerCustomActionMP_StimPack", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_N7_Turian", HasUniqueHeavyMelee: true, HasUniqueDodge: true},
	{ID: "VanguardTurianFemale", IDLook: "TurianFemale", Name: "Cabal Vanguard", SubClass: "Vanguard", Species: []Species{SpeciesTurian}, PictureFile: "MP_TurianVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_LineStrike", "SFXPowerCustomActionMP_VenomTippedBlades", "SFXPowerCustomActionMP_BioticFocus", "SFXPowerCustomActionMP_FemTurianPassive", "SFXPowerCustomActionMP_FemTurianMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Vanguard_TurianFemale"},

	// ---- Volus -------------------------------------------------------------
	{ID: "AdeptVolus", IDLook: "VolusDefault", Name: "Volus Adept", SubClass: "Adept", Species: []Species{SpeciesVolus}, PictureFile: "MP_VolusADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_BioticOrbs", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept2_Volus", HasUniqueHeavyMelee: true, HasUniqueLightMelee: true},
	{ID: "EngineerVolus", IDLook: "VolusDefault", Name: "Volus Engineer", SubClass: "Engineer", Species: []Species{SpeciesVolus}, PictureFile: "MP_VolusENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_ReconMine", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Volus"},
	{ID: "SentinelVolus", IDLook: "VolusDefault", Name: "Volus Engineer II", SubClass: "Sentinel", Species: []Species{SpeciesVolus}, PictureFile: "MP_VolusENG2.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Decoy_Volus", "SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Sentinel_Volus"},
	{ID: "VanguardVolus", IDLook: "VolusDefault", Name: "Volus Protector", SubClass: "Vanguard", Species: []Species{SpeciesVolus}, PictureFile: "MP_VolusVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_BioticOrbs", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Vanguard_Volus"},

	// ---- Vorcha ------------------------------------------------------------
	{ID: "SoldierVorcha", IDLook: "VorchaDefault", Name: "Vorcha Soldier", SubClass: "Soldier", Species: []Species{SpeciesVorcha}, PictureFile: "MP_Vorcha.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Bloodlust", "SFXPowerCustomActionMP_Flamer", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_VorchaPassive", "SFXPowerCustomActionMP_VorchaMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes"},
	{ID: "EngineerVorcha", IDLook: "VorchaDefault", Name: "Vorcha Engineer", SubClass: "Engineer", Species: []Species{SpeciesVorcha}, PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianNet", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Bloodlust", "SFXPowerCustomActionMP_VorchaPassive", "SFXPowerCustomActionMP_VorchaMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Vorcha", HasUniqueHeavyMelee: true, HasUniqueDodge: true},
	{ID: "SentinelVorcha", IDLook: "VorchaDefault", Name: "Vorcha Sentinel", SubClass: "Sentinel", Species: []Species{SpeciesVorcha}, PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Bloodlust", "SFXPowerCustomActionMP_Flamer", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_VorchaPassive", "SFXPowerCustomActionMP_VorchaMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes"},

	// ---- Armax -------------------------------------------------------------
	{ID: "Char_SimHenchmen.SimJack", IDLook: "", Name: "Jack", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/AAA_CSC_-_A_-_Jack.webp",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomAction_Pull", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomAction_WarpAmmo", "SFXPowerCustomAction_JackPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimLiara", IDLook: "", Name: "Liara", SubClass: "Squadmate", Species: []Species{SpeciesAsari}, PictureFile: "/SP/Liara0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomAction_Singularity", "SFXPowerCustomAction_Stasis", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomAction_WarpAmmo", "SFXPowerCustomAction_LiaraPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimSamara", IDLook: "", Name: "Samara", SubClass: "Squadmate", Species: []Species{SpeciesAsari}, PictureFile: "/SP/AAA_CSC_-_A_-_Samara.webp",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Reave", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomAction_Pull", "SFXPowerCustomAction_Throw", "SFXPowerCustomAction_SamaraPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimGarrus", IDLook: "", Name: "Garrus", SubClass: "Squadmate", Species: []Species{SpeciesTurian}, PictureFile: "/SP/Garrus0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomAction_ConcussiveShot", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomAction_ArmorPiercingAmmo", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomAction_GarrusPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_APP01_Henchmen.Garrus_Combat", IDLook: "", Name: "Garrus (Terminus)", SubClass: "Squadmate", Species: []Species{SpeciesTurian}, PictureFile: "/SP/Garrus3GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomAction_ConcussiveShot", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomAction_ArmorPiercingAmmo", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomAction_GarrusPassive"},
		HasHeadgear: false, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimTali", IDLook: "", Name: "Tali", SubClass: "Squadmate", Species: []Species{SpeciesQuarian}, PictureFile: "/SP/Tali0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomAction_ProtectorDrone", "SFXPowerCustomAction_TaliPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimWrex", IDLook: "", Name: "Wrex", SubClass: "Squadmate", Species: []Species{SpeciesKrogan}, PictureFile: "/SP/AAA_CSC_-_A_-_Wrex.webp",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_Barrier", "SFXPowerCustomActionMP_StimPack", "SFXPowerCustomAction_WrexPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimMiranda", IDLook: "", Name: "Miranda", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/AAA_CSC_-_A_-_Miranda.webp",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Reave", "SFXPowerCustomAction_MirandaPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimKaidan", IDLook: "", Name: "Kaidan", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/Kaidan0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Barrier", "SFXPowerCustomActionMP_Reave", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomAction_KaidenPassive"},
		HasHeadgear: false, HasHelmet: false,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimJacob", IDLook: "", Name: "Jacob", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/Jacob.png",
		PowerIDs:    [5]string{"SFXPowerCustomAction_IncendiaryAmmo", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_Barrier", "SFXPowerCustomAction_Pull", "SFXPowerCustomAction_JacobPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimAshley", IDLook: "", Name: "Ashley", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/Ashley0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_InfernoGrenade", "SFXPowerCustomAction_DisruptorAmmo", "SFXPowerCustomAction_ConcussiveShot", "SFXPowerCustomActionMP_Marksman", "SFXPowerCustomAction_AshleyPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimEDI", IDLook: "", Name: "EDI", SubClass: "Squadmate", Species: []Species{SpeciesAndroid}, PictureFile: "/SP/EDI0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomAction_GethShieldBoost", "SFXPowerCustomActionMP_Decoy", "SFXPowerCustomAction_EDIPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimGrunt", IDLook: "", Name: "Grunt", SubClass: "Squadmate", Species: []Species{SpeciesKrogan}, PictureFile: "/SP/AAA_CSC_-_A_-_Grunt.webp",
		PowerIDs:    [5]string{"SFXPowerCustomAction_ConcussiveShot", "SFXPowerCustomAction_IncendiaryAmmo", "SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomAction_GruntPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimKasumi", IDLook: "", Name: "Kasumi", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/AAA_CSC_-_A_-_Kasumi.webp",
		PowerIDs:    [5]string{"SFXPowerCustomAction_Cloak_Kasumi", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomAction_ArmorPiercingAmmo", "SFXPowerCustomActionMP_Decoy", "SFXPowerCustomAction_KasumiPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimJames", IDLook: "", Name: "James", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/James0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomAction_IncendiaryAmmo", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomAction_JimmyPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimJavik", IDLook: "", Name: "Javik", SubClass: "Squadmate", Species: []Species{SpeciesProthean}, PictureFile: "/SP/Prothean0GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_DarkChannelProthean", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomAction_Pull", "SFXPowerCustomAction_Slam", "SFXPowerCustomAction_ProtheanPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimZaeed", IDLook: "", Name: "Zaeed", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/AAA_CSC_-_A_-_Zaeed.webp",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Carnage", "SFXPowerCustomAction_ConcussiveShot", "SFXPowerCustomAction_DisruptorAmmo", "SFXPowerCustomActionMP_InfernoGrenade", "SFXPowerCustomAction_ZaeedPassive"},
		HasHeadgear: true, HasHelmet: true,
		PawnType: PawnTypeHenchman},
	{ID: "Char_Henchmen.Archetypes.Kaidan.VariantB.KaidanB_EX_Combat", IDLook: "", Name: "Kaidan (ALT)", SubClass: "Squadmate", Species: []Species{SpeciesHuman}, PictureFile: "/SP/Kaidan1GlowCropped.png",
		PowerIDs:    [5]string{"SFXPowerCustomActionMP_Barrier", "SFXPowerCustomActionMP_Reave", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomAction_KaidenPassive"},
		HasHeadgear: false, HasHelmet: true,
		PawnType: PawnTypeHenchman},
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
var subClassOrder = []string{"Soldier", "Adept", "Sentinel", "Engineer", "Vanguard", "Infiltrator", "Squadmate"}

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

// GroupedCharactersBySpecies returns the same partitioning as GroupedCharacters
// but limited to characters whose Species slice contains the given species.
// Groups with no matching characters are omitted. Passing an empty string
// returns the same result as GroupedCharacters.
func GroupedCharactersBySpecies(species string) []CharacterGroup {
	if species == "" {
		return GroupedCharacters()
	}
	target := Species(species)
	buckets := make(map[string][]CharacterDef, len(subClassOrder))
	for _, c := range CharacterCatalog {
		for _, s := range c.Species {
			if s == target {
				buckets[c.SubClass] = append(buckets[c.SubClass], c)
				break
			}
		}
	}
	groups := make([]CharacterGroup, 0, len(subClassOrder))
	for _, sc := range subClassOrder {
		if chars, ok := buckets[sc]; ok {
			groups = append(groups, CharacterGroup{SubClass: sc, Characters: chars})
		}
	}
	return groups
}

// AppearanceCharacters returns a deduplicated list of characters suitable for
// the appearance selector.  Characters with a non-empty IDLook are deduplicated:
// only the first character encountered with a given IDLook value is kept.
// Characters with an empty IDLook are always included (treated as unique).
// An optional species filter (matching PreferredSpecies) is applied first; pass
// an empty string to include all species.
func AppearanceCharacters(species string) []CharacterDef {
	var target Species
	filterSpecies := species != ""
	if filterSpecies {
		target = Species(species)
	}
	seen := make(map[string]bool)
	result := make([]CharacterDef, 0, len(CharacterCatalog))
	for _, c := range CharacterCatalog {
		if filterSpecies {
			match := false
			for _, s := range c.Species {
				if s == target {
					match = true
					break
				}
			}
			if !match {
				continue
			}
		}
		if c.IDLook == "" {
			result = append(result, c)
			continue
		}
		if !seen[c.IDLook] {
			seen[c.IDLook] = true
			result = append(result, c)
		}
	}
	return result
}

// HeavyMeleeCharacters returns all characters with HasUniqueHeavyMelee == true,
// suitable for the heavy melee selector. No deduplication is applied.
func HeavyMeleeCharacters() []CharacterDef {
	var result []CharacterDef
	for _, c := range CharacterCatalog {
		if c.HasUniqueHeavyMelee {
			result = append(result, c)
		}
	}
	return result
}

// LightMeleeCharacters returns all characters with HasUniqueLightMelee == true,
// suitable for the light melee selector. No deduplication is applied.
func LightMeleeCharacters() []CharacterDef {
	var result []CharacterDef
	for _, c := range CharacterCatalog {
		if c.HasUniqueLightMelee {
			result = append(result, c)
		}
	}
	return result
}

// DodgeCharacters returns all characters with HasUniqueDodge == true,
// suitable for the dodge selector. No deduplication is applied.
func DodgeCharacters() []CharacterDef {
	var result []CharacterDef
	for _, c := range CharacterCatalog {
		if c.HasUniqueDodge {
			result = append(result, c)
		}
	}
	return result
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

// CharacterByQualifiedPath returns the CharacterDef whose KitQualifiedPath()
// matches the given qualified archetype path, or nil if none match.
func CharacterByQualifiedPath(q string) *CharacterDef {
	if q == "" {
		return nil
	}
	for i := range CharacterCatalog {
		if CharacterCatalog[i].KitQualifiedPath() == q {
			return &CharacterCatalog[i]
		}
	}
	return nil
}

// ---------------------------------------------------------------------------
// Power-with-source helpers
// ---------------------------------------------------------------------------

// PowerWithSource pairs a PowerDef with identifying information about the
// first CharacterDef that has it in its PowerIDs array.
type PowerWithSource struct {
	Power          *PowerDef
	SourceCharID   string
	SourceCharName string
}

// passiveSortKey returns a sort tier for a power:
//   0 = normal power  (sorts first, alphabetically)
//   1 = MPPassive     (second-to-last group)
//   2 = MPMeleePassive (last group)
func passiveSortKey(p *PowerDef) int {
	switch p.Picture {
	case "MPPassive.webp":
		return 1
	case "MPMeleePassive.webp":
		return 2
	}
	return 0
}

// AllPowersWithSourceOfType returns the same list as AllPowersWithSource but
// filtered to only include powers whose Type matches t.
func AllPowersWithSourceOfType(t PowerType) []PowerWithSource {
	full := AllPowersWithSource()
	result := full[:0:0]
	for _, p := range full {
		if p.Power != nil && p.Power.Type == t {
			result = append(result, p)
		}
	}
	return result
}

// AllPowersWithSource returns every unique power across the catalog, each
// paired with the first character that has it.  Deduplication is by PowerID.
// Results are sorted alphabetically by name, with all MPPassive powers after
// normal powers and all MPMeleePassive powers last.
func AllPowersWithSource() []PowerWithSource {
	seen := make(map[string]bool, len(PowerCatalog))
	result := make([]PowerWithSource, 0, len(PowerCatalog))
	for _, char := range CharacterCatalog {
		for _, pid := range char.PowerIDs {
			if pid == "" || seen[pid] {
				continue
			}
			pd := PowerByID(pid)
			if pd == nil {
				continue
			}
			seen[pid] = true
			result = append(result, PowerWithSource{
				Power:          pd,
				SourceCharID:   char.ID,
				SourceCharName: char.Name,
			})
		}
	}
	sort.Slice(result, func(i, j int) bool {
		ki, kj := passiveSortKey(result[i].Power), passiveSortKey(result[j].Power)
		if ki != kj {
			return ki < kj
		}
		return result[i].Power.Name < result[j].Power.Name
	})
	return result
}

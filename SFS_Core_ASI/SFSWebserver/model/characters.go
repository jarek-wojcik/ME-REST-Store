package model

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
	RootPath    string    // UE3 archetype package path prefix (e.g. "BioChar_MPPlayers.Archetypes.Adept"); empty when ID already encodes the full path
	ArchetypeID string    // last segment of the UE3 archetype path (e.g. "HumanFemale_Adept"); empty when it matches ID
	PawnType    PawnType  // how the character is spawned; defaults to PlayerMP when unset
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

// ---------------------------------------------------------------------------
// Static character catalog
// ---------------------------------------------------------------------------

// CharacterCatalog is the full list of available MP character classes.
// Entries are ordered: base Human classes first, then Alliance N7, then
// alien/faction classes alphabetically by species.
var CharacterCatalog = []CharacterDef{
	// ---- Human base classes ------------------------------------------------
	{ID: "AdeptHumanFemale", Name: "Human Adept (Female)", SubClass: "Adept", PictureFile: "AdeptHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Adept"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept"},
	{ID: "AdeptHumanMale", Name: "Human Adept (Male)", SubClass: "Adept", PictureFile: "AdeptHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Adept"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept"},
	{ID: "EngineerHumanFemale", Name: "Human Engineer (Female)", SubClass: "Engineer", PictureFile: "EngineerHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Engineer"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "EngineerHumanMale", Name: "Human Engineer (Male)", SubClass: "Engineer", PictureFile: "EngineerHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Engineer"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorHumanFemale", Name: "Human Infiltrator (Female)", SubClass: "Infiltrator", PictureFile: "InfiltratorHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},
	{ID: "InfiltratorHumanMale", Name: "Human Infiltrator (Male)", SubClass: "Infiltrator", PictureFile: "InfiltratorHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},
	{ID: "SentinelHumanFemale", Name: "Human Sentinel (Female)", SubClass: "Sentinel", PictureFile: "SentinelHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "SentinelHumanMale", Name: "Human Sentinel (Male)", SubClass: "Sentinel", PictureFile: "SentinelHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "SoldierHumanFemale", Name: "Human Soldier (Female)", SubClass: "Soldier", PictureFile: "SoldierHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "SoldierHumanMale", Name: "Human Soldier (Male)", SubClass: "Soldier", PictureFile: "SoldierHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "VanguardHumanFemale", Name: "Human Vanguard (Female)", SubClass: "Vanguard", PictureFile: "VanguardHumanFemale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Discharge", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},
	{ID: "VanguardHumanMale", Name: "Human Vanguard (Male)", SubClass: "Vanguard", PictureFile: "VanguardHumanMale.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Discharge", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Alliance N7 classes -----------------------------------------------
	{ID: "AdeptN7", Name: "N7 Fury", SubClass: "Adept", PictureFile: "MP_AllianceADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AnnihilationSphere", "SFXPowerCustomActionMP_DarkChannel2", "SFXPowerCustomActionMP_Throw_N7", "SFXPowerCustomActionMP_N7AdeptPassive", "SFXPowerCustomActionMP_N7AdeptMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Adept_N7"},
	{ID: "EngineerN7", Name: "N7 Demolisher", SubClass: "Engineer", PictureFile: "MP_AllianceENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SupplyTurret", "SFXPowerCustomActionMP_EMPGrenade2", "SFXPowerCustomActionMP_HomingGrenade", "SFXPowerCustomActionMP_N7EngineerPassive", "SFXPowerCustomActionMP_N7EngineerMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Engineer_N7"},
	{ID: "InfiltratorN7", Name: "N7 Shadow", SubClass: "Infiltrator", PictureFile: "MP_AllianceINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak_N7Infiltrator", "SFXPowerCustomActionMP_ElectricSlash", "SFXPowerCustomActionMP_ShadowStrike", "SFXPowerCustomActionMP_N7InfiltratorPassive", "SFXPowerCustomActionMP_N7InfiltratorMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Infiltrator_N7"},
	{ID: "SentinelN7", Name: "N7 Paladin", SubClass: "Sentinel", PictureFile: "MP_AllianceSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_CryoCone", "SFXPowerCustomActionMP_N7SentinelPassive", "SFXPowerCustomActionMP_N7SentinelMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Sentinel_N7"},
	{ID: "SoldierN7", Name: "N7 Destroyer", SubClass: "Soldier", PictureFile: "MP_AllianceSOL.webp",
		PowerIDs: [5]string{"SFXPowerCustomAction_DevestatorMode", "SFXPowerCustomAction_MissileLauncher", "SFXPowerCustomAction_MultiFragGrenade", "SFXPowerCustomAction_N7SoldierPassive", "SFXPowerCustomAction_N7SoldierMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Soldier_N7"},
	{ID: "VanguardN7", Name: "N7 Slayer", SubClass: "Vanguard", PictureFile: "MP_AllianceVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_PalmBlaster", "SFXPowerCustomActionMP_SonicSlash", "SFXPowerCustomActionMP_N7VanguardPassive", "SFXPowerCustomActionMP_N7VanguardMeleePassive"},
		RootPath: "BioChar_DLC_MP3_MPPlayers", ArchetypeID: "Vanguard_N7"},

	// ---- Asari -------------------------------------------------------------
	{ID: "AdeptAsari", Name: "Asari Adept", SubClass: "Adept", PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Throw", "SFXPowerCustomActionMP_AsariPassive", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept"},
	{ID: "AdeptAsariCommando", Name: "Asari Justicar", SubClass: "Adept", PictureFile: "MP_AsariComm.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BubbleShield", "SFXPowerCustomActionMP_Reave_Asari", "SFXPowerCustomActionMP_Pull_Asari", "SFXPowerCustomActionMP_AsariCommandoPassive", "SFXPowerCustomActionMP_AsariMeleePassive_Commando"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "AsariCommando_Adept"},
	{ID: "InfiltratorAsari", Name: "Asari Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_AsariINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AsariCloak", "SFXPowerCustomActionMP_DarkChannel2_Shared", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_AsariPassive_Infiltrator", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_Asari"},
	{ID: "SentinelAsari", Name: "Asari Valkyrie", SubClass: "Sentinel", PictureFile: "MP_AsariSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_AnnihilationSphere_Shared", "SFXPowerCustomActionMP_AsariPassive_Sentinel", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Sentinel_Asari"},
	{ID: "VanguardAsari", Name: "Asari Vanguard", SubClass: "Vanguard", PictureFile: "MP_Asari0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_AsariPassive", "SFXPowerCustomActionMP_AsariMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Batarian ----------------------------------------------------------
	{ID: "SoldierBatarian", Name: "Batarian Soldier", SubClass: "Soldier", PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianAttack", "SFXPowerCustomActionMP_BatarianArmor", "SFXPowerCustomActionMP_InfernoGrenade_Batarian", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes"},
	{ID: "AdeptBatarian", Name: "Batarian Adept", SubClass: "Adept", PictureFile: "MP_BatarianADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Lash_Shared", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_BatarianPassive_Shared", "SFXPowerCustomActionMP_BatarianMeleePassive_Shared"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept_Batarian"},
	{ID: "SentinelBatarian", Name: "Batarian Sentinel", SubClass: "Sentinel", PictureFile: "MP_Batarian.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianArmor", "SFXPowerCustomActionMP_Shockwave_Batarian", "SFXPowerCustomActionMP_BatarianNet", "SFXPowerCustomActionMP_BatarianPassive", "SFXPowerCustomActionMP_BatarianMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes"},
	{ID: "VanguardBatarian", Name: "Batarian Vanguard", SubClass: "Vanguard", PictureFile: "MP_BatarianVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Lash_Shared", "SFXPowerCustomActionMP_BatarianArmor_Shared", "SFXPowerCustomActionMP_BatarianPassive_Shared", "SFXPowerCustomActionMP_BatarianMeleePassive_Shared"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Vanguard_Batarian"},

	// ---- Battlefield crossover ---------------------------------------------
	// {ID: "MP_BF3_INF", Name: "N7 Infiltrator (BF3)", SubClass: "Infiltrator", PictureFile: "MP_BF3_INF.webp",
	// 	PowerIDs: [5]string{"Cloak", "CryoBlast", "StickyGrenade", "MPPassive", "MPMeleePassive"}},
	{ID: "SoldierHumanMaleBF3", Name: "N7 Soldier (BF3)", SubClass: "Soldier", PictureFile: "MP_BF_HMM0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_AdrenalineRush", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_FragGrenade", "SFXPowerCustomActionMP_HumanPassive", "SFXPowerCustomActionMP_HumanMeleePassive_Soldier"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},

	// ---- Cerberus ----------------------------------------------------------
	{ID: "AdeptHumanMaleCerberus", Name: "Cerberus Adept", SubClass: "Adept", PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Singularity", "SFXPowerCustomAction_WhipSmash", "SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_WhipManPassive", "SFXPowerCustomActionMP_WhipManMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "CerberusMale_Adept"},
	{ID: "VanguardHumanMaleCerberus", Name: "Cerberus Vanguard", SubClass: "Vanguard", PictureFile: "MP_Cerberus.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomAction_WhipSmash", "SFXPowerCustomActionMP_Lash", "SFXPowerCustomActionMP_WhipManPassive", "SFXPowerCustomActionMP_WhipManMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "CerberusMale_Vanguard"},

	// ---- Collectors --------------------------------------------------------
	{ID: "AdeptCollector", Name: "Collector Adept", SubClass: "Adept", PictureFile: "MP_CollectADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomAction_DarkSingularity", "SFXPowerCustomActionMP_SeekerSwarm", "SFXPowerCustomActionMP_DarkChannelProthean", "SFXPowerCustomActionMP_CollectorPassive", "SFXPowerCustomActionMP_ProtheanMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Adept_Collector"},

	// ---- Drell -------------------------------------------------------------
	{ID: "AdeptDrell", Name: "Drell Adept", SubClass: "Adept", PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Reave", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Adept"},
	{ID: "InfiltratorDrell", Name: "Drell Assassin", SubClass: "Infiltrator", PictureFile: "MP_DrellINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_HomingGrenade_Shared", "SFXPowerCustomActionMP_ReconMine", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_Drell"},
	{ID: "VanguardDrell", Name: "Drell Vanguard", SubClass: "Vanguard", PictureFile: "MP_Drell0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_DrellPassive", "SFXPowerCustomActionMP_DrellMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Vanguard"},

	// ---- Female Bot --------------------------------------------------------
	{ID: "InfiltratorFembot", Name: "Infiltrator Bot", SubClass: "Infiltrator", PictureFile: "MP_FBotINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_FembotCloak", "SFXPowerCustomActionMP_SnapFreeze", "SFXPowerCustomActionMP_RepairMatrix", "SFXPowerCustomActionMP_FembotPassive", "SFXPowerCustomActionMP_FembotMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Infiltrator_Fembot"},

	// ---- Geth --------------------------------------------------------------
	{ID: "EngineerGeth", Name: "Geth Engineer", SubClass: "Engineer", PictureFile: "MP_GethEngineer.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_GethSentryTurret", "SFXPowerCustomActionMP_Supercharge", "SFXPowerCustomActionMP_Overload_Geth", "SFXPowerCustomActionMP_GethPassive", "SFXPowerCustomActionMP_GethMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Geth_Engineer"},
	{ID: "InfiltratorGeth", Name: "Geth Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_GethInfiltrator.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak_Geth", "SFXPowerCustomActionMP_ProximityMine_Geth", "SFXPowerCustomActionMP_Supercharge", "SFXPowerCustomActionMP_GethPassive", "SFXPowerCustomActionMP_GethMeleePassive"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Geth_Infiltrator"},
	{ID: "SoldierGethDestroyer", Name: "Geth Juggernaut", SubClass: "Soldier", PictureFile: "MP_GethPSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_HexShield", "SFXPowerCustomActionMP_SiegePulse", "SFXPowerCustomActionMP_GethSentryTurret_MP5", "SFXPowerCustomActionMP_GethDestroyerPassive", "SFXPowerCustomActionMP_GethDestroyerMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Soldier_GethDestroyer"},
	{ID: "SoldierGeth", Name: "Geth Soldier", SubClass: "Soldier", PictureFile: "MP_GethSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Flamer_Shared", "SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_Supercharge_Shared", "SFXPowerCustomActionMP_GethPassive_Shared", "SFXPowerCustomActionMP_GethMeleePassive_Shared"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_Geth"},

	// ---- Krogan ------------------------------------------------------------
	{ID: "SoldierKrogan", Name: "Krogan Soldier", SubClass: "Soldier", PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Fortification", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_InfernoGrenade", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "AdeptKrogan", Name: "Krogan Adept", SubClass: "Adept", PictureFile: "MP_KroganADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Barrier_Shared", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept_Krogan"},
	{ID: "SentinelKrogan", Name: "Krogan Sentinel", SubClass: "Sentinel", PictureFile: "MP_Krogan0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Krogan", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_LiftGrenade", "SFXPowerCustomActionMP_KroganPassive", "SFXPowerCustomActionMP_KroganMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "VanguardKrogan", Name: "Krogan Battlemaster", SubClass: "Vanguard", PictureFile: "MP_KroganBM.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge_Krogan", "SFXPowerCustomActionMP_Carnage_KroganVanguard", "SFXPowerCustomActionMP_Barrier_KroganVanguard", "SFXPowerCustomActionMP_KroganPassive_Vanguard", "SFXPowerCustomActionMP_KroganMeleePassive_Vanguard"},
		RootPath: "BioChar_DLC_MP1_MPPlayers.Archetypes", ArchetypeID: "Krogan_Vanguard"},
	{ID: "SentinelKroganWarlord", Name: "Krogan Warlord", SubClass: "Sentinel", PictureFile: "MP_BloodSEN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Warlord", "SFXPowerCustomActionMP_BioticHammerModal", "SFXPowerCustomActionMP_TechHammerModal", "SFXPowerCustomActionMP_WarlordPassive", "SFXPowerCustomActionMP_WarlordMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Sentinel_KroganWarlord"},

	// ---- Mercenary ---------------------------------------------------------
	{ID: "EngineerMerc", Name: "Blue Suns Engineer", SubClass: "Engineer", PictureFile: "MP_MercENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_CainMine", "SFXPowerCustomActionMP_MercBowModalOne", "SFXPowerCustomActionMP_MercBowModalTwo", "SFXPowerCustomActionMP_MercPassive", "SFXPowerCustomActionMP_MercMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Engineer_Merc"},

	// ---- Quarian -----------------------------------------------------------
	{ID: "EngineerQuarian", Name: "Quarian Engineer", SubClass: "Engineer", PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SentryTurret", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_FemQuarianPassive", "SFXPowerCustomActionMP_FemQuarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorQuarian", Name: "Quarian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_Quarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_StickyGrenade", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_FemQuarianPassive", "SFXPowerCustomActionMP_FemQuarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},
	{ID: "InfiltratorQuarianMale", Name: "Quarian Male Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_Damping", "SFXPowerCustomAction_EMPGrenade", "SFXPowerCustomActionMP_MaleQuarianPassive", "SFXPowerCustomActionMP_MaleQuarianMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "QuarianMale_Infiltrator"},
	{ID: "EngineerQuarianMale", Name: "Quarian Male Engineer", SubClass: "Engineer", PictureFile: "MP_QuarianMale0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Damping", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomAction_EMPGrenade", "SFXPowerCustomActionMP_MaleQuarianPassive", "SFXPowerCustomActionMP_MaleQuarianMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes", ArchetypeID: "QuarianMale_Engineer"},
	{ID: "SoldierMQuarian", Name: "Quarian Male Soldier", SubClass: "Soldier", PictureFile: "MP_QuarianMSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Marksman", "SFXPowerCustomActionMP_Damping_Shared", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_MaleQuarianPassive_Shared", "SFXPowerCustomActionMP_MaleQuarianMeleePassive_Shared"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_MQuarian"},

	// ---- Salarian ----------------------------------------------------------
	{ID: "EngineerSalarian", Name: "Salarian Engineer", SubClass: "Engineer", PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_Decoy", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_SalarianPassive", "SFXPowerCustomActionMP_SalarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Engineer"},
	{ID: "InfiltratorSalarian", Name: "Salarian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_Salarian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Cloak", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_EnergyDrain", "SFXPowerCustomActionMP_SalarianPassive", "SFXPowerCustomActionMP_SalarianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Infiltrator"},

	// ---- Turian ------------------------------------------------------------
	{ID: "SoldierTurian", Name: "Turian Soldier", SubClass: "Soldier", PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Marksman", "SFXPowerCustomActionMP_ConcussiveShot", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_TurianPassive", "SFXPowerCustomActionMP_TurianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Soldier"},
	{ID: "EngineerTurian", Name: "Turian Engineer", SubClass: "Engineer", PictureFile: "MP_TurianENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_SentryTurret", "SFXPowerCustomActionMP_AIHacking", "SFXPowerCustomActionMP_HomingGrenade_Shared", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Turian"},
	{ID: "N7InfiltratorTurian", Name: "Turian Infiltrator", SubClass: "Infiltrator", PictureFile: "MP_TurianINF.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TurianCloak", "SFXPowerCustomActionMP_StimPack", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Infiltrator_N7_Turian"},
	{ID: "SentinelTurian", Name: "Turian Sentinel", SubClass: "Sentinel", PictureFile: "MP_Turian0.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_TechArmor_Turian", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomActionMP_Overload", "SFXPowerCustomActionMP_TurianPassive", "SFXPowerCustomActionMP_TurianMeleePassive"},
		RootPath: "BioChar_MPPlayers.Archetypes.Sentinel"},
	{ID: "N7SoldierTurian", Name: "Turian Havoc", SubClass: "Soldier", PictureFile: "MP_TurianSLD.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_JetPackCharge", "SFXPowerCustomActionMP_StimPack", "SFXPowerCustomActionMP_CryoBlast", "SFXPowerCustomActionMP_N7TurianPassive", "SFXPowerCustomActionMP_N7TurianMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Soldier_N7_Turian"},
	{ID: "VanguardTurianFemale", Name: "Cabal Vanguard", SubClass: "Vanguard", PictureFile: "MP_TurianVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_LineStrike", "SFXPowerCustomActionMP_VenomTippedBlades", "SFXPowerCustomActionMP_BioticFocus", "SFXPowerCustomActionMP_FemTurianPassive", "SFXPowerCustomActionMP_FemTurianMeleePassive"},
		RootPath: "BioChar_DLC_MP5_MPPlayers", ArchetypeID: "Vanguard_TurianFemale"},

	// ---- Volus -------------------------------------------------------------
	{ID: "AdeptVolus", Name: "Volus Adept", SubClass: "Adept", PictureFile: "MP_VolusADP.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Stasis", "SFXPowerCustomActionMP_BioticOrbs", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Adept2_Volus"},
	{ID: "EngineerVolus", Name: "Volus Engineer", SubClass: "Engineer", PictureFile: "MP_VolusENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_ReconMine", "SFXPowerCustomActionMP_ProximityMine", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Volus"},
	{ID: "SentinelVolus", Name: "Volus Engineer II", SubClass: "Sentinel", PictureFile: "MP_VolusENG2.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Decoy_Volus", "SFXPowerCustomActionMP_CombatDrone", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Sentinel_Volus"},
	{ID: "VanguardVolus", Name: "Volus Protector", SubClass: "Vanguard", PictureFile: "MP_VolusVAN.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BioticCharge", "SFXPowerCustomActionMP_ShieldBoost", "SFXPowerCustomActionMP_BioticOrbs", "SFXPowerCustomActionMP_VolusPassive", "SFXPowerCustomActionMP_VolusMeleePassive"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Vanguard_Volus"},

	// ---- Vorcha ------------------------------------------------------------
	{ID: "SoldierVorcha", Name: "Vorcha Soldier", SubClass: "Soldier", PictureFile: "MP_Vorcha.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Bloodlust", "SFXPowerCustomActionMP_Flamer", "SFXPowerCustomActionMP_Carnage", "SFXPowerCustomActionMP_VorchaPassive", "SFXPowerCustomActionMP_VorchaMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes"},
	{ID: "EngineerVorcha", Name: "Vorcha Engineer", SubClass: "Engineer", PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_BatarianNet_Shared", "SFXPowerCustomActionMP_Incinerate", "SFXPowerCustomActionMP_Bloodlust_Shared", "SFXPowerCustomActionMP_VorchaPassive_Shared", "SFXPowerCustomActionMP_VorchaMeleePassive_Shared"},
		RootPath: "BioChar_DLC_MP4_MPPlayers", ArchetypeID: "Engineer_Vorcha"},
	{ID: "SentinelVorcha", Name: "Vorcha Sentinel", SubClass: "Sentinel", PictureFile: "MP_VorchaENG.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Bloodlust", "SFXPowerCustomActionMP_Flamer", "SFXPowerCustomActionMP_BioticGrenade", "SFXPowerCustomActionMP_VorchaPassive", "SFXPowerCustomActionMP_VorchaMeleePassive"},
		RootPath: "BioChar_DLC_MP2_MPPlayers.Archetypes"},

	// ---- Armax -------------------------------------------------------------
	{ID: "Char_SimHenchmen.SimJack", Name: "Jack", SubClass: "Squadmate", PictureFile: "/SP/AAA_CSC_-_A_-_Jack.webp",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomAction_WarpAmmo", "SFXPowerCustomAction_JackPassive"},
		PawnType: PawnTypeHenchman},
	{ID: "Char_SimHenchmen.SimLiara", Name: "Liara", SubClass: "Squadmate", PictureFile: "/SP/Liara0Glow.png",
		PowerIDs: [5]string{"SFXPowerCustomActionMP_Shockwave", "SFXPowerCustomActionMP_Pull", "SFXPowerCustomActionMP_Warp", "SFXPowerCustomAction_WarpAmmo", "SFXPowerCustomAction_JackPassive"},
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

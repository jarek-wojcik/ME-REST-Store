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
// The power itself is identified by PowerID (may be swapped away from the
// character's default via the selector UI).  Evolution holds the A/B choice
// for each of the three upgrade ranks.
type PowerSlot struct {
	PowerID   string    `json:"powerId"`
	Evolution [3]string `json:"evolution"` // each element: "A" or "B"
}

// Bot is a character instance assigned to a team.
// CharacterID references a CharacterDef in the catalog.
// WeaponID references a WeaponDef in the catalog.
// Powers holds 0–5 slots; slots are initialised from the CharacterDef
// defaults when a bot is first created.
type Bot struct {
	ID          string      `json:"id"`
	TeamID      string      `json:"teamId"`
	CharacterID string      `json:"characterId"`
	WeaponID    string      `json:"weaponId"`
	Powers      []PowerSlot `json:"powers"` // up to 5
}

// ---------------------------------------------------------------------------
// Character definition (static catalog)
// ---------------------------------------------------------------------------

// CharacterDef is a read-only definition of a playable MP character class.
// It is not stored in BoltDB; it is compiled into the binary.
type CharacterDef struct {
	ID          string // matches the asset filename stem, e.g. "MP_Turian0"
	Name        string // human-readable display name
	PictureFile string // filename inside /static/assets/characters/
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
	{ID: "AdeptHumanFemale", Name: "Human Adept (Female)", PictureFile: "AdeptHumanFemale.webp"},
	{ID: "AdeptHumanMale", Name: "Human Adept (Male)", PictureFile: "AdeptHumanMale.webp"},
	{ID: "EngineerHumanFemale", Name: "Human Engineer (Female)", PictureFile: "EngineerHumanFemale.webp"},
	{ID: "EngineerHumanMale", Name: "Human Engineer (Male)", PictureFile: "EngineerHumanMale.webp"},
	{ID: "InfiltratorHumanFemale", Name: "Human Infiltrator (Female)", PictureFile: "InfiltratorHumanFemale.webp"},
	{ID: "InfiltratorHumanMale", Name: "Human Infiltrator (Male)", PictureFile: "InfiltratorHumanMale.webp"},
	{ID: "SentinelHumanFemale", Name: "Human Sentinel (Female)", PictureFile: "SentinelHumanFemale.webp"},
	{ID: "SentinelHumanMale", Name: "Human Sentinel (Male)", PictureFile: "SentinelHumanMale.webp"},
	{ID: "SoldierHumanFemale", Name: "Human Soldier (Female)", PictureFile: "SoldierHumanFemale.webp"},
	{ID: "SoldierHumanMale", Name: "Human Soldier (Male)", PictureFile: "SoldierHumanMale.webp"},
	{ID: "VanguardHumanFemale", Name: "Human Vanguard (Female)", PictureFile: "VanguardHumanFemale.webp"},
	{ID: "VanguardHumanMale", Name: "Human Vanguard (Male)", PictureFile: "VanguardHumanMale.webp"},

	// ---- Alliance N7 classes -----------------------------------------------
	{ID: "MP_AllianceADP", Name: "N7 Fury", PictureFile: "MP_AllianceADP.webp"},
	{ID: "MP_AllianceENG", Name: "N7 Demolisher", PictureFile: "MP_AllianceENG.webp"},
	{ID: "MP_AllianceINF", Name: "N7 Shadow", PictureFile: "MP_AllianceINF.webp"},
	{ID: "MP_AllianceSEN", Name: "N7 Paladin", PictureFile: "MP_AllianceSEN.webp"},
	{ID: "MP_AllianceSOL", Name: "N7 Destroyer", PictureFile: "MP_AllianceSOL.webp"},
	{ID: "MP_AllianceVAN", Name: "N7 Slayer", PictureFile: "MP_AllianceVAN.webp"},

	// ---- Asari -------------------------------------------------------------
	{ID: "MP_Asari0", Name: "Asari Adept", PictureFile: "MP_Asari0.webp"},
	{ID: "MP_AsariComm", Name: "Asari Justicar", PictureFile: "MP_AsariComm.webp"},
	{ID: "MP_AsariINF", Name: "Asari Infiltrator", PictureFile: "MP_AsariINF.webp"},
	{ID: "MP_AsariSEN", Name: "Asari Valkyrie", PictureFile: "MP_AsariSEN.webp"},

	// ---- Batarian ----------------------------------------------------------
	{ID: "MP_Batarian", Name: "Batarian Soldier", PictureFile: "MP_Batarian.webp"},
	{ID: "MP_BatarianADP", Name: "Batarian Adept", PictureFile: "MP_BatarianADP.webp"},
	{ID: "MP_BatarianVAN", Name: "Batarian Vanguard", PictureFile: "MP_BatarianVAN.webp"},

	// ---- Battlefield crossover ---------------------------------------------
	{ID: "MP_BF3_INF", Name: "N7 Infiltrator (BF3)", PictureFile: "MP_BF3_INF.webp"},
	{ID: "MP_BF_HMM0", Name: "N7 Soldier (BF3)", PictureFile: "MP_BF_HMM0.webp"},

	// ---- Blood Pack --------------------------------------------------------
	{ID: "MP_BloodSEN", Name: "Blood Pack Warrior", PictureFile: "MP_BloodSEN.webp"},

	// ---- Cerberus ----------------------------------------------------------
	{ID: "MP_Cerberus", Name: "Cerberus Adept", PictureFile: "MP_Cerberus.webp"},

	// ---- Collectors --------------------------------------------------------
	{ID: "MP_CollectADP", Name: "Collector Adept", PictureFile: "MP_CollectADP.webp"},

	// ---- Drell -------------------------------------------------------------
	{ID: "MP_Drell0", Name: "Drell Adept", PictureFile: "MP_Drell0.webp"},
	{ID: "MP_DrellINF", Name: "Drell Assassin", PictureFile: "MP_DrellINF.webp"},

	// ---- Female Bot --------------------------------------------------------
	{ID: "MP_FBotINF", Name: "Female Infiltrator", PictureFile: "MP_FBotINF.webp"},

	// ---- Geth --------------------------------------------------------------
	{ID: "MP_GethEngineer", Name: "Geth Engineer", PictureFile: "MP_GethEngineer.webp"},
	{ID: "MP_GethInfiltrator", Name: "Geth Infiltrator", PictureFile: "MP_GethInfiltrator.webp"},
	{ID: "MP_GethPSLD", Name: "Geth Juggernaut", PictureFile: "MP_GethPSLD.webp"},
	{ID: "MP_GethSLD", Name: "Geth Soldier", PictureFile: "MP_GethSLD.webp"},

	// ---- Krogan ------------------------------------------------------------
	{ID: "MP_Krogan0", Name: "Krogan Soldier", PictureFile: "MP_Krogan0.webp"},
	{ID: "MP_KroganADP", Name: "Krogan Adept", PictureFile: "MP_KroganADP.webp"},
	{ID: "MP_KroganBM", Name: "Krogan Battlemaster", PictureFile: "MP_KroganBM.webp"},

	// ---- Mercenary ---------------------------------------------------------
	{ID: "MP_MercENG", Name: "Blue Suns Engineer", PictureFile: "MP_MercENG.webp"},

	// ---- Quarian -----------------------------------------------------------
	{ID: "MP_Quarian0", Name: "Quarian Engineer", PictureFile: "MP_Quarian0.webp"},
	{ID: "MP_QuarianMale0", Name: "Quarian Male Infiltrator", PictureFile: "MP_QuarianMale0.webp"},
	{ID: "MP_QuarianMSLD", Name: "Quarian Male Soldier", PictureFile: "MP_QuarianMSLD.webp"},

	// ---- Salarian ----------------------------------------------------------
	{ID: "MP_Salarian0", Name: "Salarian Infiltrator", PictureFile: "MP_Salarian0.webp"},

	// ---- Turian ------------------------------------------------------------
	{ID: "MP_Turian0", Name: "Turian Soldier", PictureFile: "MP_Turian0.webp"},
	{ID: "MP_TurianENG", Name: "Turian Engineer", PictureFile: "MP_TurianENG.webp"},
	{ID: "MP_TurianINF", Name: "Turian Infiltrator", PictureFile: "MP_TurianINF.webp"},
	{ID: "MP_TurianSLD", Name: "Turian Ghost", PictureFile: "MP_TurianSLD.webp"},
	{ID: "MP_TurianVAN", Name: "Turian Havoc Soldier", PictureFile: "MP_TurianVAN.webp"},

	// ---- Volus -------------------------------------------------------------
	{ID: "MP_VolusADP", Name: "Volus Adept", PictureFile: "MP_VolusADP.webp"},
	{ID: "MP_VolusENG", Name: "Volus Engineer", PictureFile: "MP_VolusENG.webp"},
	{ID: "MP_VolusENG2", Name: "Volus Engineer II", PictureFile: "MP_VolusENG2.webp"},
	{ID: "MP_VolusVAN", Name: "Volus Vanguard", PictureFile: "MP_VolusVAN.webp"},

	// ---- Vorcha ------------------------------------------------------------
	{ID: "MP_Vorcha", Name: "Vorcha Soldier", PictureFile: "MP_Vorcha.webp"},
	{ID: "MP_VorchaENG", Name: "Vorcha Engineer", PictureFile: "MP_VorchaENG.webp"},
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

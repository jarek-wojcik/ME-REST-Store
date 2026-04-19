package model

// VoiceDef describes a voice archetype that can be applied to a Spectre.
//
// Field reference:
//
//	ID          — Unique identifier for this voice. Posted as the {charId}
//	              segment to /api/spectres/{id}/voice/{ID}.
//	RootPath    — UE3 package path prefix, e.g. "BioChar_MPPlayers.Archetypes.Adept".
//	              Leave empty when ID is already the full qualified path.
//	ArchetypeID — Final segment of the UE3 path when it differs from ID.
//	              Leave empty to use ID as the segment.
//	              KitQualifiedPath() = RootPath + "." + (ArchetypeID or ID).
//	Name        — Internal UE3 archetype name / IDLook key.
//	DisplayName — Human-readable label shown in the voice picker UI.
//	CompatibleSpecies — Species names whose appearance characters may use this voice.
type VoiceDef struct {
	ID                string
	RootPath          string
	ArchetypeID       string
	Name              string
	DisplayName       string
	CompatibleSpecies []string
}

// KitQualifiedPath returns the fully-qualified UE3 archetype path for this voice.
func (v VoiceDef) KitQualifiedPath() string {
	if v.RootPath == "" {
		return v.ID
	}
	ai := v.ArchetypeID
	if ai == "" {
		ai = v.ID
	}
	return v.RootPath + "." + ai
}

// ---------------------------------------------------------------------------
// Species defaults
// ---------------------------------------------------------------------------

// SpeciesDefault holds the default appearance and voice to apply when a
// spectre's PreferredSpecies is changed.
type SpeciesDefault struct {
	AppearanceCharID string // CharacterDef.ID to use as default appearance
	VoiceID          string // VoiceDef.ID (= representative CharacterDef.ID) for default voice
}

// SpeciesDefaults maps a species name to its default appearance and voice.
// These are applied automatically whenever the user changes a spectre's
// species filter so both appearance and voice remain consistent.
var SpeciesDefaults = map[string]SpeciesDefault{
	"Android":   {AppearanceCharID: "InfiltratorFembot", VoiceID: "InfiltratorFembot"},
	"Asari":     {AppearanceCharID: "AdeptAsari", VoiceID: "AdeptAsari"},
	"Batarian":  {AppearanceCharID: "SoldierBatarian", VoiceID: "SoldierBatarian"},
	"Collector": {AppearanceCharID: "AdeptCollector", VoiceID: "AdeptCollector"},
	"Drell":     {AppearanceCharID: "AdeptDrell", VoiceID: "AdeptDrell"},
	"Geth":      {AppearanceCharID: "InfiltratorGeth", VoiceID: "InfiltratorGeth"},
	"Human":     {AppearanceCharID: "AdeptHumanFemale", VoiceID: "AdeptHumanFemale"},
	"Krogan":    {AppearanceCharID: "SoldierKrogan", VoiceID: "SoldierKrogan"},
	"Prothean":  {AppearanceCharID: "Char_SimHenchmen.SimJavik", VoiceID: "SoldierN7"},
	"Quarian":   {AppearanceCharID: "EngineerQuarian", VoiceID: "EngineerQuarian"},
	"Salarian":  {AppearanceCharID: "EngineerSalarian", VoiceID: "EngineerSalarian"},
	"Turian":    {AppearanceCharID: "SoldierTurian", VoiceID: "SoldierTurian"},
	"Volus":     {AppearanceCharID: "AdeptVolus", VoiceID: "AdeptVolus"},
	"Vorcha":    {AppearanceCharID: "EngineerVorcha", VoiceID: "EngineerVorcha"},
}

// ---------------------------------------------------------------------------
// Voice catalog — edit this manually, same pattern as CharacterCatalog
// ---------------------------------------------------------------------------

// VoiceCatalog is the full list of available voice archetypes.
// Add or remove entries here; nothing is auto-generated from CharacterCatalog.
var VoiceCatalog = []VoiceDef{
	{
		ID:                "AdeptHumanFemale",
		RootPath:          "BioChar_MPPlayers.Archetypes.Adept",
		Name:              "HumanFemaleRecon",
		DisplayName:       "Human Female",
		CompatibleSpecies: []string{"Human", "Asari", "Android"},
	},
	{
		ID:                "EngineerMerc",
		RootPath:          "BioChar_DLC_MP5_MPPlayers",
		ArchetypeID:       "Engineer_Merc",
		Name:              "EngineerMercenary",
		DisplayName:       "Human Mercernary",
		CompatibleSpecies: []string{"Human"},
	},
	{
		ID:                "AdeptHumanMale",
		RootPath:          "BioChar_MPPlayers.Archetypes.Adept",
		Name:              "HumanMaleRecon",
		DisplayName:       "Human Male",
		CompatibleSpecies: []string{"Human"},
	},
	{
		ID:                "SoldierKrogan",
		RootPath:          "BioChar_MPPlayers.Archetypes.Soldier",
		Name:              "KroganDefault",
		DisplayName:       "Krogan",
		CompatibleSpecies: []string{"Krogan"},
	},
	{
		ID:                "AdeptDrell",
		RootPath:          "BioChar_MPPlayers.Archetypes.Adept",
		Name:              "DrellDefault",
		DisplayName:       "Drell",
		CompatibleSpecies: []string{"Drell"},
	},
	{
		ID:                "AdeptVolus",
		ArchetypeID:       "Adept2_Volus",
		RootPath:          "BioChar_DLC_MP4_MPPlayers",
		Name:              "VolusDefault",
		DisplayName:       "Volus",
		CompatibleSpecies: []string{"Volus"},
	},
	{
		ID:                "VanguardTurianFemale",
		ArchetypeID:       "Vanguard_TurianFemale",
		RootPath:          "BioChar_DLC_MP5_MPPlayers",
		Name:              "TurianFemale",
		DisplayName:       "Turian Female",
		CompatibleSpecies: []string{"Turian"},
	},
	{
		ID:                "SoldierTurian",
		RootPath:          "BioChar_MPPlayers.Archetypes.Soldier",
		Name:              "TurianMale",
		DisplayName:       "Turian Male",
		CompatibleSpecies: []string{"Turian"},
	},
	{
		ID:                "EngineerVorcha",
		ArchetypeID:       "Engineer_Vorcha",
		RootPath:          "BioChar_DLC_MP4_MPPlayers",
		Name:              "VorchaDefault",
		DisplayName:       "Vorcha",
		CompatibleSpecies: []string{"Vorcha"},
	},
	{
		ID:                "InfiltratorFembot",
		ArchetypeID:       "Infiltrator_Fembot",
		RootPath:          "BioChar_DLC_MP5_MPPlayers",
		Name:              "AndroidDefault",
		DisplayName:       "Alliance Infiltrator Unit",
		CompatibleSpecies: []string{"Android"},
	},
	{
		ID:                "AdeptAsari",
		RootPath:          "BioChar_MPPlayers.Archetypes.Adept",
		Name:              "AsariDefault",
		DisplayName:       "Asari",
		CompatibleSpecies: []string{"Asari", "Human"},
	},
	{
		ID:                "InfiltratorGeth",
		ArchetypeID:       "Geth_Infiltrator",
		RootPath:          "BioChar_DLC_MP1_MPPlayers.Archetypes",
		Name:              "GethDefault",
		DisplayName:       "Geth Infiltrator",
		CompatibleSpecies: []string{"Geth"},
	},
	{
		ID:                "SoldierGethDestroyer",
		ArchetypeID:       "Soldier_GethDestroyer",
		RootPath:          "BioChar_DLC_MP5_MPPlayers",
		Name:              "GethDestroyer",
		DisplayName:       "Geth Juggernaut",
		CompatibleSpecies: []string{"Geth"},
	},
	{
		ID:                "SoldierN7",
		ArchetypeID:       "Soldier_N7",
		RootPath:          "BioChar_DLC_MP3_MPPlayers",
		Name:              "N7Soldier",
		DisplayName:       "N7 Devastator",
		CompatibleSpecies: []string{"Human, Prothean"},
	},
	{
		ID:                "EngineerQuarian",
		RootPath:          "BioChar_MPPlayers.Archetypes.Engineer",
		Name:              "QuarianFemale",
		DisplayName:       "Quarian Female",
		CompatibleSpecies: []string{"Quarian"},
	},
	{
		ID:                "InfiltratorQuarianMale",
		ArchetypeID:       "QuarianMale_Infiltrator",
		RootPath:          "BioChar_DLC_MP2_MPPlayers.Archetypes",
		Name:              "QuarianMale",
		DisplayName:       "Quarian Male",
		CompatibleSpecies: []string{"Quarian"},
	},
	{
		ID:                "EngineerSalarian",
		RootPath:          "BioChar_MPPlayers.Archetypes.Engineer",
		Name:              "SalarianDefault",
		DisplayName:       "Salarian",
		CompatibleSpecies: []string{"Salarian"},
	},
	{
		ID:                "SoldierBatarian",
		RootPath:          "BioChar_DLC_MP1_MPPlayers.Archetypes",
		Name:              "BatarianDefault",
		DisplayName:       "Batarian",
		CompatibleSpecies: []string{"Batarian"},
	},
	{
		ID:                "AdeptCollector",
		ArchetypeID:       "Adept_Collector",
		RootPath:          "BioChar_DLC_MP5_MPPlayers",
		Name:              "CollectorDefault",
		DisplayName:       "Collector",
		CompatibleSpecies: []string{"Collector"},
	},
}

// voiceSpeciesOverlaps returns true when any string in vSpecies matches any
// Species value in cSpecies.
func voiceSpeciesOverlaps(vSpecies []string, cSpecies []Species) bool {
	for _, vs := range vSpecies {
		for _, cs := range cSpecies {
			if string(cs) == vs {
				return true
			}
		}
	}
	return false
}

// ---------------------------------------------------------------------------
// Lookup helpers
// ---------------------------------------------------------------------------

// VoiceByID returns the VoiceDef with the given ID, or nil if not found.
func VoiceByID(id string) *VoiceDef {
	for i := range VoiceCatalog {
		if VoiceCatalog[i].ID == id {
			return &VoiceCatalog[i]
		}
	}
	return nil
}

// VoiceForQualifiedPath returns the VoiceDef whose KitQualifiedPath or ID
// matches path. As a fallback it resolves path via CharacterByQualifiedPath and
// then looks up the VoiceDef by the character's ID. Returns nil when not found.
func VoiceForQualifiedPath(path string) *VoiceDef {
	if path == "" {
		return nil
	}
	for i := range VoiceCatalog {
		v := &VoiceCatalog[i]
		if v.ID == path || v.KitQualifiedPath() == path {
			return v
		}
	}
	// Fall back through the character index.
	if c := CharacterByQualifiedPath(path); c != nil {
		return VoiceByID(c.ID)
	}
	return nil
}

// CompatibleVoiceCharsForChar returns a []CharacterDef for each VoiceDef that
// should appear in the voice picker for the given appearance character.
// Priority: if the character has a non-nil VoiceIDs list, only those entries
// are returned. Otherwise falls back to filtering VoiceCatalog by species.
func CompatibleVoiceCharsForChar(appearanceCharID string) []CharacterDef {
	appearanceChar := CharacterByID(appearanceCharID)

	// Per-character explicit list takes priority.
	if appearanceChar != nil && appearanceChar.VoiceIDs != nil {
		result := make([]CharacterDef, 0, len(appearanceChar.VoiceIDs))
		for _, voiceID := range appearanceChar.VoiceIDs {
			if compatibleChar := CharacterByID(voiceID); compatibleChar != nil {
				result = append(result, *compatibleChar)
			}
		}
		return result
	}

	// Fall back to species-level filtering.
	result := make([]CharacterDef, 0, len(VoiceCatalog))
	for _, voice := range VoiceCatalog {
		if appearanceChar != nil && len(voice.CompatibleSpecies) > 0 && !voiceSpeciesOverlaps(voice.CompatibleSpecies, appearanceChar.Species) {
			continue
		}
		if compatibleChar := CharacterByID(voice.ID); compatibleChar != nil {
			result = append(result, *compatibleChar)
		}
	}
	return result
}

// IsVoiceCompatibleWithAppearance reports whether the stored voice ID/path is
// compatible with the given appearance character. Returns true when the voice
// cannot be resolved, so callers only auto-switch on definitive incompatibility.
// Checks VoiceIDs first (if set on the character), then CompatibleSpecies.
func IsVoiceCompatibleWithAppearance(storedVoiceID, appearanceCharID string) bool {
	if storedVoiceID == "" || appearanceCharID == "" {
		return true
	}
	current := VoiceForQualifiedPath(storedVoiceID)
	if current == nil {
		return true // unknown voice; leave unchanged
	}
	c := CharacterByID(appearanceCharID)
	if c == nil {
		return true
	}
	// Per-character explicit list takes priority.
	if c.VoiceIDs != nil {
		for _, vid := range c.VoiceIDs {
			if vid == current.ID {
				return true
			}
		}
		return false
	}
	// Fall back to species-level check.
	if len(current.CompatibleSpecies) == 0 {
		return true
	}
	return voiceSpeciesOverlaps(current.CompatibleSpecies, c.Species)
}

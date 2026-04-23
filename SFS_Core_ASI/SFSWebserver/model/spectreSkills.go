package model

// SkillID is a stable string key used to reference a Spectre skill in the DB.
type SkillID = string

const (
	// InitialSkillPoints is the number of points granted when a Spectre is first created.
	InitialSkillPoints = 10
	// MaxSkillLevel is the maximum number of levels any single skill may reach.
	MaxSkillLevel = 10
)

// SkillDef is the compile-time static definition of one skill.
// Descriptions[i] describes what the character gains upon reaching level i+1.
type SkillDef struct {
	ID           SkillID
	Name         string
	Descriptions [MaxSkillLevel]string
	// BarrierOnly — when true this skill is hidden for Shield-type spectres.
	BarrierOnly bool
	// ShieldOnly — when true this skill is hidden for Barrier-type spectres.
	ShieldOnly bool
}

// SkillCatalog is the ordered, static list of all Spectre skills.
// Order here determines the display order in the UI.
var SkillCatalog = []SkillDef{
	{
		ID:           "CQC",
		Name:         "CQC",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "AssaultTraining",
		Name:         "Assaul Training",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Marksmanship",
		Name:         "Marksmanship",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Gadgets",
		Name:         "Gadgets",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Engineering",
		Name:         "Engineering",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Biotics",
		Name:         "Biotics",
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Barrier",
		Name:         "Barrier",
		BarrierOnly:  true,
		Descriptions: [MaxSkillLevel]string{},
	},
	{
		ID:           "Shielding",
		Name:         "Shielding",
		ShieldOnly:   true,
		Descriptions: [MaxSkillLevel]string{},
	},
}

// SkillByID returns the SkillDef for the given ID, or nil if not found.
func SkillByID(id SkillID) *SkillDef {
	for i := range SkillCatalog {
		if SkillCatalog[i].ID == id {
			return &SkillCatalog[i]
		}
	}
	return nil
}

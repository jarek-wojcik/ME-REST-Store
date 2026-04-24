package model

// SkillID is a stable string key used to reference a Spectre skill in the DB.
type SkillID = string

const (
	// InitialSkillPoints is the number of points granted when a Spectre is first created.
	InitialSkillPoints = 10
	// MaxSkillLevel is the maximum number of levels any single skill may reach.
	MaxSkillLevel = 10
)

var CapstoneLevels = []int{1, 5, 10}

const CapstonesPerLevel = 3

func IsCapstoneLevel(level int) bool {
	return level == 1 || level == 5 || level == 10
}

// SkillDef is the compile-time static definition of one skill.
// Descriptions[i] describes what the character gains upon reaching level i+1.
type SkillDef struct {
	ID           SkillID
	Name         string
	Descriptions [MaxSkillLevel]string
	// CapstoneDescriptions[level-1][choiceIndex] holds the descriptive text
	// for capstone choices. Only entries at capstone levels (1,5,10) are used.
	CapstoneDescriptions [MaxSkillLevel][CapstonesPerLevel]string
	// CapstoneTitles[level-1][choiceIndex] is the short heading for each
	// capstone choice (renders as the tooltip title). Only capstone levels
	// (1,5,10) need entries.
	CapstoneTitles [MaxSkillLevel][CapstonesPerLevel]string
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
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Swift Takedown", "Precise Swipe", "Knockback"},
			4: {"Momentum Strike", "Staggering Assault", "Unrelenting Combo"},
			9: {"Champion's Finish", "Opener's Devastation", "Tactical Mastery"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Swift", "Precise", "Knockback"},
			4: {"Momentum", "Stagger", "Combo"},
			9: {"Champion", "Opener", "Mastery"},
		},
	},
	{
		ID:           "AssaultTraining",
		Name:         "Assaul Training",
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Reinforced Grip", "Quick Aim", "Suppressive Fire"},
			4: {"Rapid Fire", "Overcharge", "Armor Piercing"},
			9: {"Assault Mastery", "Barrage", "Tactical Onslaught"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Grip", "Quick Aim", "Suppress"},
			4: {"Rapid", "Overcharge", "AP"},
			9: {"Mastery", "Barrage", "Onslaught"},
		},
	},
	{
		ID:           "Marksmanship",
		Name:         "Marksmanship",
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Steady Hand", "Focused Aim", "Piercing Shot"},
			4: {"Deadeye", "Critical Weakness", "Lethal Precision"},
			9: {"Marksman Legend", "One Shot One Kill", "Eagle Eye"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Steady", "Focused", "Pierce"},
			4: {"Deadeye", "Critical", "Lethal"},
			9: {"Legend", "OneShot", "Eagle"},
		},
	},
	{
		ID:           "Gadgets",
		Name:         "Gadgets",
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Deploy Drone", "Tactical Mine", "Recon Beacon"},
			4: {"Advanced Drone", "Cluster Mines", "Holo Decoy"},
			9: {"Master Engineer", "Omni-Drone", "Field Overdrive"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Drone", "Mine", "Recon"},
			4: {"Adv Drone", "Cluster", "Decoy"},
			9: {"Master", "Omni", "Overdrive"},
		},
	},
	{
		ID:   "Engineering",
		Name: "Engineering",
		Descriptions: [MaxSkillLevel]string{
			"A",
			"B",
			"C",
		},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Overload Burst", "EMP Pulse", "Static Field"},
			4: {"Enhanced Overload", "Chain Reaction", "Reactive Shield"},
			9: {"Tech Ascendancy", "Systemic Shutdown", "Quantum Overload"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Burst", "EMP", "Static"},
			4: {"Enhanced", "Chain", "Reactive"},
			9: {"Ascend", "Shutdown", "Quantum"},
		},
	},
	{
		ID:           "Biotics",
		Name:         "Biotics",
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Nova Push", "Biotic Sting", "Lift Kick"},
			4: {"Singularity Burst", "Shockwave", "Rift"},
			9: {"Biotic Mastery", "Void Nova", "Psionic Storm"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Nova", "Sting", "Lift"},
			4: {"Singularity", "Shock", "Rift"},
			9: {"Mastery", "Void", "Storm"},
		},
	},
	{
		ID:           "Barrier",
		Name:         "Barrier",
		BarrierOnly:  true,
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Minor Barrier", "Shield Lash", "Fortify"},
			4: {"Reflective Barrier", "Energy Absorb", "Barrier Surge"},
			9: {"Aegis", "Impenetrable Shell", "Barrier Overdrive"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Minor", "Lash", "Fortify"},
			4: {"Reflect", "Absorb", "Surge"},
			9: {"Aegis", "Shell", "Overdrive"},
		},
	},
	{
		ID:           "Shielding",
		Name:         "Shielding",
		ShieldOnly:   true,
		Descriptions: [MaxSkillLevel]string{},
		CapstoneDescriptions: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Kinetic Shield", "Shield Boost", "Adaptive Shield"},
			4: {"Regenerative Shield", "Shield Matrix", "Energy Redirect"},
			9: {"Shield Mastery", "Absolute Protection", "Shield Overdrive"},
		},
		CapstoneTitles: [MaxSkillLevel][CapstonesPerLevel]string{
			0: {"Kinetic", "Boost", "Adaptive"},
			4: {"Regen", "Matrix", "Redirect"},
			9: {"Mastery", "Absolute", "Overdrive"},
		},
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

package model

// SkillID is a stable string key used to reference a Spectre skill in the DB.
type SkillID = string

const (
	// InitialSkillPoints is the number of points granted when a Spectre is first created.
	InitialSkillPoints = 10
	// MaxSkillLevel is the maximum number of levels any single skill may reach.
	MaxSkillLevel = 10
)

// Capstones are now defined per-skill in SkillDef.Capstones.
// The old global CapstoneLevels/CapstonesPerLevel/IsCapstoneLevel helpers
// have been removed in favor of per-skill configuration.

// Capstone describes one selectable capstone choice for a skill at a
// particular level. Level is stored zero-based (0 == UI level 1).
type Capstone struct {
	ID          string // stable id for this capstone choice (optional)
	Title       string // short heading shown in the UI
	Description string // full descriptive tooltip text
	Level       int    // zero-based level index where this capstone appears
}

// SkillDef is the compile-time static definition of one skill.
// Descriptions[i] describes what the character gains upon reaching level i+1.
type SkillDef struct {
	ID           SkillID
	Name         string
	Descriptions [MaxSkillLevel]string
	// CapstoneDescriptions[level-1][choiceIndex] holds the descriptive text
	// for capstone choices. Only entries at capstone levels (1,5,10) are used.
	Capstones []Capstone
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
		Capstones: []Capstone{
			{ID: "CQC_0_1", Title: "Swift", Description: "Swift Takedown", Level: 0},
			{ID: "CQC_0_2", Title: "Precise", Description: "Precise Swipe", Level: 0},
			{ID: "CQC_0_3", Title: "Knockback", Description: "Knockback", Level: 0},
			{ID: "CQC_4_1", Title: "Ultra Instinct", Description: "You are immune to all sync kills grabs or staggers", Level: 4},
			{ID: "CQC_4_2", Title: "Stagger", Description: "Staggering Assault", Level: 4},
			{ID: "CQC_4_3", Title: "Combo", Description: "Unrelenting Combo", Level: 4},
			{ID: "CQC_9_1", Title: "Champion", Description: "Champion's Finish", Level: 9},
			{ID: "CQC_9_2", Title: "Opener", Description: "Opener's Devastation", Level: 9},
			{ID: "CQC_9_3", Title: "Mastery", Description: "Tactical Mastery", Level: 9},
		},
	},
	{
		ID:           "AssaultTraining",
		Name:         "Assaul Training",
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "AssaultTraining_0_1", Title: "Grip", Description: "Reinforced Grip", Level: 0},
			{ID: "AssaultTraining_0_2", Title: "Quick Aim", Description: "Quick Aim", Level: 0},
			{ID: "AssaultTraining_0_3", Title: "Suppress", Description: "Suppressive Fire", Level: 0},
			{ID: "AssaultTraining_4_1", Title: "Rapid", Description: "Rapid Fire", Level: 4},
			{ID: "AssaultTraining_4_2", Title: "Overcharge", Description: "Overcharge", Level: 4},
			{ID: "AssaultTraining_4_3", Title: "AP", Description: "Armor Piercing", Level: 4},
			{ID: "AssaultTraining_9_1", Title: "Mastery", Description: "Assault Mastery", Level: 9},
			{ID: "AssaultTraining_9_2", Title: "Barrage", Description: "Barrage", Level: 9},
			{ID: "AssaultTraining_9_3", Title: "Onslaught", Description: "Tactical Onslaught", Level: 9},
		},
	},
	{
		ID:           "Marksmanship",
		Name:         "Marksmanship",
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "Marksmanship_0_1", Title: "Outlaw", Description: "Precision kills greatly decrease reload time.", Level: 0},
			{ID: "Marksmanship_0_2", Title: "Controlled Breathing", Description: "Aiming your weapon for a short time before firing, grants increased precision damage.", Level: 0},
			{ID: "Marksmanship_0_3", Title: "Familiar Weight", Description: "Semi-automatic rifles do not affect your power cooldowns", Level: 0},
			{ID: "Marksmanship_4_1", Title: "Sensor Array", Description: "Enemies are highlighted through walls at a great distance.", Level: 4},
			{ID: "Marksmanship_4_2", Title: "Reposition", Description: "Moving into cover recharges a portion of shields, and partially reloads your current weapon.", Level: 4},
			{ID: "Marksmanship_4_3", Title: "Stunning Shot", Description: "Shots from your semi-automatic rifles can temporarily stun enemies.", Level: 4},
			{ID: "Marksmanship_9_1", Title: "Vantablack", Description: "Your Semi-Automatic rifles now have a charge time, and deal area damage.", Level: 9},
			{ID: "Marksmanship_9_2", Title: "Ex-Wife Rounds", Description: "Shots from your semi-automatic rifles penetrate through all surfaces.", Level: 9},
			{ID: "Marksmanship_9_3", Title: "Chained Shot", Description: "Your headshots do not consume ammo.", Level: 9},
		},
	},
	{
		ID:           "CovertOps",
		Name:         "Covert Ops",
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "CovertOps_0_1", Title: "Jika-Tabi", Description: "Sprinting for a short time grants a boost to movement speed for 8 seconds.", Level: 0},
			{ID: "CovertOps_0_2", Title: "Tactical Advantage", Description: "Whenever you roll, reduce your active cooldown.", Level: 0},
			{ID: "CovertOps_0_3", Title: "Ambush", Description: "Deal 2x damage to enemies above 75% health.", Level: 0},
			{ID: "CovertOps_4_1", Title: "Kinetic Converters", Description: "Dodging recharges a portion of the shields.", Level: 4},
			{ID: "CovertOps_4_2", Title: "Thrill of the hunt", Description: "Hitting enemies with powers, drastically reduces their speed.", Level: 4},
			{ID: "CovertOps_4_3", Title: "Chameleon", Description: "If you haven't moved in the last 3 seconds, enter cloak.", Level: 4},
			{ID: "CovertOps_9_1", Title: "Quantum Translocator", Description: "Your dodge now leaves a quantum beacon. Dodge again to teleport back to the beacon.", Level: 9},
			{ID: "CovertOps_9_2", Title: "Mirror Image", Description: "Dodging leaves behing an invulnerable construct dealing 50% of player damage\n3 decoys can be active at a time, each lasting 10 seconds.", Level: 9},
			{ID: "CovertOps_9_3", Title: "Impossible Target", Description: "Entering cloak grants invincibility for 3 seconds.\nKilling a nearby enemy while this effect is active, cloaks the operative.", Level: 9},
		},
	},
	{
		ID:           "Gadgets",
		Name:         "Gadgets",
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "Gadgets_0_1", Title: "Drone", Description: "Deploy Drone", Level: 0},
			{ID: "Gadgets_0_2", Title: "Mine", Description: "Tactical Mine", Level: 0},
			{ID: "Gadgets_0_3", Title: "Recon", Description: "Recon Beacon", Level: 0},
			{ID: "Gadgets_4_1", Title: "Adv Drone", Description: "Advanced Drone", Level: 4},
			{ID: "Gadgets_4_2", Title: "Cluster", Description: "Cluster Mines", Level: 4},
			{ID: "Gadgets_4_3", Title: "Decoy", Description: "Holo Decoy", Level: 4},
			{ID: "Gadgets_9_1", Title: "Master", Description: "Master Engineer", Level: 9},
			{ID: "Gadgets_9_2", Title: "Omni", Description: "Omni-Drone", Level: 9},
			{ID: "Gadgets_9_3", Title: "Overdrive", Description: "Field Overdrive", Level: 9},
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
		Capstones: []Capstone{
			{ID: "Engineering_0_1", Title: "Burst", Description: "Overload Burst", Level: 0},
			{ID: "Engineering_0_2", Title: "EMP", Description: "EMP Pulse", Level: 0},
			{ID: "Engineering_0_3", Title: "Static", Description: "Static Field", Level: 0},
			{ID: "Engineering_4_1", Title: "Enhanced", Description: "Enhanced Overload", Level: 4},
			{ID: "Engineering_4_2", Title: "Chain", Description: "Chain Reaction", Level: 4},
			{ID: "Engineering_4_3", Title: "Reactive", Description: "Reactive Shield", Level: 4},
			{ID: "Engineering_9_1", Title: "Ascend", Description: "Tech Ascendancy", Level: 9},
			{ID: "Engineering_9_2", Title: "Shutdown", Description: "Systemic Shutdown", Level: 9},
			{ID: "Engineering_9_3", Title: "Quantum", Description: "Quantum Overload", Level: 9},
		},
	},
	{
		ID:           "Biotics",
		Name:         "Biotics",
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "Biotics_0_1", Title: "Nova", Description: "Nova Push", Level: 0},
			{ID: "Biotics_0_2", Title: "Sting", Description: "Biotic Sting", Level: 0},
			{ID: "Biotics_0_3", Title: "Lift", Description: "Lift Kick", Level: 0},
			{ID: "Biotics_4_1", Title: "Singularity", Description: "Singularity Burst", Level: 4},
			{ID: "Biotics_4_2", Title: "Shock", Description: "Shockwave", Level: 4},
			{ID: "Biotics_4_3", Title: "Rift", Description: "Rift", Level: 4},
			{ID: "Biotics_9_1", Title: "Mastery", Description: "Biotic Mastery", Level: 9},
			{ID: "Biotics_9_2", Title: "Void", Description: "Void Nova", Level: 9},
			{ID: "Biotics_9_3", Title: "Storm", Description: "Psionic Storm", Level: 9},
		},
	},
	{
		ID:           "Barrier",
		Name:         "Barrier",
		BarrierOnly:  true,
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "Barrier_0_1", Title: "Minor", Description: "Minor Barrier", Level: 0},
			{ID: "Barrier_0_2", Title: "Lash", Description: "Shield Lash", Level: 0},
			{ID: "Barrier_0_3", Title: "Fortify", Description: "Fortify", Level: 0},
			{ID: "Barrier_4_1", Title: "Reflect", Description: "Reflective Barrier", Level: 4},
			{ID: "Barrier_4_2", Title: "Absorb", Description: "Energy Absorb", Level: 4},
			{ID: "Barrier_4_3", Title: "Surge", Description: "Barrier Surge", Level: 4},
			{ID: "Barrier_9_1", Title: "Aegis", Description: "Aegis", Level: 9},
			{ID: "Barrier_9_2", Title: "Shell", Description: "Impenetrable Shell", Level: 9},
			{ID: "Barrier_9_3", Title: "Overdrive", Description: "Barrier Overdrive", Level: 9},
		},
	},
	{
		ID:           "Shielding",
		Name:         "Shielding",
		ShieldOnly:   true,
		Descriptions: [MaxSkillLevel]string{},
		Capstones: []Capstone{
			{ID: "Shielding_0_1", Title: "Kinetic", Description: "Kinetic Shield", Level: 0},
			{ID: "Shielding_0_2", Title: "Boost", Description: "Shield Boost", Level: 0},
			{ID: "Shielding_0_3", Title: "Adaptive", Description: "Adaptive Shield", Level: 0},
			{ID: "Shielding_4_1", Title: "Regen", Description: "Regenerative Shield", Level: 4},
			{ID: "Shielding_4_2", Title: "Matrix", Description: "Shield Matrix", Level: 4},
			{ID: "Shielding_4_3", Title: "Redirect", Description: "Energy Redirect", Level: 4},
			{ID: "Shielding_9_1", Title: "Mastery", Description: "Shield Mastery", Level: 9},
			{ID: "Shielding_9_2", Title: "Absolute", Description: "Absolute Protection", Level: 9},
			{ID: "Shielding_9_3", Title: "Overdrive", Description: "Shield Overdrive", Level: 9},
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

// CapstonesForLevel returns the slice of capstones defined for the given
// skill definition at the UI level `levelNum` (1-based). Returns nil when
// no capstones exist for that level.
func CapstonesForLevel(def *SkillDef, levelNum int) []Capstone {
	if def == nil {
		return nil
	}
	lvlIdx := levelNum - 1
	var out []Capstone
	for _, c := range def.Capstones {
		if c.Level == lvlIdx {
			out = append(out, c)
		}
	}
	return out
}

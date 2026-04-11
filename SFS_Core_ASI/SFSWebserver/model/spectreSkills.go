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
		ID:   "Pistols",
		Name: "Pistols",
		Descriptions: [MaxSkillLevel]string{
			"Sidearm basics. +5% pistol damage.",
			"+10% pistol damage. Improved grip reduces recoil.",
			"+15% pistol damage. +10% pistol ammo capacity.",
			"+20% pistol damage. 10% faster pistol reload.",
			"+25% pistol damage. Improved hipfire accuracy.",
			"+30% pistol damage. Headshot damage bonus increased.",
			"+35% pistol damage. Draw pistol 15% faster.",
			"+40% pistol damage. +15% pistol ammo capacity.",
			"+45% pistol damage. Rounds penetrate light cover.",
			"+50% pistol damage. Pistol Master: maximum stability at all ranges.",
		},
	},
	{
		ID:   "SMGs",
		Name: "SMGs",
		Descriptions: [MaxSkillLevel]string{
			"SMG proficiency. +5% SMG damage.",
			"+10% SMG damage. Reduced spread while moving.",
			"+15% SMG damage. +10% SMG ammo capacity.",
			"+20% SMG damage. 10% faster SMG reload.",
			"+25% SMG damage. Increased sustained-fire stability.",
			"+30% SMG damage. Improved suppression at close range.",
			"+35% SMG damage. Spin-up time reduced by 20%.",
			"+40% SMG damage. +15% SMG ammo capacity.",
			"+45% SMG damage. Rounds penetrate light cover.",
			"+50% SMG damage. SMG Master: full accuracy at max fire rate.",
		},
	},
	{
		ID:   "AssaultRifles",
		Name: "Assault Rifles",
		Descriptions: [MaxSkillLevel]string{
			"Assault rifle operation. +5% AR damage.",
			"+10% AR damage. Reduced recoil per burst.",
			"+15% AR damage. +10% AR ammo capacity.",
			"+20% AR damage. 10% faster AR reload.",
			"+25% AR damage. Improved accuracy at long range.",
			"+30% AR damage. +10% damage bonus while in cover.",
			"+35% AR damage. Scope transition 15% faster.",
			"+40% AR damage. +15% AR ammo capacity.",
			"+45% AR damage. Rounds penetrate medium cover.",
			"+50% AR damage. Assault Rifle Master: pinpoint accuracy at all ranges.",
		},
	},
	{
		ID:   "Shotguns",
		Name: "Shotguns",
		Descriptions: [MaxSkillLevel]string{
			"Close-quarters proficiency. +5% shotgun damage.",
			"+10% shotgun damage. Tighter spread pattern.",
			"+15% shotgun damage. +10% shotgun ammo capacity.",
			"+20% shotgun damage. 10% faster shotgun reload.",
			"+25% shotgun damage. +15% pellet damage at point-blank.",
			"+30% shotgun damage. Impact force increases stagger chance.",
			"+35% shotgun damage. +10% damage bonus after reload for 3s.",
			"+40% shotgun damage. +15% shotgun ammo capacity.",
			"+45% shotgun damage. Slugs penetrate enemy shields.",
			"+50% shotgun damage. Shotgun Master: full choke at any range.",
		},
	},
	{
		ID:   "SniperRifles",
		Name: "Sniper Rifles",
		Descriptions: [MaxSkillLevel]string{
			"Long-range marksmanship. +5% sniper damage.",
			"+10% sniper damage. Sway dampening while scoped.",
			"+15% sniper damage. +10% sniper ammo capacity.",
			"+20% sniper damage. 10% faster sniper reload.",
			"+25% sniper damage. Headshot critical bonus +25%.",
			"+30% sniper damage. Target-acquisition time reduced.",
			"+35% sniper damage. Cloak disruption on hit.",
			"+40% sniper damage. +15% sniper ammo capacity.",
			"+45% sniper damage. Rounds penetrate one target.",
			"+50% sniper damage. Sniper Master: zero sway, instant scope lock.",
		},
	},
	{
		ID:   "MeleeCombat",
		Name: "Melee Combat",
		Descriptions: [MaxSkillLevel]string{
			"Close-combat proficiency. +5% melee damage.",
			"+10% melee damage. Reduced recovery after heavy melee.",
			"+15% melee damage. Light melee staggers enemies.",
			"+20% melee damage. Counter-attack window widened.",
			"+25% melee damage. Unlocks ground-slam follow-up.",
			"+30% melee damage. +10% movement speed during melee.",
			"+35% melee damage. Heavy melee cooldown –10%.",
			"+40% melee damage. Melee attacks breach enemy shields.",
			"+45% melee damage. Finishing blows restore 5% shields.",
			"+50% melee damage. Melee Master: all strikes stagger and interrupt.",
		},
	},
	{
		ID:   "Gadgets",
		Name: "Gadgets",
		Descriptions: [MaxSkillLevel]string{
			"Equipment fundamentals. Grenade capacity +1.",
			"Grenade capacity +1. Grenade fuse delay –10%.",
			"Grenade capacity +1. +5% grenade damage.",
			"Grenade capacity +1. Throw distance +20%.",
			"Grenade capacity +1. +15% grenade damage.",
			"+5% proximity mine damage. Increased activation range.",
			"+10% mine damage. Homing grenade mode unlocked.",
			"+15% mine damage. Double grenade throw arc.",
			"+20% mine damage. Grenade arming delay eliminated.",
			"+25% all throwable damage. Gadget Master: unlimited gadget synergy.",
		},
	},
	{
		ID:   "Tech",
		Name: "Tech",
		Descriptions: [MaxSkillLevel]string{
			"Omni-tool fundamentals. +5% tech power damage.",
			"+10% tech power damage. Tech cooldown –5%.",
			"+15% tech power damage. +10% tech power duration.",
			"+20% tech power damage. Tech cooldown –5%.",
			"+25% tech power damage. AI Hacking range +20%.",
			"+30% tech power damage. Incinerate & Disruptor Ammo +15%.",
			"+35% tech power damage. Tech cooldown –5%.",
			"+40% tech power damage. Combat Drone health +25%.",
			"+45% tech power damage. Tech Burst radius +20%.",
			"+50% tech power damage. Tech Master: all tech powers –20% cooldown.",
		},
	},
	{
		ID:   "Biotics",
		Name: "Biotics",
		Descriptions: [MaxSkillLevel]string{
			"Biotic fundamentals. +5% biotic power damage.",
			"+10% biotic power damage. Biotic cooldown –5%.",
			"+15% biotic power damage. +10% biotic power force.",
			"+20% biotic power damage. Biotic cooldown –5%.",
			"+25% biotic power damage. Warp damage-over-time +15%.",
			"+30% biotic power damage. Biotic Explosions +20%.",
			"+35% biotic power damage. Biotic cooldown –5%.",
			"+40% biotic power damage. Singularity radius +20%.",
			"+45% biotic power damage. Power kills recharge biotics.",
			"+50% biotic power damage. Biotic Master: all biotics –20% cooldown.",
		},
	},
	{
		ID:          "Barrier",
		Name:        "Barrier",
		BarrierOnly: true,
		Descriptions: [MaxSkillLevel]string{
			"Biotic barrier control. +5% barrier strength.",
			"+10% barrier strength. Barrier recharge delay –5%.",
			"+15% barrier strength. Barrier recharge delay –5%.",
			"+20% barrier strength. Barrier recharge delay –5%.",
			"+25% barrier strength. Barrier recharge triggers on kill.",
			"+30% barrier strength. Barrier energy absorption +10%.",
			"+35% barrier strength. Biotic melee recharges barrier.",
			"+40% barrier strength. Barrier recharge delay –5%.",
			"+45% barrier strength. Depletion emits a stagger pulse.",
			"+50% barrier strength. Barrier Master: instant recharge at full biotic charge.",
		},
	},
	{
		ID:         "Shielding",
		Name:       "Shielding",
		ShieldOnly: true,
		Descriptions: [MaxSkillLevel]string{
			"Kinetic shield enhancement. +5% shield strength.",
			"+10% shield strength. Shield recharge delay –5%.",
			"+15% shield strength. Shield recharge delay –5%.",
			"+20% shield strength. Shield recharge delay –5%.",
			"+25% shield strength. Shield recharge triggers on power use.",
			"+30% shield strength. Shield energy absorption +10%.",
			"+35% shield strength. Moving no longer interrupts recharge.",
			"+40% shield strength. Shield recharge delay –5%.",
			"+45% shield strength. Depletion emits a brief stagger pulse.",
			"+50% shield strength. Shield Master: instant recharge under fire.",
		},
	},
	{
		ID:   "SpectreTraining",
		Name: "Spectre Training",
		Descriptions: [MaxSkillLevel]string{
			"N7 field certification. +2% all damage, –2% damage taken.",
			"+4% all damage. –2% damage taken.",
			"+6% all damage. –3% damage taken.",
			"+8% all damage. –3% damage taken.",
			"+10% all damage. –4% damage taken. Power recharge +5%.",
			"+12% all damage. –4% damage taken. Power recharge +5%.",
			"+14% all damage. –5% damage taken. Power recharge +5%.",
			"+16% all damage. –5% damage taken. Power recharge +10%.",
			"+18% all damage. –6% damage taken. Power recharge +10%.",
			"+20% all damage. Spectre Elite: –8% damage taken, all recharge –15%.",
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

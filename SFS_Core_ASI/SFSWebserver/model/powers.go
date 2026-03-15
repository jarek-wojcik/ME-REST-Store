package model

// PowerDef is a read-only definition of a power.
// ID doubles as the icon sprite filename stem (e.g. "Singularity" → "Singularity.webp").
// It is compiled into the binary and never stored in BoltDB.
type PowerDef struct {
	ID   string // = icon file stem in /static/assets/powers/
	Name string
}

// IconURL returns the URL for the power's sprite sheet.
func (p PowerDef) IconURL() string {
	return "/static/assets/powers/" + p.ID + ".webp"
}

// PowerCatalog lists every unique power icon set.
var PowerCatalog = []PowerDef{
	{ID: "AdrenalineRush", Name: "Adrenaline Rush"},
	{ID: "AnnihilationSphere", Name: "Annihilation Field"},
	{ID: "Barrier", Name: "Barrier"},
	{ID: "BatarianArmor", Name: "Batarian Armor"},
	{ID: "BatarianAttack", Name: "Batarian Kick"},
	{ID: "BatarianNet", Name: "Batarian Net"},
	{ID: "BioticCharge", Name: "Biotic Charge"},
	{ID: "BioticFocus", Name: "Biotic Focus"},
	{ID: "BioticGrenade", Name: "Biotic Grenade"},
	{ID: "BioticHammerModal", Name: "Biotic Hammer"},
	{ID: "BioticOrbs", Name: "Dark Energy Orbs"},
	{ID: "Bloodlust", Name: "Bloodlust"},
	{ID: "BowModalOne", Name: "Bow Shot"},
	{ID: "BowModalTwo", Name: "Bow Explosive Shot"},
	{ID: "BubbleShield", Name: "Barrier Bubbles"},
	{ID: "CainMine", Name: "M-920 Cain Mine"},
	{ID: "Carnage", Name: "Carnage"},
	{ID: "Cloak", Name: "Tactical Cloak"},
	{ID: "CombatDrone", Name: "Combat Drone"},
	{ID: "ConcussiveShot", Name: "Concussive Shot"},
	{ID: "CryoBlast", Name: "Cryo Blast"},
	{ID: "CryoCone", Name: "Cryo Cone"},
	{ID: "Damping", Name: "Damping"},
	{ID: "DarkChannel", Name: "Dark Channel"},
	{ID: "DarkSingularity", Name: "Dark Singularity"},
	{ID: "Decoy", Name: "Decoy"},
	{ID: "DevestatorMode", Name: "Devastator Mode"},
	{ID: "Discharge", Name: "Neural Shock"},
	{ID: "ElectricSlash", Name: "Electric Slash"},
	{ID: "EMPGrenade", Name: "EMP Grenade"},
	{ID: "EnergyDrain", Name: "Energy Drain"},
	{ID: "Flamer", Name: "Flamer"},
	{ID: "Fortification", Name: "Fortification"},
	{ID: "FragGrenade", Name: "Frag Grenade"},
	{ID: "GethTurret", Name: "Geth Turret"},
	{ID: "Hacking", Name: "AI Hacking"},
	{ID: "HavocStrike", Name: "Havoc Strike"},
	{ID: "HexShield", Name: "Hex Shield"},
	{ID: "HomingGrenade", Name: "Homing Grenade"},
	{ID: "Incinerate", Name: "Incinerate"},
	{ID: "InfernoGrenade", Name: "Inferno Grenade"},
	{ID: "KroganBioticCharge", Name: "Biotic Charge (Krogan)"},
	{ID: "Lash", Name: "Lash"},
	{ID: "LiftGrenade", Name: "Lift Grenade"},
	{ID: "LineStrike", Name: "Line Strike"},
	{ID: "Marksman", Name: "Marksman"},
	{ID: "MissileLauncher", Name: "Missile Launcher"},
	{ID: "MPMeleePassive", Name: "Fitness"},
	{ID: "MPPassive", Name: "Combat Fitness"},
	{ID: "MultiFragGrenade", Name: "Multi Frag Grenade"},
	{ID: "Overload", Name: "Overload"},
	{ID: "PalmBlaster", Name: "Nova"},
	{ID: "ProximityMine", Name: "Proximity Mine"},
	{ID: "Pull", Name: "Pull"},
	{ID: "Reave", Name: "Reave"},
	{ID: "ReconMine", Name: "Recon Mine"},
	{ID: "RepairMatrix", Name: "Repair Matrix"},
	{ID: "SeekerSwarm", Name: "Seeker Swarm"},
	{ID: "SentryTurret", Name: "Sentry Turret"},
	{ID: "ShadowStrike", Name: "Shadow Strike"},
	{ID: "ShieldBoost", Name: "Shield Boost"},
	{ID: "Shockwave", Name: "Shockwave"},
	{ID: "SiegePulse", Name: "Siege Pulse"},
	{ID: "Singularity", Name: "Singularity"},
	{ID: "SonicSlash", Name: "Sonic Slash"},
	{ID: "Stasis", Name: "Stasis"},
	{ID: "StickyGrenade", Name: "Sticky Grenade"},
	{ID: "StimPack", Name: "Stim Pack"},
	{ID: "Supercharge", Name: "Geth Turbocharge"},
	{ID: "SupplyTurret", Name: "Supply Drone"},
	{ID: "TechArmor", Name: "Tech Armor"},
	{ID: "TechHammerModal", Name: "Tech Hammer"},
	{ID: "Throw", Name: "Throw"},
	{ID: "VenomTippedBlades", Name: "Venom-Tipped Blades"},
	{ID: "Warp", Name: "Warp"},
	{ID: "WhipSmash", Name: "Smash"},
}

// powerIndex is built once at startup for O(1) lookups.
var powerIndex = func() map[string]*PowerDef {
	m := make(map[string]*PowerDef, len(PowerCatalog))
	for i := range PowerCatalog {
		m[PowerCatalog[i].ID] = &PowerCatalog[i]
	}
	return m
}()

// PowerByID returns the PowerDef for the given ID, or nil if not found.
func PowerByID(id string) *PowerDef {
	return powerIndex[id]
}

// DefaultPower returns a fresh PowerSlot for the given power ID with rank 0
// and all evolutions defaulting to "A".
func DefaultPower(id string) PowerSlot {
	return PowerSlot{
		PowerID:   id,
		Rank:      0,
		Evolution: [3]string{"A", "A", "A"},
	}
}

package model

import (
	"strconv"
	"strings"
)

// RankDesc holds a short description for a specific power rank.
// Indices 1–3 map to ranks 1–3; then for the evolution ranks:
//
//	4 = Rank 4 Evo A,  5 = Rank 4 Evo B
//	6 = Rank 5 Evo A,  7 = Rank 5 Evo B
//	8 = Rank 6 Evo A,  9 = Rank 6 Evo B
//
// It is compiled into the binary and never stored in BoltDB.
type RankDesc struct {
	Rank        int
	Description string
}

// PowerDef is a read-only definition of a power.
// ID is the logical power identifier; Picture is the webp filename under /static/assets/powers/.
// Both are compiled into the binary and never stored in BoltDB.
type PowerDef struct {
	ID        string
	Name      string
	Picture   string     // filename in /static/assets/powers/, e.g. "Warp.webp"
	RankDescs []RankDesc // descriptions indexed 1–9 (see RankDesc comment for the mapping)
}

// IconURL returns the URL for the power's sprite sheet.
func (p PowerDef) IconURL() string {
	return "/static/assets/powers/" + p.Picture
}

// DescForRank returns the description for the given index (1–9, per the RankDesc scheme).
// Actual newline characters are converted to the JS escape sequence \n so the
// value is safe to embed inside a single-quoted JS string in an Alpine attribute.
// Falls back to the raw index as a string when no entry is present.
func (p PowerDef) DescForRank(rank int) string {
	for _, rd := range p.RankDescs {
		if rd.Rank == rank {
			return strings.ReplaceAll(rd.Description, "\n", `\n`)
		}
	}
	return "Rank " + strconv.Itoa(rank)
}

// PowerCatalog lists every unique power icon set.
var PowerCatalog = []PowerDef{

	//Base Game Power -------------------------
	{
		ID: "SFXPowerCustomActionMP_Marksman", Name: "Marksman", Picture: "Marksman.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_LiftGrenade", Name: "Lift Grenade", Picture: "LiftGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Incinerate", Name: "Incinerate", Picture: "Incinerate.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_InfernoGrenade", Name: "Inferno Grenade", Picture: "InfernoGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AIHacking", Name: "AI Hacking", Picture: "Hacking.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Fortification", Name: "Fortification", Picture: "Fortification.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FragGrenade", Name: "Frag Grenade", Picture: "FragGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_EnergyDrain", Name: "Energy Drain", Picture: "EnergyDrain.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Discharge", Name: "Neural Shock", Picture: "Discharge.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Decoy", Name: "Decoy", Picture: "Decoy.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DarkChannel", Name: "Dark Channel", Picture: "DarkChannel.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Carnage", Name: "Carnage", Picture: "Carnage.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Cloak", Name: "Tactical Cloak", Picture: "Cloak.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CombatDrone", Name: "Combat Drone", Picture: "CombatDrone.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ConcussiveShot", Name: "Concussive Shot", Picture: "ConcussiveShot.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CryoBlast", Name: "Cryo Blast", Picture: "CryoBlast.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticGrenade", Name: "Biotic Grenade", Picture: "BioticGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticCharge", Name: "Biotic Charge", Picture: "BioticCharge.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Barrier", Name: "Barrier", Picture: "Barrier.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AdrenalineRush", Name: "Adrenaline Rush", Picture: "AdrenalineRush.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ProximityMine", Name: "Proximity Mine", Picture: "ProximityMine.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Pull", Name: "Pull", Picture: "Pull.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Reave", Name: "Reave", Picture: "Reave.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethShieldBoost", Name: "Shield Boost", Picture: "ShieldBoost.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Shockwave", Name: "Shockwave", Picture: "Shockwave.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Overload", Name: "Overload", Picture: "Overload.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SentryTurret", Name: "Sentry Turret", Picture: "SentryTurret.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Stasis", Name: "Stasis", Picture: "Stasis.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_StickyGrenade", Name: "Sticky Grenade", Picture: "StickyGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Singularity", Name: "Singularity", Picture: "Singularity.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechArmor", Name: "Tech Armor", Picture: "TechArmor.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Throw", Name: "Throw", Picture: "Throw.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Warp", Name: "Warp", Picture: "Warp.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},

	//Melee Passives --------------------------
	{
		ID: "SFXPowerCustomActionMP_AsariMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Adept", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "FXPowerCustomActionMP_HumanMeleePassive_Engineer", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Soldier", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DrellMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemQuarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TurianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SalarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},

	//Fitness Passives ------------------------
	{
		ID: "SFXPowerCustomActionMP_HumanPassive", Name: "Alliance Training", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DrellPassive", Name: "Drell Assassin", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganPassive", Name: "Krogan Berserker", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemQuarianPassive", Name: "Quarian Defender", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariPassive", Name: "Asari Justicar", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TurianPassive", Name: "Turian Veteran", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SalarianPassive", Name: "Salarian Operative", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},

	//DLC Powers -----------------------------
	{
		ID: "MultiFragGrenade", Name: "Multi Frag Grenade", Picture: "MultiFragGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "PalmBlaster", Name: "Nova", Picture: "PalmBlaster.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "ReconMine", Name: "Recon Mine", Picture: "ReconMine.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "RepairMatrix", Name: "Repair Matrix", Picture: "RepairMatrix.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SeekerSwarm", Name: "Seeker Swarm", Picture: "SeekerSwarm.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "ShadowStrike", Name: "Shadow Strike", Picture: "ShadowStrike.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SiegePulse", Name: "Siege Pulse", Picture: "SiegePulse.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SonicSlash", Name: "Sonic Slash", Picture: "SonicSlash.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "StimPack", Name: "Stim Pack", Picture: "StimPack.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "Supercharge", Name: "Geth Turbocharge", Picture: "Supercharge.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SupplyTurret", Name: "Supply Drone", Picture: "SupplyTurret.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "TechHammerModal", Name: "Tech Hammer", Picture: "TechHammerModal.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "VenomTippedBlades", Name: "Venom-Tipped Blades", Picture: "VenomTippedBlades.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "WhipSmash", Name: "Smash", Picture: "WhipSmash.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "AnnihilationSphere", Name: "Annihilation Field", Picture: "AnnihilationSphere.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BatarianArmor", Name: "Batarian Armor", Picture: "BatarianArmor.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BatarianAttack", Name: "Batarian Kick", Picture: "BatarianAttack.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BatarianNet", Name: "Batarian Net", Picture: "BatarianNet.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BioticFocus", Name: "Biotic Focus", Picture: "BioticFocus.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BioticHammerModal", Name: "Biotic Hammer", Picture: "BioticHammerModal.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BioticOrbs", Name: "Dark Energy Orbs", Picture: "BioticOrbs.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "Bloodlust", Name: "Bloodlust", Picture: "Bloodlust.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BowModalOne", Name: "Bow Shot", Picture: "BowModalOne.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BowModalTwo", Name: "Bow Explosive Shot", Picture: "BowModalTwo.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "BubbleShield", Name: "Barrier Bubbles", Picture: "BubbleShield.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "CainMine", Name: "M-920 Cain Mine", Picture: "CainMine.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "CryoCone", Name: "Cryo Cone", Picture: "CryoCone.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "Damping", Name: "Damping", Picture: "Damping.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "DarkSingularity", Name: "Dark Singularity", Picture: "DarkSingularity.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "DevestatorMode", Name: "Devastator Mode", Picture: "DevestatorMode.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "ElectricSlash", Name: "Electric Slash", Picture: "ElectricSlash.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "EMPGrenade", Name: "EMP Grenade", Picture: "EMPGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "Flamer", Name: "Flamer", Picture: "Flamer.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "GethTurret", Name: "Geth Turret", Picture: "GethTurret.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "HavocStrike", Name: "Havoc Strike", Picture: "HavocStrike.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "HexShield", Name: "Hex Shield", Picture: "HexShield.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "HomingGrenade", Name: "Homing Grenade", Picture: "HomingGrenade.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "KroganBioticCharge", Name: "Biotic Charge (Krogan)", Picture: "KroganBioticCharge.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "Lash", Name: "Lash", Picture: "Lash.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "LineStrike", Name: "Line Strike", Picture: "LineStrike.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "MissileLauncher", Name: "Missile Launcher", Picture: "MissileLauncher.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},

	//Squadmate Powers ----------------------
	{
		ID: "SFXPowerCustomAction_JackPassive", Name: "Subject Zero", Picture: "MPPassive.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Health & Shield Bonus: 10%\nPower Recharge Speed Bonus: 20%"},
			{Rank: 2, Description: "Health & Shield Bonus: 20%\nPower Recharge Speed Bonus: 40%"},
			{Rank: 3, Description: "Health & Shield Bonus: 30%\nPower Recharge Speed Bonus: 60%"},
			{Rank: 4, Description: "Health & Shield Bonus: 30%\nPower Recharge Speed Bonus: 100%"},                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Health & Shield Bonus: 50%\nPower Recharge Speed Bonus: 60%"},                                                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase weapon damage by 20%."},                                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase power force and duration by 30%."},                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase recharge speed of all squadmate biotic powers by 10%."},                                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Health & Shield Bonus: 30% (Recharge Speed) 50%\nPower Recharge Speed Bonus: 160% (Recharge Speed) 120% (Durability)"}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_WarpAmmo", Name: "Warp Ammo", Picture: "Warp.webp",
		RankDescs: []RankDesc{
			{Rank: 1, Description: ""}, // Rank 1
			{Rank: 2, Description: ""}, // Rank 2
			{Rank: 3, Description: ""}, // Rank 3
			{Rank: 4, Description: ""}, // Rank 4 - Evolution A
			{Rank: 5, Description: ""}, // Rank 4 - Evolution B
			{Rank: 6, Description: ""}, // Rank 5 - Evolution A
			{Rank: 7, Description: ""}, // Rank 5 - Evolution B
			{Rank: 8, Description: ""}, // Rank 6 - Evolution A
			{Rank: 9, Description: ""}, // Rank 6 - Evolution B
		},
	},
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

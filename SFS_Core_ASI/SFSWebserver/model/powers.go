package model

import (
	"strconv"
	"strings"
)

// RankDesc holds a short description for a specific power rank.
// Indices 1â€“3 map to ranks 1â€“3; then for the evolution ranks:
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
	RootPath  string
	Name      string
	Picture   string     // filename in /static/assets/powers/, e.g. "Warp.webp"
	RankDescs []RankDesc // descriptions indexed 1â€“9 (see RankDesc comment for the mapping)
}

// IconURL returns the URL for the power's sprite sheet.
func (p PowerDef) IconURL() string {
	return "/static/assets/powers/" + p.Picture
}

// DescForRank returns the description for the given index (1â€“9, per the RankDesc scheme).
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
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost weapon accuracy and firing rate for a short time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                         // Rank 2
			{Rank: 3, Description: "Increase duration by 30%."},                               // Rank 3
			{Rank: 4, Description: "Increase accuracy bonus by 15%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase firing rate bonus by 15%."},                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase duration by 40%."},                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage by 25%."},                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase accuracy and firing rate bonuses by 10%."},       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 40%."},                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_LiftGrenade", Name: "Lift Grenade", Picture: "LiftGrenade.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Lob this grenade into a group of enemies to send them flying.\n\nDeal high damage."},  // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                     // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                             // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase power duration by 50%."},                                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "Slam floating targets to the ground as Lift wears off, stunning them for 3 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 30%.\nIncrease impact radius by 30%."},                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Incinerate", Name: "Incinerate", Picture: "Incinerate.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Burn your opponents and incinerate their armor.\n\nHeavy damage to health and armor.\nMake an enemy panic, stopping health regeneration.\n\nApplies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                    // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                            // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 1.5 meters."},                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by an additional 50% over 8 seconds."},               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 25%."},                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to frozen and chilled targets by an additional 1%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to armored targets by 50%."},                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_InfernoGrenade", Name: "Inferno Grenade", Picture: "InfernoGrenade.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Cluster-bomb a small area with incendiary munitions.\n\nDamage can be sustained indefinitely with Incendiary ammo. Applies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                   // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                           // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage by 40%."},                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 50%."},                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase impact radius by 50%.\nIncrease shrapnel by 1 fragments."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_InfernoGrenade_Batarian", Name: "Inferno Grenade (Batarian)", Picture: "InfernoGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Cluster-bomb a small area with incendiary munitions.\n\nDamage can be sustained indefinitely with Incendiary ammo. Applies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                   // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                           // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage by 40%."},                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 50%."},                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase impact radius by 50%.\nIncrease shrapnel by 1 fragments."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AIHacking", Name: "AI Hacking", Picture: "Hacking.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Sabotage weapons and hack synthetics.\n\nCompromised synthetics fight on your side.\nAffected weapons overheat."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                 // Rank 2
			{Rank: 3, Description: "Increase impact radius by 30%."},                                                                                  // Rank 3
			{Rank: 4, Description: "Increase duration by 50%."},                                                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage taken by 60% when enemy weapons overheat."},                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Synthetics explode when destroyed, dealing 350 points of damage across a 4 meter radius."},                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Hacked synthetics fighting on your side move faster and do 50% more damage."},                                     // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase all tech power damage done to target by 50% for 10 seconds."},                                            // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Fortification", Name: "Fortification", Picture: "Fortification.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor using protective Foucault currents.\nPurge the current and send its charge to your gauntlets for increased melee damage.\n\nSlow power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25% when armor is purged."},                                                                                                                // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20% when armor is purged."},                                                                                                            // Rank 3
			{Rank: 4, Description: "Increase damage protection by 5%."},                                                                                                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase melee damage bonus by 30% when armor is purged."},                                                                                                            // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield recharge rate by 15%."},                                                                                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase power damage and force by 30% while Fortification is active."},                                                                                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by 10%."},                                                                                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FragGrenade", Name: "Frag Grenade", Picture: "FragGrenade.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip your enemies apart with this shrapnel-packed grenade."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                           // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                   // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                            // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to organics by 50% over 5 seconds."},        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 75%."},                          // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields by 75%."},                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_EnergyDrain", Name: "Energy Drain", Picture: "EnergyDrain.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Hit an enemy with this energy pulse to inflict damage and to steal barrier and shield power."},              // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                           // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                   // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 1%."},                                                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield restoration rate by 50% when draining shields, barriers, or power from synthetic enemies."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 25%."},                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 40%."},                                                                                   // Rank 6 - Evolution A
			{Rank: 9, Description: "Reduce damage taken by 40% for 10 seconds by gaining a temporary layer of armor by draining shields, barriers, or energy from synthetics."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Discharge", Name: "Neural Shock", Picture: "Discharge.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Transfer the energy of your biotic barrier to charge and spark this deadly blast.\n\nBarrier strength determines blast intensity."}, // Rank 1
			{Rank: 2, Description: "Increase impact radius by 25%."},                               // Rank 2
			{Rank: 3, Description: "Increase damage and force by 30%."},                            // Rank 3
			{Rank: 4, Description: "Increase damage and force by 40%."},                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 40%."},                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed of all powers by 15% for 15 seconds."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Gain the option to use Nova two times in a row by reducing its barrier consumption by 50% but at the cost of reducing damage and force by -40%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to barriers, shields, and armored targets by 1%."},                                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Nova gains a 25% change of not using up barriers."},                                                                                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Decoy", Name: "Decoy", Picture: "Decoy.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Distract opponents with this decoy."},                                  // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 40%."},                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase shields by 40%."},                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Shock enemies for 100 points within a 2.5 meter radius of the decoy."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                      // Rank 5 - Evolution B
			{Rank: 8, Description: "Decoy explodes on destruction, causing 300 damage across 4 meters."},   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase shields by 50%.\nIncrease duration by 50%."},                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Carnage", Name: "Carnage", Picture: "Carnage.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip a target into shreds with this vicious blast.\n\nMajor collateral damage to enemies nearby.\nEffective against armor."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},             // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                     // Rank 3
			{Rank: 4, Description: "Increase impact radius by 50%."},              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage by 30%."},                     // Rank 4 - Evolution B
			{Rank: 6, Description: "Incapacitate enemies by knocking them down."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armored units by 65%."},    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 50%."},                     // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Carnage_KroganVanguard", Name: "Carnage (Krogan Vanguard)", Picture: "Carnage.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip a target into shreds with this vicious blast.\n\nMajor collateral damage to enemies nearby.\nEffective against armor."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},             // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                     // Rank 3
			{Rank: 4, Description: "Increase impact radius by 50%."},              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage by 30%."},                     // Rank 4 - Evolution B
			{Rank: 6, Description: "Incapacitate enemies by knocking them down."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armored units by 65%."},    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 50%."},                     // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Cloak", Name: "Tactical Cloak", Picture: "Cloak.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 40%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase sniper rifle damage by 25% while cloaked."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Cloak_Geth", Name: "Tactical Cloak (Geth Infiltrator)", Picture: "Cloak.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 40%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase sniper rifle damage by 25% while cloaked."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Cloak_N7Infiltrator", Name: "Tactical Cloak (N7 Shadow)", Picture: "Cloak.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 40%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase sniper rifle damage by 25% while cloaked."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CombatDrone", Name: "Combat Drone", Picture: "CombatDrone.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Deploy this attack drone to stun targets and draw enemy fire."},                                                                       // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                                     // Rank 2
			{Rank: 3, Description: "Increase drone's damage by 30%.\nIncrease drone's shields by 30%."},                                                                   // Rank 3
			{Rank: 4, Description: "Increase drone's damage by 40%.\nIncrease drone's shields by 40%."},                                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Drone explodes when destroyed, dealing 400 points of damage across a 5 meter radius."},                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Upgrade drone's short-range attack to deal 100 points of damage across a 5 meter radius.\nDrone stuns enemies for a short duration."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase drone's damage by 50%.\nIncrease drone's shields by 50%."},                                                                   // Rank 5 - Evolution B
			{Rank: 8, Description: "Upgrade drone with long-range rockets that deal 300 points of damage across a 2.5 meter radius."},                                     // Rank 6 - Evolution A
			{Rank: 9, Description: "Upgrade drone's electrical pulse to jump and hit 3 additional targets."},                                                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ConcussiveShot", Name: "Concussive Shot", Picture: "ConcussiveShot.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Flatten your enemy with a precise blast at short or long range.\n\nEffective against barriers."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                // Rank 2
			{Rank: 3, Description: "Increase damage and force by 20%."},                                                              // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."},                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 1.5 meters."},                                                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage to frozen targets by 1%."},                                             // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 25%."},                                                                // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50% and radius by 1 meters."},                                                 // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage done to organics by 2% over 10 seconds.\nIncrease force by 50%."},                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CryoBlast", Name: "Cryo Blast", Picture: "CryoBlast.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Flash-freeze and shatter unprotected enemies. Slow down the rest.\n\nWeaken armor.\nFrozen targets won't regenerate health."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                     // Rank 2
			{Rank: 3, Description: "Increase power duration by 40%."},                                                                     // Rank 3
			{Rank: 4, Description: "Increase power duration by 60%."},                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 2 meters."},                                                                 // Rank 4 - Evolution B
			{Rank: 6, Description: "Decrease movement speed of chilled targets by an additional -30%."},                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to chilled and frozen targets by 10%."},                                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase recharge speed by 1%."},                                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to frozen and chilled targets by 15%.\nWeaken armored targets by an additional 25%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticGrenade", Name: "Biotic Grenade", Picture: "BioticGrenade.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Lob this biotic grenade cluster at your enemies and watch them fly."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                     // Rank 2
			{Rank: 3, Description: "Increase damage and force by 20%."},                                   // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."},                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 35%."},                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to already-lifted targets by 1%."},                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase shrapnel count by 1."},                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage and force by 50%."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticCharge", Name: "Biotic Charge", Picture: "BioticCharge.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Smash into a target while encased in this biotic barrier, leveling your opponents.\n\nInvulnerable while this power is in effect."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                         // Rank 2
			{Rank: 3, Description: "Increase damage and force by 30%."},                                                       // Rank 3
			{Rank: 4, Description: "Increase damage and force by 40%."},                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Hit up to 2 additional targets within 2 meters of the impact point."},                     // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase weapon damage by 25% for 5 seconds after a successful Biotic Charge."},           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase power damage and force by 40% for 10 seconds after a successful Biotic Charge."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Give Biotic Charge a 50% chance of not triggering a cooldown."},                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase barriers by an additional 50% after a successful Biotic Charge."},                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Barrier_Shared", Name: "Barrier", Picture: "Barrier.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor with this biotic field. Detonate the field to lift and dangle nearby targets.\n\nReduce all forms of damage taken.\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after detonation by 25%."},                                                                                                             // Rank 2
			{Rank: 3, Description: "Increase the damage, force, and radius of the detonation by 20%."},                                                                                             // Rank 3
			{Rank: 4, Description: "Increase the damage, force, and radius of the detonation by 30%."},                                                                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Decrease damage taken by 5%."},                                                                                                                                 // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield regeneration rate by 15% while Barrier is active."},                                                                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage and force by 30% while Barrier is active."},                                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by 10%."},                                                                                                                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Barrier_KroganVanguard", Name: "Barrier (Krogan Vanguard)", Picture: "Barrier.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor with this biotic field. Detonate the field to lift and dangle nearby targets.\n\nReduce all forms of damage taken.\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after detonation by 25%."},                                                                                                             // Rank 2
			{Rank: 3, Description: "Increase the damage, force, and radius of the detonation by 20%."},                                                                                             // Rank 3
			{Rank: 4, Description: "Increase the damage, force, and radius of the detonation by 30%."},                                                                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Decrease damage taken by 5%."},                                                                                                                                 // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield regeneration rate by 15% while Barrier is active."},                                                                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage and force by 30% while Barrier is active."},                                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by 10%."},                                                                                                                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AdrenalineRush", Name: "Adrenaline Rush", Picture: "AdrenalineRush.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Accelerate reflexes, granting time to line up the perfect shot.\n\nMore weapon damage."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                        // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                        // Rank 3
			{Rank: 4, Description: "Decrease health and shield damage taken by 40%."},                                        // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage by 20%."},                                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power duration by 40%."},                                                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50%."},                                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase shield strength by 1%."},                                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Use 1 offensive power while Adrenaline Rush is active."},                                 // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ProximityMine", Name: "Proximity Mine", Picture: "ProximityMine.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Fire this sticky mine into traffic. It will detonate when an enemy steps within range."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                        // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 50%."},                                                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage dealt to targets from all sources by 20% for 8 seconds."},                // Rank 5 - Evolution A
			{Rank: 7, Description: "Slow target's movement speed by -30% for 8 seconds."},                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 40%."},                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ProximityMine_Geth", Name: "Proximity Mine (Geth)", Picture: "ProximityMine.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Fire this sticky mine into traffic. It will detonate when an enemy steps within range."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                        // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 50%."},                                                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage dealt to targets from all sources by 20% for 8 seconds."},                // Rank 5 - Evolution A
			{Rank: 7, Description: "Slow target's movement speed by -30% for 8 seconds."},                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 40%."},                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Pull", Name: "Pull", Picture: "Pull.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Yank an opponent helplessly off the ground."},                                                                   // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                               // Rank 2
			{Rank: 3, Description: "Increase duration by 50%."},                                                                                     // Rank 3
			{Rank: 4, Description: "Increase duration by 1%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 2.5 meters."},                                                                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Inflict 75 damage per second to lifted targets."},                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase all damage to targets lifted by Pull by 30%."},                                                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase duration by 50%, and increase the force and damage of biotic detonations on affected targets by 75%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 1.5%."},                                                                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Pull_Asari", Name: "Pull (Asari Justicar)", Picture: "Pull.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Yank an opponent helplessly off the ground."},                                                                   // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                               // Rank 2
			{Rank: 3, Description: "Increase duration by 50%."},                                                                                     // Rank 3
			{Rank: 4, Description: "Increase duration by 1%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 2.5 meters."},                                                                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Inflict 75 damage per second to lifted targets."},                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase all damage to targets lifted by Pull by 30%."},                                                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase duration by 50%, and increase the force and damage of biotic detonations on affected targets by 75%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 1.5%."},                                                                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Reave", Name: "Reave", Picture: "Reave.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Drain a target's health and disrupt their resistances, receiving increased damage protection while this power is in effect.\n\nEffective against barriers and armor."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                              // Rank 2
			{Rank: 3, Description: "Increase duration by 35%."},                                                                    // Rank 3
			{Rank: 4, Description: "Increase duration by 40%."},                                                                    // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 3 meters."},                                                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage protection by 10%."},                                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                              // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase effectiveness against armor and barriers by 75%."},                                    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 30%.\nIncrease duration by 30%.\nIncrease damage protection bonus by 15%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Reave_Asari", Name: "Reave (Asari Justicar)", Picture: "Reave.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Drain a target's health and disrupt their resistances, receiving increased damage protection while this power is in effect.\n\nEffective against barriers and armor."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                              // Rank 2
			{Rank: 3, Description: "Increase duration by 35%."},                                                                    // Rank 3
			{Rank: 4, Description: "Increase duration by 40%."},                                                                    // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 3 meters."},                                                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage protection by 10%."},                                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                              // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase effectiveness against armor and barriers by 75%."},                                    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 30%.\nIncrease duration by 30%.\nIncrease damage protection bonus by 15%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Shockwave", Name: "Shockwave", Picture: "Shockwave.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Topple a row of enemies with this cascading shockwave."},  // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                         // Rank 2
			{Rank: 3, Description: "Increase damage and force by 25%."},                       // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."},                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage of biotic detonations by 65%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the distance that Shockwave cascades by 50%."},   // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase recharge speed by 40%."},                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Suspend targets in the air for a short time."},            // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Shockwave_Batarian", Name: "Shockwave (Batarian)", Picture: "Shockwave.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Topple a row of enemies with this cascading shockwave."},  // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                         // Rank 2
			{Rank: 3, Description: "Increase damage and force by 25%."},                       // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."},                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage of biotic detonations by 65%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the distance that Shockwave cascades by 50%."},   // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase recharge speed by 40%."},                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Suspend targets in the air for a short time."},            // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Overload", Name: "Overload", Picture: "Overload.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Overload electronics with this power surge, stunning your enemy.\n\nEffective against shields, barriers, and synthetics.\nNot as effective against organics."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                        // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                // Rank 3
			{Rank: 4, Description: "Hit 1 additional target within 8 meters with 60% less damage."},                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage by 30%."},                                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Incapacitate weaker organic enemies for a short duration."},                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 25%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 15%.\nHit 1 additional target within 8 meters with 60% less damage."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to barriers and shields by an additional 1%."},                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Overload_Geth", Name: "Overload (Geth)", Picture: "Overload.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Overload electronics with this power surge, stunning your enemy.\n\nEffective against shields, barriers, and synthetics.\nNot as effective against organics."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                        // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                // Rank 3
			{Rank: 4, Description: "Hit 1 additional target within 8 meters with 60% less damage."},                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage by 30%."},                                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Incapacitate weaker organic enemies for a short duration."},                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 25%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 15%.\nHit 1 additional target within 8 meters with 60% less damage."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to barriers and shields by an additional 1%."},                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SentryTurret", Name: "Sentry Turret", Picture: "SentryTurret.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Deploy this heavy-weapon turret for cover fire."},                                                  // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                  // Rank 2
			{Rank: 3, Description: "Increase turret's shields by 30%.\nIncrease turret's damage by 30%."},                              // Rank 3
			{Rank: 4, Description: "Increase turret's shields by 40%.\nIncrease turret's damage by 40%."},                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Upgrade turret with shock attack to stun enemies."},                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Upgrade turret with cryo ammo, giving it a chance to freeze enemies for 3 seconds."},               // Rank 5 - Evolution A
			{Rank: 7, Description: "Upgrade turret with armor-piercing ammo, giving it a 1% damage bonus against armor."},              // Rank 5 - Evolution B
			{Rank: 8, Description: "Upgrade turret with long-range rockets that deal 300 points of damage across a 2.5 meter radius."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Upgrade turret with a close-range flamethrower that deals 65 points of damage per second."},        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Stasis", Name: "Stasis", Picture: "Stasis.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Stop an enemy in its tracks with this powerful mass effect field. No effect on armored targets.\n\nEnemies eventually break out of Stasis after taking major damage."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                   // Rank 2
			{Rank: 3, Description: "Increase duration by 30%."},                                                                         // Rank 3
			{Rank: 4, Description: "Increase duration by 40%."},                                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Deal 1.5% more damage to targets before Stasis breaks."},                                            // Rank 4 - Evolution B
			{Rank: 6, Description: "Use two powers in a row by giving the first power a 30% chance to cause no cooldown."},              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                                   // Rank 5 - Evolution B
			{Rank: 8, Description: "Unleash a Stasis bubble to trap enemies that walk into it."},                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase all damage done to target by 50%.\nDeal 35% more damage to targets before Stasis breaks."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_StickyGrenade", Name: "Sticky Grenade", Picture: "StickyGrenade.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Stick this grenade to your opponent, and the explosion will tear apart the target and the shrapnel will damage other enemies caught in the blast."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},          // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                  // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                  // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},          // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to armored units by 50%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 40%."},                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Grenades stay active for 15 seconds when attached to a wall or surface, exploding when an enemy approaches.\nIncrease impact radius by 50%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Singularity", Name: "Singularity", Picture: "Singularity.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Create a sphere of dark energy that traps and dangles enemies caught in its field."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                    // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                            // Rank 3
			{Rank: 4, Description: "Increase duration by 1.5%."},                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 35%."},                                                     // Rank 4 - Evolution B
			{Rank: 6, Description: "Inflict 50 damage per second to lifted targets."},                                    // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                                                            // Rank 6 - Evolution A
			{Rank: 9, Description: "Detonate Singularity when the field dies to inflict 500 damage across 7 meters."},    // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechArmor", Name: "Tech Armor", Picture: "TechArmor.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\n\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase detonation damage by 20%.\nIncrease impact radius by 20%."},                                                // Rank 3
			{Rank: 4, Description: "Increase detonation damage by 30%.\nIncrease impact radius by 30%."},                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage protection by an additional 5%."},                                                                   // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechArmor_Krogan", Name: "Tech Armor (Krogan)", Picture: "TechArmor.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\n\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase detonation damage by 20%.\nIncrease impact radius by 20%."},                                                // Rank 3
			{Rank: 4, Description: "Increase detonation damage by 30%.\nIncrease impact radius by 30%."},                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage protection by an additional 5%."},                                                                   // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechArmor_Turian", Name: "Tech Armor (Turian)", Picture: "TechArmor.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\n\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase detonation damage by 20%.\nIncrease impact radius by 20%."},                                                // Rank 3
			{Rank: 4, Description: "Increase detonation damage by 30%.\nIncrease impact radius by 30%."},                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage protection by an additional 5%."},                                                                   // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Throw", Name: "Throw", Picture: "Throw.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Toss your enemy through the air with this biotic blast."},           // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                   // Rank 2
			{Rank: 3, Description: "Increase force by 30%."},                                            // Rank 3
			{Rank: 4, Description: "Increase force by 40%."},                                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 2 meters."},                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage of biotic detonations by 50%."},           // Rank 5 - Evolution A
			{Rank: 7, Description: "Reset recharge time after a biotic combo detonates."},               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase force by 50%, and do an additional 200 damage on impact."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 60%."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Warp", Name: "Warp", Picture: "Warp.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip your enemy apart at a molecular level.\n\nStop targeted enemy from regenerating health.\nWeaken armor.\n\nApplies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                  // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                          // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase force, damage, and impact radius of combo detonations by 50%."},                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%.\nIncrease duration by 60%."},                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase weapon damage taken by a target by 15%.\nIncrease power damage taken by a target by 15% for 10 seconds."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to barriers and armor by 50%.\nWeaken armored targets by an additional 25%."},                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 35%."},                                                                                  // Rank 6 - Evolution B
		},
	},

	//Melee Passives --------------------------
	{
		ID: "SFXPowerCustomActionMP_AsariMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Adept", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Engineer", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Sentinel", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Vanguard", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HumanMeleePassive_Soldier", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DrellMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, durability, and movement speed."},                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%.\nIncrease movement speed bonus by 10%."},                                                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemQuarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, and durability.\n\nMelee and kill 3 enemies within 30 seconds to send the krogan into a frenzy, increasing melee damage and reducing damage taken for 30 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                             // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 25%."},                                                                                    // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%.\nIncrease melee damage bonus by 30% while in Rage mode."},                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonues by 20%.\nIncrease damage protection by an additional 5% while in Rage mode."},          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                 // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nReduce the number of melee kills required to trigger Rage to 2 within 30 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%.\nIncrease damage protection by 5% while in Rage mode."},                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TurianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SalarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},

	//Fitness Passives ------------------------
	{
		ID: "SFXPowerCustomActionMP_HumanPassive", Name: "Alliance Training", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "A decade of rigorous combat training in the Alliance starts to click.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                                                   // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                                  // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DrellPassive", Name: "Drell Assassin", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Practice makes perfect, and years spent tuning reflexes for the perfect killshot are paying dividends.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 15%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 20%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 30%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of heavy pistols by 30%."},                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 12%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganPassive", Name: "Krogan Berserker", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Battle-skills hardened on unforgiving Tuchanka come into play.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                                            // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                       // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 5%.\nIncrease weight capacity bonus by 30 points."},                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of shotguns by 30%."},                                                                                   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemQuarianPassive", Name: "Quarian Defender", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Built on a lifetime spent defending the flotilla from the geth, combat skills reach new heights.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of SMGs by 30%."},                                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariPassive", Name: "Asari Justicar", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Centuries of training as a justicar come into focus on the battlefield.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of heavy pistols by 30%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TurianPassive", Name: "Turian Veteran", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Seasoned by years of hard fighting across the galaxy, combat skills come into their own.\n\nMore weapon damage.\nGreater stability and weapon control.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon stability bonus by 15%."},                                                       // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 10%.\nIncrease weapon stability bonus by 10%."},                 // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 15%.\nIncrease weight capacity bonus by 25 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 20%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 30%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease assault rifle weight by 30%."},                                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 12%.\nIncrease weapon stability bonus by 10%."},                 // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SalarianPassive", Name: "Salarian Operative", Picture: "MPPassive.webp",
		RootPath: "SFXGameMPContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Years spent training as an STG operative are paying off.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                                                 // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                                                     // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                 // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                              // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of sniper rifles by 30%."},                                                                            // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                // Rank 6 - Evolution B
		},
	},

	//DLC Powers -----------------------------
	{
		ID: "SFXPowerCustomAction_MultiFragGrenade", Name: "Multi Frag Grenade", Picture: "MultiFragGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch multiple frag grenades by upgrading the T5-V's right gauntlet."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                       // Rank 2
			{Rank: 3, Description: "Increase damage and force by 20%."},                                     // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."},                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 35%."},                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 2."},                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage and force by 40%."},                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of grenades launched by 2."},                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage and force by 50%."},                                     // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_PalmBlaster", Name: "Nova", Picture: "PalmBlaster.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Focus the energy of your barrier to fire a high-powered beam at a target from afar.\n\nFiring the beam consumes 40% of max barrier."}, // Rank 1
			{Rank: 2, Description: "Increase impact radius by 30%."},               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                      // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 50%."},               // Rank 4 - Evolution B
			{Rank: 6, Description: "Knock weaker enemies to the ground."},          // Rank 5 - Evolution A
			{Rank: 7, Description: "Reduce the amount of barrier drained by 50%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 75%."},             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields/barriers by 75%."},  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ReconMine", Name: "Recon Mine", Picture: "ReconMine.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch a mine that sticks to the first surface it touches and arms after 3 seconds. The mine scans the area for enemies to provide a tactical overlay, and it can be detonated at any time to deal massive damage to nearby targets.\n\nOnly one mine can be active at a time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                  // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                          // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase scan and explosion radius by 50%."},                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%."},                                                          // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                  // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armored targets by 75%."},                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Scanned enemies take 25% more damage from all sources and move -30% more slowly."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_RepairMatrix", Name: "Repair Matrix", Picture: "RepairMatrix.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor with metal-repelling Foucault currents to increase movement speed, decrease damage taken, and to regenerate shields for a short duration. When activated, the fallen caster instantly gets back on their feet. This can only occur once, and a limited number of charges can be carried for this power."}, // Rank 1
			{Rank: 2, Description: "Increase the maximum number of charges that can be carried by 1."},              // Rank 2
			{Rank: 3, Description: "Increase the amount of shields restored by 20%."},                               // Rank 3
			{Rank: 4, Description: "Decrease damage taken by 5%.\nIncrease movement speed by 10%."},                 // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the amount of shields restored by 30%."},                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the maximum number of charges that can be carried by 1."},              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase duration by 50%."},                                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "When getting back up from a downed state, take 75% less damage for 5 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the amount of shields restored by 35%.\nReduce damage taken by 10%."},  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SeekerSwarm", Name: "Seeker Swarm", Picture: "SeekerSwarm.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch a slow-moving sphere of ark energy to cause damage over time to any target it passes over. The sphere can be detonated at any time to cause massive damage.\n\nThis power only has a cooldown when detonated."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 15%."},                                                                                                     // Rank 2
			{Rank: 3, Description: "Increase detonation damage by 20%.\nIncrease damage over time by 15%."},                                                               // Rank 3
			{Rank: 4, Description: "Increase detonation damage by 30% and damage over time by 20%."},                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the detonation radius of the dark sphere by 40%."},                                                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage over time by 40% and duration by 40%."},                                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                                                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "Dark Sphere implodes to do 1% more damage at the expense of decreasing the detonation radius by -50%."},                               // Rank 6 - Evolution A
			{Rank: 9, Description: "Destabilize the Dark Sphere to increase the detonation radius by 40%.\nIncrease damage over time by 40%.\nIncrease duration by 40%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ShadowStrike", Name: "Shadow Strike", Picture: "ShadowStrike.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Cloak and sneak behind your target to unleash a vicious sword attack.\n\nReceives damage bonuses from sword upgrades.\nConsidered a melee attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                        // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                        // Rank 4 - Evolution A
			{Rank: 5, Description: "Reduce all damage taken by 40% for 5 seconds after decloaking."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Hit your opponent with an electrical attack that does 40% additional damage over 5 seconds.\n\nDetonate this effect with other powers."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},         // Rank 6 - Evolution A
			{Rank: 9, Description: "Strike shields or barriers to drain their energy to refill your shields.\nIncrease movement speed by 15% for 4 seconds after decloaking."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SiegePulse", Name: "Siege Pulse", Picture: "SiegePulse.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Generate 3 electric charges that are stored in your platform's batteries. Use the power again to consume a charge to launch a long-range pulse that blasts a massive area. Each shot has a chance of incapacitating unarmored enemies.\n\nHighly effective against armor, shields, and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                   // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                           // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 60%."},                                                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Each stored charge on your platform reduces all damage taken by 10%."},                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 40%."},                                                                   // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of shots fired by 1, and increase the chance of knocking down enemies by 15%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage done to armor, shields, and barriers by 60%."},                                      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SonicSlash", Name: "Sonic Slash", Picture: "SonicSlash.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Charge your sword with biotic energy and slash nearby enemies in a wide swath, flattening unshielded opponents."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                 // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                         // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                                  // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage of biotic detonations by 50%."},                                                         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 40%."},                                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                                                                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase range by 50%."},                                                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_StimPack", Name: "Stim Pack", Picture: "StimPack.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "A specially designed ops survival pack that temporarily increases survivability and all damage output.\n\nA limited number of these packs can be carried."}, // Rank 1
			{Rank: 2, Description: "Increase pack capacity by 1."},                                                            // Rank 2
			{Rank: 3, Description: "Increase damage bonus by 2%."},                                                            // Rank 3
			{Rank: 4, Description: "Increase damage bonus by 5%."},                                                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase max shield bonus by 40%."},                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase pack capacity by 1."},                                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase duration by 50%."},                                                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase weapon damage by 8% for the duration of the power."},                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase max shield bonus by 60% and melee damage by 25% for the duration of the power."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Supercharge", Name: "Geth Turbocharge", Picture: "Supercharge.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Advanced diagnostics redirect power into offensive systems, boosting combat capabilities.\n\nFaster movement.\nSee through smoke and objects.\nMore weapon, power, and melee damage.\nGreater weapon accuracy.\nShields reduced by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase movement speed by 5%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase damage bonus by 2%."},                                                              // Rank 3
			{Rank: 4, Description: "Increase recharge speed of all powers by 20% while active."},                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase weapon accuracy bonus by 15%."},                                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage of all powers by 15% while active."},                                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase rate of fire of all weapons by 15% while active."},                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase movement speed bonus by 10%.\nIncrease the range of your enhanced vision by 60%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage bonus by 10%."},                                                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Supercharge_Shared", Name: "Geth Turbocharge", Picture: "Supercharge.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Advanced diagnostics redirect power into offensive systems, boosting combat capabilities.\n\nFaster movement.\nSee through smoke and objects.\nMore weapon, power, and melee damage.\nGreater weapon accuracy.\nShields reduced by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase movement speed by 5%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase damage bonus by 2%."},                                                              // Rank 3
			{Rank: 4, Description: "Increase recharge speed of all powers by 20% while active."},                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase weapon accuracy bonus by 15%."},                                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage of all powers by 15% while active."},                                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase rate of fire of all weapons by 15% while active."},                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase movement speed bonus by 10%.\nIncrease the range of your enhanced vision by 60%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage bonus by 10%."},                                                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SupplyTurret", Name: "Supply Drone", Picture: "SupplyTurret.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Deploy an immobile pylon that supplies ammo and grenades. A built-in tech generator also increases maximum shields for nearby allies.\n\nOnly one pylon can be active at a time.\nAmmo and grenades expire after 17.5s."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                     // Rank 2
			{Rank: 3, Description: "Increase the rate of ammunition generation by 15%.\nIncrease the rate of grenade generation by 15%."}, // Rank 3
			{Rank: 4, Description: "Increase the rate of ammunition generation by 25%.\nIncrease the rate of grenade generation by 25%."}, // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the radius in which the pylon gives bonuses to allies by 40%."},                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Upgrade the tech generator to also increase allied weapon damage by 10%."},                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Upgrade the tech generator to also increase allied power damage by 10%."},                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of grenades generated by 1."},                                                     // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase max shields by an additional 25%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechHammerModal", Name: "Tech Hammer", Picture: "TechHammerModal.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Charge your hammer with electric energy, making all hammer impacts do electrical damage in a large area while stunning enemies. Your melee attacks will expend these charges.\n\nHighly effective against shields and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                                             // Rank 2
			{Rank: 3, Description: "Increase damage radius by 20%."},                                                                                                              // Rank 3
			{Rank: 4, Description: "Increase damage done to shields/barrier by 75%."},                                                                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 40%."},                                                                                                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Add a fire effect to impacted targets to do 250 damage over 5 seconds.\n\nApplies fire DoT."},                                                 // Rank 5 - Evolution A
			{Rank: 7, Description: "Add a chill effect to impacted targets that decreases movement speed by -30% and increases all damage by 20%.\nThis effect lasts 5 seconds."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase impact radius by 30%.\nIncrease the damage of tech combo detonations by 65%."},                                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the number of charges generated by Electric Hammer by 2."},                                                                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_VenomTippedBlades", Name: "Venom-Tipped Blades", Picture: "VenomTippedBlades.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch a short-range volley of venom tipped blades to paralyze non-shielded targets. These blades cause instant damage and poison the target, causing damage over time.\n\nBlade damage is most effective at close-range.\nA limited number of these blades can be carried."}, // Rank 1
			{Rank: 2, Description: "Increase blade carrying capacity by 1."},                                                                      // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                     // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase blade carrying capacity by 1."},                                                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase range by 50%."},                                                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Boost the concentration of neurotoxins to increase the paralyze duration by 40% and poison duration by 40%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Boost the concentration of venom in the blades to increase direct damage by 40% and poison damage by 60%."},   // Rank 6 - Evolution A
			{Rank: 9, Description: "Blades explode after 3 seconds, doing 400 poisonous area damage."},                                            // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_WhipSmash", Name: "Smash", Picture: "WhipSmash.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Drive the lash into the ground to cause area-of-effect damage and devastating direct damage."},                       // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                    // Rank 2
			{Rank: 3, Description: "Increase force and damage by 20%."},                                                                                  // Rank 3
			{Rank: 4, Description: "Add a biotic effect to a target that can be detonated.\nIncrease damage by 30%."},                                    // Rank 4 - Evolution A
			{Rank: 5, Description: "Add an electrical effect to a target that can be detonated.\nIncrease damage by an additional 50% for 7.5 seconds."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage by 40%."},                                                                                  // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 40%."},                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase effectiveness against armor and barriers by 75%."},                                                          // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase radius by 50%.\nIncrease the number of targets hit by 1."},                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AnnihilationSphere", Name: "Annihilation Field", Picture: "AnnihilationSphere.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Spin this fiery effect around you to burn nearby enemies. When active, the field can be recast to blast a short-range area and to detonate combos."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                              // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                      // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Targets caught in the field take 15% additional damage from all sources."},                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase movement speed by 20% while active."},                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 65%."},                                                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase duration by 1%.\nDrain 1% of the damage done to enemy shields/barriers to restore your own shields."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AnnihilationSphere_Shared", Name: "Annihilation Field", Picture: "AnnihilationSphere.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Spin this fiery effect around you to burn nearby enemies. When active, the field can be recast to blast a short-range area and to detonate combos."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                              // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                      // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Targets caught in the field take 15% additional damage from all sources."},                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase movement speed by 20% while active."},                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 65%."},                                                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase duration by 1%.\nDrain 1% of the damage done to enemy shields/barriers to restore your own shields."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianArmor", Name: "Batarian Armor", Picture: "BatarianArmor.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor with razor-sharp blades to damage enemies that melee.\n\nLess damage taken.\nMore melee damage dealt.\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                            // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 10%."},                        // Rank 3
			{Rank: 4, Description: "Increase damage protection by 5%."},                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase melee damage bonus by 15%."},                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield recharge rate by 15%."},                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage returned to targets that melee you by 24%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianArmor_Shared", Name: "Batarian Armor", Picture: "BatarianArmor.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reinforce armor with razor-sharp blades to damage enemies that melee.\n\nLess damage taken.\nMore melee damage dealt.\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                            // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 10%."},                        // Rank 3
			{Rank: 4, Description: "Increase damage protection by 5%."},                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase melee damage bonus by 15%."},                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase shield recharge rate by 15%."},                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage returned to targets that melee you by 24%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianAttack", Name: "Batarian Kick", Picture: "BatarianAttack.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Fire a salvo of blades to impale your enemies, inflicting massive bleed damage.\n\nThe closer your target is, the more damage you deal."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase cone spread by 20 degrees."},                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase attack range by 50%."},                                                 // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%.\nIncrease bleed duration by 50%."},                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Blades explode after 3 seconds, doing 400 damage but ending the bleed effect."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianNet", Name: "Batarian Net", Picture: "BatarianNet.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Entangle opponents in an electrified net, dealing massive damage to armored targets and incapacitating unarmored targets as they break free.\n\nTargets build up resistances to the grappling effects of the net."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase damage by 30%.\nIncrease duration by 30%."},                                        // Rank 3
			{Rank: 4, Description: "Increase damage by 40%."},                                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Incapacitate targets 1% longer."},                                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%.\nSlow armored targets by 30% for 10 seconds."},                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 45%."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to shields and barriers by 50%."},                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Improve the electrified net to deal 150 points of damage across 6 meters every 1 seconds."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianNet_Shared", Name: "Batarian Net", Picture: "BatarianNet.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Entangle opponents in an electrified net, dealing massive damage to armored targets and incapacitating unarmored targets as they break free.\n\nTargets build up resistances to the grappling effects of the net."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase damage by 30%.\nIncrease duration by 30%."},                                        // Rank 3
			{Rank: 4, Description: "Increase damage by 40%."},                                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Incapacitate targets 1% longer."},                                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%.\nSlow armored targets by 30% for 10 seconds."},                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 45%."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to shields and barriers by 50%."},                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Improve the electrified net to deal 150 points of damage across 6 meters every 1 seconds."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticFocus", Name: "Biotic Focus", Picture: "BioticFocus.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Focus your biotic energy and atavistic muscle structure to decrease damage taken and to increase melee damage and movement speed for a short time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                             // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                                                             // Rank 3
			{Rank: 4, Description: "Decrease damage taken by 10%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase movement speed by 7%."},                                                                                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase duration by 40%."},                                                                                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage bonus by 30%."},                                                                                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Activate to regenerate barriers by 40% and to gain an invulnerability effect for 50 seconds."},                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Enter a heightened biotic state to reduce damage taken by 20% and to increase movement speed by 7% and melee damage by 30%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticHammerModal", Name: "Biotic Hammer", Picture: "BioticHammerModal.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Charge your hammer with biotic energy, drastically increasing direct damage and force. Your melee attacks will expend these charges.\n\nHighly effective against armor and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                         // Rank 2
			{Rank: 3, Description: "Increase damage and force by 20%."},                                                                                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%.\nIncrease force by 40%."},                                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase recharge speed by 35%."},                                                                                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage and force of biotic detonations by 50%."},                                                                 // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage done to armor by 50%."},                                                                                   // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the force of impacts by 1%.\nImpact passes through armor, shields, or barriers to knock down humanoid targets."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the number of charges generated by Biotic Hammer by 1."},                                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticOrbs", Name: "Dark Energy Orbs", Picture: "BioticOrbs.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Summon 3 biotic orbs to float around you. Use the power again to launch an orb at your target. Each floating orb increases the recharge speed of your powers by 10%.\n\nHighly effective against armor and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                      // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                              // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 1%."},                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%."},                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the recharge speed bonus of each orb by 5%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Each orb impact causes the target to take 15% more damage from all sources for 6 seconds. This effect can stack up to 3 times."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the number of orbs summoned by 1. This also boosts the maximum recharge speed bonus applied by the orbs."},              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Bloodlust", Name: "Bloodlust", Picture: "Bloodlust.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "The vorcha flies into a frenzy, increasing movement speed, health regeneration, and melee damage. Each kill intensifies these effects and can stack up to three times.\n\nAdditional stacks last for 15 seconds.\nSlows power use by -60%.\nLasts until deactivated."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                           // Rank 2
			{Rank: 3, Description: "Increase health regeneration by 30%."},                                      // Rank 3
			{Rank: 4, Description: "Increase melee damage of each stack by 10%."},                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health regeneration of each stack by 50%"},                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage bonus of each stack by 5%."},                          // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase weapon damage bonus of each stack by 5%."},                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase movement speed bonus by 5%.\nIncrease melee damage bonus by 10%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health regeneration of each stack by an additional 1%."},           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Bloodlust_Shared", Name: "Bloodlust", Picture: "Bloodlust.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "The vorcha flies into a frenzy, increasing movement speed, health regeneration, and melee damage. Each kill intensifies these effects and can stack up to three times.\n\nAdditional stacks last for 15 seconds.\nSlows power use by -60%.\nLasts until deactivated."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                           // Rank 2
			{Rank: 3, Description: "Increase health regeneration by 30%."},                                      // Rank 3
			{Rank: 4, Description: "Increase melee damage of each stack by 10%."},                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health regeneration of each stack by 50%"},                         // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage bonus of each stack by 5%."},                          // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase weapon damage bonus of each stack by 5%."},                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase movement speed bonus by 5%.\nIncrease melee damage bonus by 10%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health regeneration of each stack by an additional 1%."},           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MercBowModalOne", Name: "Bow Shot", Picture: "BowModalOne.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Load 3 concussive charges into your omni-bow to increase impact force, to knock down unarmored enemies, and to increase the number of arrows fired simultaneously. When you run out of concussive charges, you will fire normal arrows again.\n\nHighly effective against barriers.\nConsumes a grenade."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},   // Rank 2
			{Rank: 3, Description: "Increase damage and force by 20%."}, // Rank 3
			{Rank: 4, Description: "Increase damage and force by 30%."}, // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase grenade capacity by 1."},   // Rank 4 - Evolution B
			{Rank: 6, Description: "Add an electrical effect to do an additional 1% damage over 5 seconds while briefly stunning the targets. This effect can be detonated."},                          // Rank 5 - Evolution A
			{Rank: 7, Description: "Add a chill effect to each arrow that slows enemy movement by -10% and increases all damage done to it by 5%. This effect lasts 8 seconds and can stack 3 times."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of arrows released per shot by 1."},                                                                                                            // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase grenade capacity by 2."},                                                                                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MercBowModalTwo", Name: "Bow Explosive Shot", Picture: "BowModalTwo.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Load 3 armor-piercing charges into your omni-bow to increase damage as well as the number of arrows fired simultaneously. When you run out of these armor-piercing charges, you will fire normal arrows again.\n\nHighly effective against armor.\nConsumes a grenade."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                                               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase grenade capacity by 1."},                                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Shreds targets, doing an additional 50% damage over 5 seconds."},                                                // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage done to armor by 35% to weaken the target's armor resistance to weapons by 50% for 8 seconds."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of arrows released per shot by 1."},                                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase grenade capacity by 2."},                                                                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BubbleShield", Name: "Barrier Bubbles", Picture: "BubbleShield.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Create a defensive shield that surrounds the caster and nearby allies.\n\nMore damage dealt to enemies entering the shielded area."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                                                                                 // Rank 2
			{Rank: 3, Description: "Increase duration by 30%."},                                                                                                                                                       // Rank 3
			{Rank: 4, Description: "Keep allies within the shield to decrease shield-recharge delay by 15%."},                                                                                                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the shield's radius by 30%."},                                                                                                                                            // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage reduction to allies within the shield by 10%."},                                                                                                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the damage taken by enemies within the shielded area by an additional 15%."},                                                                                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the damage that shielded allies take by 10%.\nDecrease the delay before shields regenerate by 10%."},                                                                     // Rank 6 - Evolution A
			{Rank: 9, Description: "Hit enemies inside the shield with Warp, dealing 50 damage per second and reducing armor by 25%.\n\nAffect up to 3 enemies at a time.\nSet an enemy up for a biotic detonation."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CainMine", Name: "M-920 Cain Mine", Picture: "CainMine.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Attach a C4 proximity explosive to any surface that arms after 1.5 seconds. Decimate the defenses of enemies that trip the sensor. Only 3 mines can be armed at a time.\n\nHighly effective against armor, shields, and barriers.\nConsumes a grenade."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},       // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},               // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase explosion radius by 30%."},     // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage done to armor by 50%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase grenade capacity by 2."},       // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},               // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase explosion radius by 50%."},     // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CryoCone", Name: "Cryo Cone", Picture: "CryoCone.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Flash-freeze unprotected enemies and slow down the rest with a wave of ice damage.\n\nFrozen targets don't regenerate health.\nWeaken armor by 25%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."}, // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},         // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase range by 50%."},          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the duration of freeze effects by 50%.\nDecrease the movement speed of chilled targets by an additional -20%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to chilled and frozen targets by 10%."},                                                                  // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 40%.\nWeaken armored targets by an additional 25%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the damage of tech combos by 1%."},                                                                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Damping", Name: "Damping", Picture: "Damping.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reveal weaknesses in defenses, increasing all damage done to the target and slowing its movement speed.\n\nProvide the entire squad with a tactical readout. Only one scan can be active on a target."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 50%."},                                                                                          // Rank 2
			{Rank: 3, Description: "Increase duration by 30%."},                                                                                                // Rank 3
			{Rank: 4, Description: "Increase all weapon damage done to the target by 7%."},                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase all power damage done to the target by 7%."},                                                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "This evolution is bugged and doesn't work."},                                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the target's movement speed penalty by 15%."},                                                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase all damage done to the target by 10%."},                                                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase scan duration by 1%.\nMomentarily reveal enemies within 20 meters of the target with an initial scanning pulse."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Damping_Shared", Name: "Damping", Picture: "Damping.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Reveal weaknesses in defenses, increasing all damage done to the target and slowing its movement speed.\n\nProvide the entire squad with a tactical readout. Only one scan can be active on a target."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 50%."},                                                                                          // Rank 2
			{Rank: 3, Description: "Increase duration by 30%."},                                                                                                // Rank 3
			{Rank: 4, Description: "Increase all weapon damage done to the target by 7%."},                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase all power damage done to the target by 7%."},                                                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "This evolution is bugged and doesn't work."},                                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the target's movement speed penalty by 15%."},                                                                     // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase all damage done to the target by 10%."},                                                                           // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase scan duration by 1%.\nMomentarily reveal enemies within 20 meters of the target with an initial scanning pulse."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_DarkSingularity", Name: "Dark Singularity", Picture: "DarkSingularity.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Summon 3 Seeker Swarms to cloud around you. Use the power again to launch a swarm at your target that deals damage and slows movement."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 15%."},                                                                                               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                                       // Rank 3
			{Rank: 4, Description: "Increase recharge speed by 25%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Decrease target movement speed by an additional -10%.\nIncrease the duration of the slowdown by 40%."},                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Upgrade the Seeker Swarm field for 10% damage protection for each active swarm."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage by 40%."},                                                                                                       // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the number of Seeker Swarms by 1."},                                                                                    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage by 50%.\nDecrease target movement speed by an additional -15%.\nIncrease the duration of the slowdown by 20%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_DevestatorMode", Name: "Devastator Mode", Picture: "DevestatorMode.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Turn into a powerful turret with the T5-V Battlesuit.\n\nIncrease weapon damage, rate of fire, and magazine size.\nSlows movement speed.\nStays active until disabled."}, // Rank 1
			{Rank: 2, Description: "Increase magazine size by 5%."},                              // Rank 2
			{Rank: 3, Description: "Increase damage bonus by 5%."},                               // Rank 3
			{Rank: 4, Description: "Reduce the delay before shields start regenerating by 15%."}, // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase weapon accuracy bonus by 25% while active."},        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase magazine size by 15%."},                             // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase rate of fire by 15%."},                              // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase max shields by 40%."},                               // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage bonus by 15%."},                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ElectricSlash", Name: "Electric Slash", Picture: "ElectricSlash.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Unleash a wave of electrical energy from your sword to stun and damage all enemies in a cone.\n\nHighly effective against shields/barriers.\nConsidered a power attack.\nReceives damage bonuses from power upgrades."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},            // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                    // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                    // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},             // Rank 4 - Evolution B
			{Rank: 6, Description: "This evolution is bugged and doesn't work."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 40%."},            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                    // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase range by 50%."},                     // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_EMPGrenade", Name: "EMP Grenade", Picture: "EMPGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Stun and electrocute your enemies with an EMP-packed grenade. Effective against shields and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                                       // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                               // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 1."},                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Add an electrical effect that does 40% additional damage over 10 seconds."},                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 75%."},                                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields and barriers by 75%."},                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Flamer", Name: "Flamer", Picture: "Flamer.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Fire a powerful short-range flame attack. The flames will persist for a max duration and can be canceled early for a faster recharge.\n\nHighly effective against armor.\n\nSubject to a self-stacking glitch; damage can reach 3 times the presented value with continuous fire. Applies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                 // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                         // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase range by 50%."},                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%."},                         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase duration by 60%."},                       // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 50%."},                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields and barriers by 50%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Flamer_Shared", Name: "Flamer", Picture: "Flamer.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Fire a powerful short-range flame attack. The flames will persist for a max duration and can be canceled early for a faster recharge.\n\nHighly effective against armor.\n\nSubject to a self-stacking glitch; damage can reach 3 times the presented value with continuous fire. Applies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                 // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                         // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase range by 50%."},                          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%."},                         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase duration by 60%."},                       // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 50%."},                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields and barriers by 50%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethSentryTurret", Name: "Geth Turret", Picture: "GethTurret.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Deploy a multifunctional turret that deals heavy damage and repairs the shields of allies within 8 meters every 8 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                             // Rank 2
			{Rank: 3, Description: "Increase turret's shields by 30%.\nIncrease turret's damage by 30%."},                         // Rank 3
			{Rank: 4, Description: "Increase turret's shields by 40%.\nIncrease turret's damage by 40%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the shields restored to allies by 50%."},                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the turret's damage by 30%.\nIncrease the damage done to armor by 50%."},             // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the shields restored to allies by 50%.\nIncrease the range of this ability by 40%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Upgrade turret with a close-range flamethrower that deals 55 points of damage per second."},   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the frequency of restoring shields by 60%."},                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethSentryTurret_MP5", Name: "Geth Turret (Juggernaut)", Picture: "GethTurret.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Deploy a multifunctional turret that deals heavy damage and repairs the shields of allies within 8 meters every 8 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                             // Rank 2
			{Rank: 3, Description: "Increase turret's shields by 30%.\nIncrease turret's damage by 30%."},                         // Rank 3
			{Rank: 4, Description: "Increase turret's shields by 40%.\nIncrease turret's damage by 40%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase the shields restored to allies by 50%."},                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the turret's damage by 30%.\nIncrease the damage done to armor by 50%."},             // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the shields restored to allies by 50%.\nIncrease the range of this ability by 40%."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Upgrade turret with a close-range flamethrower that deals 55 points of damage per second."},   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the frequency of restoring shields by 60%."},                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HexShield", Name: "Hex Shield", Picture: "HexShield.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Spawn a geth energy barrier that blocks all fast-moving projectiles, including bullets."},                             // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                     // Rank 2
			{Rank: 3, Description: "Increase shield strength by 20%."},                                                                                    // Rank 3
			{Rank: 4, Description: "Upon spawning, an electric pulse is emitted that does 400 damage in a 3 meter radius."},                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase shield strength by 30%."},                                                                                    // Rank 4 - Evolution B
			{Rank: 6, Description: "Enemies passing through the shield are electrified, taking 500 damage over 5 seconds. This effect can be detonated."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase duration by 1%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "While active, generate additional energy for all your systems to increase damage by 10%."},                            // Rank 6 - Evolution A
			{Rank: 9, Description: "Spawn a wider shield and increase shield strength by 40%."},                                                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HomingGrenade", Name: "Homing Grenade", Picture: "HomingGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch this seeking grenade to track down a target, causing a massive explosion on impact."},                   // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                                              // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                      // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 1."},                                                                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Add a fire effect to targets, dealing 50% additional damage over 5 seconds.\n\nApplies fire DoT."},             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 60%.\nDecrease weapon damage mitigation of armored targets by 50% for 8 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Split a grenade in half to seek two targets that do 60% damage each."},                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_HomingGrenade_Shared", Name: "Homing Grenade", Picture: "HomingGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Launch this seeking grenade to track down a target, causing a massive explosion on impact."},                   // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                                              // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                      // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 1."},                                                                              // Rank 5 - Evolution A
			{Rank: 7, Description: "Add a fire effect to targets, dealing 50% additional damage over 5 seconds.\n\nApplies fire DoT."},             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 60%.\nDecrease weapon damage mitigation of armored targets by 50% for 8 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Split a grenade in half to seek two targets that do 60% damage each."},                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BioticCharge_Krogan", Name: "Biotic Charge (Krogan)", Picture: "KroganBioticCharge.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Smash into a target while encased in this biotic barrier, leveling your opponents.\n\nInvulnerable while this power is in effect."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                               // Rank 2
			{Rank: 3, Description: "Increase damage and force by 30%."},                                             // Rank 3
			{Rank: 4, Description: "Increase damage and force by 40%."},                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Hit up to 2 additional targets within 2 meters of the impact point."},           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase weapon damage by 25% for 5 seconds after a successful Biotic Charge."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% for 5 seconds after a successful Biotic Charge."},  // Rank 5 - Evolution B
			{Rank: 8, Description: "Give Biotic Charge a 50% chance of not triggering a cooldown."},                 // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase barriers by an additional 50% after a successful Biotic Charge."},      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Lash", Name: "Lash", Picture: "Lash.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Latch this biotic field onto enemies to jerk them toward you, doing massive damage in the process."},                    // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase force and damage of biotic detonations by 50%."},                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 35%."},                                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Do an additional 1% damage over 10 seconds."},                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Give the power a 35% chance of not causing a cooldown.\nIncrease the time that lifted targets can be detonated by 1%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Penetrate through shields and barriers, lifting any target without armor but with reduced force."},                      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Lash_Shared", Name: "Lash", Picture: "Lash.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Latch this biotic field onto enemies to jerk them toward you, doing massive damage in the process."},                    // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase force and damage of biotic detonations by 50%."},                                                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 35%."},                                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Do an additional 1% damage over 10 seconds."},                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Give the power a 35% chance of not causing a cooldown.\nIncrease the time that lifted targets can be detonated by 1%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Penetrate through shields and barriers, lifting any target without armor but with reduced force."},                      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_LineStrike", Name: "Line Strike", Picture: "LineStrike.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Slash through an enemy line while encased in this biotic barrier causing instant biotic damage and applying a poison effect that does damage over time to every hit enemy.\n\nInvulnerable while this power is in effect."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                    // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                            // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase range by 40%."},                                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase poison duration by 60%."},                                                   // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase poison damage by 50%.\nParalyze up to 2 unshielded enemies for 4 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Reduce dash range by -40%, but only every other dash triggers a cooldown."},          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomAction_MissileLauncher", Name: "Missile Launcher", Picture: "MissileLauncher.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip a target into shreds with the T5-V's autofiring shoulder cannon.\n\nLock onto a target to launch a stinger missile.\nStays active until disabled.\nDecreases max shields by -50% while active."}, // Rank 1
			{Rank: 2, Description: "Reduce refire time by 10%."},                                                                                     // Rank 2
			{Rank: 3, Description: "Increase missile damage by 30%."},                                                                                // Rank 3
			{Rank: 4, Description: "Reduce shield penalty by 40%."},                                                                                  // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase missile damage and force by 40%."},                                                                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Reduce refire time by 35%."},                                                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase effectiveness against armored targets by 50%."},                                                         // Rank 5 - Evolution B
			{Rank: 8, Description: "Upgrade missile housing to fire 2 extra seeking projectiles.\n\nDecreases the payload of each missile by -25%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Upgrade missile munitions to increase damage and force by 1.5%.\nIncrease impact radius by 3%."},                 // Rank 6 - Evolution B
		},
	},

	// Missing DLC Active Powers --------------
	{
		ID: "SFXPowerCustomActionMP_DarkChannel2", Name: "Dark Channel", Picture: "DarkChannel.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Plague an opponent with a persistent, damaging biotic field.\n\nEffect transfers to a second target if the first is killed.\nEffect's length depends on Dark Channel's duration.\nOnly one field may be active at a time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power duration by 40%."},               // Rank 4 - Evolution B
			{Rank: 6, Description: "Slow target's movement speed by -30%."},         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to armor and barriers by 75%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DarkChannel2_Shared", Name: "Dark Channel", Picture: "DarkChannel.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Plague an opponent with a persistent, damaging biotic field.\n\nEffect transfers to a second target if the first is killed.\nEffect's length depends on Dark Channel's duration.\nOnly one field may be active at a time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power duration by 40%."},               // Rank 4 - Evolution B
			{Rank: 6, Description: "Slow target's movement speed by -30%."},         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to armor and barriers by 75%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Throw_N7", Name: "Throw", Picture: "Throw.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Toss your enemy through the air with this biotic blast."},           // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                   // Rank 2
			{Rank: 3, Description: "Increase force by 30%."},                                            // Rank 3
			{Rank: 4, Description: "Increase force by 40%."},                                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 2 meters."},                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase force and damage of biotic detonations by 50%."},           // Rank 5 - Evolution A
			{Rank: 7, Description: "Reset recharge time after a biotic combo detonates."},               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase force by 50%, and do an additional 200 damage on impact."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 60%."},                                   // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_EMPGrenade2", Name: "EMP Grenade", Picture: "EMPGrenade.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Stun and electrocute your enemies with an EMP-packed grenade. Effective against shields and barriers."}, // Rank 1
			{Rank: 2, Description: "Increase grenade capacity by 1."},                                                                       // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                               // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase impact radius by 30%."},                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase grenade capacity by 1."},                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Add an electrical effect that does 40% additional damage over 10 seconds."},                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to armor by 75%."},                                                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to shields and barriers by 75%."},                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_SnapFreeze", Name: "Snap Freeze", Picture: "CryoCone.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Flash-freeze unprotected enemies and slow down the rest with a wave of ice damage.\n\nFrozen targets don't regenerate health.\nWeaken armor by 25%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."}, // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},         // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase range by 50%."},          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the duration of freeze effects by 50%.\nDecrease the movement speed of chilled targets by an additional -20%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase damage to chilled and frozen targets by 10%."},                                                                  // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 40%.\nWeaken armored targets by an additional 25%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase the damage of tech combos by 1%."},                                                                              // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_DarkChannelProthean", Name: "Dark Channel (Prothean)", Picture: "DarkChannel.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost biotic and offensive abilities.\nIncrease Collector and Prothean weapon damage."},            // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                              // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                                  // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},    // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                  // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase power damage and force bonuses by 20%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease Collector and Prothean weapon damage bonus by 5%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TechArmor_Warlord", Name: "Tech Armor (Warlord)", Picture: "TechArmor.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\n\nSlows power use by -50%."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},                                                            // Rank 2
			{Rank: 3, Description: "Increase detonation damage by 20%.\nIncrease impact radius by 20%."},                                                // Rank 3
			{Rank: 4, Description: "Increase detonation damage by 30%.\nIncrease impact radius by 30%."},                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage protection by an additional 5%."},                                                                   // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce power speed penalty by 30%."},                                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage protection by an additional 10%."},                                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FembotCloak", Name: "Tactical Cloak (Geth)", Picture: "Cloak.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 40%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Shotguns fired during cloak do 25% more damage."},                                      // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariCloak", Name: "Tactical Cloak (Asari)", Picture: "Cloak.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 60%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase power damage by 40%."},                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_TurianCloak", Name: "Tactical Cloak (Turian)", Picture: "Cloak.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Become invisible.\n\nGain a massive damage bonus when breaking from cloak to attack."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 1.5%."},                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase damage bonus by 40%."},                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 30%."},                                                      // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},                                      // Rank 6 - Evolution A
			{Rank: 9, Description: "When Tactical Cloak is activated, assault rifles do 20% more damage for 20 seconds."},  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_JetPackCharge", Name: "Havoc Strike", Picture: "HavocStrike.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Use the propulsion pack to launch a devastating strike on multiple targets."},                           // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                       // Rank 2
			{Rank: 3, Description: "Increase damage and force by 25%."},                                                                     // Rank 3
			{Rank: 4, Description: "Increase damage and force by 35%."},                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase recharge speed by 30%."},                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase weapon damage by 25% for 5 seconds after a successful charge."},                                // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase melee damage by 40% for 5 seconds after a successful charge."},                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 55%."},                                                                               // Rank 6 - Evolution A
			{Rank: 9, Description: "Expand the spread of the flame to hit up to 2 additional targets within 3 meters of the impact point."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_Decoy_Volus", Name: "Decoy (Volus)", Picture: "Decoy.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Distract opponents with this decoy."},                                  // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                      // Rank 2
			{Rank: 3, Description: "Increase power duration by 30%."},                                      // Rank 3
			{Rank: 4, Description: "Increase power duration by 40%."},                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase shields by 40%."},                                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Shock enemies for 100 points within a 2.5 meter radius of the decoy."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},                                      // Rank 5 - Evolution B
			{Rank: 8, Description: "Decoy explodes on destruction, causing 300 damage across 4 meters."},   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase shields by 50%.\nIncrease duration by 50%."},                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ShieldBoost", Name: "Shield Boost (Volus)", Picture: "ShieldBoost.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Repair your shields and those of nearby allies, providing a large initial boost to shields, and then restoring shields every second for 3 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                       // Rank 2
			{Rank: 3, Description: "Increase shields restored by 30%."},                                                                     // Rank 3
			{Rank: 4, Description: "Increase impact radius by 40%."},                                                                        // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase shields restored by 40%."},                                                                     // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 35%."},                                                                       // Rank 5 - Evolution A
			{Rank: 7, Description: "Reduce the delay before shields start regenerating by 20% for 12 seconds for you and affected allies."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the duration that shields are restored by 1%."},                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase shield restoration by 50%, causing you and affected allies to take 50% less damage for 6 seconds.\nTotal damage reduction from all sources cannot exceed 90%."}, // Rank 6 - Evolution B
		},
	},

	// DLC Passives (Melee) --------------------
	// MP1
	{
		ID: "SFXPowerCustomActionMP_GethMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, durability, and shield regeneration."},                                                // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethMeleePassive_Shared", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, durability, and shield regeneration."},                                                // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianMeleePassive_Shared", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariMeleePassive_Commando", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganMeleePassive_Vanguard", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, and durability.\n\nMelee and kill 3 enemies within 30 seconds to send the krogan into a frenzy, increasing melee damage and reducing damage taken for 30 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                             // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 25%."},                                                                                    // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%.\nIncrease melee damage bonus by 30% while in Rage mode."},                            // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonues by 20%.\nIncrease damage protection by an additional 5% while in Rage mode."},          // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                 // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nReduce the number of melee kills required to trigger Rage to 2 within 30 seconds."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%.\nIncrease damage protection by 5% while in Rage mode."},                       // Rank 6 - Evolution B
		},
	},
	// MP2
	{
		ID: "SFXPowerCustomActionMP_WhipManMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MaleQuarianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 30% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MaleQuarianMeleePassive_Shared", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 30% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_VorchaMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 30% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_VorchaMeleePassive_Shared", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 30% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	// MP3
	{
		ID: "SFXPowerCustomActionMP_N7EngineerMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7InfiltratorMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, durability, and movement speed."},                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                              // Rank 2
			{Rank: 3, Description: "Increase sword damage by 20%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase sword damage by 30%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase sword damage by 50% for 20 seconds after an enemy is killed by a sword attack."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 10%.\nIncrease movement speed by 10%."},                 // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase sword damage to shields/barrier by 50%."},                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase sword damage to armor by 50%."},                                                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7VanguardMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7SentinelMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},            // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                               // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                      // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                      // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                               // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase the damage the omni-shield withstands before collapsing by 50%."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                   // Rank 5 - Evolution B
			{Rank: 8, Description: "Add a flame effect to your omni-shield. Your shield melees will burn enemies and are highly effective against armor.\n\nAdds a fire effect to impacted targets that does 50% additional damage over 5 seconds.\n\nApplies fire DoT."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Add a freezing effect to your omni-shield that can chill or freeze enemies.\n\nSnap freeze unprotected enemies.\nSlow shielded and armored targets by -30%.\nWeaken enemy armor by 50% for 5 seconds."},                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7AdeptMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	// MP4
	{
		ID: "SFXPowerCustomActionMP_VolusMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                     // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                        // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                               // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                               // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                        // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                            // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                            // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease power damage bonus by 30% for 20 seconds after an enemy is killed by a heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                        // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7TurianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 30% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	// MP5
	{
		ID: "SFXPowerCustomActionMP_FembotMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability."},                                                                    // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 15%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 10%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 10%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 10%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemTurianMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, and durability.\n\n30 of melee damage is applied as poison damage over 5 seconds."},           // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%."},                                                                                       // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                              // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                              // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%."},                                                                                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                           // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nIncrease weapon damage bonus by 25% for 20 seconds after an enemy is killed by heavy melee."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%."},                                                                                       // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethDestroyerMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, and shield regeneration in addition to upgrading shield draining and advanced squad tactics. Shield upgrades also increase the strength of your Hex Shield.\n\nYour heavy melee drains energy from your target, restoring your shields."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 15%.\nIncrease the shields restored by heavy melee by 15%."},                                                                                                                                                                             // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                             // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%."},                                                                                             // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%.\nIncrease the shields restored by heavy melee by 20%."},                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase movement speed by 15% for 10 seconds after an enemy is killed by a heavy melee."},                                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                          // Rank 5 - Evolution B
			{Rank: 8, Description: "All allies within 4 meters do 10% more damage. This bonus does not affect you.\nIncrease your melee damage by 30%."},              // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 75%.\nIncrease shields restored by heavy melee by 50%.\nDecrease all damage done by -15%."}, // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MercMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, and omni-bow damage. Your omni-bow attacks are considered melee attacks and receive bonuses from melee upgrades. Concussive and armor-piercing arrows are considered power attacks and receive bonuses from power upgrades. While active, concussive and armor-piercing arrow damage supplements the base omni-bow damage."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                // Rank 2
			{Rank: 3, Description: "Increase omni-bow damage by 25%."},                                                          // Rank 3
			{Rank: 4, Description: "Increase omni-bow damage by 35%."},                                                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase omni-bow damage by 25% for 30 seconds after an enemy is killed by your omni-bow."}, // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase omni-bow damage by 50%."},                                                          // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_WarlordMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields, melee damage, and durability.\nThis krogan regenerates health slowly during combat, restoring 100 health per second.\n\nMelee and kill 2 enemies within 45 seconds to go into a frenzy to increase melee damage, reduce damage taken, and to boost health regeneration for 45 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                                    // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 25%."},                                                                                                           // Rank 3
			{Rank: 4, Description: "Increase melee damage bonus by 30%.\nIncrease melee damage bonus by 30% while in Rage mode."},                                                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 20%.\nIncrease damage protection by an additional 5% and health regeneration by 40% while in Rage mode."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase melee damage by 75% for 30 seconds after an enemy is killed by a heavy melee."},                                                        // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase melee damage bonus by 30%.\nReduce the number of melee kills required to trigger Rage to 1 within 45 seconds."},                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 30%.\nIncrease damage protection by 5% and health regeneration by 60% while in Rage mode."},               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_ProtheanMeleePassive", Name: "Fitness", Picture: "MPMeleePassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Plague an opponent with a persistent, damaging biotic field.\n\nEffect transfers to a second target if the first is killed.\nEffect's length depends on Dark Channel's duration.\nOnly one field may be active at a time."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},               // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                       // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power duration by 40%."},               // Rank 4 - Evolution B
			{Rank: 6, Description: "Slow target's movement speed by -30%."},         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase recharge speed by 35%."},               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 50%."},                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase damage to armor and barriers by 75%."}, // Rank 6 - Evolution B
		},
	},

	// DLC Passives (Race/Class) ---------------
	// MP1
	{
		ID: "SFXPowerCustomActionMP_GethPassive", Name: "Geth Hardware", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Advanced combat platform fine-tunes powers and weapons, especially geth weapons.\n\nMore power damage.\nMore weapon damage.\nMore geth weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of assault rifles and sniper rifles by 25%."},                                 // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease geth weapon damage bonus by 5%."},                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethPassive_Shared", Name: "Geth Hardware", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Advanced combat platform fine-tunes powers and weapons, especially geth weapons.\n\nMore power damage.\nMore weapon damage.\nMore geth weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of assault rifles and sniper rifles by 25%."},                                 // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease geth weapon damage bonus by 5%."},                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianPassive", Name: "Batarian Enforcer", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "The destruction of their home system has made the batarians even more ruthless in their struggle for survival.\n\nMore power damage.\nMore weapon damage.\nGreater thermal clip capacity.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%.\nIncrease spare ammunition by 5%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 25 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of sniper rifles and shotguns by 25%."},                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage by 10%.\nIncrease spare ammunition by 10%."},                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_BatarianPassive_Shared", Name: "Batarian Enforcer", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "The destruction of their home system has made the batarians even more ruthless in their struggle for survival.\n\nMore power damage.\nMore weapon damage.\nGreater thermal clip capacity.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%.\nIncrease spare ammunition by 5%."},                         // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 25 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of sniper rifles and shotguns by 25%."},                                       // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage by 10%.\nIncrease spare ammunition by 10%."},                             // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariCommandoPassive", Name: "Asari Commando", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Centuries of rigid training gives the asari greater martial prowess and the mental focus to strengthen their biotics.\n\nLonger power duration.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                           // Rank 2
			{Rank: 3, Description: "Increase power duration bonuses by 20%."},                                       // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power duration by 25%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease assault rifle weight by 30%."},                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_KroganPassive_Vanguard", Name: "Krogan Vanguard", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP1",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Battle-skills hardened on unforgiving Tuchanka come into play.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                                            // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                       // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                             // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of shotguns by 30%."},                                                                                   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                      // Rank 6 - Evolution B
		},
	},
	// MP2
	{
		ID: "SFXPowerCustomActionMP_WhipManPassive", Name: "Cerberus Operative", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "These operatives had upgrades installed by their former employer Cerberus to dramatically improve biotic and combat skills.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of pistols and shotguns by 25%."},                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MaleQuarianPassive", Name: "Quarian Machinist", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Built on a lifetime spent defending the flotilla from the geth, combat skills reach new heights.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MaleQuarianPassive_Shared", Name: "Quarian Machinist", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Built on a lifetime spent defending the flotilla from the geth, combat skills reach new heights.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 12%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_VorchaPassive", Name: "Vorcha Survivor", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "A vorcha's adaptable nature gives them advantages in combat.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                                                                     // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 5%."},                                                                          // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                  // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of shotguns and assault rifles by 25%."},                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                    // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_VorchaPassive_Shared", Name: "Vorcha Survivor", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP2",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "A vorcha's adaptable nature gives them advantages in combat.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                                                                     // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 5%."},                                                                          // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                     // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                         // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                  // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of shotguns and assault rifles by 25%."},                                                                // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                    // Rank 6 - Evolution B
		},
	},
	// MP3
	{
		ID: "SFXPowerCustomActionMP_N7EngineerPassive", Name: "N7 Engineer", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Combat skills are perfected to an art with N7 training.\n\nMore power damage.\nMore weapon damage.\nGreater grenade capacity."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 10%."},                                                                               // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease grenade capacity by 1."},                                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase power damage and force bonuses by 20%."},                                                                               // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease grenade capacity by 1."},                                                         // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7InfiltratorPassive", Name: "N7 Infiltrator", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Combat skills are perfected to an art with N7 training.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                                     // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                    // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7VanguardPassive", Name: "N7 Vanguard", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Combat skills are perfected to an art with N7 training.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 10%."},                                                                    // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                    // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7SentinelPassive", Name: "N7 Sentinel", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Combat skills are perfected to an art with N7 training.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 10%."},                                                                    // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                    // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                               // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7AdeptPassive", Name: "N7 Adept", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP3",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Combat skills are perfected to an art with N7 training.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 10%."},                                                                    // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                      // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                    // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                             // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                                             // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                               // Rank 6 - Evolution B
		},
	},
	// MP4
	{
		ID: "SFXPowerCustomActionMP_VolusPassive", Name: "Volus Mercenary", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Upgrades to the advanced power armor suit provide enhanced combat abilities.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase the amount of shields restored by Shield Boost by 30%."},                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariPassive_Infiltrator", Name: "Asari Infiltrator", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Centuries of training as a justicar come into focus on the battlefield.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of heavy pistols by 30%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_AsariPassive_Sentinel", Name: "Asari Sentinel", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Centuries of training as a justicar come into focus on the battlefield.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 2%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                               // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of heavy pistols by 30%."},                                                  // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                          // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_N7TurianPassive", Name: "N7 Turian", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP4",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "The turian's lethal 26th Armiger Legion is a respected and feared frontline assault squad.\n\nMore weapon damage.\nGreater stability and weapon control.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon stability bonus by 15%."},                                                       // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%.\nIncrease weapon stability bonus by 10%."},                  // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 25 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease assault rifle weight by 30%."},                                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease weapon stability bonus by 10%."},                 // Rank 6 - Evolution B
		},
	},
	// MP5
	{
		ID: "SFXPowerCustomActionMP_FembotPassive", Name: "Geth Juggernaut", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "An infiltration unit designed for close-quarters combat.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                                                                 // Rank 2
			{Rank: 3, Description: "Increase power damage and force bonuses by 10%."},                                                                     // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                 // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."},                       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                              // Rank 5 - Evolution B
			{Rank: 8, Description: "Reduce the weight of pistols and shotguns by 25%."},                                                                   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_FemTurianPassive", Name: "Turian Cabal", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Seasoned by years of hard fighting across the galaxy, combat skills come into their own.\n\nMore weapon damage.\nGreater stability and weapon control.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon stability bonus by 15%."},                                                       // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 10%.\nIncrease weapon stability bonus by 10%."},                 // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 15%.\nIncrease weight capacity bonus by 25 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 20%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 30%."},                                                        // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease assault rifle weight by 30%."},                                                         // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 12%.\nIncrease weapon stability bonus by 10%."},                 // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_GethDestroyerPassive", Name: "Geth Destroyer", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "This advanced combat platform fine-tunes powers and weapons.\n\nMore weapon damage.\nMore weapon stability and spare ammunition.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase weapon damage bonus by 5%."},                                                           // Rank 2
			{Rank: 3, Description: "Increase weapon stability by 5%.\nIncrease spare ammunition by 5%."},                            // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                           // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\nIncrease weight capacity bonus by 20 points."}, // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase weapon stability by 15%.\nIncrease spare ammunition by 15%."},                          // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease weight of all weapons by 20%."},                                                        // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%.\nIncrease damage done with geth weapons by 5%."},           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_MercPassive", Name: "Talon Mercenary", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Years of experience working for hire have honed your combat abilities.\n\nIncrease power and weapon damage. Your battery pack also slowly regenerates a charge that can be consumed to lay Cain Trip Mines or to equip Concussive or Armor-Piercing Arrows."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},        // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                   // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                   // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 12%."},       // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},       // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase the rate that charges are regenerated by 1%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                  // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_CollectorPassive", Name: "Collector", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability.\n\nUtilize heavy melee to switch to the powerful Ascension Stance to increase damage and power recharge speed at the expense of increasing the damage taken. This stance lasts 45 seconds."}, // Rank 1
			{Rank: 2, Description: "Increase health and shield bonuses by 10%."},                                                                                           // Rank 2
			{Rank: 3, Description: "Increase melee damage bonus by 20%."},                                                                                                  // Rank 3
			{Rank: 4, Description: "Increase damage bonus by 5% while Ascension Stance is active."},                                                                        // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase health and shield bonuses by 15%."},                                                                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase recharge speed by 10% while Ascension Stance is active."},                                                                     // Rank 5 - Evolution A
			{Rank: 7, Description: "Decrease shield-recharge delay by 15%."},                                                                                               // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage by 10% and recharge speed by 10% while Ascension Stance is active at the expense of damage taken increasing by -10%."}, // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase health and shield bonuses by 25%."},                                                                                           // Rank 6 - Evolution B
		},
	},
	{
		ID: "SFXPowerCustomActionMP_WarlordPassive", Name: "Krogan Warlord", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_CON_MP5",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Battle-skills hardened on unforgiving Tuchanka come into play.\n\nMore power damage.\nMore weapon damage.\nMore strength."}, // Rank 1
			{Rank: 2, Description: "Increase power damage and force bonuses by 5%."},                                                                            // Rank 2
			{Rank: 3, Description: "Increase weapon damage bonus by 5%."},                                                                                       // Rank 3
			{Rank: 4, Description: "Increase weapon damage bonus by 7%."},                                                                                       // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase power damage and force bonuses by 5%.\nIncrease weight capacity bonus by 30 points."},                              // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase power damage and force bonuses by 15%."},                                                                           // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase headshot damage bonus by 20%."},                                                                                    // Rank 5 - Evolution B
			{Rank: 8, Description: "Decrease the weight of shotguns by 30%."},                                                                                   // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase weapon damage bonus by 10%."},                                                                                      // Rank 6 - Evolution B
		},
	},

	//Squadmate Powers ----------------------
	{
		ID: "SFXPowerCustomAction_JackPassive", Name: "Subject Zero", Picture: "MPPassive.webp",
		RootPath: "SFXGameContentDLC_EXP_Pack003",
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
		RootPath: "SFXGameContent",
		RankDescs: []RankDesc{
			{Rank: 1, Description: "Rip your enemy apart at a molecular level.\n\nStop targeted enemy from regenerating health.\nWeaken armor.\n\nApplies fire DoT."}, // Rank 1
			{Rank: 2, Description: "Increase recharge speed by 25%."},                                                                                  // Rank 2
			{Rank: 3, Description: "Increase damage by 20%."},                                                                                          // Rank 3
			{Rank: 4, Description: "Increase damage by 30%."},                                                                                          // Rank 4 - Evolution A
			{Rank: 5, Description: "Increase force, damage, and impact radius of combo detonations by 50%."},                                           // Rank 4 - Evolution B
			{Rank: 6, Description: "Increase damage by 40%.\nIncrease duration by 60%."},                                                               // Rank 5 - Evolution A
			{Rank: 7, Description: "Increase weapon damage taken by a target by 15%.\nIncrease power damage taken by a target by 15% for 10 seconds."}, // Rank 5 - Evolution B
			{Rank: 8, Description: "Increase damage to barriers and armor by 50%.\nWeaken armored targets by an additional 25%."},                      // Rank 6 - Evolution A
			{Rank: 9, Description: "Increase recharge speed by 35%."},                                                                                  // Rank 6 - Evolution B
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

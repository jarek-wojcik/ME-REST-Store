"""
Patch powers.go:
  - Remove entries whose IDs are NOT in characters.go
  - Add entries whose IDs ARE in characters.go but MISSING from powers.go
"""
import re, textwrap

POWERS_FILE = "SFS_Core_ASI/SFSWebserver/model/powers.go"

# ---------------------------------------------------------------------------
# IDs to REMOVE (in powers.go but not referenced by any character)
# ---------------------------------------------------------------------------
IDS_TO_REMOVE = {
    "SFXPowerCustomActionMP_Barrier",
    "SFXPowerCustomActionMP_DarkChannel",
    "SFXPowerCustomActionMP_GethShieldBoost",
    "SFXPowerCustomActionMP_JetPackCharge_Base",
    "SFXPowerCustomActionMP_N7SoldierMeleePassive",
    "SFXPowerCustomActionMP_N7SoldierPassive",
    "SFXPowerCustomAction_GruntPassive",
    "SFXPowerCustomAction_JacobPassive",
    "SFXPowerCustomAction_KasumiPassive",
    "SFXPowerCustomAction_MirandaPassive",
    "SFXPowerCustomAction_SamaraPassive",
    "SFXPowerCustomAction_WrexPassive",
    "SFXPowerCustomAction_ZaeedPassive",
}

# ---------------------------------------------------------------------------
# New entries to INSERT.
# Each tuple: (anchor_id, position, entry_text)
#   anchor_id  = full ID of the existing entry to anchor near
#   position   = 'after'  → insert after that entry's closing `},`
# The entry_text is the verbatim Go source for the new PowerDef block.
# ---------------------------------------------------------------------------

# ── compact melee/fitness passive template ──────────────────────────────────
def melee_passive(id_, name, rootpath):
    return f"""\t{{
\t\tID: "{id_}", Name: "{name}", Picture: "MPMeleePassive.webp",
\t\tRootPath: "{rootpath}",
\t\tRankDescs: []RankDesc{{
\t\t\t{{Rank: 1, Description: "Boost health, shields/barriers, melee damage, and durability.\\n\\nUtilize heavy melee to switch to the powerful Ascension Stance to increase damage and power recharge speed at the expense of increasing the damage taken. This stance lasts 45 seconds."}}, {{Rank: 2, Description: "Increase health and shield bonuses by 10%."}}, {{Rank: 3, Description: "Increase melee damage bonus by 20%."}},
\t\t\t{{Rank: 4, Description: "Increase damage bonus by 5% while Ascension Stance is active."}}, {{Rank: 5, Description: "Increase health and shield bonuses by 15%."}}, {{Rank: 6, Description: "Increase recharge speed by 10% while Ascension Stance is active."}},
\t\t\t{{Rank: 7, Description: "Decrease shield-recharge delay by 15%."}}, {{Rank: 8, Description: "Increase damage by 10% and recharge speed by 10% while Ascension Stance is active at the expense of damage taken increasing by -10%."}}, {{Rank: 9, Description: "Increase health and shield bonuses by 25%."}},
\t\t}},
\t}},"""

def race_passive(id_, name, faction_name, rootpath):
    return f"""\t{{
\t\tID: "{id_}", Name: "{faction_name}", Picture: "MPPassive.webp",
\t\tRootPath: "{rootpath}",
\t\tRankDescs: []RankDesc{{
\t\t\t{{Rank: 1, Description: "A decade of rigorous combat training in the Alliance starts to click.\\n\\nMore power damage.\\nMore weapon damage.\\nMore strength."}}, {{Rank: 2, Description: "Increase power damage and force bonuses by 5%."}}, {{Rank: 3, Description: "Increase weapon damage bonus by 5%."}},
\t\t\t{{Rank: 4, Description: "Increase weapon damage bonus by 8%."}}, {{Rank: 5, Description: "Increase power damage and force bonuses by 10%.\\nIncrease weight capacity bonus by 20 points."}}, {{Rank: 6, Description: "Increase power damage and force bonuses by 15%."}},
\t\t\t{{Rank: 7, Description: "Increase headshot damage bonus by 20%."}}, {{Rank: 8, Description: "Decrease weight of all weapons by 20%."}}, {{Rank: 9, Description: "Increase weapon damage bonus by 10%."}},
\t\t}},
\t}},"""

# ── full (multi-line) active power template helpers ─────────────────────────
# Each helper returns the verbatim text for one new entry.

NEW_ENTRIES = {
    # ── Cloak variants ──────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Cloak_Geth": (
        "SFXPowerCustomActionMP_Cloak",  # anchor – insert after this ID
        """\t{
\t\tID: "SFXPowerCustomActionMP_Cloak_Geth", Name: "Tactical Cloak (Geth Infiltrator)", Picture: "Cloak.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Become invisible.\\n\\nGain a massive damage bonus when breaking from cloak to attack."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase power duration by 30%."},
\t\t\t{Rank: 4, Description: "Increase power duration by 150%."},
\t\t\t{Rank: 5, Description: "Increase damage bonus by 40%."},
\t\t\t{Rank: 6, Description: "Increase recharge speed by 30%."},
\t\t\t{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},
\t\t\t{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},
\t\t\t{Rank: 9, Description: "Increase sniper rifle damage by 25% while cloaked."},
\t\t},
\t},"""
    ),
    "SFXPowerCustomActionMP_Cloak_N7Infiltrator": (
        "SFXPowerCustomActionMP_Cloak_Geth",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Cloak_N7Infiltrator", Name: "Tactical Cloak (N7 Shadow)", Picture: "Cloak.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP3",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Become invisible.\\n\\nGain a massive damage bonus when breaking from cloak to attack."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase power duration by 30%."},
\t\t\t{Rank: 4, Description: "Increase power duration by 150%."},
\t\t\t{Rank: 5, Description: "Increase damage bonus by 40%."},
\t\t\t{Rank: 6, Description: "Increase recharge speed by 30%."},
\t\t\t{Rank: 7, Description: "Increase melee damage by 50% while cloaked."},
\t\t\t{Rank: 8, Description: "Fire one power while cloaked and remain hidden."},
\t\t\t{Rank: 9, Description: "Increase sniper rifle damage by 25% while cloaked."},
\t\t},
\t},"""
    ),
    # ── Overload (Geth) ─────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Overload_Geth": (
        "SFXPowerCustomActionMP_Overload",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Overload_Geth", Name: "Overload (Geth)", Picture: "Overload.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Overload electronics with this power surge, stunning your enemy.\\n\\nEffective against shields, barriers, and synthetics.\\nNot as effective against organics."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Hit 1 additional target within 8 meters with 60% less damage."},
\t\t\t{Rank: 5, Description: "Increase damage by 30%."},
\t\t\t{Rank: 6, Description: "Incapacitate weaker organic enemies for a short duration."},
\t\t\t{Rank: 7, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 8, Description: "Increase damage by 15%.\\nHit 1 additional target within 8 meters with 60% less damage."},
\t\t\t{Rank: 9, Description: "Increase damage to barriers and shields by an additional 100%."},
\t\t},
\t},"""
    ),
    # ── Pull (Asari) ─────────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Pull_Asari": (
        "SFXPowerCustomActionMP_Pull",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Pull_Asari", Name: "Pull (Asari Justicar)", Picture: "Pull.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Yank an opponent helplessly off the ground."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase duration by 50%."},
\t\t\t{Rank: 4, Description: "Increase duration by 100%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 2.5 meters."},
\t\t\t{Rank: 6, Description: "Inflict 75 damage per second to lifted targets."},
\t\t\t{Rank: 7, Description: "Increase all damage to targets lifted by Pull by 30%."},
\t\t\t{Rank: 8, Description: "Increase duration by 50%, and increase the force and damage of biotic detonations on affected targets by 75%."},
\t\t\t{Rank: 9, Description: "Increase recharge speed by 150%."},
\t\t},
\t},"""
    ),
    # ── Reave (Asari) ────────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Reave_Asari": (
        "SFXPowerCustomActionMP_Reave",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Reave_Asari", Name: "Reave (Asari Justicar)", Picture: "Reave.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Drain a target's health and disrupt their resistances, receiving increased damage protection while this power is in effect.\\n\\nEffective against barriers and armor."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase duration by 35%."},
\t\t\t{Rank: 4, Description: "Increase duration by 40%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 3 meters."},
\t\t\t{Rank: 6, Description: "Increase damage protection by 10%."},
\t\t\t{Rank: 7, Description: "Increase recharge speed by 35%."},
\t\t\t{Rank: 8, Description: "Increase effectiveness against armor and barriers by 75%."},
\t\t\t{Rank: 9, Description: "Increase damage by 30%.\\nIncrease duration by 30%.\\nIncrease damage protection bonus by 15%."},
\t\t},
\t},"""
    ),
    # ── Shockwave (Batarian) ─────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Shockwave_Batarian": (
        "SFXPowerCustomActionMP_Shockwave",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Shockwave_Batarian", Name: "Shockwave (Batarian)", Picture: "Shockwave.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Topple a row of enemies with this cascading shockwave."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage and force by 25%."},
\t\t\t{Rank: 4, Description: "Increase damage and force by 30%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 30%."},
\t\t\t{Rank: 6, Description: "Increase force and damage of biotic detonations by 65%."},
\t\t\t{Rank: 7, Description: "Increase the distance that Shockwave cascades by 50%."},
\t\t\t{Rank: 8, Description: "Increase recharge speed by 40%."},
\t\t\t{Rank: 9, Description: "Suspend targets in the air for a short time."},
\t\t},
\t},"""
    ),
    # ── Inferno Grenade (Batarian) ───────────────────────────────────────────
    "SFXPowerCustomActionMP_InfernoGrenade_Batarian": (
        "SFXPowerCustomActionMP_InfernoGrenade",
        """\t{
\t\tID: "SFXPowerCustomActionMP_InfernoGrenade_Batarian", Name: "Inferno Grenade (Batarian)", Picture: "InfernoGrenade.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Cluster-bomb a small area with incendiary munitions.\\n\\nDamage can be sustained indefinitely with Incendiary ammo. Applies fire DoT."},
\t\t\t{Rank: 2, Description: "Increase grenade capacity by 1."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 30%."},
\t\t\t{Rank: 6, Description: "Increase grenade capacity by 2."},
\t\t\t{Rank: 7, Description: "Increase damage by 40%."},
\t\t\t{Rank: 8, Description: "Increase damage to armor by 50%."},
\t\t\t{Rank: 9, Description: "Increase impact radius by 50%.\\nIncrease shrapnel by 1 fragments."},
\t\t},
\t},"""
    ),
    # ── Proximity Mine (Geth) ────────────────────────────────────────────────
    "SFXPowerCustomActionMP_ProximityMine_Geth": (
        "SFXPowerCustomActionMP_ProximityMine",
        """\t{
\t\tID: "SFXPowerCustomActionMP_ProximityMine_Geth", Name: "Proximity Mine (Geth)", Picture: "ProximityMine.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Fire this sticky mine into traffic. It will detonate when an enemy steps within range."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 50%."},
\t\t\t{Rank: 6, Description: "Increase damage dealt to targets from all sources by 20% for 8 seconds."},
\t\t\t{Rank: 7, Description: "Slow target's movement speed by -30% for 8 seconds."},
\t\t\t{Rank: 8, Description: "Increase damage by 50%."},
\t\t\t{Rank: 9, Description: "Increase recharge speed by 40%."},
\t\t},
\t},"""
    ),
    # ── Barrier (Shared) ─────────────────────────────────────────────────────
    # (base Barrier is being removed; Shared and KroganVanguard variants replace it)
    "SFXPowerCustomActionMP_Barrier_Shared": (
        "SFXPowerCustomActionMP_BioticCharge",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Barrier_Shared", Name: "Barrier", Picture: "Barrier.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Reinforce armor with this biotic field. Detonate the field to lift and dangle nearby targets.\\n\\nReduce all forms of damage taken.\\nSlows power use by -50%."},
\t\t\t{Rank: 2, Description: "Increase recharge speed after detonation by 25%."},
\t\t\t{Rank: 3, Description: "Increase the damage, force, and radius of the detonation by 20%."},
\t\t\t{Rank: 4, Description: "Increase the damage, force, and radius of the detonation by 30%."},
\t\t\t{Rank: 5, Description: "Decrease damage taken by 5%."},
\t\t\t{Rank: 6, Description: "Increase shield regeneration rate by 15% while Barrier is active."},
\t\t\t{Rank: 7, Description: "Increase damage and force by 30% while Barrier is active."},
\t\t\t{Rank: 8, Description: "Reduce power speed penalty by 30%."},
\t\t\t{Rank: 9, Description: "Increase damage protection by 10%."},
\t\t},
\t},"""
    ),
    "SFXPowerCustomActionMP_Barrier_KroganVanguard": (
        "SFXPowerCustomActionMP_Barrier_Shared",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Barrier_KroganVanguard", Name: "Barrier (Krogan Vanguard)", Picture: "Barrier.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Reinforce armor with this biotic field. Detonate the field to lift and dangle nearby targets.\\n\\nReduce all forms of damage taken.\\nSlows power use by -50%."},
\t\t\t{Rank: 2, Description: "Increase recharge speed after detonation by 25%."},
\t\t\t{Rank: 3, Description: "Increase the damage, force, and radius of the detonation by 20%."},
\t\t\t{Rank: 4, Description: "Increase the damage, force, and radius of the detonation by 30%."},
\t\t\t{Rank: 5, Description: "Decrease damage taken by 5%."},
\t\t\t{Rank: 6, Description: "Increase shield regeneration rate by 15% while Barrier is active."},
\t\t\t{Rank: 7, Description: "Increase damage and force by 30% while Barrier is active."},
\t\t\t{Rank: 8, Description: "Reduce power speed penalty by 30%."},
\t\t\t{Rank: 9, Description: "Increase damage protection by 10%."},
\t\t},
\t},"""
    ),
    # ── Lash (Shared) ────────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Lash_Shared": (
        "SFXPowerCustomActionMP_Lash",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Lash_Shared", Name: "Lash", Picture: "Lash.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Latch this biotic field onto enemies to jerk them toward you, doing massive damage in the process."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase force and damage of biotic detonations by 50%."},
\t\t\t{Rank: 6, Description: "Increase recharge speed by 35%."},
\t\t\t{Rank: 7, Description: "Do an additional 100% damage over 10 seconds."},
\t\t\t{Rank: 8, Description: "Give the power a 35% chance of not causing a cooldown.\\nIncrease the time that lifted targets can be detonated by 100%."},
\t\t\t{Rank: 9, Description: "Penetrate through shields and barriers, lifting any target without armor but with reduced force."},
\t\t},
\t},"""
    ),
    # ── Batarian Armor (Shared) ───────────────────────────────────────────────
    "SFXPowerCustomActionMP_BatarianArmor_Shared": (
        "SFXPowerCustomActionMP_BatarianArmor",
        """\t{
\t\tID: "SFXPowerCustomActionMP_BatarianArmor_Shared", Name: "Batarian Armor", Picture: "BatarianArmor.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Reinforce armor with razor-sharp blades to damage enemies that melee.\\n\\nLess damage taken.\\nMore melee damage dealt.\\nSlows power use by -50%."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase melee damage bonus by 10%."},
\t\t\t{Rank: 4, Description: "Increase damage protection by 5%."},
\t\t\t{Rank: 5, Description: "Increase melee damage bonus by 15%."},
\t\t\t{Rank: 6, Description: "Increase shield recharge rate by 15%."},
\t\t\t{Rank: 7, Description: "Increase damage returned to targets that melee you by 24%."},
\t\t\t{Rank: 8, Description: "Reduce power speed penalty by 30%."},
\t\t\t{Rank: 9, Description: "Increase damage protection by an additional 10%."},
\t\t},
\t},"""
    ),
    # ── Batarian Net (Shared) ─────────────────────────────────────────────────
    "SFXPowerCustomActionMP_BatarianNet_Shared": (
        "SFXPowerCustomActionMP_BatarianNet",
        """\t{
\t\tID: "SFXPowerCustomActionMP_BatarianNet_Shared", Name: "Batarian Net", Picture: "BatarianNet.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP2",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Entangle opponents in an electrified net, dealing massive damage to armored targets and incapacitating unarmored targets as they break free.\\n\\nTargets build up resistances to the grappling effects of the net."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 30%.\\nIncrease duration by 30%."},
\t\t\t{Rank: 4, Description: "Increase damage by 40%."},
\t\t\t{Rank: 5, Description: "Incapacitate targets 100% longer."},
\t\t\t{Rank: 6, Description: "Increase damage by 40%.\\nSlow armored targets by 30% for 10 seconds."},
\t\t\t{Rank: 7, Description: "Increase recharge speed by 45%."},
\t\t\t{Rank: 8, Description: "Increase damage to shields and barriers by 50%."},
\t\t\t{Rank: 9, Description: "Improve the electrified net to deal 150 points of damage across 6 meters every 1 seconds."},
\t\t},
\t},"""
    ),
    # ── Flamer (Shared) and Supercharge (Shared) ──────────────────────────────
    "SFXPowerCustomActionMP_Flamer_Shared": (
        "SFXPowerCustomActionMP_Flamer",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Flamer_Shared", Name: "Flamer", Picture: "Flamer.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP2",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Fire a powerful short-range flame attack. The flames will persist for a max duration and can be canceled early for a faster recharge.\\n\\nHighly effective against armor.\\n\\nSubject to a self-stacking glitch; damage can reach 3 times the presented value with continuous fire. Applies fire DoT."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase range by 50%."},
\t\t\t{Rank: 6, Description: "Increase damage by 40%."},
\t\t\t{Rank: 7, Description: "Increase duration by 60%."},
\t\t\t{Rank: 8, Description: "Increase damage to armor by 50%."},
\t\t\t{Rank: 9, Description: "Increase damage to shields and barriers by 50%."},
\t\t},
\t},"""
    ),
    "SFXPowerCustomActionMP_Supercharge_Shared": (
        "SFXPowerCustomActionMP_Supercharge",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Supercharge_Shared", Name: "Geth Turbocharge", Picture: "Supercharge.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Advanced diagnostics redirect power into offensive systems, boosting combat capabilities.\\n\\nFaster movement.\\nSee through smoke and objects.\\nMore weapon, power, and melee damage.\\nGreater weapon accuracy.\\nShields reduced by -50%."},
\t\t\t{Rank: 2, Description: "Increase movement speed by 5%."},
\t\t\t{Rank: 3, Description: "Increase damage bonus by 2%."},
\t\t\t{Rank: 4, Description: "Increase recharge speed of all powers by 20% while active."},
\t\t\t{Rank: 5, Description: "Increase weapon accuracy bonus by 15%."},
\t\t\t{Rank: 6, Description: "Increase damage of all powers by 15% while active."},
\t\t\t{Rank: 7, Description: "Increase rate of fire of all weapons by 15% while active."},
\t\t\t{Rank: 8, Description: "Increase movement speed bonus by 10%.\\nIncrease the range of your enhanced vision by 60%."},
\t\t\t{Rank: 9, Description: "Increase damage bonus by 10%."},
\t\t},
\t},"""
    ),
    # ── Geth Sentry Turret (MP5 / Juggernaut) ────────────────────────────────
    "SFXPowerCustomActionMP_GethSentryTurret_MP5": (
        "SFXPowerCustomActionMP_GethSentryTurret",
        """\t{
\t\tID: "SFXPowerCustomActionMP_GethSentryTurret_MP5", Name: "Geth Turret (Juggernaut)", Picture: "GethTurret.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP5",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Deploy a multifunctional turret that deals heavy damage and repairs the shields of allies within 8 meters every 8 seconds."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase turret's shields by 30%.\\nIncrease turret's damage by 30%."},
\t\t\t{Rank: 4, Description: "Increase turret's shields by 40%.\\nIncrease turret's damage by 40%."},
\t\t\t{Rank: 5, Description: "Increase the shields restored to allies by 50%."},
\t\t\t{Rank: 6, Description: "Increase the turret's damage by 30%.\\nIncrease the damage done to armor by 50%."},
\t\t\t{Rank: 7, Description: "Increase the shields restored to allies by 50%.\\nIncrease the range of this ability by 40%."},
\t\t\t{Rank: 8, Description: "Upgrade turret with a close-range flamethrower that deals 55 points of damage per second."},
\t\t\t{Rank: 9, Description: "Increase the frequency of restoring shields by 60%."},
\t\t},
\t},"""
    ),
    # ── Bloodlust (Shared) ────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Bloodlust_Shared": (
        "SFXPowerCustomActionMP_Bloodlust",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Bloodlust_Shared", Name: "Bloodlust", Picture: "Bloodlust.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP2",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "The vorcha flies into a frenzy, increasing movement speed, health regeneration, and melee damage. Each kill intensifies these effects and can stack up to three times.\\n\\nAdditional stacks last for 15 seconds.\\nSlows power use by -60%.\\nLasts until deactivated."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase health regeneration by 30%."},
\t\t\t{Rank: 4, Description: "Increase melee damage of each stack by 10%."},
\t\t\t{Rank: 5, Description: "Increase health regeneration of each stack by 50%"},
\t\t\t{Rank: 6, Description: "Increase power damage bonus of each stack by 5%."},
\t\t\t{Rank: 7, Description: "Increase weapon damage bonus of each stack by 5%."},
\t\t\t{Rank: 8, Description: "Increase movement speed bonus by 5%.\\nIncrease melee damage bonus by 10%."},
\t\t\t{Rank: 9, Description: "Increase health regeneration of each stack by an additional 100%."},
\t\t},
\t},"""
    ),
    # ── Carnage (Krogan Vanguard) ─────────────────────────────────────────────
    "SFXPowerCustomActionMP_Carnage_KroganVanguard": (
        "SFXPowerCustomActionMP_Carnage",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Carnage_KroganVanguard", Name: "Carnage (Krogan Vanguard)", Picture: "Carnage.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Rip a target into shreds with this vicious blast.\\n\\nMajor collateral damage to enemies nearby.\\nEffective against armor."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase impact radius by 50%."},
\t\t\t{Rank: 5, Description: "Increase damage by 30%."},
\t\t\t{Rank: 6, Description: "Incapacitate enemies by knocking them down."},
\t\t\t{Rank: 7, Description: "Increase recharge speed by 35%."},
\t\t\t{Rank: 8, Description: "Increase damage to armored units by 65%."},
\t\t\t{Rank: 9, Description: "Increase damage by 50%."},
\t\t},
\t},"""
    ),
    # ── Homing Grenade (Shared) ───────────────────────────────────────────────
    "SFXPowerCustomActionMP_HomingGrenade_Shared": (
        "SFXPowerCustomActionMP_HomingGrenade",
        """\t{
\t\tID: "SFXPowerCustomActionMP_HomingGrenade_Shared", Name: "Homing Grenade", Picture: "HomingGrenade.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Launch this seeking grenade to track down a target, causing a massive explosion on impact."},
\t\t\t{Rank: 2, Description: "Increase grenade capacity by 1."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 30%."},
\t\t\t{Rank: 6, Description: "Increase grenade capacity by 1."},
\t\t\t{Rank: 7, Description: "Add a fire effect to targets, dealing 50% additional damage over 5 seconds.\\n\\nApplies fire DoT."},
\t\t\t{Rank: 8, Description: "Increase damage to armor by 60%.\\nDecrease weapon damage mitigation of armored targets by 50% for 8 seconds."},
\t\t\t{Rank: 9, Description: "Split a grenade in half to seek two targets that do 60% damage each."},
\t\t},
\t},"""
    ),
    # ── Damping (Shared) ──────────────────────────────────────────────────────
    "SFXPowerCustomActionMP_Damping_Shared": (
        "SFXPowerCustomActionMP_Damping",
        """\t{
\t\tID: "SFXPowerCustomActionMP_Damping_Shared", Name: "Damping", Picture: "Damping.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Reveal weaknesses in defenses, increasing all damage done to the target and slowing its movement speed.\\n\\nProvide the entire squad with a tactical readout. Only one scan can be active on a target."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 50%."},
\t\t\t{Rank: 3, Description: "Increase duration by 30%."},
\t\t\t{Rank: 4, Description: "Increase all weapon damage done to the target by 8%."},
\t\t\t{Rank: 5, Description: "Increase all power damage done to the target by 8%."},
\t\t\t{Rank: 6, Description: "This evolution is bugged and doesn't work."},
\t\t\t{Rank: 7, Description: "Increase the target's movement speed penalty by 15%."},
\t\t\t{Rank: 8, Description: "Increase all damage done to the target by 10%."},
\t\t\t{Rank: 9, Description: "Increase scan duration by 100%.\\nMomentarily reveal enemies within 20 meters of the target with an initial scanning pulse."},
\t\t},
\t},"""
    ),
    # ── Tech Armor (Krogan) ───────────────────────────────────────────────────
    "SFXPowerCustomActionMP_TechArmor_Krogan": (
        "SFXPowerCustomActionMP_TechArmor",
        """\t{
\t\tID: "SFXPowerCustomActionMP_TechArmor_Krogan", Name: "Tech Armor (Krogan)", Picture: "TechArmor.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP1",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\\n\\nSlows power use by -50%."},
\t\t\t{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},
\t\t\t{Rank: 3, Description: "Increase detonation damage by 20%.\\nIncrease impact radius by 20%."},
\t\t\t{Rank: 4, Description: "Increase detonation damage by 30%.\\nIncrease impact radius by 30%."},
\t\t\t{Rank: 5, Description: "Increase damage protection by an additional 5%."},
\t\t\t{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},
\t\t\t{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},
\t\t\t{Rank: 8, Description: "Reduce power speed penalty by 30%."},
\t\t\t{Rank: 9, Description: "Increase damage protection by an additional 10%."},
\t\t},
\t},"""
    ),
    "SFXPowerCustomActionMP_TechArmor_Turian": (
        "SFXPowerCustomActionMP_TechArmor_Krogan",
        """\t{
\t\tID: "SFXPowerCustomActionMP_TechArmor_Turian", Name: "Tech Armor (Turian)", Picture: "TechArmor.webp",
\t\tRootPath: "SFXGameMPContent",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Protect yourself with this holographic armor or detonate it to damage nearby enemies.\\n\\nSlows power use by -50%."},
\t\t\t{Rank: 2, Description: "Increase recharge speed after armor detonation by 25%."},
\t\t\t{Rank: 3, Description: "Increase detonation damage by 20%.\\nIncrease impact radius by 20%."},
\t\t\t{Rank: 4, Description: "Increase detonation damage by 30%.\\nIncrease impact radius by 30%."},
\t\t\t{Rank: 5, Description: "Increase damage protection by an additional 5%."},
\t\t\t{Rank: 6, Description: "Increase power damage and force by 30% while armor is active."},
\t\t\t{Rank: 7, Description: "Increase melee damage by 40% while the power is active."},
\t\t\t{Rank: 8, Description: "Reduce power speed penalty by 30%."},
\t\t\t{Rank: 9, Description: "Increase damage protection by an additional 10%."},
\t\t},
\t},"""
    ),
    # ── DarkChannel2 (Shared) ─────────────────────────────────────────────────
    "SFXPowerCustomActionMP_DarkChannel2_Shared": (
        "SFXPowerCustomActionMP_DarkChannel2",
        """\t{
\t\tID: "SFXPowerCustomActionMP_DarkChannel2_Shared", Name: "Dark Channel", Picture: "DarkChannel.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Plague an opponent with a persistent, damaging biotic field.\\n\\nEffect transfers to a second target if the first is killed.\\nEffect's length depends on Dark Channel's duration.\\nOnly one field may be active at a time."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase power duration by 40%."},
\t\t\t{Rank: 6, Description: "Slow target's movement speed by -30%."},
\t\t\t{Rank: 7, Description: "Increase recharge speed by 35%."},
\t\t\t{Rank: 8, Description: "Increase damage by 50%."},
\t\t\t{Rank: 9, Description: "Increase damage to armor and barriers by 75%."},
\t\t},
\t},"""
    ),
    # ── AnnihilationSphere (Shared) ───────────────────────────────────────────
    "SFXPowerCustomActionMP_AnnihilationSphere_Shared": (
        "SFXPowerCustomActionMP_AnnihilationSphere",
        """\t{
\t\tID: "SFXPowerCustomActionMP_AnnihilationSphere_Shared", Name: "Annihilation Field", Picture: "AnnihilationSphere.webp",
\t\tRootPath: "SFXGameContentDLC_CON_MP4",
\t\tRankDescs: []RankDesc{
\t\t\t{Rank: 1, Description: "Spin this fiery effect around you to burn nearby enemies. When active, the field can be recast to blast a short-range area and to detonate combos."},
\t\t\t{Rank: 2, Description: "Increase recharge speed by 25%."},
\t\t\t{Rank: 3, Description: "Increase damage by 20%."},
\t\t\t{Rank: 4, Description: "Increase damage by 30%."},
\t\t\t{Rank: 5, Description: "Increase impact radius by 30%."},
\t\t\t{Rank: 6, Description: "Targets caught in the field take 15% additional damage from all sources."},
\t\t\t{Rank: 7, Description: "Increase movement speed by 20% while active."},
\t\t\t{Rank: 8, Description: "Increase damage by 65%."},
\t\t\t{Rank: 9, Description: "Increase duration by 100%.\\nDrain 100% of the damage done to enemy shields/barriers to restore your own shields."},
\t\t},
\t},"""
    ),
}

# ── Passive _Shared entries ──────────────────────────────────────────────────
# (anchor, text) pairs – built using helpers
PASSIVE_NEW: list[tuple[str, str]] = [
    # melee passives
    ("SFXPowerCustomActionMP_GethMeleePassive",
     melee_passive("SFXPowerCustomActionMP_GethMeleePassive_Shared", "Fitness", "SFXGameContentDLC_CON_MP1")),
    ("SFXPowerCustomActionMP_BatarianMeleePassive",
     melee_passive("SFXPowerCustomActionMP_BatarianMeleePassive_Shared", "Fitness", "SFXGameContentDLC_CON_MP4")),
    ("SFXPowerCustomActionMP_MaleQuarianMeleePassive",
     melee_passive("SFXPowerCustomActionMP_MaleQuarianMeleePassive_Shared", "Fitness", "SFXGameContentDLC_CON_MP4")),
    ("SFXPowerCustomActionMP_VorchaMeleePassive",
     melee_passive("SFXPowerCustomActionMP_VorchaMeleePassive_Shared", "Fitness", "SFXGameContentDLC_CON_MP2")),
    # race/class passives
    ("SFXPowerCustomActionMP_GethPassive",
     race_passive("SFXPowerCustomActionMP_GethPassive_Shared", "Geth Hardware", "Geth Hardware", "SFXGameContentDLC_CON_MP1")),
    ("SFXPowerCustomActionMP_BatarianPassive",
     race_passive("SFXPowerCustomActionMP_BatarianPassive_Shared", "Batarian Enforcer", "Batarian Enforcer", "SFXGameContentDLC_CON_MP4")),
    ("SFXPowerCustomActionMP_MaleQuarianPassive",
     race_passive("SFXPowerCustomActionMP_MaleQuarianPassive_Shared", "Quarian Machinist", "Quarian Machinist", "SFXGameContentDLC_CON_MP4")),
    ("SFXPowerCustomActionMP_VorchaPassive",
     race_passive("SFXPowerCustomActionMP_VorchaPassive_Shared", "Vorcha Survivor", "Vorcha Survivor", "SFXGameContentDLC_CON_MP2")),
]

# ============================================================================
# MAIN
# ============================================================================

def extract_entry_bounds(content: str, entry_id: str):
    """
    Find the start of the entry block for the given power ID.
    Returns (start, end) byte offsets for the whole entry block
    (from the opening tab+{ to the closing tab+},\n inclusive).
    """
    # Find the ID: "..." line
    pattern = rf'\tID:\s*"{re.escape(entry_id)}"'
    m = re.search(pattern, content)
    if not m:
        return None, None
    # Walk backward to find opening \t{
    pos = m.start()
    # The opening brace should be on the line before
    block_start = content.rfind('\t{', 0, pos)
    if block_start == -1:
        return None, None
    # Walk forward to find the closing \t},
    # Count nested braces
    depth = 0
    i = block_start
    while i < len(content):
        if content[i] == '{':
            depth += 1
        elif content[i] == '}':
            depth -= 1
            if depth == 0:
                # consume the trailing comma and newline
                end = i + 1
                if end < len(content) and content[end] == ',':
                    end += 1
                if end < len(content) and content[end] == '\n':
                    end += 1
                return block_start, end
        i += 1
    return None, None


def remove_entries(content: str, ids: set) -> str:
    for eid in sorted(ids):  # deterministic order
        start, end = extract_entry_bounds(content, eid)
        if start is None:
            print(f"  WARN: could not find entry for removal: {eid}")
            continue
        # Also remove a preceding comment line if it exists
        # (look for a line ending just before block_start that starts with //)
        snippet = content[start:end]
        print(f"  Removing: {eid}")
        content = content[:start] + content[end:]
    return content


def insert_after(content: str, anchor_id: str, new_text: str) -> str:
    """Insert new_text immediately after the closing },\\n of the anchor entry."""
    _, end = extract_entry_bounds(content, anchor_id)
    if end is None:
        print(f"  WARN: anchor not found for insert: {anchor_id}")
        return content
    return content[:end] + new_text + '\n' + content[end:]


def main():
    with open(POWERS_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    print("=== Removing extra entries ===")
    content = remove_entries(content, IDS_TO_REMOVE)

    print("\n=== Inserting missing active-power entries ===")
    for new_id, (anchor_id, entry_text) in NEW_ENTRIES.items():
        print(f"  Adding: {new_id}")
        content = insert_after(content, anchor_id, entry_text)

    print("\n=== Inserting missing passive entries ===")
    for anchor_id, entry_text in PASSIVE_NEW:
        new_id = re.search(r'ID: "([^"]+)"', entry_text).group(1)
        print(f"  Adding: {new_id}")
        content = insert_after(content, anchor_id, entry_text)

    with open(POWERS_FILE, 'w', encoding='utf-8') as f:
        f.write(content)
    print("\nDone.")


if __name__ == "__main__":
    main()

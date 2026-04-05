Class SFXDamageType extends DamageType
    native
    abstract
    config(Weapon);

struct native ResistanceInfo 
{
    var float Shield;
    var float Armour;
    var float Biotic;
};
struct DamageCalculationAlgorithm 
{
    var EDamageCalculationSource Source;
    var Name TargetName;
    var Name DamageClassName;
    var float BaseDamage;
    var float Weapon_RangeMultiplier;
    var float Weapon_PawnEffectsDamageMultiplier;
    var float Weapon_PawnEffectsHeadshotDamageMultiplier;
    var float Weapon_WeaponEffectsDamageMultiplier;
    var float Weapon_StealthDamageMultiplier;
    var float Weapon_HeadshotDamageMultiplier;
    var float Weapon_RagdollDamageMultiplier;
    var float Weapon_DamageTakenMultiplier;
    var float Power_WeaponMeleeDamageMultiplier;
    var float Power_DamageTakenMultiplier;
    var float Global_DifficultyMultiplier;
    var float Global_CoverMultiplier;
    var float Global_PlayerPopupMultiplier;
    var float Global_OutOfCoverMultiplier;
    var float Global_DamageTakenMultiplier;
    var float Global_HeadshotTakenMultiplier;
    var float ActualDamageDealt;
    var float ActualDamageApplied;
};
enum EDamageCalculationSource
{
    DamageCalcWeapon,
    DamageCalcPower,
};
enum EWoundDamage
{
    WoundDamage_None,
    WoundDamage_Light,
    WoundDamage_Medium,
    WoundDamage_Heavy,
};
struct native HitReactionSet 
{
    var(HitReactionSet) Name BodyPart;
    var(HitReactionSet) float ReactionChance;
    var(HitReactionSet) bool bIgnoreShields;
    var(HitReactionSet) EReactionTypes Reaction;
    var(HitReactionSet) EHitReactRange MaxRange;
};
enum ESFXDamageFalloffType
{
    DamageFalloffType_Constant,
    DamageFalloffType_Linear,
};
enum EHitReactRange
{
    HitReactRange_Invalid,
    HitReactRange_Melee,
    HitReactRange_Short,
    HitReactRange_Medium,
    HitReactRange_Long,
};

var(SFXDamageType) config array<HitReactionSet> HitReactions;
var(SFXDamageType) ResistanceInfo Resistance;
var(SFXDamageType) config float WoundPct;
var float DamageRadius;
var(SFXDamageType) float HeadGibChance;
var(SFXDamageType) ForceFeedbackWaveform ShieldHitFFWaveform;
var RvrClientEffectInterface CE_DeathEffect;
var int DeathEffectPriority;
var RvrClientEffectInterface CE_PlayerFrameBufferEffect;
var(SFXDamageType) float Range_Melee;
var(SFXDamageType) float Range_Short;
var(SFXDamageType) float Range_Medium;
var(SFXDamageType) float Range_Long;
var(SFXDamageType) float FlinchChance;
var(SFXDamageType) float FlinchDistance;
var stringref SourceDisplayName;
var WwiseEvent DeathSoundEffect;
var bool bSpawnWeaponImpacts;
var(SFXDamageType) bool bIgnoreShields;
var(SFXDamageType) bool bPartBasedDamageDisabled;
var(SFXDamageType) bool bHealthDamage;
var(SFXDamageType) bool bDamagesFriends;
var(SFXDamageType) bool bCanGibHead;
var(SFXDamageType) bool bIsMelee;
var(SFXDamageType) bool bCausesNormalizedDamage;
var(SFXDamageType) bool bUsesDamageScaling;
var(SFXDamageType) bool bIgnoreDamageGating;
var(SFXDamageType) bool bAlwaysPlayHitReact;
var(SFXDamageType) bool bCriticalHit;
var(SFXDamageType) bool bMPKillDamage;
var(SFXDamageType) bool bCausesRagdoll;
var(SFXDamageType) bool bCausesRagdollOnDeath;
var(SFXDamageType) bool bDisableAIControl;
var(SFXDamageType) bool bImmediateDeath;
var(SFXDamageType) bool bIgnoresCoverDirection;
var bool bNoShake;
var const bool bCorpseDestroyedOnDeath;
var ESFXDamageFalloffType FalloffType;
var(SFXDamageType) config EWoundDamage WoundDamage;

public static function float CalculateDamageMultiplier(out DamageCalculationAlgorithm DamageCalc)
{
    local float TargetBonus;
    local float SourceBonus;
    local float DifficultyBonus;
    
    SourceBonus = 1.0 + DamageCalc.Power_WeaponMeleeDamageMultiplier + DamageCalc.Weapon_PawnEffectsDamageMultiplier + DamageCalc.Weapon_PawnEffectsHeadshotDamageMultiplier + DamageCalc.Weapon_WeaponEffectsDamageMultiplier + DamageCalc.Weapon_StealthDamageMultiplier;
    TargetBonus = 1.0 + DamageCalc.Global_CoverMultiplier + DamageCalc.Global_PlayerPopupMultiplier + DamageCalc.Global_OutOfCoverMultiplier + DamageCalc.Global_DamageTakenMultiplier + DamageCalc.Global_HeadshotTakenMultiplier + DamageCalc.Weapon_HeadshotDamageMultiplier + DamageCalc.Weapon_RagdollDamageMultiplier + DamageCalc.Weapon_DamageTakenMultiplier + DamageCalc.Power_DamageTakenMultiplier + DamageCalc.Weapon_RangeMultiplier;
    DifficultyBonus = 1.0 + DamageCalc.Global_DifficultyMultiplier;
    return SourceBonus * TargetBonus * DifficultyBonus;
}
public static function bool CanPlayDeathEffect(BioPawn Target, optional Controller Killer)
{
    return TRUE;
}
public static function ResetDamageCalc(out DamageCalculationAlgorithm DamageCalc)
{
    DamageCalc.BaseDamage = 0.0;
    DamageCalc.Weapon_PawnEffectsDamageMultiplier = 0.0;
    DamageCalc.Weapon_PawnEffectsHeadshotDamageMultiplier = 0.0;
    DamageCalc.Weapon_RangeMultiplier = 0.0;
    DamageCalc.Weapon_StealthDamageMultiplier = 0.0;
    DamageCalc.Weapon_RagdollDamageMultiplier = 0.0;
    DamageCalc.Weapon_HeadshotDamageMultiplier = 0.0;
    DamageCalc.Weapon_DamageTakenMultiplier = 0.0;
    DamageCalc.Power_WeaponMeleeDamageMultiplier = 0.0;
    DamageCalc.Power_DamageTakenMultiplier = 0.0;
    DamageCalc.Global_CoverMultiplier = 0.0;
    DamageCalc.Global_PlayerPopupMultiplier = 0.0;
    DamageCalc.Global_OutOfCoverMultiplier = 0.0;
    DamageCalc.Global_DifficultyMultiplier = 0.0;
    DamageCalc.Global_DamageTakenMultiplier = 0.0;
    DamageCalc.Global_HeadshotTakenMultiplier = 0.0;
    DamageCalc.ActualDamageApplied = 0.0;
    DamageCalc.ActualDamageDealt = 0.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=DamagedFFWave
        Samples = ({Duration = 0.25, LeftAmplitude = 55, RightAmplitude = 55, LeftFunction = EWaveformFunction.WF_LinearDecreasing, RightFunction = EWaveformFunction.WF_LinearDecreasing}
                  )
    End Object
    Resistance = {Shield = 1.0, Armour = 1.0, Biotic = 1.0}
    HeadGibChance = 0.5
    ShieldHitFFWaveform = DamagedFFWave
    Range_Melee = 100.0
    Range_Short = 200.0
    Range_Medium = 1200.0
    Range_Long = 2000.0
    FlinchChance = 0.75
    FlinchDistance = 22.5
    bHealthDamage = TRUE
    bUsesDamageScaling = TRUE
    FalloffType = ESFXDamageFalloffType.DamageFalloffType_Linear
    KDamageImpulse = 1.0
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
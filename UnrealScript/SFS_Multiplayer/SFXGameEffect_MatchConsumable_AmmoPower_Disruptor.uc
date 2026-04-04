Class SFXGameEffect_MatchConsumable_AmmoPower_Disruptor extends SFXGameEffect_MatchConsumable_AmmoPower
    config(Game);

var config array<float> Damage;
var config array<float> StunChance;
var config array<float> ElectricComboDuration;
var Class<SFXDamageType> DamageType;
var config float ShieldRegenPenalty;
var config float ShieldRegenPenaltyDuration;
var float LastStunTime;

public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local BioPawn oPawn;
    local Actor oHitActor;
    local Vector Momentum;
    local float fDamage;
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local float fStunChance;
    local SFXModule_GameEffectManager Manager;
    
    Super.OnWeaponImpact(Weapon, Impact);
    oHitActor = GetHitTarget(Impact);
    if (Weapon == None || oHitActor == None || Power == None)
    {
        return;
    }
    if (BioPawn(oHitActor) != None && Power.m_oPawn.IsFriendly(BioPawn(oHitActor)))
    {
        return;
    }
    fDamage = GetWeaponDamage(Weapon, Impact) * Damage[VersionIdx];
    Resistance = oHitActor.GetPowerResistance(Power.m_oPawn, Impact.HitLocation, Impact.HitNormal, fDamage, Momentum, DamageType, oTargetOverride);
    if (oTargetOverride != None)
    {
        oHitActor = oTargetOverride;
    }
    oPawn = BioPawn(oHitActor);
    if (oHitActor.ImpactWithPower(Resistance, None, Impact.HitLocation, Impact.HitNormal, fDamage, Momentum, DamageType))
    {
        if (oPawn != None)
        {
            oPawn.ReplicateAnimatedReaction(oPawn.CurrentCustomAction);
        }
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        Manager = oHitActor.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && !Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ShieldRegenBonus', Category))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_ShieldRegenBonus', Category, ShieldRegenPenaltyDuration, 1, ShieldRegenPenalty, Instigator, Causer);
        }
    }
    if (OwnerPawn != None && OwnerPawn.Role == ENetRole.ROLE_Authority)
    {
        fStunChance = StunChance[VersionIdx];
        if (BulletsPerSecond > float(0))
        {
            fStunChance = StunChance[VersionIdx] / BulletsPerSecond;
        }
        if (fStunChance > float(0) && FRand() < fStunChance && Resistance != EPowerResistance.Resistance_Full && Power != None && Power.m_oPawn != None && Power.m_oPawn.WorldInfo != None && Power.m_oPawn.WorldInfo.GameTimeSeconds - LastStunTime > 1.0)
        {
            LastStunTime = Power.m_oPawn.WorldInfo.GameTimeSeconds;
            StunEnemy(oPawn);
        }
    }
}
public function StunEnemy(BioPawn oPawn)
{
    if (oPawn == None || Power == None)
    {
        return;
    }
    if (oPawn != None && oPawn.Role == ENetRole.ROLE_Authority)
    {
        if (oPawn.RequestReaction(3, Instigator))
        {
            oPawn.ReplicateAnimatedReaction(oPawn.CurrentCustomAction);
        }
    }
    Power.AddComboEffect(oPawn, Class'SFXGameEffect_PowerCombo_Electric', ElectricComboDuration[VersionIdx]);
    if (Power.ShouldReplicate())
    {
        Power.ReplicateImpact(oPawn);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Damage = (0.0500000007, 0.100000001, 0.150000006)
    StunChance = (1.0, 1.39999998, 1.79999995)
    ElectricComboDuration = (3.5, 3.5, 3.5)
    ShieldRegenPenalty = 1.0
    ShieldRegenPenaltyDuration = 8.0
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Overload'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Disruptor'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_vfx_dis_ammo_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_dis_mzzl'
    VersionCount = 3
}
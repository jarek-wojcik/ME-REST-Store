Class SFXGameEffect_DisruptorAmmo extends SFXGameEffect_AmmoPower;

var Class<SFXDamageType> DamageType;
var float StunChance;
var float ElectricComboDuration;
var float Damage;
var float SpareAmmoBonus;
var float HeadShotDamageBonus;
var float LastStunTime;
var float ShieldRegenPenalty;
var float ShieldRegenPenaltyDuration;

public function OnRemoved()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnRemoved();
    Manager = OwnerWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (SpareAmmoBonus > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_SpareAmmo', Category);
    }
    if (HeadShotDamageBonus > float(0))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_ConstraintDmgBonus', Category);
    }
}
public function float GetDamageVocProbabilityMod()
{
    return 0.0500000007;
}
public function OnApplied()
{
    local SFXModule_GameEffectManager Manager;
    
    Super.OnApplied();
    if (OwnerWeapon == None)
    {
        return;
    }
    Manager = OwnerWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (SpareAmmoBonus > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_SpareAmmo', Category, 0.0, 2, SpareAmmoBonus, Instigator);
    }
    if (HeadShotDamageBonus > float(0))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_ConstraintDmgBonus', Category, 0.0, 2, HeadShotDamageBonus, Instigator);
    }
}
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
    fDamage = GetWeaponDamage(Weapon, Impact) * Damage;
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
        fStunChance = StunChance;
        if (BulletsPerSecond > float(0))
        {
            fStunChance = StunChance / BulletsPerSecond;
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
    Power.AddComboEffect(oPawn, Class'SFXGameEffect_PowerCombo_Electric', ElectricComboDuration);
    if (Power.ShouldReplicate())
    {
        Power.ReplicateImpact(oPawn);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Overload'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Disruptor'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_vfx_dis_ammo_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_dis_mzzl'
}
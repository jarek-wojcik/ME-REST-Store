Class SFXGameEffect_CryoAmmo extends SFXGameEffect_AmmoPower
    config(Game);

var float FreezeChance;
var float FreezeDuration;
var float SpeedReduction;
var float SpeedReductionDuration;
var float FrozenDamageBonus;
var float ArmorWeakness;
var float SpareAmmoBonus;
var float HeadShotDamageBonus;
var(SFXGameEffect_CryoAmmo) ParticleSystem ImpactEffect;
var RvrClientEffectInterface CE_HalfFrozenTemplate;
var config float DelayedFreezeRandDuration;
var config float DelayedFreezeStaticDuration;

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
}
public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local BioPawn oPawn;
    local Actor oHitActor;
    local SFXModule_GameEffectManager Manager;
    
    Super.OnWeaponImpact(Weapon, Impact);
    if (OwnerPawn != None && OwnerPawn.Role == ENetRole.ROLE_Authority)
    {
        if (BulletsPerSecond <= float(0) || FRand() > FreezeChance / BulletsPerSecond)
        {
            return;
        }
        oHitActor = GetHitTarget(Impact);
        if (oHitActor == None || Power == None)
        {
            return;
        }
        oPawn = BioPawn(oHitActor);
        if (oPawn == None || Power.m_oPawn.IsFriendly(oPawn))
        {
            return;
        }
        Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager == None)
        {
            return;
        }
        if (Manager.HasEffectOfType(Class'SFXGameEffect_DelayedCryoFreeze') || Manager.HasEffectOfType(Class'SFXGameEffect_CryoFreeze'))
        {
            return;
        }
        DoFreezeEffect(oPawn, FRand() * DelayedFreezeRandDuration + DelayedFreezeStaticDuration, Impact.HitLocation, Impact.HitNormal, FALSE);
    }
}
public function DoFreezeEffect(BioPawn oHitPawn, float fDelay, Vector HitLocation, Vector HitNormal, bool bForced, optional EPowerResistance ForcedResistance)
{
    local SFXModule_GameEffectManager Manager;
    local EPowerResistance Resistance;
    local Actor oTargetOverride;
    local Vector vForce;
    local RvrClientEffectTarget TargetInfo;
    local SFXGameEffect_MovementSpeedBonus SpeedEffect;
    local float fDamage;
    local SFXGameEffect Effect;
    local SFXGameEffect_DelayedCryoFreeze FreezeEffect;
    
    if (Power == None || oHitPawn == None)
    {
        return;
    }
    if (!bForced)
    {
        Resistance = oHitPawn.GetPowerResistance(OwnerPawn, HitLocation, HitNormal, fDamage, vForce, Class'SFXDamageType_CryoAmmo', oTargetOverride);
        if (oTargetOverride != None && !bForced)
        {
            oHitPawn = BioPawn(oTargetOverride);
            if (oHitPawn == None)
            {
                return;
            }
        }
    }
    else
    {
        Resistance = ForcedResistance;
    }
    if (oHitPawn.ImpactWithPower(Resistance, OwnerPawn, HitLocation, HitNormal, fDamage, vForce, Class'SFXDamageType_CryoAmmo'))
    {
        oHitPawn.ReplicateAnimatedReaction(oHitPawn.CurrentCustomAction);
    }
    Manager = oHitPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (bForced)
    {
        Manager.RemoveEffectsByType(Class'SFXGameEffect_DelayedCryoFreeze');
        Manager.RemoveEffectsByType(Class'SFXGameEffect_CryoFreeze');
    }
    if (Resistance == EPowerResistance.Resistance_None)
    {
        FreezeEffect = SFXGameEffect_DelayedCryoFreeze(Manager.CreateEffect(Class'SFXGameEffect_DelayedCryoFreeze', Category, fDelay, 1, FreezeDuration, Instigator));
        if (FreezeEffect != None)
        {
            FreezeEffect.Power = Power;
            FreezeEffect.OnApplied();
        }
        if (HeadShotDamageBonus > float(0))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_PartBasedDamageTakenBonus', Category, fDelay + FreezeDuration, 1, HeadShotDamageBonus, Instigator);
        }
        if (FrozenDamageBonus > float(0))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', Category, fDelay + FreezeDuration, 1, FrozenDamageBonus, Instigator);
        }
        if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ArmorWeakness', Name))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_ArmorWeakness', Name, fDelay + FreezeDuration, 1, -ArmorWeakness, Instigator);
        }
    }
    else if (Resistance != EPowerResistance.Resistance_Full)
    {
        foreach Manager.GameEffects(Effect, )
        {
            SpeedEffect = SFXGameEffect_MovementSpeedBonus(Effect);
            if (SpeedEffect != None && SpeedEffect.EffectValue < float(0))
            {
                if (SpeedEffect.EffectValue <= -SpeedReduction)
                {
                    return;
                }
                else
                {
                    SpeedEffect.CurrentTime = SpeedEffect.Duration + float(1);
                    SpeedEffect.DurationType = EDurationType.DurationType_Temporary;
                }
            }
        }
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, SpeedReductionDuration, 1, -SpeedReduction, Instigator);
        if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ArmorWeakness', Name))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_ArmorWeakness', Name, SpeedReductionDuration, 1, -ArmorWeakness, Instigator);
        }
        TargetInfo.Instigator = oHitPawn;
        TargetInfo.SpawnValue.X = SpeedReductionDuration;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_HalfFrozenTemplate, TargetInfo);
    }
    if (Power.ShouldReplicate())
    {
        Power.ReplicateImpact(oHitPawn, Power.ReplicationEncodeDelayAndResistance(fDelay, Resistance), FALSE, HitLocation, HitNormal);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CE_HalfFrozenTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Half_Frozen_VCFX'
    DelayedFreezeRandDuration = 0.200000003
    DelayedFreezeStaticDuration = 0.5
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Cryo'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Cryo'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_cryo_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_cryo_mzzl'
}
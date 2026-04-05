Class SFXGameEffect_MatchConsumable_AmmoPower_Cryo extends SFXGameEffect_MatchConsumable_AmmoPower
    config(Game);

var config array<float> SpeedReduction;
var config array<float> FrostDuration;
var config array<float> FreezeChance;
var config array<float> ArmorWeakness;
var Class<SFXDamageType> DamageType;
var RvrClientEffectInterface CE_HalfFrozenTemplate;
var config float DelayedFreezeRandDuration;
var config float DelayedFreezeStaticDuration;

public function OnWeaponImpact(SFXWeapon Weapon, ImpactInfo Impact)
{
    local BioPawn oPawn;
    local Actor oHitActor;
    local SFXModule_GameEffectManager Manager;
    
    Super.OnWeaponImpact(Weapon, Impact);
    if (OwnerPawn != None && OwnerPawn.Role == ENetRole.ROLE_Authority)
    {
        if (BulletsPerSecond <= float(0) || FRand() > FreezeChance[VersionIdx] / BulletsPerSecond)
        {
            return;
        }
        oHitActor = GetHitTarget(Impact);
        if (oHitActor == None || Power == None)
        {
            return;
        }
        oPawn = BioPawn(oHitActor);
        if (oPawn == None || oPawn.IsFriendly(OwnerPawn))
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
    local SFXGameEffect_DelayedCryoFreeze FreezeEffect;
    
    if (Power == None || oHitPawn == None)
    {
        return;
    }
    if (!bForced)
    {
        Resistance = oHitPawn.GetPowerResistance(OwnerPawn, HitLocation, HitNormal, fDamage, vForce, DamageType, oTargetOverride);
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
    if (oHitPawn.ImpactWithPower(Resistance, OwnerPawn, HitLocation, HitNormal, fDamage, vForce, DamageType))
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
        FreezeEffect = SFXGameEffect_DelayedCryoFreeze(Manager.CreateEffect(Class'SFXGameEffect_DelayedCryoFreeze', Name, fDelay, 1, FrostDuration[VersionIdx], OwnerPawn.Controller));
        if (FreezeEffect != None)
        {
            FreezeEffect.Power = Power;
            FreezeEffect.OnApplied();
        }
    }
    else if (Resistance != EPowerResistance.Resistance_Full)
    {
        SpeedEffect = SFXGameEffect_MovementSpeedBonus(Manager.GetFirstEffectOfType(Class'SFXGameEffect_MovementSpeedBonus'));
        if (SpeedEffect != None)
        {
            if (SpeedEffect.EffectValue <= -SpeedReduction[VersionIdx])
            {
                return;
            }
            else
            {
                Manager.RemoveEffect(SpeedEffect);
            }
        }
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, FrostDuration[VersionIdx], 1, -SpeedReduction[VersionIdx], OwnerPawn.Controller);
        if (!Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ArmorWeakness', Name))
        {
            Manager.CreateAndApplyEffect(Class'SFXGameEffect_ArmorWeakness', Name, FrostDuration[VersionIdx], 1, -ArmorWeakness[VersionIdx], Instigator);
        }
        TargetInfo.Instigator = oHitPawn;
        TargetInfo.SpawnValue.X = FrostDuration[VersionIdx];
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
    SpeedReduction = (0.150000006, 0.25, 0.349999994)
    FrostDuration = (3.0, 4.0, 5.0)
    FreezeChance = (1.0, 1.39999998, 1.79999995)
    ArmorWeakness = (0.25, 0.349999994, 0.5)
    DamageType = Class'SFXDamageType_CryoAmmo'
    CE_HalfFrozenTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Half_Frozen_VCFX'
    DelayedFreezeRandDuration = 0.200000003
    DelayedFreezeStaticDuration = 0.5
    HologramTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Cryo'
    IconTemplate = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Holo_Icon_Cryo'
    NormalImpactSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_cryo_imp'
    WeaponFireSound = WwiseEvent'Wwise_VFX_Tech.Play_ammo_cryo_mzzl'
    VersionCount = 3
}
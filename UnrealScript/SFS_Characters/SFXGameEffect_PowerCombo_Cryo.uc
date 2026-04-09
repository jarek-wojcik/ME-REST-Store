Class SFXGameEffect_PowerCombo_Cryo extends SFXGameEffect_PowerCombo
    config(Game);

var config Vector2D FreezeDuration;
var config float ResistanceDurationMultiplier;
var RvrClientEffectInterface CE_HalfFrozenTemplate;
var config float SpeedReduction;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn oPawn;
    local SFXModule_GameEffectManager Manager;
    local RvrClientEffectTarget TargetInfo;
    local SFXGameEffect_MovementSpeedBonus SpeedEffect;
    local float SlowDuration;
    local SFXGameEffect Effect;
    local int nMaxRagdoll;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn != None)
    {
        Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && (oPawn.Role != ENetRole.ROLE_Authority && nPreviouslyImpacted >= 0 || oPawn.Role == ENetRole.ROLE_Authority && !Manager.HasEffectOfType(Class'SFXGameEffect_DelayedCryoFreeze') && !Manager.HasEffectOfType(Class'SFXGameEffect_CryoFreeze')))
        {
            if (SFXGRI(Owner.WorldInfo.GRI).IsMultiplayerGame())
            {
                nMaxRagdoll = MaximumRagdollTargetsMP;
            }
            else
            {
                nMaxRagdoll = MaximumRagdollTargets;
            }
            if (Resistance == EPowerResistance.Resistance_None && (nMaxRagdoll == 0 || nPreviouslyImpacted < nMaxRagdoll))
            {
                Manager.CreateAndApplyEffect(Class'SFXGameEffect_DelayedCryoFreeze', Name, 1.0, 1, Lerp(FreezeDuration.X, FreezeDuration.Y, fPowerRatio), Instigator);
            }
            else
            {
                foreach Manager.GameEffects(Effect, )
                {
                    SpeedEffect = SFXGameEffect_MovementSpeedBonus(Effect);
                    if (SpeedEffect != None && SpeedEffect.EffectValue < float(0))
                    {
                        if (SpeedEffect.EffectValue <= -SpeedReduction)
                        {
                            return Super.OnImpact(Resistance, oImpacted, nPreviouslyImpacted, HitLocation, HitNormal);
                        }
                        else
                        {
                            SpeedEffect.CurrentTime = SpeedEffect.Duration + float(1);
                            SpeedEffect.DurationType = EDurationType.DurationType_Temporary;
                        }
                    }
                }
                SlowDuration = Lerp(FreezeDuration.X, FreezeDuration.Y, fPowerRatio) * ResistanceDurationMultiplier;
                Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, SlowDuration, 1, -SpeedReduction, Instigator);
                TargetInfo.Instigator = oPawn;
                TargetInfo.SpawnValue.X = SlowDuration;
                Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_HalfFrozenTemplate, TargetInfo);
            }
        }
        else
        {
            nPreviouslyImpacted = -1;
        }
    }
    return Super.OnImpact(Resistance, oImpacted, nPreviouslyImpacted, HitLocation, HitNormal);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FreezeDuration = {X = 2.0, Y = 5.0}
    ResistanceDurationMultiplier = 3.0
    CE_HalfFrozenTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Half_Frozen_VCFX'
    SpeedReduction = 0.300000012
    EffectsRemovedOnCombo = ('SFXGameEffect_PowerCombo_Cryo')
    DetonationScreenShakeClass = Class'SFXShake_Power_CryoCombo'
    DetonationRumbleClass = Class'SFXRumble_Power_CryoCombo'
    DamageType = Class'SFXDamageType_CryoExplosion'
    MaxRagdollDmgTypeOverride = Class'SFXDamageType_CryoExplosion'
    DetonationParameters = {ImpactPlaceables = TRUE, BlockedByObjects = TRUE}
    ComboDamage = {X = 50.0, Y = 125.0}
    ComboForce = {X = 200.0, Y = 450.0}
    ComboRadius = {X = 300.0, Y = 500.0}
    DetonationVFX = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Combo_Imp_VCFX'
    DetonationSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_combo_ice'
    MaxTargets = 4
    MaximumRagdollTargets = 2
    MaximumRagdollTargetsMP = 1
    bOnlyOnDeath = TRUE
}
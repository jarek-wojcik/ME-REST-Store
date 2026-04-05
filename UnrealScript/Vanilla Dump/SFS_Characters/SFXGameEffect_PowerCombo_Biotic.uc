Class SFXGameEffect_PowerCombo_Biotic extends SFXGameEffect_PowerCombo
    config(Game);

public function OnPowerComboDetonated(SFXPowerCustomAction DetonationPower, Vector HitLocation, Vector HitNormal)
{
    if (Owner == None || SourcePower == None || DetonationPower == None)
    {
        return;
    }
    Super.OnPowerComboDetonated(DetonationPower, HitLocation, HitNormal);
    if (DetonationPower != None && DetonationPower.m_oPawn != None && DetonationPower.m_oPawn.PowerManager != None)
    {
        DetonationPower.m_oPawn.PowerManager.BioticCombo(DetonationPower, BioPawn(Owner));
    }
    SourcePower.OnSourcePowerBioticDetonation();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EffectsRemovedOnCombo = ('SFXGameEffect_PowerCombo_Biotic', 'SFXGameEffect_Singularity', 'SFXGameEffect_Pull', 'SFXGameEffect_AntiGravity', 'SFXGameEffect_Ragdoll', 'SFXGameEffect_Stasis')
    DetonationScreenShakeClass = Class'SFXShake_Power_BioticCombo'
    DetonationRumbleClass = Class'SFXRumble_Power_BioticCombo'
    DamageType = Class'SFXDamageType_BioticExplosion'
    MaxRagdollDmgTypeOverride = Class'SFXDamageType_BioticExplosion_NoRagdoll'
    DetonationParameters = {ImpactPlaceables = TRUE, BlockedByObjects = TRUE}
    ComboDamage = {X = 100.0, Y = 250.0}
    ComboForce = {X = 500.0, Y = 1000.0}
    ComboRadius = {X = 300.0, Y = 500.0}
    DetonationVFX = RvrClientEffect'BioVFX_B_Warp.VCFX.Biotic_Explosion_VCFX'
    DetonationSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_combo_biotic'
    TargetCrustVFX = RvrClientEffect'BioVFX_B_Pull.VCFX.Pull_Lift_Crust_VCFX'
    MaxTargets = 4
    MaximumRagdollTargets = 2
    MaximumRagdollTargetsMP = 1
}
Class SFXGameEffect_PowerCombo_Electric extends SFXGameEffect_PowerCombo
    config(Game);

var config float BeamDuration;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_ElectricComboBeam BeamEffect;
    
    if (oImpacted != None && oImpacted != Owner)
    {
        Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            BeamEffect = SFXGameEffect_ElectricComboBeam(Manager.CreateEffect(Class'SFXGameEffect_ElectricComboBeam', Category, BeamDuration, 1, 0.0, Instigator));
            if (BeamEffect != None)
            {
                BeamEffect.SourceActor = Owner;
                BeamEffect.OnApplied();
            }
        }
    }
    return Super.OnImpact(Resistance, oImpacted, nPreviouslyImpacted, HitLocation, HitNormal);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BeamDuration = 2.0
    EffectsRemovedOnCombo = ('SFXGameEffect_PowerCombo_Electric')
    DetonationScreenShakeClass = Class'SFXShake_Power_ElectricCombo'
    DetonationRumbleClass = Class'SFXRumble_Power_ElectricCombo'
    DamageType = Class'SFXDamageType_ElectricCombo'
    DetonationParameters = {ImpactPlaceables = TRUE, BlockedByObjects = TRUE}
    ComboDamage = {X = 75.0, Y = 200.0}
    ComboForce = {X = 200.0, Y = 450.0}
    ComboRadius = {X = 450.0, Y = 750.0}
    DetonationVFX = RvrClientEffect'BioVFX_T_TechPowers.05_Overload.VCFX.Overload_Imp_VCFX'
    DetonationSound = WwiseEvent'Wwise_Power_Shared.Play_power_shared_combo_elec'
    TargetCrustVFX = RvrClientEffect'BioVFX_C_Electricity.VCFX.Electrocute_TargetCrust_DOT_VCFX'
    MaxTargets = 4
}
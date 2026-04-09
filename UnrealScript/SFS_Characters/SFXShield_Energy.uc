Class SFXShield_Energy extends SFXShield_Base
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShieldDisplayName = $341713
    PS_Impact = ParticleSystem'BioVFX_C_Impacts.Generic.Particles.Generic_Imp_ForceField'
    PS_Recharged = ParticleSystem'BioVFX_C_Shield.Particles.Shield_Booster'
    PS_Breach = ParticleSystem'BioVFX_C_Shield.Particles.Shield__Break'
    PhysMat = PhysicalMaterial'BIOG_PHM_General_F.PHM_GEN_Shields'
    ShieldsBreakSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_NP_down'
    ShieldsUpSound = WwiseEvent'Wwise_Generic_Shield.Play_gen_shield_NP_up'
    Resistance = EResistanceType.ResistanceType_Shield
}
Class SFXShield_Energy_Player extends SFXShield_Player
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShieldDisplayName = $341713
    PS_Impact = ParticleSystem'BioVFX_C_Impacts.Generic.Particles.Generic_Imp_ForceField'
    PS_Recharged = ParticleSystem'BioVFX_C_Shield.Particles.Shield_Booster'
    PS_Breach = ParticleSystem'BioVFX_C_Shield.Particles.Shield__Break'
    PhysMat = PhysicalMaterial'BIOG_PHM_General_F.PHM_GEN_Shields'
    Resistance = EResistanceType.ResistanceType_Shield
}
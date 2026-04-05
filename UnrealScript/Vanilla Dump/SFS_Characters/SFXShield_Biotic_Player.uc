Class SFXShield_Biotic_Player extends SFXShield_Player
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShieldDisplayName = $341715
    PS_Impact = ParticleSystem'BioVFX_C_Impacts.Generic.Particles.Generic_Imp_BioticShield'
    PS_Recharged = ParticleSystem'BioVFX_C_Shield.Particles.Shield_Boost_Biotic'
    PS_Breach = ParticleSystem'BioVFX_C_Shield.Particles.Shield__Break_Biotic'
    PhysMat = PhysicalMaterial'BIOG_PHM_General_F.PHM_GEN_Biotic'
    Resistance = EResistanceType.ResistanceType_Biotic
}
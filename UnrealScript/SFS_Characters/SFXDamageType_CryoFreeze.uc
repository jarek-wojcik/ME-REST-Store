Class SFXDamageType_CryoFreeze extends SFXDamageType_Power_Freeze
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    Resistance = {Shield = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    bHealthDamage = FALSE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 25.0
}
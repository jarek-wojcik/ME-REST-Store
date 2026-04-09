Class SFXDamageType_Shockwave extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    Resistance = {Biotic = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $314056
    bCausesRagdoll = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 10.0
}
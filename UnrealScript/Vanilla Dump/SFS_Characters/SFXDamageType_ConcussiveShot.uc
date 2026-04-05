Class SFXDamageType_ConcussiveShot extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Resistance = {Biotic = 4.0}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $190258
    bCausesRagdoll = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 15.0
}
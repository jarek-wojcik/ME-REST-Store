Class SFXDamageType_FragGrenade extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $506269
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 25.0
}
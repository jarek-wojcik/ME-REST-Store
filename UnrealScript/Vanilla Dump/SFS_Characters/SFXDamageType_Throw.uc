Class SFXDamageType_Throw extends SFXDamageType_Power_Ragdoll
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $501004
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 10.0
}
Class SFXDamageType_Stasis extends SFXDamageType_Power_Control
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $127059
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
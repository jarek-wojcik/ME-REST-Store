Class SFXDamageType_Decoy extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $674631
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
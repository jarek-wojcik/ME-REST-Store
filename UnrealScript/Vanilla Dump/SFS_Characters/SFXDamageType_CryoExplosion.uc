Class SFXDamageType_CryoExplosion extends SFXDamageType_Power_Freeze
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $692225
    bCausesNormalizedDamage = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
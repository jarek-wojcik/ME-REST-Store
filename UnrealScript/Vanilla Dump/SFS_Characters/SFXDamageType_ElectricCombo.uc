Class SFXDamageType_ElectricCombo extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    Resistance = {Shield = 2.0}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $689088
    bCausesNormalizedDamage = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
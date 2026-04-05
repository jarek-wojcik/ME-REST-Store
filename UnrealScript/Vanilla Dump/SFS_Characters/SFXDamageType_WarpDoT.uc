Class SFXDamageType_WarpDoT extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    Resistance = {Shield = 0.5, Armour = 1.5, Biotic = 2.0}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $501005
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
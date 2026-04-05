Class SFXDamageType_EnergyDrainRobot extends SFXDamageType_Power_Electrocute
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    Resistance = {Shield = 3.0, Biotic = 3.0}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $205894
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
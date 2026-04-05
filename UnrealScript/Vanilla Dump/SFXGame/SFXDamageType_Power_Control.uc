Class SFXDamageType_Power_Control extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    bDisableAIControl = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
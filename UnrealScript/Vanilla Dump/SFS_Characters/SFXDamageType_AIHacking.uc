Class SFXDamageType_AIHacking extends SFXDamageType_Power_Control
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Resistance = {Shield = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $536448
    bHealthDamage = FALSE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
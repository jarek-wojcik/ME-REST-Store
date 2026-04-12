Class SFXDamageType_BatarianNet_Shields_Shared extends SFXDamageType_BatarianNet_Shared
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Resistance = {Shield = 1.5, Biotic = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
Class SFXDamageType_Reave_Improved extends SFXDamageType_Reave
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Resistance = {Armour = 2.625, Biotic = 3.5}
    ShieldHitFFWaveform = DamagedFFWave
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
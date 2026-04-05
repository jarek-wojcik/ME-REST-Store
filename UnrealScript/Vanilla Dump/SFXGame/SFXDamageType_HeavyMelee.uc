Class SFXDamageType_HeavyMelee extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Resistance = {Armour = 0.75}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $659925
    bIsMelee = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
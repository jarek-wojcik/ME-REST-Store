Class SFXDamageType_CryoAmmo extends SFXDamageType_Power_Freeze
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Resistance = {Shield = 0.0, Armour = 0.0, Biotic = 0.0}
    ShieldHitFFWaveform = DamagedFFWave
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
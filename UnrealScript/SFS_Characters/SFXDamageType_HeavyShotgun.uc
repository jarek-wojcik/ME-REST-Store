Class SFXDamageType_HeavyShotgun extends SFXDamageType_Shotgun
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HeadGibChance = 0.600000024
    ShieldHitFFWaveform = DamagedFFWave
    KDamageImpulse = 1.5
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 25.0
}
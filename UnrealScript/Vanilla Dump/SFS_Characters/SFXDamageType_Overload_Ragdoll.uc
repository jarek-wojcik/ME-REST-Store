Class SFXDamageType_Overload_Ragdoll extends SFXDamageType_Overload
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    bCausesRagdoll = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
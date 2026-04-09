Class SFXDamageType_Singularity_NoRagdoll extends SFXDamageType_Singularity
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    bCausesRagdoll = FALSE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
Class SFXDamageType_Power_Ragdoll extends SFXDamageType_Power
    config(Weapon);

var EAICustomAction AnimatedPowerRagdollType;

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
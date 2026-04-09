Class SFXDamageType_LiftGrenade_NoRagdoll extends SFXDamageType_LiftGrenade
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
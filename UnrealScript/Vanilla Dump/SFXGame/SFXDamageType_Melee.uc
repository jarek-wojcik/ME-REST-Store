Class SFXDamageType_Melee extends SFXDamageType_Default
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $659925
    bIsMelee = TRUE
    bCausesRagdollOnDeath = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
Class SFXDamageType_CombatDroneAttackImproved extends SFXDamageType_Power_Ragdoll
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $199784
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
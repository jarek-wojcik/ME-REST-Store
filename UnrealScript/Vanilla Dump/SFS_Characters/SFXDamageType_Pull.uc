Class SFXDamageType_Pull extends SFXDamageType_Power_Ragdoll
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    AnimatedPowerRagdollType = EAICustomAction.CA_AnimRagdoll_Singularity
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $189298
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
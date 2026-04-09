Class SFXDamageType_Gib extends SFXDamageType_Weapon
    config(Weapon);

public static function bool CanPlayDeathEffect(BioPawn Target, optional Controller Killer)
{
    if (SFXPawn_PlayerParty(Target) == None && Target.bCanRagdoll == TRUE)
    {
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    CE_DeathEffect = RvrClientEffect'BioVFX_C_Blood.VCFX.Gib_01_VCFX'
    DeathEffectPriority = 10
    DeathSoundEffect = WwiseEvent'Wwise_Generic_Bullet_Impacts.Play_bullet_imp_gore_fullbody'
    bCorpseDestroyedOnDeath = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}
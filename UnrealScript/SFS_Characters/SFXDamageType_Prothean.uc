Class SFXDamageType_Prothean extends SFXDamageType_Gib
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'RightLeg', ReactionChance = 0.0799999982, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}
                   )
    WoundPct = 0.100000001
    ShieldHitFFWaveform = DamagedFFWave
    CE_DeathEffect = RvrClientEffect'BioVFX_C_Wpn_Spitfire.VCFX.GethPlasma_Death_VCFX'
    FlinchChance = 1.0
    FlinchDistance = 100.0
    bSpawnWeaponImpacts = TRUE
    WoundDamage = EWoundDamage.WoundDamage_Light
    KDamageImpulse = 5.0
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 3.0
}
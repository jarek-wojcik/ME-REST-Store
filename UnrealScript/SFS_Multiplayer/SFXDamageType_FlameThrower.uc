Class SFXDamageType_FlameThrower extends SFXDamageType_Weapon
    config(AI);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'None', ReactionChance = 0.850000024, bIgnoreShields = TRUE, Reaction = EReactionTypes.Reaction_Fire, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'None', ReactionChance = 0.75, bIgnoreShields = TRUE, Reaction = EReactionTypes.Reaction_Fire, MaxRange = EHitReactRange.HitReactRange_Medium}
                   )
    Resistance = {Shield = 1.5, Armour = 2.0, Biotic = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    CE_DeathEffect = RvrClientEffect'biovfx_c_fire.VCFX.Fire_Death_VCFX'
    CE_PlayerFrameBufferEffect = RvrClientEffect'BioVFX_Crt_FlameThrower.VCFX.Flame_Thrower_FB_VCFX'
    bPartBasedDamageDisabled = TRUE
    bAlwaysPlayHitReact = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 5.0
}
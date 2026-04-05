Class SFXDamageType_HeavyPistol extends SFXDamageType_Weapon
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'Head', ReactionChance = 0.649999976, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Head', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.400000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.25, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.25, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.600000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.600000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.400000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.649999976, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.649999976, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Invalid}
                   )
    WoundPct = 0.400000006
    ShieldHitFFWaveform = DamagedFFWave
    FlinchChance = 0.5
    bSpawnWeaponImpacts = TRUE
    WoundDamage = EWoundDamage.WoundDamage_Light
    KDamageImpulse = 2.5
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 3.0
}
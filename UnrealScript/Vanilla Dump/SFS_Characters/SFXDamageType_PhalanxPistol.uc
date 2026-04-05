Class SFXDamageType_PhalanxPistol extends SFXDamageType_HeavyPistol
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'Head', ReactionChance = 0.100000001, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 0.949999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Chest', ReactionChance = 0.25, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.349999994, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.300000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.300000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.100000001, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.100000001, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.600000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.400000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.400000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}
                   )
    WoundPct = 0.600000024
    HeadGibChance = 0.0500000007
    ShieldHitFFWaveform = DamagedFFWave
    bCanGibHead = TRUE
    WoundDamage = EWoundDamage.WoundDamage_Medium
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 10.0
}
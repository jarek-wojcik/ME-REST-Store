Class SFXDamageType_Machinegun extends SFXDamageType_AssaultRifle
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'Head', ReactionChance = 0.200000003, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 0.349999994, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Head', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Head', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.300000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.5, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.0700000003, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.0700000003, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Chest', ReactionChance = 0.400000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathLight, MaxRange = EHitReactRange.HitReactRange_Long}
                   )
    WoundPct = 0.200000003
    ShieldHitFFWaveform = DamagedFFWave
    WoundDamage = EWoundDamage.WoundDamage_Medium
    KDamageImpulse = 10.0
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 7.5
}
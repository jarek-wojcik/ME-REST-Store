Class SFXDamageType_Shotgun extends SFXDamageType_Weapon
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'Head', ReactionChance = 0.800000012, bIgnoreShields = TRUE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Head', ReactionChance = 0.150000006, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Head', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Chest', ReactionChance = 0.699999988, bIgnoreShields = TRUE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Chest', ReactionChance = 0.600000024, bIgnoreShields = TRUE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.449999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.699999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.699999988, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Chest', ReactionChance = 1.0, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Chest', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}, 
                    {BodyPart = 'Head', ReactionChance = 1.0, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Short}, 
                    {BodyPart = 'Head', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Medium}
                   )
    WoundPct = 0.400000006
    HeadGibChance = 0.800000012
    ShieldHitFFWaveform = DamagedFFWave
    bSpawnWeaponImpacts = TRUE
    bCanGibHead = TRUE
    WoundDamage = EWoundDamage.WoundDamage_Heavy
    KDamageImpulse = 2.5
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 20.0
}
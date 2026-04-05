Class SFXDamageType_SniperRifle_Widow extends SFXDamageType_Gib
    config(Weapon);

public static function bool CanPlayDeathEffect(BioPawn Target, optional Controller Killer)
{
    if (Target != None && Target.bCanRagdoll && Killer != None)
    {
        if (VSize(Killer.location - Target.location) > default.Range_Medium && (Target.WorldInfo.NetMode == ENetMode.NM_Standalone && FRand() < 0.0500000007))
        {
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    HitReactions = ({BodyPart = 'Head', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 0.850000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.349999994, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Heavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.550000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Chest', ReactionChance = 0.850000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.75, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.25, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.25, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Light, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.850000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.850000024, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_Medium, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'Head', ReactionChance = 1.0, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftArm', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightArm', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'LeftLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}, 
                    {BodyPart = 'RightLeg', ReactionChance = 0.800000012, bIgnoreShields = FALSE, Reaction = EReactionTypes.Reaction_DeathHeavy, MaxRange = EHitReactRange.HitReactRange_Invalid}
                   )
    WoundPct = 1.0
    HeadGibChance = 1.0
    ShieldHitFFWaveform = DamagedFFWave
    FlinchChance = 1.0
    FlinchDistance = 100.0
    bSpawnWeaponImpacts = TRUE
    bCanGibHead = TRUE
    WoundDamage = EWoundDamage.WoundDamage_Heavy
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 45.0
}
Class SFXAICmd_HenchFollowActor extends SFXAICmd_FollowActor within SFXAI_Henchman;

public function bool ShouldCancelFollow()
{
    local float fDistance;
    local Pawn FollowedPawn;
    
    if (Super.ShouldCancelFollow())
    {
        return TRUE;
    }
    if (Outer.m_bCancelAction && (Outer.m_nCancelReasons & 2) != 0 && Outer.MyBP.CurrentCustomAction == 0)
    {
        return TRUE;
    }
    FollowedPawn = Pawn(Outer.m_ActorToFollow);
    if (FollowedPawn != None && FollowedPawn.Controller == None)
    {
        return TRUE;
    }
    if (BioPlayerController(FollowedPawn.Controller) != None && Outer.m_RequestedActorToFollow == None)
    {
        if (Outer.IsInCombat())
        {
            fDistance = VSize(Outer.m_ActorToFollow.location - Outer.MyBP.location);
            if (Outer.m_bFollowPlayer == FALSE && Outer.IsWithinThreatRadius() && fDistance < Outer.TetherDistance)
            {
                return TRUE;
            }
            if (fDistance <= Outer.DistanceToStartCombatWhileFollowing)
            {
                Outer.m_bFollowPlayer = FALSE;
                if (Outer.ShouldFollowPlayer() == FALSE)
                {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
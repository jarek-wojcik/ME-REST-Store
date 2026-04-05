Class SFXAICmd_FollowActor extends SFXAICommand within SFXAI_Core;

var bool bActorReachable;

public event function GetActorToFollow(out Actor oActor, out Vector vLocation)
{
    oActor = Outer.m_ActorToFollow;
    vLocation = Outer.m_ActorToFollow.location;
}
public event function bool NotifyBump(Actor Other, Vector HitNormal)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyBump(Other, HitNormal);
    }
    return Outer.RespondToBump(Other, HitNormal);
}
public function bool IsDirectlyReachable()
{
    if (Outer.m_ActorToFollow == None)
    {
        return FALSE;
    }
    return Outer.DirectWalkCheck(Outer.m_ActorToFollow.location, Outer.m_ActorToFollow);
}
public function bool PathfindToActor()
{
    local BioPawn ActualPawn;
    
    if (Outer.m_ActorToFollow == None)
    {
        return FALSE;
    }
    ActualPawn = BioPawn(Outer.m_ActorToFollow);
    if (ActualPawn == None && VSize(Outer.MyBP.location - Outer.m_ActorToFollow.location) > 400.0)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.m_ActorToFollow, 400.0, TRUE, FALSE);
    }
    else if (ActualPawn != None && VSize(Outer.MyBP.location - ActualPawn.location) > 400.0 + ActualPawn.FollowDistanceModifier)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.m_ActorToFollow, 400.0 + ActualPawn.FollowDistanceModifier, TRUE, FALSE);
    }
    return TRUE;
}
public event function Popped()
{
    if (Outer.MyBP != None)
    {
        Outer.MyBP.StopMovement(FALSE);
    }
    Outer.ClearTimer('SelectTarget');
    Outer.ClearTimer('UpdateFollowing', Self);
    Outer.m_ActorToFollow = None;
    Outer.m_bFollowingActor = FALSE;
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.m_bFollowingActor = TRUE;
    Outer.SetTimer(0.5 + FRand() * 0.200000003, TRUE, 'SelectTarget', );
    Outer.SetTimer(0.5, TRUE, 'UpdateFollowing', Self);
    Outer.ClearCancelAction();
    GotoState('FollowingActor', , , );
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    if (ShouldCancelFollow())
    {
        Outer.PopCommand(Self);
        return;
    }
}
public function bool ShouldCancelFollow()
{
    if (Outer.m_bCancelAction && (Outer.m_nCancelReasons & 4) != 0 && Outer.MyBP.CurrentCustomAction == 0)
    {
        return TRUE;
    }
    if (Outer.m_ActorToFollow == None)
    {
        return TRUE;
    }
    return FALSE;
}
public function UpdateFollowing()
{
    if (ShouldCancelFollow())
    {
        Outer.PopCommand(Self);
        return;
    }
}

state FollowingActor extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead())
    {
        Outer.PopCommand(Self);
    }
    if (Outer.m_ActorToFollow == None)
    {
        Outer.PopCommand(Self);
    }
    if (Outer.MyBP.IsInCover())
    {
        Outer.InvalidateCover();
    }
    if (Outer.MyBP.bIsCrouched)
    {
        Outer.MyBP.ShouldCrouch(FALSE);
    }
    if (Outer.MyBP.Physics == EPhysics.PHYS_None)
    {
        Outer.MyBP.SetPhysics(1);
        Outer.MyBP.LastPhysicsSetter = Outer;
    }
    while (TRUE)
    {
        if (Outer.MyBP.bCanStrafe && Outer.HasValidTarget())
        {
            Outer.Focus = Outer.FireTarget;
        }
        Outer.SteeringMovement();
        Outer.Focus = Outer.FireTarget;
        Outer.SetFocalPoint(Outer.MyBP.location + Normal(Outer.MyBP.Velocity) * 4000.0);
        do {
            Outer.Sleep(0.100000001);
            if (ShouldCancelFollow())
            {
                Outer.PopCommand(Self);
            }
            PathfindToActor();
            bActorReachable = IsDirectlyReachable();
        } until (bActorReachable || Outer.bReachedMoveGoal == FALSE);
        if (!bActorReachable)
        {
            Outer.m_nMoveAttemptCounter = 0;
            while (Outer.TeleportToActor(Outer.m_ActorToFollow) == FALSE && Outer.m_nMoveAttemptCounter < 3)
            {
                Outer.m_nMoveAttemptCounter++;
                Outer.Sleep(1.0);
                if (ShouldCancelFollow())
                {
                    Outer.PopCommand(Self);
                }
            }
        }
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
Class SFXAICmd_MoveToGoal extends SFXAICommand within SFXAI_Core;

var transient Actor m_oTempGoalActor;
var transient bool m_bAllowedToFire;
var transient bool m_bUsePartialPaths;
var transient bool m_bRotateBeforeMoving;
var transient bool m_bMovingToFireTarget;

public function OnEnteredPlaypen()
{
    if (!Outer.m_bAllowedToLeavePlaypen && Outer.m_nEnabledFlags == 0)
    {
        Outer.SetTimer(0.5, TRUE, 'CheckPawnInPlaypen', Self);
    }
}
public function Paused(GameAICommand NewCommand)
{
    StopFiringWeapon(FALSE);
    if (Outer.MyBP.LastPhysicsSetter == Outer)
    {
        if (Outer.MyBP.Physics == EPhysics.PHYS_PathApproximation)
        {
            Outer.MyBP.ForceGroundConform();
        }
        Outer.MyBP.SetPhysics(1);
    }
    Super.Paused(NewCommand);
}
public event function UpdateMovementActions()
{
    local float fDist;
    local float fDot;
    local Vector vTargetVector;
    local Vector vMoveVector;
    local Actor OriginalFocus;
    
    if (ChildCommand != None)
    {
        return;
    }
    OriginalFocus = Outer.Focus;
    if (Outer.MyBP.bCanStrafe && Outer.HasValidTarget())
    {
        fDist = VSizeSq(Outer.MyBP.location - Outer.MoveTarget.location);
        if (IsSpecialMoveAfterCurrentMoveTarget() && fDist < 250000.0)
        {
            Outer.Focus = Outer.MoveTarget;
            if (Outer.FireTarget != None && Outer.IsFiringWeapon())
            {
                vTargetVector = Outer.FireTarget.location - Outer.MyBP.location;
                vMoveVector = Outer.MoveTarget.location - Outer.MyBP.location;
                fDot = vTargetVector Dot vMoveVector;
                if (fDot < Outer.m_fFiringArcAngle)
                {
                    StopFiringWeapon();
                }
            }
        }
        else
        {
            Outer.UpdateMovementFocus();
        }
    }
    else
    {
        Outer.Focus = Outer.MoveTarget;
    }
    if (OriginalFocus != Outer.Focus)
    {
        Outer.MyBP.ResetDesiredRotation();
    }
    if (Outer.IsFiringWeapon() == FALSE && CanStartFiring())
    {
        StartFiringWeapon();
    }
    Outer.MyBP.DestinationOffset = GetMoveOffset();
}
public function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    Super.NotifyWeaponFinishedFiring(W, FireMode);
    if (int(FireMode) != 4)
    {
        Outer.m_bDelayWeaponUse = TRUE;
        Outer.SetTimer(Outer.GetMoveFireDelayTime(), FALSE, 'NotifyWeaponDelayFinished', );
    }
}
public function bool ApplyPathConstraints()
{
    local bool bAppliedConstraints;
    local Vector LastMantleLocation;
    local Goal_AtActor oAtGoalEval;
    
    bAppliedConstraints = FALSE;
    if (Class'Goal_AtActor'.static.AtActor(Outer.MyBP, Outer.MoveGoal, Outer.MoveOffset, m_bUsePartialPaths))
    {
        oAtGoalEval = Goal_AtActor(Outer.MyBP.PathGoalList);
        m_oTempGoalActor = oAtGoalEval.GoalActor;
        Class'Path_TowardGoal'.static.TowardGoal(Outer.MyBP, Outer.MoveGoal);
        Outer.ApplyBasePathConstraints();
        Class'SFXPath_AvoidClaimedCover'.static.AvoidClaimedCover(Outer.MyBP);
        if (Outer.WorldInfo.GameTimeSeconds - Outer.MyBP.LastMantleTime < 5.0)
        {
            LastMantleLocation = Outer.MyBP.LastMantleLocation;
        }
        if (Outer.MyBP.bCanMantle || Outer.MyBP.bCanClimbUp)
        {
            Class'Path_MinDistBetweenSpecsOfType'.static.EnforceMinDist(Outer.MyBP, 500.0, Class'MantleReachSpec', LastMantleLocation);
        }
        if (Outer.m_bAvoidDangerLinks)
        {
            Class'SFXPath_AvoidFireFromCover'.static.AvoidFireFromCover(Outer.MyBP, Outer.m_bAvoidFireFromPlayerOnly);
        }
        bAppliedConstraints = TRUE;
    }
    return bAppliedConstraints;
}
public function bool CancelCommand(optional int nReason)
{
    if (Outer.ShouldCancelMove(nReason))
    {
        Outer.MoveTarget = None;
        Outer.m_nMoveCompletionReason = 0;
        if (nReason == 8)
        {
            Outer.m_bClearVelocityAfterMove = TRUE;
        }
        return TRUE;
    }
    return FALSE;
}
public function bool CanSkipNodeAfterTimeout(Actor oMoveTarget)
{
    local float fRetryDistSq;
    local Vector vDirToMoveTarget;
    local ReachSpec oReachSpec;
    
    if (oMoveTarget == None || Outer.RouteCache.Length == 0 || IsSpecialMoveAfterCurrentMoveTarget())
    {
        return FALSE;
    }
    oReachSpec = NavigationPoint(oMoveTarget).GetReachSpecTo(Outer.RouteCache[0]);
    if (oReachSpec != None)
    {
        if (oReachSpec.IsBlockedFor(Outer.MyBP))
        {
            return FALSE;
        }
    }
    vDirToMoveTarget = Outer.MyBP.location - oMoveTarget.location;
    fRetryDistSq = 10000.0;
    if (Outer.MyBP.CylinderComponent != None)
    {
        if (Outer.WorldInfo.GameTimeSeconds - Outer.m_fLastBumpTime < 1.0 && Outer.m_oLastBumped != None && Outer.m_oLastBumped.CylinderComponent != None)
        {
            fRetryDistSq = Outer.m_oLastBumped.CylinderComponent.CollisionRadius * 2.0;
        }
        else
        {
            fRetryDistSq = Outer.MyBP.CylinderComponent.CollisionRadius;
        }
        fRetryDistSq += Outer.MyBP.CylinderComponent.CollisionRadius + 5.0;
        fRetryDistSq *= fRetryDistSq;
    }
    vDirToMoveTarget.Z = 0.0;
    if (VSizeSq(vDirToMoveTarget) < fRetryDistSq)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool CanStartFiring()
{
    if (!m_bAllowedToFire)
    {
        return FALSE;
    }
    if (Outer.m_bDelayWeaponUse)
    {
        return FALSE;
    }
    if (Outer.MyBP.Weapon == None)
    {
        return FALSE;
    }
    if (Outer.MyBP.IsReloading(TRUE))
    {
        return FALSE;
    }
    if (Outer.HasValidTarget() == FALSE)
    {
        return FALSE;
    }
    if (Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle, 1) == FALSE)
    {
        Outer.m_nWeaponCompletionReason = 3;
        return FALSE;
    }
    if (Vehicle(Outer.FireTarget) != None)
    {
        if (VSize(Outer.FireTarget.location - Outer.MyBP.location) > Outer.MyBP.SightRadius)
        {
            return FALSE;
        }
    }
    if (Outer.CanShootWeapon(Outer.FireTarget) == FALSE)
    {
        return FALSE;
    }
    if (Outer.m_bCheckLOS && Outer.CanAttack(Outer.FireTarget) == FALSE)
    {
        Outer.m_nWeaponCompletionReason = 3;
        return FALSE;
    }
    if (!Outer.AcquireTicket(Outer.FireTarget, 2))
    {
        Outer.m_bFailedTicket = TRUE;
        return FALSE;
    }
    return TRUE;
}
public function CheckPawnInPlaypen()
{
    if (Outer.MyBP != None && Outer.MyBP.Squad != None && Outer.MyBP.Squad.IsPositionInPlaypen(Outer.MyBP.location))
    {
        if (ChildCommand == None)
        {
            Outer.PopCommand(Self);
        }
    }
}
public function FinishPathGeneration()
{
    if (m_bMovingToFireTarget && Outer.MoveGoal != Outer.FireTarget)
    {
        Outer.MoveTarget = None;
    }
    else if (Outer.RouteGoal != m_oTempGoalActor)
    {
        if (VSizeSq(Outer.RouteGoal.location - m_oTempGoalActor.location) > Outer.MoveOffset * Outer.MoveOffset)
        {
        }
    }
}
public function bool GetFirstMoveTarget()
{
    local bool bIgnoreDirectWalkCheck;
    
    if (Outer.Pawn != None && Outer.Pawn.Anchor != None && Outer.Pawn.Anchor.IsA('CoverSlotMarker') && Outer.MoveGoal.IsA('CoverSlotMarker'))
    {
        bIgnoreDirectWalkCheck = TRUE;
    }
    if (bIgnoreDirectWalkCheck == FALSE && Outer.DirectWalkCheck(Outer.MoveGoal.location, Outer.MoveGoal))
    {
        Outer.MoveTarget = Outer.MoveGoal;
        Outer.m_nMoveAttemptCounter = 0;
        LogRoute();
    }
    else
    {
        if (ApplyPathConstraints() == FALSE)
        {
            return FALSE;
        }
        PushState('PathFinding');
    }
    return TRUE;
}
public function float GetMoveOffset()
{
    if (Outer.MoveTarget == None || Outer.MoveGoal == None)
    {
        return 0.0;
    }
    if (Outer.MoveTarget == Outer.MoveGoal)
    {
        return Outer.MoveOffset;
    }
    return 0.0;
}
public function float GetPeriodicMoveInterval()
{
    return 0.25;
}
public function bool HasReachedGoal()
{
    if (Outer.MoveGoal != None && Outer.Pawn != None)
    {
        if (Outer.Pawn.Anchor == Outer.MoveGoal)
        {
            return TRUE;
        }
        else
        {
            if (Outer.Pawn.ReachedDestination(Outer.MoveGoal))
            {
                return TRUE;
            }
            if (Outer.m_bFollowingActor)
            {
                if (Outer.m_ActorToFollow != None && Outer.m_ActorToFollow == Outer.MoveGoal)
                {
                    if (Outer.RouteCache.Length == 0)
                    {
                        return TRUE;
                    }
                }
            }
            return FALSE;
        }
    }
    return TRUE;
}
public function bool IsSpecialMoveAfterCurrentMoveTarget()
{
    local ReachSpec NextPath;
    local NavigationPoint CurrentTarget;
    local NavigationPoint NextTarget;
    
    if (Outer.MyBP != None && Outer.RouteCache.Length > 0 && Outer.MoveTarget != None)
    {
        CurrentTarget = NavigationPoint(Outer.MoveTarget);
        NextTarget = Outer.RouteCache[0];
        if (CurrentTarget != None)
        {
            NextPath = CurrentTarget.GetReachSpecTo(NextTarget);
            if (NextPath != None)
            {
                if (NextPath.IsA('MantleReachSpec') || NextPath.IsA('AdvancedReachSpec'))
                {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public function LogRoute()
{
    local int nIndex;
    
    if (Outer.bAILogging == FALSE)
    {
        return;
    }
    if (Outer.MoveTarget == None && Outer.RouteCache.Length == 0)
    {
        return;
    }
    if (Outer.MyBP.Anchor != None)
    {
        Outer.DrawLocationMarker(Outer.MyBP.Anchor.location, 10.0, 0, 0, 255);
    }
    if (Outer.MoveTarget != None)
    {
        Outer.DrawLocationMarker(Outer.MoveTarget.location, 10.0, 0, 0, 255);
    }
    for (nIndex = 0; nIndex < Outer.RouteCache.Length; nIndex++)
    {
        Outer.DrawLocationMarker(Outer.RouteCache[nIndex].location, 10.0, 0, 0, 255);
    }
}
public static function bool MoveToGoal(SFXAI_Core AI, Actor NewMoveGoal, optional float NewMoveOffset, optional bool bInAllowedToFire = TRUE, optional bool bInAllowPartialPath = TRUE, optional bool bInRotateBeforeMoving = FALSE)
{
    local SFXAICmd_MoveToGoal Cmd;
    
    if (AI != None && NewMoveGoal != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveToGoal';
        if (Cmd != None)
        {
            if (Controller(NewMoveGoal) != None)
            {
                NewMoveGoal = Controller(NewMoveGoal).Pawn;
            }
            Cmd.Outer.MoveGoal = NewMoveGoal;
            Cmd.Outer.MoveOffset = NewMoveOffset;
            Cmd.m_bAllowedToFire = bInAllowedToFire;
            Cmd.m_bUsePartialPaths = bInAllowPartialPath;
            Cmd.m_bRotateBeforeMoving = bInRotateBeforeMoving;
            Cmd.m_bMovingToFireTarget = AI.FireTarget != None && AI.FireTarget == NewMoveGoal;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public event function Popped()
{
    Super(GameAICommand).Popped();
    StopFiringWeapon();
    Outer.m_bCheckLOS = TRUE;
    Outer.MoveGoal = None;
    Outer.MovePoint = vect(0.0, 0.0, 0.0);
    Outer.MoveOffset = 0.0;
    Outer.MoveTarget = None;
    Outer.RouteCache_Empty();
    if (Outer.MyBP != None && Outer.m_bClearVelocityAfterMove)
    {
        Outer.MyBP.StopMovement(FALSE);
    }
    Outer.m_bClearVelocityAfterMove = TRUE;
    Outer.ClearTimer('CheckPawnInPlaypen', Self);
    Outer.ClearTimer('PeriodicMoveCheck');
    if (Outer.__MoveToDelegate__Delegate != None)
    {
        if (Outer.bReachedMoveGoal)
        {
            Outer.m_nMoveCompletionReason = 1;
        }
        Outer.__MoveToDelegate__Delegate(Outer.m_nMoveCompletionReason);
        Outer.__MoveToDelegate__Delegate = None;
    }
    Outer.bKismetForcedWalk = FALSE;
    if (Outer.MyBP.LastPhysicsSetter == Outer)
    {
        if (Outer.MyBP.Physics == EPhysics.PHYS_PathApproximation)
        {
            Outer.MyBP.ForceGroundConform();
        }
        Outer.MyBP.SetPhysics(1);
    }
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.SetTimer(GetPeriodicMoveInterval(), TRUE, 'PeriodicMoveCheck', );
    Outer.bReachedMoveGoal = FALSE;
    Outer.MoveTarget = None;
    Outer.RouteCache_Empty();
    Outer.m_nMoveCompletionReason = 2;
    Outer.ClearCancelAction();
    GotoState('MovingToGoal', , , );
}
public function bool StartFiringWeapon()
{
    Outer.StartFiring();
    Outer.SetTimer(0.5, TRUE, 'UpdateFiring', Self);
    return TRUE;
}
public function StopFiringWeapon(optional bool bReleaseAttackTicket = TRUE)
{
    if (bReleaseAttackTicket)
    {
        Outer.ReleaseTicket(Outer.FireTarget, 2);
    }
    Outer.ClearTimer('UpdateFiring', Self);
    Outer.ClearTimer('StartFiring');
    Outer.StopFiring();
}
public function UpdateFiring()
{
    if (Outer.m_bCancelAction || Outer.IsReloading() || Outer.IsFiringWeapon() == FALSE || Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle) == FALSE)
    {
        StopFiringWeapon();
    }
    if (Outer.m_bCancelAction)
    {
        Outer.m_nWeaponCompletionReason = 0;
    }
}

state MovingToGoal extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead() || Outer.MoveGoal == None)
    {
        Outer.PopCommand(Self);
    }
    if (Outer.WorldInfo.GameTimeSeconds - Outer.LastFailedPathTime < 0.5 && Outer.WorldInfo.GameTimeSeconds - Outer.MyBP.FindAnchorFailedTime < 0.5)
    {
        Outer.Sleep(0.25);
        Outer.PopCommand(Self);
    }
    Outer.bGetFirstMoveTargetFailed = FALSE;
    if (GetFirstMoveTarget() == FALSE)
    {
        Outer.bGetFirstMoveTargetFailed = TRUE;
        Outer.PopCommand(Self);
    }
    if (Outer.MoveTarget == None)
    {
        if (Outer.WorldInfo.GameTimeSeconds - Outer.LastFailedPathTime < 1.0 && (Outer.WorldInfo.GameTimeSeconds - Outer.MyBP.LastValidAnchorTime > Outer.StuckTimeout || Outer.WorldInfo.GameTimeSeconds - Outer.LastSuccessfulPathTime > Outer.StuckTimeout))
        {
            Outer.NotifyStuck();
        }
        Outer.LastFailedPathTime = Outer.WorldInfo.GameTimeSeconds;
        Outer.PopCommand(Self);
    }
    Outer.LastSuccessfulPathTime = Outer.WorldInfo.GameTimeSeconds;
    if (Outer.MoveTarget != Outer.MoveGoal || BioPawn(Outer.MoveTarget) == None)
    {
        Outer.MyBP.SetPhysics(13);
    }
    else
    {
        Outer.MyBP.SetPhysics(1);
    }
    Outer.MyBP.LastPhysicsSetter = Outer;
    Outer.m_vOriginalMoveGoalLocation = Outer.MoveGoal.location;
    Outer.CheckLeaveCover();
    if (m_bRotateBeforeMoving)
    {
        if (Outer.MyBP.bCanStrafe && Outer.HasValidTarget())
        {
            Outer.Focus = Outer.FireTarget;
        }
        else
        {
            Outer.Focus = Outer.MoveTarget;
        }
        Outer.FinishRotation();
    }
    for (; Outer.MoveTarget != None && Outer.MoveGoal != None; Outer.Sleep(0.100000001))
    {
        Outer.SetMovementSpeed();
        Outer.SmoothPathMovement();
        if (Outer.m_bCustomActionFailed)
        {
            Outer.m_bCustomActionFailed = FALSE;
            Outer.RouteCache_Empty();
            if (GetFirstMoveTarget())
            {
                if (Outer.MoveTarget != None)
                {
                    if (Outer.MoveTarget != Outer.MoveGoal || BioPawn(Outer.MoveTarget) == None)
                    {
                        Outer.MyBP.SetPhysics(13);
                    }
                    else
                    {
                        Outer.MyBP.SetPhysics(1);
                    }
                    Outer.MyBP.LastPhysicsSetter = Outer;
                }
            }
            continue;
        }
        if (Outer.MoveTimer < float(0))
        {
            if (CanSkipNodeAfterTimeout(Outer.MoveTarget))
            {
                Outer.MoveTarget = Outer.RouteCache[0];
                Outer.RouteCache_RemoveIndex(0);
                continue;
            }
            break;
        }
    }
    Outer.bReachedMoveGoal = HasReachedGoal();
    if (Outer.bReachedMoveGoal == FALSE)
    {
    }
    Outer.PopCommand(Self);
    stop;
};
state PathFinding extends DebugState 
{
    
Begin:
    Outer.FindPathTowardIterative(Outer.MoveGoal, FALSE, 2000);
    if (Outer.MoveTarget == None)
    {
        PopState();
    }
    if (Outer.MoveTarget == Outer.RouteCache[0])
    {
        Outer.RouteCache_RemoveIndex(0);
    }
    FinishPathGeneration();
    Outer.m_nMoveAttemptCounter = 0;
    LogRoute();
    PopState();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
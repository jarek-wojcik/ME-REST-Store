Class SFXAICmd_MoveToLocation extends SFXAICommand within SFXAI_Core;

var transient bool m_bAllowEarlyFinish;
var transient bool m_bAllowedToFire;
var transient bool m_bMoveCancelled;
var transient bool m_bUsePartialPaths;

public event function bool NotifyBump(Actor Other, Vector HitNormal)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyBump(Other, HitNormal);
    }
    if (m_bAllowEarlyFinish && VSize(Outer.MyBP.location - Outer.MovePoint) <= 250.0)
    {
        Outer.bReachedMoveGoal = TRUE;
        return TRUE;
    }
    return FALSE;
}
public function Paused(GameAICommand NewCommand)
{
    StopFiringWeapon(FALSE);
    Super.Paused(NewCommand);
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
public function bool CancelCommand(optional int nReason)
{
    if (Outer.ShouldCancelMove(nReason))
    {
        Outer.m_nMoveCompletionReason = 0;
        m_bMoveCancelled = TRUE;
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
    if (Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle) == FALSE)
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
public function bool HasReachedLocation()
{
    local Vector vMoveLocation;
    local Vector vPawnLocation;
    local float fCollisionRadius;
    
    if (Outer.bReachedMoveGoal)
    {
        return TRUE;
    }
    if (Outer.MyBP == None)
    {
        return TRUE;
    }
    vMoveLocation = Outer.MovePoint;
    vMoveLocation.Z = 0.0;
    vPawnLocation = Outer.MyBP.location;
    vPawnLocation.Z = 0.0;
    if (Outer.MyBP.CylinderComponent != None)
    {
        fCollisionRadius = Outer.MyBP.CylinderComponent.CollisionRadius;
    }
    if (VSize(vMoveLocation - vPawnLocation) <= Outer.MoveOffset + fCollisionRadius)
    {
        return TRUE;
    }
    return FALSE;
}
public static function bool MoveToLocation(SFXAI_Core AI, Vector NewMovePoint, optional float NewMoveOffset, optional bool bInAllowedToFire = TRUE, optional bool bInAllowPartialPath = TRUE, optional bool bInAllowEarlyFinish = FALSE)
{
    local SFXAICmd_MoveToLocation Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveToLocation';
        if (Cmd != None)
        {
            Cmd.Outer.MovePoint = NewMovePoint;
            Cmd.Outer.MoveOffset = NewMoveOffset;
            Cmd.m_bAllowedToFire = bInAllowedToFire;
            Cmd.m_bUsePartialPaths = bInAllowPartialPath;
            Cmd.m_bAllowEarlyFinish = bInAllowEarlyFinish;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public event function Popped()
{
    StopFiringWeapon();
    Outer.m_bCheckLOS = TRUE;
    Outer.MovePoint = vect(0.0, 0.0, 0.0);
    Outer.MoveOffset = 0.0;
    Outer.MoveTimer = 0.0;
    if (Outer.MyBP != None && Outer.m_bClearVelocityAfterMove)
    {
        Outer.MyBP.StopMovement(FALSE);
    }
    Outer.m_bClearVelocityAfterMove = TRUE;
    Outer.ClearCancelAction();
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.bReachedMoveGoal = FALSE;
    Outer.m_nMoveCompletionReason = 1;
    GotoState('MovingToLocation', , , );
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

state MovingToLocation extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead())
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
    Outer.SetMovementSpeed();
    if (Outer.MyBP.bCanStrafe && Outer.HasValidTarget())
    {
        Outer.Focus = Outer.FireTarget;
        if (Outer.IsFiringWeapon() == FALSE && CanStartFiring())
        {
            StartFiringWeapon();
        }
    }
    else
    {
        Outer.Focus = None;
        Outer.SetFocalPoint(Outer.MovePoint + Normal(Outer.MovePoint - Outer.MyBP.location) * 100.0);
    }
    if (Outer.MoveTimer <= 0.0)
    {
        Outer.MoveTimer = 20.0;
    }
    while (HasReachedLocation() == FALSE && Outer.MoveTimer > 0.0 && !m_bMoveCancelled)
    {
        Outer.MoveTowardLocation(Outer.MovePoint);
        Outer.Sleep(0.100000001);
    }
    if (Outer.MoveTimer > 0.0 && Outer.m_nMoveCompletionReason != 0)
    {
        Outer.bReachedMoveGoal = TRUE;
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
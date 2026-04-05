Class SFXCustomAction_AirRecoverBase extends SFXCustomAction_ReachSpecMove
    native
    abstract
    config(Game);

var(SFXCustomAction_AirRecoverBase) float FlightAccel;
var transient bool bTimedOut;

public function Vector GetDestination();

public function StartCustomAction()
{
    Super.StartCustomAction();
    bTimedOut = FALSE;
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function DestTimeout()
{
    bTimedOut = TRUE;
    Super(SFXCustomAction_ProceduralMoveBase).DestTimeout();
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    return TRUE;
}
public function PlayStartAnimation()
{
    local Rotator ToLandingPos;
    
    Destination = GetDestination();
    ToLandingPos = Rotator(Destination - m_oPawn.location);
    ToLandingPos.Pitch = 0;
    SetFacePreciseRotation(ToLandingPos, 0.300000012);
    Super(SFXCustomAction_ProceduralMoveBase).PlayStartAnimation();
    m_oPawn.LastPhysicsSetter = Outer;
    m_oPawn.SetPhysics(4);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    if (m_oPawn.LastPhysicsSetter == Outer)
    {
        if (MoveStage == EMoveStage.EMS_End && !bTimedOut)
        {
            m_oPawn.SetPhysics(1);
        }
        else
        {
            m_oPawn.SetPhysics(2);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FlightAccel = 1500.0
    fStartBlendInTime = 0.200000003
    fStartBlendOutTime = 0.200000003
    fLoopBlendInTime = 0.200000003
    fEndBlendOutTime = 0.200000003
    StartRootBoneX = ERootBoneAxis.RBA_Discard
    StartRootBoneY = ERootBoneAxis.RBA_Discard
    StartRootBoneZ = ERootBoneAxis.RBA_Discard
    StartRMM = ERootMotionMode.RMM_Ignore
    EndRMM = ERootMotionMode.RMM_Accel
    MoveSpeed = 1500.0
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bDisableLook = TRUE
    bLockRotationAfterPreciseRotation = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
Class SFXCustomAction_ClimbUpBase extends SFXCustomAction_ReachSpecMove
    native
    abstract
    config(Game);

var(SFXCustomAction_ClimbUpBase) float fGroundOffset;
var(SFXCustomAction_ClimbUpBase) float fClimbSpeed;
var(SFXCustomAction_ClimbUpBase) float fMaxClimbSpeed;
var(SFXCustomAction_ClimbUpBase) float fMaxAcceleration;
var(SFXCustomAction_ClimbUpBase) float fStopSpeed;

public function PreAlignPawnLocation()
{
    local float AlignRotYaw;
    local Rotator NewRotation;
    
    Super.PreAlignPawnLocation();
    AlignRotYaw = float(Rotator(Destination - MovementPath.Start.location).Yaw);
    NewRotation = m_oPawn.Rotation;
    NewRotation.Yaw = int(AlignRotYaw);
    SetFacePreciseRotation(NewRotation, 0.200000003);
}
public function SetMoveStage(EMoveStage NextStage)
{
    Super(SFXCustomAction_ProceduralMoveBase).SetMoveStage(NextStage);
    if (NextStage == EMoveStage.EMS_Start)
    {
        m_oPawn.LastPhysicsSetter = Outer;
        m_oPawn.SetPhysics(4);
    }
}
public function StopCustomAction()
{
    if (m_oPawn.LastPhysicsSetter == Outer)
    {
        m_oPawn.SetPhysics(1);
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fGroundOffset = 60.0
    fClimbSpeed = 200.0
    fMaxClimbSpeed = 275.0
    fMaxAcceleration = 55.0
    fStopSpeed = 1.0
    fStartBlendOutTime = 0.0
    fLoopBlendInTime = 0.0
    fEndBlendInTime = 0.25
    fEndBlendOutTime = 0.200000003
    fLoopTimeout = 8.0
    bAlignPawnBeforeMove = TRUE
    StartRMM = ERootMotionMode.RMM_Ignore
    EndRMM = ERootMotionMode.RMM_Accel
    PlayerCameraMode = Class'SFXCameraMode_LadderUp'
    fCameraTransitionIn = 0.100000001
    fCameraTransitionOut = 0.100000001
    bLockPawnRotation = TRUE
    bHideWeapon = TRUE
    bTurnOffReticle = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
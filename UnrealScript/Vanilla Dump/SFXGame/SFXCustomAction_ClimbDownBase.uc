Class SFXCustomAction_ClimbDownBase extends SFXCustomAction_ReachSpecMove
    native
    abstract
    config(Game);

var(SFXCustomAction_ClimbDownBase) float fClimbSpeed;

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
    fClimbSpeed = -200.0
    fEndAnimDist = 50.0
    fStartBlendOutTime = 0.0
    fLoopBlendInTime = 0.0
    fEndBlendInTime = 0.25
    fEndBlendOutTime = 0.200000003
    fLoopTimeout = 15.0
    bAlignPawnBeforeMove = TRUE
    EndRMM = ERootMotionMode.RMM_Accel
    StartRootRotationPitch = ERootRotationOption.RRO_Extract
    StartRootRotationYaw = ERootRotationOption.RRO_Extract
    StartRootRotationRoll = ERootRotationOption.RRO_Extract
    bLockPawnRotation = TRUE
    bDisableLook = TRUE
    bHideWeapon = TRUE
    bTurnOffReticle = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
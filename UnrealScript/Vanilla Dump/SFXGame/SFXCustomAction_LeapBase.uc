Class SFXCustomAction_LeapBase extends SFXCustomAction_ReachSpecMove
    native
    abstract
    config(Game);

var(SFXCustomAction_LeapBase) InterpCurveFloat LeapCurve;
var(SFXCustomAction_LeapBase) float LeapSpeed;
var(SFXCustomAction_LeapBase) transient SFXLeapReachSpecBase LeapSpec;

public function PlayStartAnimation()
{
    Super(SFXCustomAction_ProceduralMoveBase).PlayStartAnimation();
    m_oPawn.LastPhysicsSetter = Outer;
    m_oPawn.SetPhysics(4);
    LeapSpec = SFXLeapReachSpecBase(MovementPath);
    if (LeapSpec == None)
    {
        EndThisCustomAction();
    }
}
public function PreAlignPawnLocation()
{
    local float LeapRotYaw;
    local Rotator NewRotation;
    
    Super.PreAlignPawnLocation();
    SetReachPreciseDestination(MovementPath.Start.location);
    LeapRotYaw = float(Rotator(Destination - m_oPawn.location).Yaw);
    NewRotation = m_oPawn.Rotation;
    NewRotation.Yaw = int(LeapRotYaw);
    SetFacePreciseRotation(NewRotation, 0.200000003);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    LeapSpec = None;
    if (m_oPawn.LastPhysicsSetter == Outer)
    {
        m_oPawn.SetPhysics(1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LeapCurve = {
                 Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 1.5, InterpMode = EInterpCurveMode.CIM_CurveAuto}, 
                           {InVal = 0.25, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}, 
                           {InVal = 1.0, OutVal = 0.0, ArriveTangent = -0.5, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}
                          ), 
                 InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                }
    LeapSpeed = 750.0
    fEndAnimDist = 100.0
    fStartBlendInTime = 0.449999988
    fStartBlendOutTime = 0.349999994
    fLoopBlendInTime = 0.200000003
    fEndBlendOutTime = 0.449999988
    bAlignPawnBeforeMove = TRUE
    StartRootBoneX = ERootBoneAxis.RBA_Discard
    StartRootBoneY = ERootBoneAxis.RBA_Discard
    StartRootBoneZ = ERootBoneAxis.RBA_Discard
    EndRootBoneX = ERootBoneAxis.RBA_Discard
    EndRootBoneY = ERootBoneAxis.RBA_Discard
    EndRootBoneZ = ERootBoneAxis.RBA_Discard
    StartRMM = ERootMotionMode.RMM_Ignore
    EndRMM = ERootMotionMode.RMM_Ignore
    bDisableLook = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
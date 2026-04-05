Class SFXCustomAction_LadderClimbDownBase extends SFXCustomAction_ReachSpecMove
    native
    abstract
    config(Game);

var(SFXCustomAction_LadderClimbDownBase) float fClimbDownSpeed;
var transient AnimSet LadderAnimSet;

public function StartCustomAction()
{
    local SFXNav_LadderNode LadderNode;
    
    Destination = MovementPath.End.Actor.location;
    LadderNode = SFXNav_LadderNode(MovementPath.Start);
    if (LadderNode != None)
    {
        LadderAnimSet = LadderNode.AnimInfo.AnimSet;
        m_oPawn.RegisterTemporaryAnim(LadderAnimSet);
    }
    Super.StartCustomAction();
}
public function PreAlignPawnLocation()
{
    Super.PreAlignPawnLocation();
    SetFacePreciseRotation(Rotator(Destination - MovementPath.Start.location), 0.5);
}
public function SetMoveStage(EMoveStage NextStage)
{
    Super(SFXCustomAction_ProceduralMoveBase).SetMoveStage(NextStage);
    if (NextStage == EMoveStage.EMS_Start || NextStage == EMoveStage.EMS_Loop)
    {
        m_oPawn.LastPhysicsSetter = Outer;
        if (m_oPawn.Physics == EPhysics.PHYS_PathApproximation)
        {
            m_oPawn.ForceGroundConform();
        }
        m_oPawn.SetPhysics(4);
    }
}
public function StopCustomAction()
{
    if (m_oPawn.LastPhysicsSetter == Outer)
    {
        m_oPawn.SetPhysics(1);
    }
    if (LadderAnimSet != None)
    {
        m_oPawn.UnregisterTemporaryAnim(LadderAnimSet);
        LadderAnimSet = None;
    }
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fClimbDownSpeed = -1000.0
    fEndAnimDist = 225.0
    fLoopTimeout = 3.5
    bAlignPawnBeforeMove = TRUE
    EndRMM = ERootMotionMode.RMM_Ignore
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bDisableLook = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
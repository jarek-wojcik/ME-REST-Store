Class SFXCustomAction_PlayerLadderClimbUp extends SFXCustomAction_ClimbUpBase
    config(Game);

var BodyStance BS_CloseLadderEnter;
var BodyStance BS_FarLadderEnter;
var transient AnimSet LadderAnimSet;
var float DecayRate;
var float CloseEnterDistance;
var float JumpStartDistance;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_CloseLadderEnter, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_FarLadderEnter, UsedAnims);
    Super(SFXCustomAction_ProceduralMoveBase).GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local SFXNav_LadderNode LadderNode;
    
    LadderNode = SFXNav_LadderNode(MovementPath.Start);
    if (LadderNode != None)
    {
        LadderAnimSet = LadderNode.AnimInfo.AnimSet;
        m_oPawn.RegisterTemporaryAnim(LadderAnimSet);
    }
    if (VSize(MovementPath.Start.location - m_oPawn.location) < CloseEnterDistance)
    {
        BS_Start = BS_CloseLadderEnter;
        JumpStartDistance = 0.0;
    }
    else
    {
        BS_Start = BS_FarLadderEnter;
        JumpStartDistance = default.JumpStartDistance;
    }
    Super(SFXCustomAction_ReachSpecMove).StartCustomAction();
}
public function TickCustomAction(float DeltaTime)
{
    local NavigationPoint StartNode;
    local NavigationPoint EndNode;
    
    Super(BioCustomAction).TickCustomAction(DeltaTime);
    if (MovementPath != None)
    {
        StartNode = MovementPath.Start;
        EndNode = NavigationPoint(MovementPath.End.Actor);
    }
    if (EndNode == None || StartNode == None)
    {
        return;
    }
    TickAlignment(DeltaTime);
    if (EndNode.CylinderComponent == None)
    {
        return;
    }
}
public function PreAlignPawnLocation()
{
    local NavigationPoint StartNode;
    local NavigationPoint EndNode;
    local Vector PlayerOffset;
    
    StartNode = MovementPath.Start;
    EndNode = NavigationPoint(MovementPath.End.Actor);
    if (EndNode != None && StartNode != None)
    {
        if (JumpStartDistance == float(0))
        {
            PlayerOffset = EndNode.location - StartNode.location;
        }
        else
        {
            PlayerOffset = StartNode.location - m_oPawn.location;
        }
        PlayerOffset.Z = 0.0;
        PlayerOffset = Normal(PlayerOffset);
        SetReachPreciseDestination(StartNode.location - PlayerOffset * JumpStartDistance);
        SetFacePreciseRotation(Rotator(PlayerOffset), 0.25);
    }
}
public function SetMoveStage(EMoveStage NextStage)
{
    local NavigationPoint StartNode;
    local NavigationPoint EndNode;
    local Vector ToEnd;
    local Vector StartLocation;
    
    if (NextStage == EMoveStage.EMS_Loop && MoveStage != EMoveStage.EMS_Loop)
    {
        StartNode = MovementPath.Start;
        EndNode = NavigationPoint(MovementPath.End.Actor);
        if (EndNode != None && StartNode != None)
        {
            ToEnd = EndNode.location - StartNode.location;
            ToEnd.Z /= 2.0;
            ToEnd = Normal(ToEnd);
            StartLocation = StartNode.location;
            StartLocation.Z = m_oPawn.location.Z;
            m_oPawn.SetLocation(StartLocation, );
        }
    }
    Super.SetMoveStage(NextStage);
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.LockDesiredRotation(FALSE, FALSE);
    if (LadderAnimSet != None)
    {
        m_oPawn.UnregisterTemporaryAnim(LadderAnimSet);
        LadderAnimSet = None;
    }
}
public function TickInput(BioPlayerInput Input, float DeltaTime)
{
    if (MoveStage == EMoveStage.EMS_Sync)
    {
        if (Input.Outer.DetectPressAway(MovementPath.Start.location, MovementPath.End.Actor.location))
        {
            m_oPawn.InterruptCustomAction();
        }
    }
}
public function SyncRotation(float Alpha)
{
    local NavigationPoint StartNode;
    local NavigationPoint EndNode;
    local Vector ToEnd2D;
    local Rotator R;
    
    StartNode = MovementPath.Start;
    EndNode = NavigationPoint(MovementPath.End.Actor);
    ToEnd2D = EndNode.location - StartNode.location;
    ToEnd2D.Z = 0.0;
    ToEnd2D = Normal(ToEnd2D);
    m_oPawn.LockDesiredRotation(FALSE, FALSE);
    m_oPawn.Mesh.RootMotionRotationMode = ERootMotionRotationMode.RMRM_Ignore;
    R = RLerp(m_oPawn.Rotation, Rotator(ToEnd2D), Alpha, TRUE);
    m_oPawn.SetRotation(R);
    m_oPawn.SetDesiredRotation(R, TRUE, FALSE, 0.0);
}
public function SyncJumpEntrance(float Alpha)
{
    local Vector PlayerPos;
    
    PlayerPos = VLerp(m_oPawn.location, MovementPath.Start.location, Alpha);
    PlayerPos.Z = m_oPawn.location.Z;
    m_oPawn.SetLocation(PlayerPos, );
    m_oPawn.Velocity.X = 0.0;
    m_oPawn.Velocity.Y = 0.0;
    m_oPawn.Acceleration = vect(0.0, 0.0, 0.0);
    m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Ignore;
}
public function TickAlignment(float DeltaTime)
{
    local Vector PlayerOffset;
    local float Alpha;
    
    PlayerOffset = MovementPath.Start.location - m_oPawn.location;
    PlayerOffset.Z = 0.0;
    Alpha = 1.0 - FClamp(2.71799994 ** (-DecayRate * DeltaTime), 0.0, 1.0);
    if (MoveStage != EMoveStage.EMS_End && VSize(PlayerOffset) < float(40))
    {
        SyncRotation(Alpha);
        if (JumpStartDistance > float(0))
        {
            SyncJumpEntrance(Alpha);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_CloseLadderEnter = {
                           AnimName = ('EX_LadderUp_Enter')
                          }
    BS_FarLadderEnter = {
                         AnimName = ('EX_LadderUp_JumpEnter')
                        }
    DecayRate = 5.0
    CloseEnterDistance = 200.0
    JumpStartDistance = 200.0
    BS_Loop = {
               AnimName = ('EX_LadderUp_Loop')
              }
    BS_End = {
              AnimName = ('EX_LadderUp_Exit')
             }
    StartRMM = ERootMotionMode.RMM_Accel
    fCameraTransitionIn = 0.25
    fCameraTransitionOut = 0.25
    bBreakFromCover = TRUE
}
Class SFXCustomAction_SimpleMoveBase extends BioCustomAction
    abstract
    config(Game);

var(SFXCustomAction_SimpleMoveBase) BodyStance BS_Anim;
var SFXReachSpecPlaceholderCylinder BlockingStartCylinder;
var SFXReachSpecPlaceholderCylinder BlockingEndCylinder;
var transient ReachSpec MovementPath;
var float MoveDistance;
var float fBlendInTime;
var float fBlendOutTime;
var const bool bAlignPawnBeforeMove;
var AlphaBlendType BlendType;
var ERootBoneAxis RootBoneX;
var ERootBoneAxis RootBoneY;
var ERootBoneAxis RootBoneZ;
var ERootMotionMode RMM;
var ERootRotationOption RootRotationPitch;
var ERootRotationOption RootRotationYaw;
var ERootRotationOption RootRotationRoll;
var ERootMotionRotationMode RMRM;
var EPhysics MovePhysics;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Anim, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public event function ReachedPrecisePosition()
{
    m_oPawn.ClearTimer('DestTimeout', Self);
    PlayStartAnimation();
}
public function StartCustomAction()
{
    local NavigationPoint Start;
    local float RotYaw;
    local Rotator NewRotation;
    
    BlockMoveEndPoints();
    Super.StartCustomAction();
    if (bAlignPawnBeforeMove)
    {
        m_oPawn.SetTimer(3.0, FALSE, 'DestTimeout', Self);
        Start = MovementPath.Start;
        if (Start != None)
        {
            SetReachPreciseDestination(Start.location);
        }
        RotYaw = float(Rotator(MovementPath.End.Actor.location - MovementPath.Start.location).Yaw);
        NewRotation = m_oPawn.Rotation;
        NewRotation.Yaw = int(RotYaw);
        SetFacePreciseRotation(NewRotation, 0.5);
    }
    else
    {
        PlayStartAnimation();
    }
}
public function BlockMoveEndPoints()
{
    local SFXCustomReachSpec CustomReachSpec;
    local NavigationPoint EndNav;
    
    BlockingStartCylinder = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , MovementPath.Start.location);
    if (BlockingStartCylinder != None)
    {
        BlockingStartCylinder.PawnsToIgnore[0] = m_oPawn;
        BlockingStartCylinder.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.14999998, m_oPawn.GetCollisionHeight());
    }
    BlockingEndCylinder = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , MovementPath.End.Actor.location);
    if (BlockingEndCylinder != None)
    {
        BlockingEndCylinder.PawnsToIgnore[0] = m_oPawn;
        BlockingEndCylinder.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.14999998, m_oPawn.GetCollisionHeight());
    }
    CustomReachSpec = SFXCustomReachSpec(MovementPath);
    if (CustomReachSpec != None)
    {
        CustomReachSpec.BlockingPawn = m_oPawn;
    }
    EndNav = NavigationPoint(MovementPath.End.Actor);
    if (EndNav != None)
    {
        CustomReachSpec = SFXCustomReachSpec(EndNav.GetReachSpecTo(MovementPath.Start));
        if (CustomReachSpec != None)
        {
            CustomReachSpec.BlockingPawn = m_oPawn;
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    EndThisCustomAction();
}
public function bool CanBeInterrupted()
{
    return FALSE;
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        if (ReachSpec(m_oPawn.ReplicatedCustomActionInfo.Target) != None)
        {
            MovementPath = ReachSpec(m_oPawn.ReplicatedCustomActionInfo.Target);
        }
        Super.ClientDoCustomAction(bForced);
    }
}
public function DestTimeout()
{
    EndThisCustomAction();
}
public function BodyStance GetBodyStanceAnim()
{
    return BS_Anim;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (MovementPath != None)
    {
        return TRUE;
    }
    else if (m_oPawn.Controller != None && m_oPawn.Controller.CurrentPath != None)
    {
        MovementPath = m_oPawn.Controller.CurrentPath;
        return TRUE;
    }
    return FALSE;
}
public function PlayStartAnimation()
{
    local float DistToEnd;
    local float RootMotionScaleFactor;
    local BodyStance BS_ToPlay;
    
    BS_ToPlay = GetBodyStanceAnim();
    if (m_oPawn.PlayBodyStance(BS_ToPlay, 1.0, fBlendInTime, fBlendOutTime, , , , , BlendType) != 0.0)
    {
        m_oPawn.SetPhysics(MovePhysics);
        m_oPawn.LastPhysicsSetter = Self;
        m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, RootBoneX, RootBoneY, RootBoneZ);
        m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        m_oPawn.Mesh.RootMotionMode = RMM;
        m_oPawn.SetBodyStanceRootRotationOption(BS_ToPlay, RootRotationPitch, RootRotationYaw, RootRotationRoll);
        m_oPawn.Mesh.RootMotionRotationMode = RMRM;
        DistToEnd = VSize2D(MovementPath.End.Actor.location - m_oPawn.location);
        RootMotionScaleFactor = FMax(DistToEnd / MoveDistance, 1.0);
        m_oPawn.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
        m_oPawn.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
        m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
    }
    else
    {
        EndThisCustomAction();
    }
}
public function RemoveBlockingEndPoints()
{
    local SFXCustomReachSpec CustomReachSpec;
    local NavigationPoint EndNav;
    
    if (BlockingStartCylinder != None)
    {
        BlockingStartCylinder.Destroy();
        BlockingStartCylinder = None;
    }
    if (BlockingEndCylinder != None)
    {
        BlockingEndCylinder.Destroy();
        BlockingEndCylinder = None;
    }
    CustomReachSpec = SFXCustomReachSpec(MovementPath);
    if (CustomReachSpec != None)
    {
        CustomReachSpec.BlockingPawn = None;
    }
    EndNav = NavigationPoint(MovementPath.End.Actor);
    if (EndNav != None)
    {
        CustomReachSpec = SFXCustomReachSpec(EndNav.GetReachSpecTo(MovementPath.Start));
        if (CustomReachSpec != None)
        {
            CustomReachSpec.BlockingPawn = None;
        }
    }
}
public function Replicate()
{
    Super.Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.Target = MovementPath;
    }
}
public function StopCustomAction()
{
    local BodyStance BS_ToPlay;
    
    BS_ToPlay = GetBodyStanceAnim();
    m_oPawn.ClearTimer('DestTimeout', Self);
    Super.StopCustomAction();
    RemoveBlockingEndPoints();
    m_oPawn.StopBodyStance(BS_ToPlay, fBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, FALSE);
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, 1, 1, 1);
    m_oPawn.SetBodyStanceRootRotationOption(BS_ToPlay, 1, 1, 1);
    m_oPawn.Mesh.RootMotionAccelScale.X = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Y = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    m_oPawn.Mesh.RootMotionRotationMode = m_oPawn.Mesh.default.RootMotionRotationMode;
    if (m_oPawn.LastPhysicsSetter == Self)
    {
        m_oPawn.SetPhysics(1);
    }
    MovementPath = None;
    m_oPawn.StopMovement(TRUE);
    if (m_oAI != None && m_oAI.MoveTarget != None)
    {
        if (VSize(m_oPawn.location - m_oAI.MoveTarget.location) < VSize(m_oPawn.location - m_oPawn.Anchor.location))
        {
            m_oAI.ReachedMoveTarget();
            m_oAI.UpdateMovementFocus();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MoveDistance = 1.0
    fBlendInTime = 0.100000001
    fBlendOutTime = 0.100000001
    bAlignPawnBeforeMove = TRUE
    RootBoneX = ERootBoneAxis.RBA_Translate
    RootBoneY = ERootBoneAxis.RBA_Translate
    RootBoneZ = ERootBoneAxis.RBA_Translate
    RMM = ERootMotionMode.RMM_Accel
    MovePhysics = EPhysics.PHYS_Flying
    AICommand = Class'SFXAICmd_CA_CoverMantleClimbBase'
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bReplicateCustomAction = TRUE
    bForceLocalSimulation = TRUE
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}
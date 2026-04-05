Class SFXCustomAction_MantleOverCoverBase extends SFXCustomAction_ProceduralMoveBase
    native
    abstract
    config(Game);

var MantleInfo MyMantleInfo;
var SFXReachSpecPlaceholderCylinder PlaceholderCylinder;
var SFXReachSpecPlaceholderCylinder PlaceholderCylinder2;

public function PlayEndAnimation()
{
    local BodyStance Loop;
    local BodyStance End;
    
    GetLoopAnim(Loop);
    m_oPawn.SetBodyStanceAnimEndNotification(Loop, FALSE);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.default.Mesh.RootMotionMode;
    SetMoveStage(3);
    GetEndAnim(End);
    if (m_oPawn.PlayBodyStance(End, 1.0, fEndBlendInTime, fEndBlendOutTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(End, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(End, 2, 2, 2);
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Accel;
    }
}
public function StartCustomAction()
{
    local Vector CylLoc;
    
    if (m_oPawn.bIsCrouched)
    {
        m_oPawn.UnCrouch();
    }
    Super.StartCustomAction();
    CylLoc = GetBasedPosition(MyMantleInfo.EstimatedLandingLoc);
    PlaceholderCylinder = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , CylLoc);
    if (PlaceholderCylinder != None)
    {
        PlaceholderCylinder.PawnsToIgnore[0] = m_oPawn;
        PlaceholderCylinder.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.14999998, m_oPawn.GetCollisionHeight());
    }
    CylLoc = GetBasedPosition(MyMantleInfo.MantleEndLoc);
    PlaceholderCylinder2 = m_oPawn.Spawn(Class'SFXReachSpecPlaceholderCylinder', , , CylLoc);
    if (PlaceholderCylinder2 != None)
    {
        PlaceholderCylinder2.PawnsToIgnore[0] = m_oPawn;
        PlaceholderCylinder2.SetCollisionSize(m_oPawn.GetCollisionRadius() * 1.35000002, m_oPawn.GetCollisionHeight());
    }
}
public simulated function AdaptJumpToPathing()
{
    m_oPawn.Mesh.RootMotionAccelScale.X = MyMantleInfo.RootMotionScaleFactor;
    m_oPawn.Mesh.RootMotionAccelScale.Y = MyMantleInfo.RootMotionScaleFactor;
    m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
}
public simulated function AdjustLoopPlayRate(float FallDuration)
{
    local float TimeLeft;
    local float PlayRate;
    local BodyStance Stance;
    
    GetLoopAnim(Stance);
    TimeLeft = m_oPawn.BS_GetTimeLeft(Stance);
    PlayRate = 1.0;
    if (FallDuration > float(0))
    {
        PlayRate = TimeLeft / FallDuration;
    }
    m_oPawn.BS_SetPlayRate(Stance, m_oPawn.BS_GetPlayRate(Stance) * PlayRate);
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (MoveStage == EMoveStage.EMS_Start)
    {
        PlayLoopAnimation();
    }
    else if (MoveStage == EMoveStage.EMS_End)
    {
        EndThisCustomAction();
    }
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        if (NavigationPoint(m_oPawn.ReplicatedCustomActionInfo.Target) != None)
        {
            m_oPawn.SetAnchor(NavigationPoint(m_oPawn.ReplicatedCustomActionInfo.Target));
        }
        Super(BioCustomAction).ClientDoCustomAction(bForced);
    }
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    MyMantleInfo.bForced = bForced;
    return m_oPawn.CanPerformMantleSlow(MyMantleInfo, bForceLocalSimulation);
}
public function PlayLoopAnimation()
{
    local BodyStance Stance;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector TraceEnd;
    local Vector TraceStart;
    local Actor HitActor;
    local float DistanceToGround;
    local float FallDuration;
    
    GetStartAnim(Stance);
    m_oPawn.StopBodyStance(Stance, 0.200000003);
    m_oPawn.SetBodyStanceAnimEndNotification(Stance, FALSE);
    m_oPawn.SetCollisionSize(m_oPawn.default.CylinderComponent.CollisionRadius, m_oPawn.default.CylinderComponent.CollisionHeight);
    m_oPawn.FitCollision();
    SetMoveStage(2);
    GetLoopAnim(Stance);
    if (m_oPawn.PlayBodyStance(Stance, 1.0, fLoopBlendInTime, fLoopBlendOutTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(Stance, TRUE);
        m_oPawn.SetBodyStanceRootBoneAxisOption(Stance, 1, 1, 1);
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Ignore;
    }
    m_oPawn.SetPhysics(2);
    if (m_oPawn.Controller != None || bForceLocalSimulation)
    {
        m_oPawn.Velocity = m_oPawn.GetInitialFallVelocity(MyMantleInfo);
    }
    TraceStart = m_oPawn.location + m_oPawn.default.CollisionComponent.Translation + vect(0.0, 0.0, -1.0) * m_oPawn.default.CylinderComponent.CollisionHeight + Vector(m_oPawn.Rotation) * m_oPawn.default.CylinderComponent.CollisionRadius;
    TraceEnd = TraceStart + vect(0.0, 0.0, -1.0) * 1024.0;
    HitActor = m_oPawn.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, , , );
    if (HitActor != None)
    {
        DistanceToGround = VSize(HitLocation - TraceStart);
        FallDuration = Sqrt(DistanceToGround / Abs(m_oPawn.GetGravityZ())) + 0.100000001;
        AdjustLoopPlayRate(FallDuration);
    }
}
public function PlayStartAnimation()
{
    local BodyStance StartStance;
    
    Super.PlayStartAnimation();
    GetStartAnim(StartStance);
    if (m_oPawn.IsPlayingBodyStance(StartStance))
    {
        m_oPawn.SetPhysics(4);
        m_oPawn.LastPhysicsSetter = Outer;
        m_oPawn.SetCollisionSize(m_oPawn.default.CylinderComponent.CollisionRadius, m_oPawn.default.CylinderComponent.CollisionHeight * 0.5);
        AdaptJumpToPathing();
    }
}
public function PreAlignPawnLocation()
{
    local Rotator NewRotation;
    local int MantleRotYaw;
    
    if (m_oPawn.Controller != None || bForceLocalSimulation)
    {
        MantleRotYaw = Rotator(Normal(GetBasedPosition(MyMantleInfo.MantleEndLoc) - GetBasedPosition(MyMantleInfo.MantleStartLoc))).Yaw;
        NewRotation = m_oPawn.Rotation;
        NewRotation.Yaw = MantleRotYaw;
        SetFacePreciseRotation(NewRotation, 0.100000001);
        SetReachPreciseDestination(GetBasedPosition(MyMantleInfo.MantleStartLoc));
    }
}
public function Replicate()
{
    Super(BioCustomAction).Replicate();
    if (m_oPawn != None)
    {
        if (m_oPawn.Anchor != None)
        {
            m_oPawn.ReplicatedCustomActionInfo.Target = m_oPawn.Anchor;
        }
    }
}
public function ServerStartCustomAction(int NewAction, optional BioPawn Sync, optional int NewPowerAction)
{
    if (m_oPawn != None && m_oPC != None)
    {
        m_oPC.ServerStartCustomActionWithNav(NewAction, m_oPawn.Anchor, Sync, NewPowerAction);
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    if (PlaceholderCylinder != None)
    {
        PlaceholderCylinder.Destroy();
        PlaceholderCylinder = None;
    }
    if (PlaceholderCylinder2 != None)
    {
        PlaceholderCylinder2.Destroy();
        PlaceholderCylinder2 = None;
    }
    if (m_oPawn.CylinderComponent.CollisionHeight != m_oPawn.default.CylinderComponent.CollisionHeight)
    {
        if (m_oPawn.CylinderComponent != m_oPawn.CollisionComponent)
        {
            m_oPawn.CylinderComponent.SetCylinderSize(m_oPawn.default.CylinderComponent.CollisionRadius, m_oPawn.default.CylinderComponent.CollisionHeight);
        }
        m_oPawn.SetCollisionSize(m_oPawn.default.CylinderComponent.CollisionRadius, m_oPawn.default.CylinderComponent.CollisionHeight);
        m_oPawn.FitCollision();
    }
    if (m_oPawn.LastPhysicsSetter == Outer && m_oPawn.Physics == EPhysics.PHYS_Flying)
    {
        m_oPawn.SetPhysics(2);
    }
    MyMantleInfo.RootMotionScaleFactor = default.MyMantleInfo.RootMotionScaleFactor;
    m_oPawn.Mesh.RootMotionAccelScale.X = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Y = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
    m_oPawn.bForceFloorCheck = TRUE;
    if (m_oPC != None)
    {
        m_oPawn.SetAnchor(None);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MyMantleInfo = {
                    CurrentSlot = {
                                   Actions = (), 
                                   FireLinks = (), 
                                   RejectedFireLinks = (), 
                                   ExposedCoverPackedProperties = (), 
                                   DangerCoverPackedProperties = (), 
                                   SlipTarget = (), 
                                   SlipRefs = (), 
                                   OverlapClaims = (), 
                                   MantleTarget = {
                                                   SlotIdx = 0, 
                                                   Direction = 0, 
                                                   Guid = {A = 0, B = 0, C = 0, D = 0}, 
                                                   Actor = None
                                                  }, 
                                   LocationOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                   RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                   SlotOwner = None, 
                                   SlotValidAfterTime = 0.0, 
                                   TurnTargetPackedProperties = -1, 
                                   CoverTurnTargetPackedProperties = -1, 
                                   ExtraCost = 0, 
                                   LeanTraceDist = 64.0, 
                                   SlotMarker = None, 
                                   bLeanLeft = FALSE, 
                                   bLeanRight = FALSE, 
                                   bForceCanPopUp = FALSE, 
                                   bCanPopUp = FALSE, 
                                   bCanMantle = TRUE, 
                                   bCanClimbUp = FALSE, 
                                   bForceCanCoverSlip_Left = FALSE, 
                                   bForceCanCoverSlip_Right = FALSE, 
                                   bCanCoverSlip_Left = TRUE, 
                                   bCanCoverSlip_Right = TRUE, 
                                   bCanSwatTurn_Left = TRUE, 
                                   bCanSwatTurn_Right = TRUE, 
                                   bCanCoverTurn_Left = TRUE, 
                                   bCanCoverTurn_Right = TRUE, 
                                   bEnabled = TRUE, 
                                   bAllowPopup = TRUE, 
                                   bAllowMantle = TRUE, 
                                   bAllowCoverSlip = TRUE, 
                                   bAllowClimbUp = FALSE, 
                                   bAllowSwatTurn = TRUE, 
                                   bAllowCoverTurn = TRUE, 
                                   bForceNoGroundAdjust = FALSE, 
                                   bPlayerOnly = FALSE, 
                                   bUnsafeCover = FALSE, 
                                   bSelected = FALSE, 
                                   bFailedToFindSurface = FALSE, 
                                   ForceCoverType = ECoverType.CT_None, 
                                   CoverType = ECoverType.CT_None, 
                                   LocationDescription = ECoverLocationDescription.CoverDesc_None
                                  }, 
                    LeftSlot = {
                                Actions = (), 
                                FireLinks = (), 
                                RejectedFireLinks = (), 
                                ExposedCoverPackedProperties = (), 
                                DangerCoverPackedProperties = (), 
                                SlipTarget = (), 
                                SlipRefs = (), 
                                OverlapClaims = (), 
                                MantleTarget = {
                                                SlotIdx = 0, 
                                                Direction = 0, 
                                                Guid = {A = 0, B = 0, C = 0, D = 0}, 
                                                Actor = None
                                               }, 
                                LocationOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                SlotOwner = None, 
                                SlotValidAfterTime = 0.0, 
                                TurnTargetPackedProperties = -1, 
                                CoverTurnTargetPackedProperties = -1, 
                                ExtraCost = 0, 
                                LeanTraceDist = 64.0, 
                                SlotMarker = None, 
                                bLeanLeft = FALSE, 
                                bLeanRight = FALSE, 
                                bForceCanPopUp = FALSE, 
                                bCanPopUp = FALSE, 
                                bCanMantle = TRUE, 
                                bCanClimbUp = FALSE, 
                                bForceCanCoverSlip_Left = FALSE, 
                                bForceCanCoverSlip_Right = FALSE, 
                                bCanCoverSlip_Left = TRUE, 
                                bCanCoverSlip_Right = TRUE, 
                                bCanSwatTurn_Left = TRUE, 
                                bCanSwatTurn_Right = TRUE, 
                                bCanCoverTurn_Left = TRUE, 
                                bCanCoverTurn_Right = TRUE, 
                                bEnabled = TRUE, 
                                bAllowPopup = TRUE, 
                                bAllowMantle = TRUE, 
                                bAllowCoverSlip = TRUE, 
                                bAllowClimbUp = FALSE, 
                                bAllowSwatTurn = TRUE, 
                                bAllowCoverTurn = TRUE, 
                                bForceNoGroundAdjust = FALSE, 
                                bPlayerOnly = FALSE, 
                                bUnsafeCover = FALSE, 
                                bSelected = FALSE, 
                                bFailedToFindSurface = FALSE, 
                                ForceCoverType = ECoverType.CT_None, 
                                CoverType = ECoverType.CT_None, 
                                LocationDescription = ECoverLocationDescription.CoverDesc_None
                               }, 
                    RightSlot = {
                                 Actions = (), 
                                 FireLinks = (), 
                                 RejectedFireLinks = (), 
                                 ExposedCoverPackedProperties = (), 
                                 DangerCoverPackedProperties = (), 
                                 SlipTarget = (), 
                                 SlipRefs = (), 
                                 OverlapClaims = (), 
                                 MantleTarget = {
                                                 SlotIdx = 0, 
                                                 Direction = 0, 
                                                 Guid = {A = 0, B = 0, C = 0, D = 0}, 
                                                 Actor = None
                                                }, 
                                 LocationOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                 SlotOwner = None, 
                                 SlotValidAfterTime = 0.0, 
                                 TurnTargetPackedProperties = -1, 
                                 CoverTurnTargetPackedProperties = -1, 
                                 ExtraCost = 0, 
                                 LeanTraceDist = 64.0, 
                                 SlotMarker = None, 
                                 bLeanLeft = FALSE, 
                                 bLeanRight = FALSE, 
                                 bForceCanPopUp = FALSE, 
                                 bCanPopUp = FALSE, 
                                 bCanMantle = TRUE, 
                                 bCanClimbUp = FALSE, 
                                 bForceCanCoverSlip_Left = FALSE, 
                                 bForceCanCoverSlip_Right = FALSE, 
                                 bCanCoverSlip_Left = TRUE, 
                                 bCanCoverSlip_Right = TRUE, 
                                 bCanSwatTurn_Left = TRUE, 
                                 bCanSwatTurn_Right = TRUE, 
                                 bCanCoverTurn_Left = TRUE, 
                                 bCanCoverTurn_Right = TRUE, 
                                 bEnabled = TRUE, 
                                 bAllowPopup = TRUE, 
                                 bAllowMantle = TRUE, 
                                 bAllowCoverSlip = TRUE, 
                                 bAllowClimbUp = FALSE, 
                                 bAllowSwatTurn = TRUE, 
                                 bAllowCoverTurn = TRUE, 
                                 bForceNoGroundAdjust = FALSE, 
                                 bPlayerOnly = FALSE, 
                                 bUnsafeCover = FALSE, 
                                 bSelected = FALSE, 
                                 bFailedToFindSurface = FALSE, 
                                 ForceCoverType = ECoverType.CT_None, 
                                 CoverType = ECoverType.CT_None, 
                                 LocationDescription = ECoverLocationDescription.CoverDesc_None
                                }, 
                    MantleStartLoc = {
                                      Position = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                      CachedBaseLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                      CachedBaseRotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                      CachedTransPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                      Base = None
                                     }, 
                    MantleEndLoc = {
                                    Position = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    CachedBaseLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    CachedBaseRotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                    CachedTransPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                    Base = None
                                   }, 
                    EstimatedLandingLoc = {
                                           Position = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                           CachedBaseLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                           CachedBaseRotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                           CachedTransPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                           Base = None
                                          }, 
                    MantleDistance = 0.0, 
                    DestLink = None, 
                    LeftLink = None, 
                    RightLink = None, 
                    CurrentLink = None, 
                    CurrentSlotIdx = 0, 
                    LeftSlotIdx = 0, 
                    RightSlotIdx = 0, 
                    CurrentSlotPct = 0.0, 
                    FallForwardVelocity = 300.0, 
                    RootMotionScaleFactor = 1.0, 
                    DefaultMantleDistance = 190.0, 
                    bForced = FALSE, 
                    bIsOnASlot = FALSE
                   }
    bAlignPawnBeforeMove = TRUE
    AICommand = Class'SFXAICmd_CA_CoverMantleClimbBase'
    bLockPawnRotation = TRUE
    bBreakFromCover = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    bForceLocalSimulation = TRUE
}
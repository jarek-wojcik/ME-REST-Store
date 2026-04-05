Class Pawn extends Actor
    native
    placeable
    nativereplication
    abstract
    config(Game);

enum EPathSearchType
{
    PST_Default,
    PST_Breadth,
    PST_NewBestPathTo,
    PST_Constraint,
};

var RootMotionCurve RootMotionInterpCurve;
var const localized string MenuName;
var transient array<AnimNodeSlot> SlotNodes;
var transient array<InterpGroup> InterpGroupList;
var Class<AIController> ControllerClass;
var Class<DamageType> HitDamageType;
var Class<InventoryManager> InventoryManagerClass;
var Vector SerpentineDir;
var Vector Floor;
var Vector RMVelocity;
var const Vector noise1spot;
var const Vector noise2spot;
var Vector TakeHitLocation;
var Vector TearOffMomentum;
var(Movement) const Rotator DesiredRotation;
var repnotify Vector FlashLocation;
var Vector LastFiringFlashLocation;
var Vector RootMotionInterpCurveLastValue;
var Name LandMovementState;
var Name WaterMovementState;
var const float MaxStepHeight;
var const float MaxJumpHeight;
var const float WalkableFloorZ;
var const float LedgeCheckThreshold;
var repnotify Controller Controller;
var const Pawn NextPawn;
var float NetRelevancyTime;
var PlayerController LastRealViewer;
var Actor LastViewer;
var const float UncrouchTime;
var float CrouchHeight;
var float CrouchRadius;
var const int FullHeight;
var float NonPreferredVehiclePathMultiplier;
var PathConstraint PathConstraintList;
var PathGoalEvaluator PathGoalList;
var const float DesiredSpeed;
var float MaxDesiredSpeed;
var(AI) float HearingThreshold;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var const float AvgPhysicsTime;
var float Mass;
var float Buoyancy;
var float MeleeRange;
var const NavigationPoint Anchor;
var const int AnchorItem;
var const NavigationPoint LastAnchor;
var float FindAnchorFailedTime;
var float LastValidAnchorTime;
var float DestinationOffset;
var float NextPathRadius;
var float SerpentineDist;
var float SerpentineTime;
var float SpawnTime;
var int MaxPitchLimit;
var float GroundSpeed;
var float WaterSpeed;
var float AirSpeed;
var float LadderSpeed;
var float AccelRate;
var float JumpZ;
var float OutofWaterZ;
var float MaxOutOfWaterStepHeight;
var float AirControl;
var float WalkingPct;
var float CrouchedPct;
var float MaxFallSpeed;
var float AIMaxFallSpeedFactor;
var(Camera) float BaseEyeHeight;
var(Camera) float EyeHeight;
var float SplashTime;
var float OldZ;
var transient PhysicsVolume HeadVolume;
var(Pawn) int Health;
var(Pawn) int HealthMax;
var float BreathTime;
var float UnderWaterTime;
var float LastPainTime;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var float SoundDampening;
var float DamageScaling;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var LadderVolume OnLadder;
var PlayerStart LastStartSpot;
var float LastStartTime;
var(Pawn) editinline export SkeletalMeshComponent Mesh;
var editinline export CylinderComponent CylinderComponent;
var(Pawn) float RBPushRadius;
var(Pawn) float RBPushStrength;
var repnotify Vehicle DrivenVehicle;
var float AlwaysRelevantDistanceSquared;
var(Pawn) float VehicleCheckRadius;
var Controller LastHitBy;
var(Pawn) float ViewPitchMin;
var(Pawn) float ViewPitchMax;
var int AllowedYawError;
var repnotify InventoryManager InvManager;
var(Pawn) Weapon Weapon;
var float m_fWallSlideSpeedAdj;
var int ShotCount;
var editinline export PrimitiveComponent PreRagdollCollisionComponent;
var RB_BodyInstance PhysicsPushBody;
var int FailedLandingCount;
var editinline transient export AudioComponent FacialAudioComp;
var transient MaterialInstanceConstant MIC_PawnMat;
var transient MaterialInstanceConstant MIC_PawnHair;
var float RootMotionInterpRate;
var float RootMotionInterpCurrentTime;
var transient export Object Stats;
var config bool bUseDeltaReplication;
var bool bSkipPawnPropertyReplication;
var const bool BioSoftwareSkinned;
var bool bUpAndOut;
var bool bIsWalking;
var bool bWantsToCrouch;
var const bool bIsCrouched;
var const bool bTryToUncrouch;
var(Pawn) bool bCanCrouch;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bJumpCapable;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanClimbLadders;
var bool bCanStrafe;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bAllowLedgeOverhang;
var const bool bSimulateGravity;
var bool bIgnoreForces;
var bool bCanWalkOffLedges;
var bool bCanBeBaseForPawns;
var const bool bSimGravityDisabled;
var bool bDirectHitWall;
var const bool bPushesRigidBodies;
var bool bForceFloorCheck;
var bool bForceKeepAnchor;
var bool bCanMantle;
var bool bCanClimbUp;
var bool bCanClimbCeilings;
var bool bCanSwatTurn;
var bool bCanLeap;
var bool bCanCoverSlip;
var globalconfig bool bDisplayPathErrors;
var(AI) bool bIsFemale;
var bool bCanPickupInventory;
var bool bAmbientCreature;
var(AI) bool bLOSHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bDontPossess;
var bool bAutoFire;
var bool bRollToDesired;
var bool bStationary;
var bool bCachedRelevant;
var bool bSpecialHUD;
var bool bNoWeaponFiring;
var bool bCanUse;
var bool bModifyReachSpecCost;
var bool bModifyNavPointDest;
var bool bPathfindsAsVehicle;
var bool bRunPhysicsWithNoController;
var bool bForceMaxAccel;
var bool bLimitFallAccel;
var bool bReplicateHealthToAll;
var bool bForceRMVelocity;
var bool bForceRegularVelocity;
var bool bPlayedDeath;
var const bool bDesiredRotationSet;
var const bool bLockDesiredRotation;
var const bool bUnlockWhenReached;
var bool m_bEnableRagdollRecovery;
var bool m_bIsWallSliding;
var bool bNeedsBaseTickedFirst;
var bool bRootMotionFromInterpCurve;
var(Debug) bool bDebugShowCameraLocation;
var EPathSearchType PathSearchType;
var const byte RemoteViewPitch;
var repnotify byte FlashCount;
var repnotify byte FiringMode;

public function AddDefaultInventory();

public native function AddGoalEvaluator(PathGoalEvaluator Evaluator);

public native function AddPathConstraint(PathConstraint Constraint);

public final native function Vector AdjustDestination(Actor GoalActor, optional Vector Dest);

public event simulated function AnimSetListUpdated();

public event singular function BaseChange()
{
    local DynamicSMActor Dyn;
    
    if (Pawn(Base) != None && (DrivenVehicle == None || !DrivenVehicle.IsBasedOn(Base)))
    {
        if (!Pawn(Base).CanBeBaseForPawn(Self))
        {
            Pawn(Base).CrushedBy(Self);
            JumpOffPawn();
        }
    }
    Dyn = DynamicSMActor(Base);
    if (Dyn != None && !Dyn.CanBasePawn(Self))
    {
        JumpOffPawn();
    }
}
public event simulated function BecomeViewTarget(PlayerController PC)
{
    if (PhysicsVolume != None)
    {
        PhysicsVolume.NotifyPawnBecameViewTarget(Self, PC);
    }
    if (!bReplicateHealthToAll && WorldInfo.NetMode != ENetMode.NM_Client)
    {
        PC.ForceSingleNetUpdateFor(Self);
    }
}
public event simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
    MAT_BeginAnimControl(InInterpGroup);
}
public event function BreathTimer()
{
    if (HeadVolume.bWaterVolume)
    {
        if (Health < 0 || WorldInfo.NetMode == ENetMode.NM_Client || DrivenVehicle != None)
        {
            return;
        }
        TakeDrowningDamage();
        if (Health > 0)
        {
            BreathTime = 2.0;
        }
    }
    else
    {
        BreathTime = 0.0;
    }
}
public event simulated function BuildScriptAnimSetList();

public final native function CheckDesiredRotation();

public native function ClearConstraints();

public native function ClearPathStep();

public event function ClientMessage(coerce string S, optional Name Type)
{
    if (PlayerController(Controller) != None)
    {
        PlayerController(Controller).ClientMessage(S, Type);
    }
}
public final event function Inventory CreateInventory(Class<Inventory> NewInvClass, optional bool bDoNotActivate)
{
    if (InvManager != None)
    {
        return InvManager.CreateInventory(NewInvClass, bDoNotActivate);
    }
    return None;
}
public event simulated function Destroyed()
{
    DetachFromController();
    if (InvManager != None)
    {
        InvManager.Destroy();
    }
    if (WorldInfo.NetMode == ENetMode.NM_Client)
    {
        return;
    }
    SetAnchor(None);
    Weapon = None;
    ClearPathStep();
    Super.Destroyed();
}
public native function DrawPathStep(Canvas C);

public event function EncroachedBy(Actor Other)
{
    if (Pawn(Other) != None && Vehicle(Other) == None)
    {
        gibbedBy(Other);
    }
}
public event function bool EncroachingOn(Actor Other)
{
    if (Other.bWorldGeometry || Other.bBlocksTeleport)
    {
        return TRUE;
    }
    if ((Controller == None || !Controller.bIsPlayer) && Pawn(Other) != None)
    {
        return TRUE;
    }
    return FALSE;
}
public function EndClimbLadder(LadderVolume OldLadder)
{
    if (Controller != None)
    {
        Controller.EndClimbLadder();
    }
    if (Physics == EPhysics.PHYS_Ladder)
    {
        SetPhysics(2);
    }
}
public event simulated function EndCrouch(float HeightAdjust)
{
    EyeHeight -= HeightAdjust;
    OldZ += HeightAdjust;
    SetBaseEyeheight();
}
public event function Falling();

public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        Health = -1;
        Died(None, dmgType, location);
        if (dmgType == None)
        {
            SetPhysics(0);
            SetHidden(TRUE);
            LifeSpan = FMin(LifeSpan, 1.0);
        }
    }
}
public final simulated function Inventory FindInventoryType(Class<Inventory> DesiredClass, optional bool bAllowSubclass)
{
    return InvManager != None ? InvManager.FindInventoryType(DesiredClass, bAllowSubclass) : None;
}
public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}
public native function ForceCrouch();

public event simulated function GetActorEyesViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    out_Location = GetPawnViewLocation();
    out_rotation = GetViewRotation();
}
public event function FaceFXAsset GetActorFaceFXAsset()
{
    return Mesh.GetBioFaceFXAsset();
}
public native function GetAdjustedMoveDirection(const out Vector Dest, Actor MoveTarget, out Vector Direction);

public event singular simulated function Rotator GetBaseAimRotation()
{
    local Vector POVLoc;
    local Rotator POVRot;
    
    if (Controller != None && !InFreeCam())
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVRot;
    }
    POVRot = Rotation;
    if (POVRot.Pitch == 0)
    {
        POVRot.Pitch = int(RemoteViewPitch) << 8;
    }
    return POVRot;
}
public native function NavigationPoint GetBestAnchor(Actor TestActor, Vector TestLocation, bool bStartPoint, bool bOnlyCheckVisible, out float out_Dist);

public native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

public native function float GetDesiredSpeed();

public event simulated function AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
}
public native function float GetFallDuration();

public native function float GetMaxSpeed();

public event simulated native function Vector GetPawnViewLocation();

public native function SkeletalMeshComponent GetPrimarySkelMeshComponent();

public simulated native function byte GetTeamNum();

public native function Vehicle GetVehicleBase();

public event simulated native function Rotator GetViewRotation();

public event simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector POVLoc;
    local Rotator POVRot;
    
    if (Controller != None)
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVLoc;
    }
    return GetPawnViewLocation();
}
public event function HeadVolumeChange(PhysicsVolume newHeadVolume)
{
    if (WorldInfo.NetMode == ENetMode.NM_Client || Controller == None)
    {
        return;
    }
    if (HeadVolume != None && HeadVolume.bWaterVolume)
    {
        if (!newHeadVolume.bWaterVolume)
        {
            if (Controller.bIsPlayer && BreathTime > float(0) && BreathTime < float(8))
            {
                Gasp();
            }
            BreathTime = -1.0;
        }
    }
    else if (newHeadVolume.bWaterVolume)
    {
        BreathTime = UnderWaterTime;
    }
}
public event function bool HealDamage(int Amount, Controller Healer, Class<DamageType> DamageType)
{
    if (Health > 0 && Health < HealthMax)
    {
        Health = Min(HealthMax, Health + Amount);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public native function IncrementPathChild(int Cnt, Canvas C);

public native function IncrementPathStep(int Cnt, Canvas C);

public event simulated function bool InFreeCam()
{
    local PlayerController PC;
    
    PC = PlayerController(Controller);
    return PC != None && PC.PlayerCamera != None && (PC.PlayerCamera.CameraStyle == 'FreeCam' || PC.PlayerCamera.CameraStyle == 'FreeCam_Default');
}
public native function bool InitRagdoll();

public final native function bool InPlayerParty();

public event simulated function InterpolationFinished(SeqAct_Interp InterpAction)
{
    Super.InterpolationFinished(InterpAction);
}
public event simulated function InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    local InterpGroupAI MyGroup;
    
    if (InterpGroupInstAI(GroupInst) != None)
    {
        MyGroup = InterpGroupAI(GroupInst.Group);
        if (MyGroup != None && MyGroup.StageMarkActor != None)
        {
            SetLocation(MyGroup.StageMarkActor.location, );
            SetRotation(MyGroup.StageMarkActor.Rotation);
        }
    }
    Super.InterpolationStarted(InterpAction, GroupInst);
}
public final simulated native function bool IsAliveAndWell();

public final native function bool IsBioSoftwareSkinned();

public final native function bool IsDead();

public final native function bool IsDesiredRotationInUse();

public final native function bool IsDesiredRotationLocked();

public function bool IsFiring()
{
    if (Weapon != None)
    {
        return Weapon.IsFiring();
    }
    return FALSE;
}
public native function bool IsFriendly(Pawn Other);

public native function bool IsHostile(Pawn Other);

public simulated native function bool IsHumanControlled(optional Controller PawnController);

public native function bool IsInvisible();

public simulated native function bool IsLocallyControlled(optional Controller PawnController);

public simulated native function bool IsPlayerPawn();

public event simulated function bool IsSameTeam(Pawn Other)
{
    return Other != None && Other.GetTeam() != None && Other.GetTeam() == GetTeam();
}
public native function bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

public native function bool IsValidTargetFor(const Controller C);

public function KilledBy(Pawn EventInstigator)
{
    local Controller Killer;
    
    Health = 0;
    if (EventInstigator != None)
    {
        Killer = EventInstigator.Controller;
        LastHitBy = None;
    }
    Died(Killer, Class'DmgType_Suicided', location);
}
public event function Landed(Vector HitNormal, Actor FloorActor)
{
    TakeFallingDamage();
    if (Health > 0)
    {
        PlayLanded(Velocity.Z);
    }
    LastHitBy = None;
}
public function bool LineOfSightTo(Actor Other)
{
    return Controller != None && Controller.LineOfSightTo(Other, , );
}
public final native function LockDesiredRotation(bool Lock, optional bool InUnlockWhenReached = FALSE);

public event function MAT_BeginAIGroup(Vector StartLoc, Rotator StartRot)
{
    SetLocation(StartLoc, );
    SetRotation(StartRot);
}
public native function MAT_BeginAnimControl(InterpGroup InInterpGroup);

public native function MAT_FinishAnimControl(InterpGroup InInterpGroup);

public native function MAT_SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

public native function MAT_SetAnimWeights(array<AnimSlotInfo> SlotInfos);

public native function MAT_SetMorphWeight(Name MorphNodeName, float MorphWeight);

public native function MAT_SetSkelControlScale(Name SkelControlName, float Scale);

public final event function MessagePlayer(coerce string Msg);

public event simulated function ModifyVelocity(float DeltaTime, Vector OldVelocity);

public event singular simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority && PlayerController(Controller) == None)
    {
        KilledBy(Self);
    }
    else
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            KilledBy(Self);
        }
        SetPhysics(0);
        SetHidden(TRUE);
        LifeSpan = FMin(LifeSpan, 1.0);
    }
}
public event function bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return Mesh.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}
public event function PlayFootStepSound(int FootDown);

public simulated function PlayHit(float Damage, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo, Pawn DamageCauser)
{
    if (Damage <= float(0) && (Controller == None || !Controller.bGodMode))
    {
        return;
    }
    LastPainTime = WorldInfo.TimeSeconds;
}
public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    SplashTime = 0.0;
    SpawnTime = WorldInfo.GameTimeSeconds;
    EyeHeight = BaseEyeHeight;
    if (WorldInfo.bStartup && Health > 0 && !bDontPossess)
    {
        SpawnDefaultController();
    }
    if (FacialAudioComp != None)
    {
        FacialAudioComp.__OnAudioFinished__Delegate = FaceFXAudioFinished;
    }
    if (Role == ENetRole.ROLE_Authority && InvManager == None && InventoryManagerClass != None)
    {
        InvManager = Spawn(InventoryManagerClass, Self);
        if (InvManager == None)
        {
        }
        else
        {
            InvManager.SetupFor(Self);
        }
    }
    ClearPathStep();
}
public event simulated function PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    Super.PostInitAnimTree(SkelComp);
    ClearAnimNodes();
    CacheAnimNodes();
}
public event simulated function PreBeginPlay()
{
    if (HealthMax == 0)
    {
        HealthMax = default.Health;
    }
    Super.PreBeginPlay();
    Instigator = Self;
    SetDesiredRotation(Rotation);
    EyeHeight = BaseEyeHeight;
}
public final native function bool ReachedDesiredRotation();

public native function bool ReachedDestination(Actor Goal);

public native function bool ReachedPoint(Vector Point, Actor NewAnchor);

public event simulated function ReceivedNewEvent(SequenceEvent Evt)
{
    if (Controller != None)
    {
        Controller.ReceivedNewEvent(Evt);
    }
    Super.ReceivedNewEvent(Evt);
}
public function ReceiveLocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (PlayerController(Controller) != None)
    {
        PlayerController(Controller).ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    Super.ReplicatedEvent(VarName);
    if (VarName == 'FlashCount')
    {
        FlashCountUpdated(Weapon, FlashCount, TRUE);
    }
    else if (VarName == 'FlashLocation')
    {
        FlashLocationUpdated(Weapon, FlashLocation, TRUE);
    }
    else if (VarName == 'FiringMode')
    {
        FiringModeUpdated(Weapon, FiringMode, TRUE);
    }
    else if (VarName == 'DrivenVehicle')
    {
        if (DrivenVehicle != None)
        {
            NotifyTeamChanged();
        }
    }
    else if (VarName == 'PlayerReplicationInfo')
    {
        NotifyTeamChanged();
    }
    else if (VarName == 'Controller')
    {
        if (Controller != None && Controller.Pawn == None)
        {
            Controller.Pawn = Self;
            if (PlayerController(Controller) != None && PlayerController(Controller).ViewTarget == Controller)
            {
                PlayerController(Controller).SetViewTarget(Self);
            }
        }
    }
}
public function Reset()
{
    if (Controller == None || Controller.bIsPlayer)
    {
        DetachFromController();
        Destroy();
    }
    else
    {
        Super.Reset();
    }
}
public final native function ResetDesiredRotation();

public event simulated function bool RestoreAnimSetsToDefault()
{
    Mesh.AnimSets = default.Mesh.AnimSets;
    return TRUE;
}
public native function SetAnchor(NavigationPoint NewAnchor);

public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    MAT_SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
}
public final native function bool SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = FALSE, optional bool InUnlockWhenReached = FALSE, optional float InterpolationTime = -1.0);

public native function SetDesiredSpeed(float fSpeedScaling);

public event function SetMorphWeight(Name MorphNodeName, float MorphWeight)
{
    MAT_SetMorphWeight(MorphNodeName, MorphWeight);
}
public native function SetPushesRigidBodies(bool NewPush);

public final native function SetRemoteViewPitch(int NewRemoteViewPitch);

public native function SetRootMotionInterpCurrentTime(float inTime, optional float DeltaTime, optional bool bUpdateSkelPose);

public event function SetSkelControlScale(Name SkelControlName, float Scale)
{
    MAT_SetSkelControlScale(SkelControlName, Scale);
}
public event function SetWalking(bool bNewIsWalking)
{
    if (bNewIsWalking != bIsWalking)
    {
        bIsWalking = bNewIsWalking;
    }
}
public event function SoakPause()
{
    local PlayerController PC;
    
    foreach WorldInfo.LocalPlayerControllers(Class'PlayerController', PC)
    {
        PC.SoakPause(Self);
        break;
    }
}
public event function SpawnedByKismet()
{
    if (Controller != None)
    {
        Controller.SpawnedByKismet();
    }
}
public event function bool SpecialMoveThruEdge(ENavMeshEdgeType Type, int Dir, Vector MoveStart, Vector MoveDest, optional Actor RelActor, optional int RelItem);

public event simulated function StartCrouch(float HeightAdjust)
{
    EyeHeight += HeightAdjust;
    OldZ -= HeightAdjust;
    SetBaseEyeheight();
}
public event simulated function StartDriving(Vehicle V)
{
    StopFiring();
    if (Health <= 0)
    {
        return;
    }
    DrivenVehicle = V;
    bForceNetUpdate = TRUE;
    ShouldCrouch(FALSE);
    bIgnoreForces = TRUE;
    bCanTeleport = FALSE;
    BreathTime = 0.0;
    V.AttachDriver(Self);
}
public event function StopActorFaceFXAnim()
{
    Mesh.StopFaceFXAnim();
}
public event simulated function StopDriving(Vehicle V)
{
    if (Mesh != None)
    {
        Mesh.SetCullDistance(default.Mesh.CachedMaxDrawDistance);
        Mesh.SetShadowParent(None);
    }
    bForceNetUpdate = TRUE;
    if (V != None)
    {
        V.StopFiring();
    }
    if (Physics == EPhysics.PHYS_RigidBody)
    {
        return;
    }
    DrivenVehicle = None;
    bIgnoreForces = FALSE;
    SetHardAttach(FALSE);
    bCanTeleport = TRUE;
    bCollideWorld = TRUE;
    if (V != None)
    {
        V.DetachDriver(Self);
    }
    SetCollision(TRUE, TRUE, );
    if (Role == ENetRole.ROLE_Authority)
    {
        if (PhysicsVolume.bWaterVolume && Health > 0)
        {
            SetPhysics(3);
        }
        else
        {
            SetPhysics(2);
        }
        SetBase(None, , , );
        SetHidden(FALSE);
    }
}
public function bool StopFiring()
{
    if (Weapon != None)
    {
        Weapon.StopFire(Weapon.CurrentFireMode);
    }
    return TRUE;
}
public event function StuckOnPawn(Pawn OtherPawn);

public native function bool SuggestJumpVelocity(out Vector JumpVelocity, Vector Destination, Vector Start);

public event simulated function TakeDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}
public event function bool TakeRadiusDamageOnBones(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, array<Name> Bones)
{
    local int idx;
    local TraceHitInfo HitInfo;
    local bool bResult;
    local float DamageScale;
    local float Dist;
    local Vector Dir;
    local Vector BoneLoc;
    
    PruneDamagedBoneList(Bones);
    for (idx = 0; idx < Bones.Length; idx++)
    {
        HitInfo.BoneName = Bones[idx];
        HitInfo.HitComponent = Mesh;
        BoneLoc = Mesh.GetBoneLocation(Bones[idx]);
        Dir = BoneLoc - HurtOrigin;
        Dist = VSize(Dir);
        Dir = Normal(Dir);
        if (bFullDamage)
        {
            DamageScale = 1.0;
        }
        else
        {
            DamageScale = 1.0 - Dist / DamageRadius;
        }
        if (DamageScale > 0.0)
        {
            TakeDamage(DamageScale * BaseDamage, instigatedBy, BoneLoc, DamageScale * Momentum * Dir, DamageType, HitInfo, DamageCauser);
        }
        bResult = TRUE;
    }
    return bResult;
}
public native function bool TermRagdoll();

public event simulated function TornOff()
{
    if (!bPlayedDeath)
    {
        PlayDying(HitDamageType, TakeHitLocation);
    }
}
public final simulated native function UpdateAnimSetList();

public final event simulated function UpdatePawnRotation(Rotator NewRotation)
{
    FaceRotation(NewRotation, 0.0);
}
public final native function bool ValidAnchor();

public simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
    ShotCount = 0;
    if (InWeapon != None)
    {
        InWeapon.StopFireEffects(GetWeaponFiringMode(InWeapon));
    }
}
public simulated function bool CanActorPlayFaceFXAnim()
{
    return TRUE;
}
public simulated function bool CanSplash()
{
    if (WorldInfo.TimeSeconds - SplashTime > 0.150000006 && (Physics == EPhysics.PHYS_Falling || Physics == EPhysics.PHYS_Flying) && Abs(Velocity.Z) > float(100))
    {
        SplashTime = WorldInfo.TimeSeconds;
        return TRUE;
    }
    return FALSE;
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Canvas Canvas;
    local AnimTree AnimTreeRootNode;
    local int i;
    
    Canvas = HUD.Canvas;
    if (PlayerReplicationInfo == None)
    {
        Canvas.DrawText("NO PLAYERREPLICATIONINFO", FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    else
    {
        PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
    }
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Health " $ Health);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawText("Anchor " $ Anchor $ " Serpentine Dist " $ SerpentineDist $ " Time " $ SerpentineTime);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Physics'))
    {
        T = "Floor " $ Floor $ " DesiredSpeed " $ DesiredSpeed $ " Crouched " $ bIsCrouched;
        if (OnLadder != None || Physics == EPhysics.PHYS_Ladder)
        {
            T = T $ " on ladder " $ OnLadder;
        }
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "Collision Component:" @ CollisionComponent;
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "bForceMaxAccel:" @ bForceMaxAccel;
        Canvas.DrawText(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        if (Mesh != None)
        {
            T = "RootMotionMode:" @ Mesh.RootMotionMode @ "RootMotionVelocity:" @ Mesh.RootMotionVelocity;
            Canvas.DrawText(T);
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Camera'))
    {
        Canvas.DrawText("EyeHeight " $ EyeHeight $ " BaseEyeHeight " $ BaseEyeHeight);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (Controller == None)
    {
        Canvas.SetDrawColor(255, 0, 0);
        Canvas.DrawText("NO CONTROLLER");
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        HUD.PlayerOwner.DisplayDebug(HUD, out_YL, out_YPos);
    }
    else
    {
        Controller.DisplayDebug(HUD, out_YL, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Weapon'))
    {
        if (Weapon == None)
        {
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawText("NO WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
        else
        {
            Weapon.DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    if (HUD.ShouldDisplayDebug('Animation'))
    {
        if (Mesh != None && Mesh.Animations != None)
        {
            AnimTreeRootNode = AnimTree(Mesh.Animations);
            if (AnimTreeRootNode != None)
            {
                Canvas.DrawText("AnimGroups count:" @ AnimTreeRootNode.AnimGroups.Length);
                out_YPos += out_YL;
                Canvas.SetPos(4.0, out_YPos);
                for (i = 0; i < AnimTreeRootNode.AnimGroups.Length; i++)
                {
                    Canvas.DrawText(" GroupName:" @ AnimTreeRootNode.AnimGroups[i].GroupName @ "NodeCount:" @ AnimTreeRootNode.AnimGroups[i].SeqNodes.Length @ "RateScale:" @ AnimTreeRootNode.AnimGroups[i].RateScale);
                    out_YPos += out_YL;
                    Canvas.SetPos(4.0, out_YPos);
                }
            }
        }
    }
}
public function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors;
    local bool bOldBlockActors;
    local bool bValidBone;
    local bool bValidSocket;
    
    if (Mesh != None && Action.BoneName != 'None')
    {
        bValidSocket = Mesh.GetSocketByName(Action.BoneName) != None;
        bValidBone = Mesh.MatchRefBone(Action.BoneName) != -1;
        if (!bValidBone && !bValidSocket)
        {
        }
    }
    if (bValidBone || bValidSocket)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(FALSE, FALSE, );
        Attachment.SetHardAttach(Action.bHardAttach);
        if (bValidBone && !bValidSocket)
        {
            if (Action.bUseRelativeOffset)
            {
                Attachment.SetLocation(Mesh.GetBoneLocation(Action.BoneName), );
            }
            if (Action.bUseRelativeRotation)
            {
                Attachment.SetRotation(QuatToRotator(Mesh.GetBoneQuaternion(Action.BoneName)));
            }
        }
        Attachment.SetBase(Self, , Mesh, Action.BoneName);
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors, );
    }
    else
    {
        Super.DoKismetAttachment(Attachment, Action);
    }
}
public simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController P;
    
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        return bForceDedicated;
    }
    if (WorldInfo.NetMode == ENetMode.NM_ListenServer && WorldInfo.Game.NumPlayers + WorldInfo.Game.NumSpectators > 1)
    {
        if (bForceDedicated)
        {
            return TRUE;
        }
        if (IsHumanControlled() && IsLocallyControlled())
        {
            return TRUE;
        }
    }
    else if (IsHumanControlled())
    {
        return TRUE;
    }
    if (SpawnLocation != location || WorldInfo.TimeSeconds - LastRenderTime < 1.0)
    {
        foreach LocalPlayerControllers(Class'PlayerController', P)
        {
            if (P.ViewTarget != None && (P.Pawn == Self || CheckMaxEffectDistance(P, SpawnLocation, CullDistance)))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public simulated function string GetHumanReadableName()
{
    if (PlayerReplicationInfo != None)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    return MenuName;
}
public simulated function bool IsActorPlayingFaceFXAnim()
{
    return Mesh != None && Mesh.IsPlayingFaceFXAnim();
}
public function bool IsInPain()
{
    local PhysicsVolume V;
    
    foreach TouchingActors(Class'PhysicsVolume', V, )
    {
        if (V.bPainCausing && V.DamagePerSec > float(0))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool IsStationary()
{
    return FALSE;
}
public simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Actor destActor;
    local Vector vLocation;
    local Rotator rRotation;
    
    if (Action.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        if (SetLocation(vLocation, TRUE))
        {
            PlayTeleportEffect(FALSE, TRUE);
            if (Action.bUpdateRotation)
            {
                SetDesiredRotation(rRotation);
                SetRotation(rRotation);
                if (Controller != None)
                {
                    Controller.SetRotation(rRotation);
                    Controller.ClientSetRotation(rRotation);
                }
            }
        }
        if (Controller != None)
        {
            Controller.OnTeleport(None);
        }
    }
}
public function PlayTeleportEffect(bool bOut, bool bSound)
{
    MakeNoise(1.0, );
}
public function AddVelocity(Vector NewVelocity, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    if (bIgnoreForces || NewVelocity == vect(0.0, 0.0, 0.0))
    {
        return;
    }
    if (Physics == EPhysics.PHYS_Walking || (Physics == EPhysics.PHYS_Ladder || Physics == EPhysics.PHYS_Spider) && NewVelocity.Z > default.JumpZ)
    {
        SetPhysics(2);
    }
    if (Velocity.Z > default.JumpZ && NewVelocity.Z > float(0))
    {
        NewVelocity.Z *= 0.5;
    }
    Velocity += NewVelocity;
}
public simulated function AdjustCameraScale(bool bMoveCameraIn);

public function AdjustDamage(out int inDamage, out Vector Momentum, Controller instigatedBy, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo);

public function float AdjustedStrength()
{
    return 0.0;
}
public simulated function bool AffectedByHitEffects()
{
    return Controller == None || Controller.bAffectedByHitEffects;
}
public function bool BotFire(bool bFinished)
{
    StartFire(ChooseFireMode());
    return TRUE;
}
public simulated function CacheAnimNodes()
{
    local AnimNodeSlot SlotNode;
    
    foreach Mesh.AllAnimNodes(Class'AnimNodeSlot', SlotNode)
    {
        SlotNodes[SlotNodes.Length] = SlotNode;
    }
}
public function bool CanAttack(Actor Other)
{
    if (Weapon == None)
    {
        return FALSE;
    }
    return Weapon.CanAttack(Other);
}
public simulated function bool CanBeBaseForPawn(Pawn aPawn)
{
    return bCanBeBaseForPawns;
}
public function bool CanGrabLadder()
{
    return bCanClimbLadders && Controller != None && Physics != EPhysics.PHYS_Ladder && (Physics != EPhysics.PHYS_Falling || Abs(Velocity.Z) <= JumpZ);
}
public function bool CannotJumpNow()
{
    return FALSE;
}
public simulated function bool CanThrowWeapon()
{
    return Weapon != None && Weapon.CanThrow();
}
public function bool CheatFly()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(TRUE, TRUE, );
    bCollideWorld = TRUE;
    return TRUE;
}
public function bool CheatGhost()
{
    UnderWaterTime = -1.0;
    SetCollision(FALSE, FALSE, );
    bCollideWorld = FALSE;
    SetPushesRigidBodies(FALSE);
    return TRUE;
}
public function bool CheatWalk()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(TRUE, TRUE, );
    SetPhysics(2);
    bCollideWorld = TRUE;
    SetPushesRigidBodies(default.bPushesRigidBodies);
    return TRUE;
}
public function bool CheckWaterJump(out Vector WallNormal)
{
    local Actor HitActor;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector Checkpoint;
    local Vector Start;
    local Vector checkNorm;
    local Vector Extent;
    
    if (AIController(Controller) != None)
    {
        if (Controller.InLatentExecution(503) && Controller.MoveTarget != None && !Controller.MoveTarget.PhysicsVolume.bWaterVolume)
        {
            Checkpoint = Normal(Controller.MoveTarget.location - location);
        }
        else
        {
            Checkpoint = Acceleration;
        }
        Checkpoint.Z = 0.0;
    }
    if (Checkpoint == vect(0.0, 0.0, 0.0))
    {
        Checkpoint = Vector(Rotation);
    }
    Checkpoint.Z = 0.0;
    checkNorm = Normal(Checkpoint);
    Checkpoint = location + 1.20000005 * CylinderComponent.CollisionRadius * checkNorm;
    Extent = CylinderComponent.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = CylinderComponent.CollisionHeight;
    HitActor = Trace(HitLocation, HitNormal, Checkpoint, location, TRUE, Extent, , 8);
    if (HitActor != None && Pawn(HitActor) == None)
    {
        WallNormal = float(-1) * HitNormal;
        Start = location;
        Start.Z += MaxOutOfWaterStepHeight;
        Checkpoint = Start + 3.20000005 * CylinderComponent.CollisionRadius * WallNormal;
        HitActor = Trace(HitLocation, HitNormal, Checkpoint, Start, TRUE, , , 8);
        if (HitActor == None || HitNormal.Z > 0.699999988)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function byte ChooseFireMode()
{
    return 0;
}
public simulated function ClearAnimNodes()
{
    SlotNodes.Length = 0;
}
public simulated function ClearFlashCount(Weapon InWeapon)
{
    Internal_ClearFlashCount(InWeapon, FlashCount);
}
public function ClearFlashLocation(Weapon InWeapon)
{
    Internal_ClearFlashLocation(InWeapon, FlashLocation);
}
public simulated function ClientRestart()
{
    ZeroMovementVariables();
    SetBaseEyeheight();
}
public function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    if (Controller != None)
    {
        Controller.ClientSetLocation(NewLocation, NewRotation);
    }
}
public function ClientSetRotation(Rotator NewRotation)
{
    if (Controller != None)
    {
        Controller.ClientSetRotation(NewRotation);
    }
}
public function ClimbLadder(LadderVolume L)
{
    OnLadder = L;
    SetRotation(OnLadder.WallDir);
    SetPhysics(9);
    if (IsHumanControlled())
    {
        Controller.GotoState('PlayerClimbing', , , );
    }
}
public function PathConstraint CreatePathConstraint(Class<PathConstraint> ConstraintClass)
{
    return new (Self) ConstraintClass;
}
public function PathGoalEvaluator CreatePathGoalEvaluator(Class<PathGoalEvaluator> GoalEvalClass)
{
    return new (Self) GoalEvalClass;
}
public function CrushedBy(Pawn OtherPawn)
{
    TakeDamage((1.0 - OtherPawn.Velocity.Z / float(400)) * OtherPawn.Mass / Mass, OtherPawn.Controller, location, vect(0.0, 0.0, 0.0), Class'DmgType_Crushed');
}
public function DetachFromController(optional bool bDestroyController)
{
    local Controller OldController;
    
    if (Controller != None && Controller.Pawn == Self)
    {
        OldController = Controller;
        Controller.PawnDied(Self);
        if (Controller != None)
        {
            Controller.UnPossess();
        }
        if (bDestroyController && OldController != None && !OldController.bDeleteMe && !OldController.bIsPlayer)
        {
            OldController.Destroy();
        }
        Controller = None;
    }
}
public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    local SeqAct_Latent Action;
    
    if (DamageType == None)
    {
        DamageType = Class'DamageType';
    }
    if (bDeleteMe || WorldInfo.Game == None || WorldInfo.Game.bLevelChange)
    {
        return FALSE;
    }
    if (DamageType.default.bCausedByWorld && (Killer == None || Killer == Controller) && LastHitBy != None)
    {
        Killer = LastHitBy;
    }
    if (WorldInfo.Game.PreventDeath(Self, Killer, DamageType, HitLocation))
    {
        Health = Max(Health, 1);
        return FALSE;
    }
    Health = Min(0, Health);
    TriggerEventClass(Class'SeqEvent_Death', Self);
    foreach LatentActions(Action, )
    {
        Action.AbortFor(Self);
    }
    LatentActions.Length = 0;
    if (DrivenVehicle != None)
    {
        Velocity = DrivenVehicle.Velocity;
        DrivenVehicle.DriverDied(DamageType);
    }
    else if (Weapon != None)
    {
        Weapon.HolderDied();
        ThrowWeaponOnDeath();
    }
    if (Controller != None)
    {
        WorldInfo.Game.Killed(Killer, Controller, Self, DamageType);
    }
    else
    {
        WorldInfo.Game.Killed(Killer, Controller(Owner), Self, DamageType);
    }
    DrivenVehicle = None;
    if (InvManager != None)
    {
        InvManager.OwnerDied();
    }
    Velocity.Z *= 1.29999995;
    if (IsHumanControlled())
    {
        PlayerController(Controller).ForceDeathUpdate();
    }
    NetUpdateFrequency = default.NetUpdateFrequency;
    PlayDying(DamageType, HitLocation);
    return TRUE;
}
public function bool DoJump(bool bUpdating)
{
    if (bJumpCapable && !bIsCrouched && !bWantsToCrouch && (Physics == EPhysics.PHYS_Walking || Physics == EPhysics.PHYS_Ladder || Physics == EPhysics.PHYS_Spider))
    {
        if (Physics == EPhysics.PHYS_Spider)
        {
            Velocity = JumpZ * Floor;
        }
        else if (Physics == EPhysics.PHYS_Ladder)
        {
            Velocity.Z = 0.0;
        }
        else if (bIsWalking)
        {
            Velocity.Z = default.JumpZ;
        }
        else
        {
            Velocity.Z = JumpZ;
        }
        if (Base != None && !Base.bWorldGeometry && Base.Velocity.Z > 0.0)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        return TRUE;
    }
    return FALSE;
}
public simulated function DrawHUD(HUD H)
{
    if (InvManager != None)
    {
        InvManager.DrawHUD(H);
    }
}
public function DropToGround()
{
    bCollideWorld = TRUE;
    if (Health > 0)
    {
        SetCollision(TRUE, TRUE, );
        SetPhysics(2);
        if (IsHumanControlled())
        {
            Controller.GotoState(LandMovementState, , , );
        }
    }
}
public simulated function FaceFXAudioFinished(AudioComponent AC);

public simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    if (!InFreeCam())
    {
        if (Physics == EPhysics.PHYS_Ladder)
        {
            NewRotation = OnLadder.WallDir;
        }
        else if (Physics == EPhysics.PHYS_Walking || Physics == EPhysics.PHYS_Falling)
        {
            NewRotation.Pitch = 0;
        }
        SetRotation(NewRotation);
    }
}
public function FinishedInterpolation()
{
    DropToGround();
}
public function bool FireOnRelease()
{
    if (Weapon != None)
    {
        return Weapon.FireOnRelease();
    }
    return FALSE;
}
public simulated function FiringModeUpdated(Weapon InWeapon, byte InFiringMode, bool bViaReplication)
{
    if (InWeapon != None)
    {
        InWeapon.FireModeUpdated(InFiringMode, bViaReplication);
    }
}
public simulated function FlashCountUpdated(Weapon InWeapon, byte InFlashCount, bool bViaReplication)
{
    if (int(InFlashCount) > 0)
    {
        WeaponFired(InWeapon, bViaReplication);
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
}
public simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
    if (!IsZero(InFlashLocation))
    {
        WeaponFired(InWeapon, bViaReplication, InFlashLocation);
    }
    else
    {
        WeaponStoppedFiring(InWeapon, bViaReplication);
    }
}
public function Gasp();

public simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    if (Controller == None || Role < ENetRole.ROLE_Authority)
    {
        return GetBaseAimRotation();
    }
    return Controller.GetAdjustedAimFor(W, StartFireLoc);
}
public final simulated function Vector GetCollisionExtent()
{
    local Vector Extent;
    
    Extent = GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Extent.Z = GetCollisionHeight();
    return Extent;
}
public simulated function float GetCollisionHeight()
{
    return CylinderComponent != None ? CylinderComponent.CollisionHeight : 0.0;
}
public simulated function float GetCollisionRadius()
{
    return CylinderComponent != None ? CylinderComponent.CollisionRadius : 0.0;
}
public function float GetDamageScaling()
{
    return DamageScaling;
}
public simulated function Name GetDefaultCameraMode(PlayerController RequestedBy)
{
    if (RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'FirstPerson';
}
public function Actor GetMoveTarget()
{
    if (Controller == None)
    {
        return None;
    }
    return Controller.MoveTarget;
}
public simulated function TeamInfo GetTeam()
{
    if (Controller != None && Controller.PlayerReplicationInfo != None)
    {
        return Controller.PlayerReplicationInfo.Team;
    }
    else if (PlayerReplicationInfo != None)
    {
        return PlayerReplicationInfo.Team;
    }
    else if (DrivenVehicle != None && DrivenVehicle.PlayerReplicationInfo != None)
    {
        return DrivenVehicle.PlayerReplicationInfo.Team;
    }
    else
    {
        return None;
    }
}
public simulated function byte GetWeaponFiringMode(Weapon InWeapon)
{
    return FiringMode;
}
public function gibbedBy(Actor Other)
{
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (Pawn(Other) != None)
    {
        Died(Pawn(Other).Controller, Class'DmgType_Telefragged', location);
    }
    else
    {
        Died(None, Class'DmgType_Telefragged', location);
    }
}
public function HandleMomentum(Vector Momentum, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
}
public function HandlePickup(Inventory Inv)
{
    MakeNoise(0.200000003, );
    if (Controller != None)
    {
        Controller.HandlePickup(Inv);
    }
}
public function bool HasRangedAttack()
{
    return Weapon != None;
}
public simulated function IncrementFlashCount(Weapon InWeapon, byte InFiringMode)
{
    Internal_IncrementFlashCount(InWeapon, InFiringMode, FlashCount);
}
public function bool InGodMode()
{
    return Controller != None && Controller.bGodMode;
}
public final simulated function Internal_ClearFlashCount(Weapon InWeapon, out byte out_FlashCountVar)
{
    if (int(out_FlashCountVar) != 0)
    {
        bForceNetUpdate = TRUE;
        out_FlashCountVar = 0;
        FlashCountUpdated(InWeapon, out_FlashCountVar, FALSE);
    }
}
public final function Internal_ClearFlashLocation(Weapon InWeapon, out Vector out_FlashLocation)
{
    if (!IsZero(out_FlashLocation))
    {
        bForceNetUpdate = TRUE;
        out_FlashLocation = vect(0.0, 0.0, 0.0);
        FlashLocationUpdated(InWeapon, out_FlashLocation, FALSE);
    }
}
public final simulated function Internal_IncrementFlashCount(Weapon InWeapon, byte InFiringMode, out byte out_FlashCountVar)
{
    bForceNetUpdate = TRUE;
    out_FlashCountVar++;
    if (int(out_FlashCountVar) == 0)
    {
        out_FlashCountVar += 2;
    }
    SetFiringMode(InWeapon, InFiringMode);
    FlashCountUpdated(InWeapon, out_FlashCountVar, FALSE);
}
public final simulated function Internal_SetFiringMode(Weapon InWeapon, byte InFiringMode, out byte out_FiringModeVar)
{
    if (int(out_FiringModeVar) != int(InFiringMode))
    {
        out_FiringModeVar = InFiringMode;
        bForceNetUpdate = TRUE;
        FiringModeUpdated(InWeapon, out_FiringModeVar, FALSE);
    }
}
public final simulated function Internal_SetFlashLocation(Weapon InWeapon, out Vector out_FlashLocation, byte InFiringMode, Vector NewLoc)
{
    if (NewLoc == LastFiringFlashLocation)
    {
        NewLoc += vect(0.0, 0.0, 1.0);
    }
    if (NewLoc == vect(0.0, 0.0, 0.0))
    {
        NewLoc = vect(0.0, 0.0, 1.0);
    }
    bForceNetUpdate = TRUE;
    out_FlashLocation = NewLoc;
    LastFiringFlashLocation = NewLoc;
    SetFiringMode(InWeapon, InFiringMode);
    FlashLocationUpdated(InWeapon, out_FlashLocation, FALSE);
}
public simulated function bool IsFirstPerson()
{
    local PlayerController PC;
    
    PC = PlayerController(Controller);
    return PC != None && PC.UsingFirstPersonCamera();
}
public function bool IsOnSamePathNetwork(Pawn P)
{
    local NavigationPoint MyAnchor;
    local NavigationPoint OtherAnchor;
    local float DistToAnchor;
    
    MyAnchor = GetBestAnchor(Self, location, TRUE, TRUE, DistToAnchor);
    if (P != None)
    {
        OtherAnchor = P.Anchor;
        if (OtherAnchor == None)
        {
            OtherAnchor = P.GetBestAnchor(P, P.location, TRUE, TRUE, DistToAnchor);
        }
    }
    return MyAnchor != None && OtherAnchor != None && MyAnchor.NetworkID == OtherAnchor.NetworkID;
}
public simulated function bool IsValidEnemy()
{
    return TRUE;
}
public function JumpOffPawn()
{
    Velocity += (float(100) + CylinderComponent.CollisionRadius) * VRand();
    if (VSize2D(Velocity) > FMax(500.0, GroundSpeed))
    {
        Velocity = FMax(500.0, GroundSpeed) * Normal(Velocity);
    }
    Velocity.Z = 200.0 + CylinderComponent.CollisionHeight;
    SetPhysics(2);
}
public function JumpOutOfWater(Vector jumpDir)
{
    Falling();
    Velocity = jumpDir * WaterSpeed;
    Acceleration = jumpDir * AccelRate;
    Velocity.Z = OutofWaterZ;
    bUpAndOut = TRUE;
}
public function bool NearMoveTarget()
{
    if (Controller == None || Controller.MoveTarget == None)
    {
        return FALSE;
    }
    return ReachedDestination(Controller.MoveTarget);
}
public function bool NeedToTurn(Vector targ)
{
    local Vector LookDir;
    local Vector AimDir;
    
    LookDir = Vector(Rotation);
    LookDir.Z = 0.0;
    LookDir = Normal(LookDir);
    AimDir = targ - location;
    AimDir.Z = 0.0;
    AimDir = Normal(AimDir);
    return LookDir Dot AimDir < 0.930000007;
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    if (Controller != None)
    {
        Controller.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    }
}
public simulated function NotifyTeamChanged();

public function OnAssignController(SeqAct_AssignController inAction)
{
    if (inAction.ControllerClass != None)
    {
        if (Controller != None)
        {
            DetachFromController(TRUE);
        }
        Controller = Spawn(inAction.ControllerClass);
        Controller.Possess(Self, FALSE);
        if (Controller.IsA('AIController'))
        {
            ControllerClass = Class<AIController>(Controller.Class);
        }
    }
}
public simulated function OnGiveInventory(SeqAct_GiveInventory inAction)
{
    local int idx;
    local Class<Inventory> InvClass;
    
    if (inAction.bClearExisting)
    {
        InvManager.DiscardInventory();
    }
    if (inAction.InventoryList.Length > 0)
    {
        for (idx = 0; idx < inAction.InventoryList.Length; idx++)
        {
            InvClass = inAction.InventoryList[idx];
            if (InvClass != None)
            {
                if (FindInventoryType(InvClass, FALSE) == None)
                {
                    CreateInventory(InvClass);
                }
                continue;
            }
            inAction.ScriptLog("WARNING: Attempting to give NULL inventory!");
        }
    }
    else
    {
        inAction.ScriptLog("WARNING: Give Inventory without any inventory specified!");
    }
}
public simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    Mesh.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
}
public function OnSetMaterial(SeqAct_SetMaterial Action)
{
    if (Mesh != None)
    {
        Mesh.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    }
}
public simulated function bool PawnCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    return CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    GotoState('Dying', , , );
    bReplicateMovement = FALSE;
    bTearOff = TRUE;
    Velocity += TearOffMomentum;
    SetDyingPhysics();
    bPlayedDeath = TRUE;
}
public simulated function PlayDyingSound();

public function PlayerChangedTeam()
{
    Died(None, Class'DamageType', location);
}
public function PlayLanded(float ImpactVel);

public simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon);

public function PossessedBy(Controller C, bool bVehicleTransition)
{
    Controller = C;
    NetUpdateFrequency = 100.0;
    bForceNetUpdate = TRUE;
    if (C.PlayerReplicationInfo != None)
    {
        PlayerReplicationInfo = C.PlayerReplicationInfo;
    }
    UpdateControllerOnPossess(bVehicleTransition);
    SetOwner(Controller);
    EyeHeight = BaseEyeHeight;
    if (C.IsA('PlayerController'))
    {
        if (WorldInfo.NetMode != ENetMode.NM_Standalone)
        {
            RemoteRole = ENetRole.ROLE_AutonomousProxy;
        }
        if (Weapon != None)
        {
            Weapon.ClientWeaponSet(FALSE);
        }
    }
    else
    {
        RemoteRole = default.RemoteRole;
    }
    if (Weapon != None)
    {
        Weapon.CacheAIController();
    }
}
public simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    out_ViewRotation += out_DeltaRot;
    out_DeltaRot = rot(0, 0, 0);
    if (PlayerController(Controller) != None)
    {
        out_ViewRotation = PlayerController(Controller).LimitViewRotation(out_ViewRotation, ViewPitchMin, ViewPitchMax);
    }
}
public function PruneDamagedBoneList(out array<Name> Bones);

public function float RangedAttackTime()
{
    return 0.0;
}
public function bool RecommendLongRangedAttack()
{
    return FALSE;
}
public function Restart();

public function RestartPlayer();

public simulated function SetActiveWeapon(Weapon NewWeapon)
{
    if (InvManager != None)
    {
        InvManager.SetCurrentWeapon(NewWeapon);
    }
}
public simulated function SetBaseEyeheight()
{
    if (!bIsCrouched)
    {
        BaseEyeHeight = default.BaseEyeHeight;
    }
    else
    {
        BaseEyeHeight = FMin(0.800000012 * CrouchHeight, CrouchHeight - float(10));
    }
}
public simulated function SetCinematicMode(bool bInCinematicMode);

public function SetDyingPhysics()
{
    if (Physics != EPhysics.PHYS_RigidBody)
    {
        SetPhysics(2);
    }
}
public simulated function SetFiringMode(Weapon InWeapon, byte InFiringMode)
{
    Internal_SetFiringMode(InWeapon, InFiringMode, FiringMode);
}
public simulated function SetFlashLocation(Weapon InWeapon, byte InFiringMode, Vector NewLoc)
{
    Internal_SetFlashLocation(InWeapon, FlashLocation, InFiringMode, NewLoc);
}
public function Controller SetKillInstigator(Controller instigatedBy, Class<DamageType> DamageType)
{
    if (instigatedBy != None && instigatedBy != Controller)
    {
        return instigatedBy;
    }
    else if (DamageType.default.bCausedByWorld && LastHitBy != None)
    {
        return LastHitBy;
    }
    return instigatedBy;
}
public function SetMovementPhysics()
{
    if (PhysicsVolume.bWaterVolume)
    {
        SetPhysics(3);
    }
    else if (Physics != EPhysics.PHYS_Falling)
    {
        SetPhysics(2);
    }
}
public function SetMoveTarget(Actor NewTarget)
{
    if (Controller != None)
    {
        Controller.MoveTarget = NewTarget;
    }
}
public simulated function SetViewRotation(Rotator NewRotation)
{
    if (Controller != None)
    {
        Controller.SetRotation(NewRotation);
    }
    else
    {
        SetRotation(NewRotation);
    }
}
public function ShouldCrouch(bool bCrouch)
{
    bWantsToCrouch = bCrouch;
}
public function SpawnDefaultController()
{
    if (Controller != None)
    {
        return;
    }
    if (ControllerClass != None)
    {
        Controller = Spawn(ControllerClass);
    }
    if (Controller != None)
    {
        Controller.Possess(Self, FALSE);
    }
}
public function int SpecialCostForPath(ReachSpec Path)
{
    return NavigationPoint(Path.End.Actor).Cost;
}
public function bool SpecialMoveTo(NavigationPoint Start, NavigationPoint End, Actor Next);

public simulated function StartFire(byte FireModeNum)
{
    if (bNoWeaponFiring)
    {
        return;
    }
    if (InvManager != None)
    {
        InvManager.StartFire(FireModeNum);
    }
}
public simulated function StopFire(byte FireModeNum)
{
    if (InvManager != None)
    {
        InvManager.StopFire(FireModeNum);
    }
}
public function Suicide()
{
    KilledBy(Self);
}
public function TakeDrowningDamage();

public function TakeFallingDamage()
{
    local float EffectiveSpeed;
    
    if (Velocity.Z < -0.5 * MaxFallSpeed)
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            MakeNoise(1.0, );
            if (Velocity.Z < float(-1) * MaxFallSpeed)
            {
                EffectiveSpeed = Velocity.Z;
                if (TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                if (EffectiveSpeed < float(-1) * MaxFallSpeed)
                {
                    TakeDamage(-100.0 * (EffectiveSpeed + MaxFallSpeed) / MaxFallSpeed, None, location, vect(0.0, 0.0, 0.0), Class'DmgType_Fell');
                }
            }
        }
    }
    else if (Velocity.Z < -1.39999998 * JumpZ)
    {
        MakeNoise(0.5, );
    }
    else if (Velocity.Z < -0.800000012 * JumpZ)
    {
        MakeNoise(0.200000003, );
    }
}
public function ThrowActiveWeapon()
{
    if (Weapon != None)
    {
        TossInventory(Weapon);
    }
}
public function ThrowWeaponOnDeath()
{
    ThrowActiveWeapon();
}
public function bool TooCloseToAttack(Actor Other)
{
    return FALSE;
}
public function TossInventory(Inventory Inv, optional Vector ForceVelocity)
{
    local Vector POVLoc;
    local Vector TossVel;
    local Rotator POVRot;
    local Vector X;
    local Vector Y;
    local Vector Z;
    
    if (ForceVelocity != vect(0.0, 0.0, 0.0))
    {
        TossVel = ForceVelocity;
    }
    else
    {
        GetActorEyesViewPoint(POVLoc, POVRot);
        TossVel = Vector(POVRot);
        TossVel = TossVel * (Velocity Dot TossVel + float(500)) + vect(0.0, 0.0, 200.0);
    }
    GetAxes(Rotation, X, Y, Z);
    Inv.DropFrom(location + 0.800000012 * CylinderComponent.CollisionRadius * X - 0.5 * CylinderComponent.CollisionRadius * Y, TossVel);
}
public function bool TouchingWaterVolume()
{
    local PhysicsVolume V;
    
    foreach TouchingActors(Class'PhysicsVolume', V, )
    {
        if (V.bWaterVolume)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function TurnOff()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        RemoteRole = ENetRole.ROLE_SimulatedProxy;
    }
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && Mesh != None)
    {
        Mesh.bPauseAnims = TRUE;
        if (Physics == EPhysics.PHYS_RigidBody)
        {
            Mesh.PhysicsWeight = 1.0;
            Mesh.bUpdateKinematicBonesFromAnimation = FALSE;
        }
    }
    SetCollision(TRUE, FALSE, );
    bNoWeaponFiring = TRUE;
    Velocity = vect(0.0, 0.0, 0.0);
    SetPhysics(0);
    bIgnoreForces = TRUE;
    if (Weapon != None)
    {
        Weapon.StopFire(Weapon.CurrentFireMode);
    }
}
public simulated function UnCrouch()
{
    if (bIsCrouched || bWantsToCrouch)
    {
        ShouldCrouch(FALSE);
    }
}
public function UnPossessed()
{
    bForceNetUpdate = TRUE;
    if (DrivenVehicle != None)
    {
        NetUpdateFrequency = 5.0;
    }
    PlayerReplicationInfo = None;
    SetOwner(None);
    Controller = None;
}
public function UpdateControllerOnPossess(bool bVehicleTransition)
{
    if (!bVehicleTransition)
    {
        Controller.SetRotation(Rotation);
    }
}
public simulated function bool WasPlayerPawn()
{
    return FALSE;
}
public simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
    ShotCount++;
    if (InWeapon != None)
    {
        InWeapon.PlayFireEffects(GetWeaponFiringMode(InWeapon), HitLocation);
    }
}
public simulated function ZeroMovementVariables()
{
    Velocity = vect(0.0, 0.0, 0.0);
    Acceleration = vect(0.0, 0.0, 0.0);
}

state Dying 
{
    ignores HitWall, Falling, PhysicsVolumeChange, Bump, HeadVolumeChange
    ;
    public event function BeginState(Name PreviousStateName)
    {
        local Actor A;
        local array<SequenceEvent> TouchEvents;
        local int i;
        
        if (bTearOff && WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
        {
            LifeSpan = 2.0;
        }
        else
        {
            SetTimer(2.0, FALSE, , );
            LifeSpan = 25.0;
        }
        SetDyingPhysics();
        SetCollision(TRUE, FALSE, );
        if (Controller != None)
        {
            if (Controller.bIsPlayer)
            {
                DetachFromController();
            }
            else
            {
                Controller.Destroy();
            }
        }
        foreach TouchingActors(Class'Actor', A, )
        {
            if (A.FindEventsOfClass(Class'SeqEvent_Touch', TouchEvents))
            {
                for (i = 0; i < TouchEvents.Length; i++)
                {
                    SeqEvent_Touch(TouchEvents[i]).NotifyTouchingPawnDied(Self);
                }
                TouchEvents.Length = 0;
            }
        }
        foreach BasedActors(Class'Actor', A)
        {
            A.PawnBaseDied();
        }
    }
    public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        SetPhysics(2);
        if (Physics == EPhysics.PHYS_None && Momentum.Z < float(0))
        {
            Momentum.Z *= float(-1);
        }
        Velocity += float(3) * Momentum / (Mass + float(200));
        if (DamageType == None)
        {
            DamageType = Class'DamageType';
        }
        Health -= int(Damage);
    }
    public event function Timer()
    {
        if (!PlayerCanSeeMe())
        {
            Destroy();
        }
        else
        {
            SetTimer(2.0, FALSE, , );
        }
    }
    public event singular simulated function OutsideWorldBounds()
    {
        SetPhysics(0);
        SetHidden(TRUE);
        LifeSpan = FMin(LifeSpan, 1.0);
    }
    public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation);
    
    public event function Landed(Vector HitNormal, Actor FloorActor);
    
    public event singular function BaseChange();
    
    public simulated function PlayNextAnimation();
    
    public simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon);
    
    public function FellOutOfWorld(Class<DamageType> dmgType);
    
    public function BreathTimer();
    
    
    stop;
};

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        HitDamageType, TakeHitLocation, PlayerReplicationInfo, DrivenVehicle, InvManager, bIsWalking;
    if (bNetDirty && (bNetOwner || bReplicateHealthToAll))
        Health;
    if (bNetDirty && bNetOwner && Role == ENetRole.ROLE_Authority)
        Controller, GroundSpeed, WaterSpeed, AirSpeed, AccelRate, JumpZ, AirControl;
    if (bNetDirty && bNetOwner && bNetInitial)
        bCanSwatTurn;
    if (bNetDirty && (!bNetOwner || bDemoRecording) && Role == ENetRole.ROLE_Authority)
        FlashCount, FiringMode;
    if (bNetDirty && !bSkipPawnPropertyReplication && (!bNetOwner || bDemoRecording) && Role == ENetRole.ROLE_Authority)
        bIsCrouched;
    if (bNetDirty && !bUseDeltaReplication && (!bNetOwner || bDemoRecording) && Role == ENetRole.ROLE_Authority)
        FlashLocation;
    if (bTearOff && bNetDirty && Role == ENetRole.ROLE_Authority)
        TearOffMomentum;
    if ((!bNetOwner || bDemoRecording) && Role == ENetRole.ROLE_Authority)
        RemoteViewPitch;
    if (bNetInitial && !bNetOwner && Role == ENetRole.ROLE_Authority)
        bRootMotionFromInterpCurve;
    if (bNetInitial && !bNetOwner && Role == ENetRole.ROLE_Authority && bRootMotionFromInterpCurve)
        RootMotionInterpCurveLastValue, RootMotionInterpRate, RootMotionInterpCurrentTime;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 78.0
        CollisionRadius = 34.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockActors = TRUE
    End Object
    ControllerClass = Class'AIController'
    InventoryManagerClass = Class'InventoryManager'
    LandMovementState = 'PlayerWalking'
    WaterMovementState = 'PlayerSwimming'
    MaxStepHeight = 35.0
    MaxJumpHeight = 96.0
    WalkableFloorZ = 0.699999988
    LedgeCheckThreshold = 4.0
    CrouchHeight = 40.0
    CrouchRadius = 34.0
    NonPreferredVehiclePathMultiplier = 1.0
    DesiredSpeed = 1.0
    MaxDesiredSpeed = 1.0
    HearingThreshold = 2800.0
    SightRadius = 5000.0
    AvgPhysicsTime = 0.100000001
    Mass = 100.0
    MaxPitchLimit = 3072
    GroundSpeed = 600.0
    WaterSpeed = 300.0
    AirSpeed = 600.0
    LadderSpeed = 200.0
    AccelRate = 2048.0
    JumpZ = 420.0
    OutofWaterZ = 420.0
    MaxOutOfWaterStepHeight = 40.0
    AirControl = 0.0500000007
    WalkingPct = 0.5
    CrouchedPct = 0.5
    MaxFallSpeed = 1200.0
    AIMaxFallSpeedFactor = 1.0
    BaseEyeHeight = 64.0
    EyeHeight = 54.0
    Health = 100
    noise1time = -10.0
    noise2time = -10.0
    SoundDampening = 1.0
    DamageScaling = 1.0
    CylinderComponent = CollisionCylinder
    RBPushRadius = 10.0
    RBPushStrength = 50.0
    VehicleCheckRadius = 150.0
    ViewPitchMin = -16384.0
    ViewPitchMax = 16383.0
    AllowedYawError = 2000
    RootMotionInterpRate = 1.0
    bJumpCapable = TRUE
    bCanJump = TRUE
    bCanWalk = TRUE
    bAllowLedgeOverhang = TRUE
    bSimulateGravity = TRUE
    bDisplayPathErrors = TRUE
    bLOSHearing = TRUE
    bCanUse = TRUE
    bLimitFallAccel = TRUE
    bReplicateHealthToAll = TRUE
    Components = (None, CollisionCylinder, None)
    RotationRate = {Pitch = 20000, Yaw = 20000, Roll = 20000}
    NetPriority = 2.0
    CollisionComponent = CollisionCylinder
    bUpdateSimulatedPosition = TRUE
    bCanBeDamaged = TRUE
    bShouldBaseAtStartup = TRUE
    bCanTeleport = TRUE
    bCollideActors = TRUE
    bCollideWorld = TRUE
    bBlockActors = TRUE
    bProjTarget = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}
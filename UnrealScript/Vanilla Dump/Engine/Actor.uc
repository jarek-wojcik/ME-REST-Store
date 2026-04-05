Class Actor
    native
    nativereplication
    abstract;

enum EPowerResistance
{
    Resistance_Full,
    Resistance_Partial,
    Resistance_None,
};
struct native BasedPosition 
{
    var(BasedPosition) Vector Position;
    var Vector CachedBaseLocation;
    var Rotator CachedBaseRotation;
    var Vector CachedTransPosition;
    var(BasedPosition) Actor Base;
};
struct native immutablewhencooked NavReference 
{
    var(NavReference) const editconst Guid Guid;
    var(NavReference) NavigationPoint Nav;
};
struct native immutablewhencooked ActorReference 
{
    var(ActorReference) const editconst Guid Guid;
    var(ActorReference) Actor Actor;
};
enum EDoubleClickDir
{
    DCLICK_None,
    DCLICK_Left,
    DCLICK_Right,
    DCLICK_Forward,
    DCLICK_Back,
    DCLICK_Active,
    DCLICK_Done,
};
enum ETravelType
{
    TRAVEL_Absolute,
    TRAVEL_Partial,
    TRAVEL_Relative,
};
struct native PhysEffectInfo 
{
    var(PhysEffectInfo) float Threshold;
    var(PhysEffectInfo) float ReFireDelay;
    var(PhysEffectInfo) ParticleSystem Effect;
    var(PhysEffectInfo) SoundCue Sound;
};
struct native ReplicatedHitImpulse 
{
    var Vector AppliedImpulse;
    var Vector HitLocation;
    var Name BoneName;
    var bool bRadialImpulse;
    var byte ImpulseCount;
};
struct CollisionImpactData 
{
    var array<RigidBodyContactInfo> ContactInfos;
    var Vector TotalNormalForceVector;
    var Vector TotalFrictionForceVector;
};
struct RigidBodyContactInfo 
{
    var Vector ContactPosition;
    var Vector ContactNormal;
    var float ContactPenetration;
    var Vector ContactVelocity[2];
    var PhysicalMaterial PhysMaterial[2];
};
const RB_Sleeping = 0x02;
const RB_NeedsUpdate = 0x01;
const RB_None = 0x00;
struct RigidBodyState 
{
    var Vector Position;
    var Quat Quaternion;
    var Vector LinVel;
    var Vector AngVel;
    var byte bNewData;
};
const RBSTATE_ANGVELSCALE = 1000.0;
const RBSTATE_LINVELSCALE = 10.0;
const ACTORMAXSTEPHEIGHT = 35.0;
const MINFLOORZ = 0.7;
enum ECollisionType
{
    COLLIDE_CustomDefault,
    COLLIDE_NoCollision,
    COLLIDE_BlockAll,
    COLLIDE_BlockWeapons,
    COLLIDE_TouchAll,
    COLLIDE_TouchWeapons,
    COLLIDE_BlockAllButWeapons,
    COLLIDE_TouchAllButWeapons,
    COLLIDE_WaterSurface,
    COLLIDE_BlockWeaponsKickable,
};
struct native transient AnimSlotDesc 
{
    var init Name SlotName;
    var init int NumChannels;
};
struct native transient AnimSlotInfo 
{
    var init array<float> ChannelWeights;
    var init Name SlotName;
};
struct native transient ImpactInfo 
{
    var editinline init TraceHitInfo HitInfo;
    var init Vector HitLocation;
    var init Vector HitNormal;
    var init Vector RayDir;
    var init Vector StartTrace;
    var init Actor HitActor;
    var init float PenetrationDepth;
};
struct native transient TraceHitInfo 
{
    var init Name BoneName;
    var init Material Material;
    var init PhysicalMaterial PhysMaterial;
    var init int Item;
    var init int LevelIndex;
    var editinline export init PrimitiveComponent HitComponent;
};
struct native TimerData 
{
    var Name FuncName;
    var float Rate;
    var float Count;
    var float TimerTimeDilation;
    var Object TimerObj;
    var bool bLoop;
    var bool bPaused;
    
    structdefaultproperties
    {
        TimerTimeDilation = 1.0
    }
};
enum EMoveDir
{
    MD_Stationary,
    MD_Forward,
    MD_Backward,
    MD_Left,
    MD_Right,
    MD_Up,
    MD_Down,
};
enum EPhysics
{
    PHYS_None,
    PHYS_Walking,
    PHYS_Falling,
    PHYS_Swimming,
    PHYS_Flying,
    PHYS_Rotating,
    PHYS_Projectile,
    PHYS_Interpolating,
    PHYS_Spider,
    PHYS_Ladder,
    PHYS_RigidBody,
    PHYS_SoftBody,
    PHYS_NavMeshWalking,
    PHYS_PathApproximation,
    PHYS_Unused,
    PHYS_Custom,
};
struct native SFXTextureRefCount 
{
    var Texture2D Texture;
    var int RefCount;
};
const REP_RBLOCATION_ERROR_TOLERANCE_SQ = 16.0f;
const TRACEFLAG_Blocking = 8;
const TRACEFLAG_SkipMovers = 4;
const TRACEFLAG_PhysicsVolumes = 2;
const TRACEFLAG_Bullet = 1;

var const editinline export array<ActorComponent> Components;
var(Actor) export clearcrosslevel array<SFXModule> Modules;
var const editinline transient export array<ActorComponent> AllComponents;
var transient array<SFXTextureRefCount> PrimedTextures;
var const array<TimerData> Timers;
var const transient array<Actor> Touching;
var const transient array<Actor> Children;
var const array<Actor> Attached;
var const array<SequenceEvent> GeneratedEvents;
var array<SeqAct_Latent> LatentActions;
var Class<LocalMessage> MessageClass;
var(Movement) const Vector location;
var(Movement) const Rotator Rotation;
var(Display) const interp Vector DrawScale3D;
var(Display) const Vector PrePivot;
var Vector Velocity;
var Vector Acceleration;
var const transient Vector AngularVelocity;
var const Vector RelativeLocation;
var const Rotator RelativeRotation;
var(Movement) Rotator RotationRate;
var(Object) Name Tag;
var(Object) Name UniqueTag;
var Name InitialState;
var(Object) Name Group;
var(Attachment) Name BaseBoneName;
var const transient int NextModuleNetIndex;
var(Display) const interp float DrawScale;
var const native RenderCommandFence DetachFence;
var float CustomTimeDilation;
var const Actor Owner;
var(Attachment) const Actor Base;
var const transient int NetTag;
var const float NetUpdateTime;
var float NetUpdateFrequency;
var float NetPriority;
var const transient float LastNetUpdateTime;
var float TimeSinceLastTick;
var float TickFrequency;
var(Advanced) float TickFrequencyAtEndDistance;
var float TickFrequencyDecreaseDistanceStart;
var float TickFrequencyDecreaseDistanceEnd;
var float TickFrequencyLastSeenTimeBeforeForcingMaxTickFrequency;
var Pawn Instigator;
var const transient WorldInfo WorldInfo;
var float LifeSpan;
var const float CreationTime;
var transient float LastRenderTime;
var const float LatentFloat;
var const AnimNodeSequence LatentSeqNode;
var const transient PhysicsVolume PhysicsVolume;
var(Attachment) editinline export SkeletalMeshComponent BaseSkelComponent;
var(Collision) editinline editconst export PrimitiveComponent CollisionComponent;
var native int OverlapTag;
var Actor PendingTouch;
var float m_fGravityScaling;
var(Physics) float DensityScaling;
var const transient int ActorTickBreakGroup;
var(Physics) float m_fPhysicsThreshold;
var(Audio) float AudioObstruction;
var(Audio) float AudioOcclusion;
var const bool bStatic;
var(Display) const bool bHidden;
var const bool bNoDelete;
var const bool bDeleteMe;
var const transient bool bTicked;
var const bool bOnlyOwnerSee;
var const bool bTickIsDisabled;
var bool bWorldGeometry;
var bool bIgnoreRigidBodyPawns;
var bool bOrientOnSlope;
var const bool bIgnoreEncroachers;
var bool bPushedByEncroachers;
var bool bDestroyedByInterpActor;
var const bool bRouteBeginPlayEvenIfStatic;
var const bool bIsMoving;
var bool bAlwaysEncroachCheck;
var bool bHasAlternateTargetLocation;
var(Collision) bool bCanStepUpOn;
var const bool bNetTemporary;
var const bool bOnlyRelevantToOwner;
var transient bool bNetDirty;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var bool bTearOff;
var bool bOnlyDirtyReplication;
var bool bDontReplicateBaseRotation;
var(Physics) bool bAllowFluidSurfaceInteraction;
var transient bool bDemoRecording;
var bool bDemoOwner;
var bool bForceDemoRelevant;
var const bool bNetInitialRotation;
var bool bReplicateRigidBodyLocation;
var bool bKillDuringLevelTransition;
var const bool bExchangedRoles;
var(Advanced) bool bConsiderAllStaticMeshComponentsForStreaming;
var(Debug) bool bDebug;
var bool bPostRenderIfNotVisible;
var transient bool bForceNetUpdate;
var const transient bool bPendingNetUpdate;
var(Attachment) const bool bHardAttach;
var(Attachment) bool bIgnoreBaseRotation;
var(Attachment) bool bShadowParented;
var bool bCanBeAdheredTo;
var bool bCanBeFrictionedTo;
var(Attachment) bool bBioSnapToBase;
var bool m_bBioBoneDependsOnBaseSkel;
var bool bHurtEntry;
var bool bGameRelevant;
var const bool bMovable;
var bool bDestroyInPainVolume;
var bool bCanBeDamaged;
var bool bShouldBaseAtStartup;
var bool bPendingDelete;
var bool bCanTeleport;
var const bool bAlwaysTick;
var(Navigation) bool bBlocksNavigation;
var(Collision) const transient bool BlockRigidBody;
var bool bCollideWhenPlacing;
var const bool bCollideActors;
var bool bCollideWorld;
var(Collision) bool bCollideComplex;
var bool bBlockActors;
var bool bProjTarget;
var bool bBlocksTeleport;
var bool bMoveIgnoresDestruction;
var(Collision) bool bNoEncroachCheck;
var bool bCollideAsEncroacher;
var(Collision) bool bPhysRigidBodyOutOfWorldCheck;
var const transient bool bComponentOutsideWorld;
var const transient bool bRigidBodyWasAwake;
var bool bCallRigidBodyWakeEvents;
var bool bBounce;
var const bool bJustTeleported;
var transient bool bLevelStreamingStasisApplied;
var const bool bNetInitial;
var const bool bNetOwner;
var(Advanced) const bool bHiddenEd;
var(Advanced) const bool bHiddenEdGroup;
var const bool bHiddenEdCustom;
var(Advanced) bool bEdShouldSnap;
var const transient bool bTempEditor;
var(Collision) bool bPathColliding;
var transient bool bPathTemp;
var bool bScriptInitialized;
var(Advanced) bool bLockLocation;
var const bool bForceAllowKismetModification;
var bool bTickDuringPlayersOnly;
var bool bNoTick;
var(Actor) bool m_bWasInVehicleTransition;
var const bool m_bAlwaysCollide;
var(Audio) bool OverridePhysMat;
var(Movement) const EPhysics Physics;
var ENetRole RemoteRole;
var ENetRole Role;
var(Collision) const transient ECollisionType CollisionType;
var transient ECollisionType ReplicatedCollisionType;
var const ETickingGroup TickGroup;

public native function AddSFXModule(SFXModule oModule, optional bool bUserModule = FALSE);

public final iterator native(304) function AllActors(Class<Actor> BaseClass, out Actor Actor, optional Class<Interface> InterfaceClass);

public final iterator native function AllOwnedComponents(Class<Component> BaseClass, out ActorComponent OutComponent);

public event simulated function AnimTreeUpdated(SkeletalMeshComponent SkelMesh);

public event function Attach(Actor Other);

public final native function AttachComponent(ActorComponent NewComponent);

public final native(3971) function AutonomousPhysics(float DeltaSeconds);

public event function BaseChange();

public final iterator native(306) function BasedActors(Class<Actor> BaseClass, out Actor Actor);

public event function BecomeViewTarget(PlayerController PC);

public event function BeginAnimControl(InterpGroup InInterpGroup);

public event function BeginMovementControl(InterpGroup InInterpGroup)
{
    BioRestoreFromStasis();
}
public final native function BioApplyStasis(string Cause);

public event simulated function BioBaseRemovedFromWorld();

public event function BioDoKismetAttachment(Actor InAttachment, bool bInDetach, bool bInHardAttach, Name InBoneName, bool bInUseRelativeOffset, Vector InRelativeOffset, bool bInUseRelativeRotation, Rotator InRelativeRotation)
{
    local SeqAct_AttachToActor Seq;
    
    Seq = new (Outer) Class'SeqAct_AttachToActor';
    Seq.bDetach = bInDetach;
    Seq.bHardAttach = bInHardAttach;
    Seq.BoneName = InBoneName;
    Seq.bUseRelativeOffset = bInUseRelativeOffset;
    Seq.RelativeOffset = InRelativeOffset;
    Seq.bUseRelativeRotation = bInUseRelativeRotation;
    Seq.RelativeRotation = InRelativeRotation;
    DoKismetAttachment(InAttachment, Seq);
}
public final native function BioEnqueueDoKismetAttachment(Actor InAttachment, bool bInDetach, bool bInHardAttach, Name InBoneName, bool bInUseRelativeOffset, Vector InRelativeOffset, bool bInUseRelativeRotation, Rotator InRelativeRotation);

public final native function BioRestoreFromStasis();

public final native function BlockForTextureStreaming();

public static final native function Vector BP2Vect(BasedPosition BP);

public event function BroadcastLocalizedMessage(Class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    WorldInfo.Game.BroadcastLocalized(Self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public event function BroadcastLocalizedTeamMessage(int TeamIndex, Class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    WorldInfo.Game.BroadcastLocalizedTeam(TeamIndex, Self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public event function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal);

public final native function ChartData(string DataName, float DataValue);

public final iterator native(305) function ChildActors(Class<Actor> BaseClass, out Actor Actor);

public final simulated native function bool ClampRotation(out Rotator out_Rot, Rotator rBase, Rotator rUpperLimits, Rotator rLowerLimits);

public final native function ClearAllTimers(optional Object inObj);

public final native function ClearTimer(optional Name inTimerFunc = 'Timer', optional Object inObj);

public final native function Clock(out float Time);

public final iterator native(321) function CollidingActors(Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bUseOverlapCheck, optional Class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo);

public event function CollisionChanged();

public final iterator native function ComponentList(Class<ActorComponent> BaseClass, out ActorComponent out_Component);

public native function string ConsoleCommand(string Command, optional bool bWriteToLog = TRUE);

public event simulated function ConstraintBrokenNotify(Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance);

public final native function bool ContainsPoint(Vector Spot);

public final native function AudioComponent CreateAudioComponent(SoundCue InSoundCue, optional bool bPlay, optional bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation, optional bool bAttachToSelf = TRUE);

public event function DebugFreezeGame(optional Actor ActorToLookAt);

public final native(279) function bool Destroy();

public event function Destroyed();

public event function Detach(Actor Other);

public final native function DetachComponent(ActorComponent ExComponent);

public static final native function DrawDebugBox(Vector Center, Vector Extent, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugCone(Vector Origin, Vector Direction, float Length, float AngleWidth, float AngleHeight, int NumSides, Color DrawColor, optional bool bPersistentLines);

public static final native function DrawDebugCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines);

public static final native function DrawDebugCylinder(Vector Start, Vector End, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugFrustrum(const out Matrix FrustumToWorld, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugPoint(Vector Position, float Size, LinearColor PointColor, optional bool bPersistentLines);

public static final native function DrawDebugSphere(Vector Center, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugStar(Vector Position, float Size, byte R, byte G, byte B, optional bool bPersistentLines);

public static final native function DrawDebugString(Vector TextLocation, coerce string Text, optional Actor TestBaseActor, optional Color TextColor, optional float Duration = -1.0);

public final iterator native(313) function DynamicActors(Class<Actor> BaseClass, out Actor Actor, optional Class<Interface> InterfaceClass);

public event function EncroachedBy(Actor Other);

public event function bool EncroachingOn(Actor Other);

public event function EndViewTarget(PlayerController PC);

public event function ExceededPhysicsThreshold(Actor instigatedBy);

public event function Falling();

public final native(548) function bool FastTrace(Vector TraceEnd, optional Vector TraceStart, optional Vector BoxExtent, optional bool bTraceBullet);

public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    SetPhysics(0);
    SetHidden(TRUE);
    SetCollision(FALSE, FALSE, );
    Destroy();
}
public native function FindBase();

public final simulated function bool FindEventsOfClass(Class<SequenceEvent> EventClass, optional out array<SequenceEvent> out_EventList, optional bool bIncludeDisabled)
{
    local SequenceEvent Evt;
    local bool bFoundEvent;
    
    foreach GeneratedEvents(Evt, )
    {
        if (Evt != None && (Evt.bEnabled || bIncludeDisabled) && ClassIsChildOf(Evt.Class, EventClass) && (Evt.MaxTriggerCount == 0 || Evt.MaxTriggerCount > Evt.TriggerCount))
        {
            out_EventList.AddItem(Evt);
            bFoundEvent = TRUE;
        }
    }
    return bFoundEvent;
}
public final native function bool FindSpot(Vector BoxExtent, out Vector SpotLocation);

public final latent native(261) function FinishAnim(AnimNodeSequence SeqNode);

public event function FinishAnimControl(InterpGroup InInterpGroup);

public event function FinishMovementControl(InterpGroup InInterpGroup);

public final native function int fixedTurn(int Current, int Desired, int DeltaRate);

public static final native function FlushDebugStrings();

public static final native function FlushPersistentDebugLines();

public event function ForceNetRelevant()
{
    if (RemoteRole == ENetRole.ROLE_None && bNoDelete && !bStatic)
    {
        RemoteRole = ENetRole.ROLE_SimulatedProxy;
        bAlwaysRelevant = TRUE;
        NetUpdateFrequency = 0.100000001;
    }
    bForceNetUpdate = TRUE;
}
public native function ForceUpdateComponents(optional bool bCollisionUpdate = FALSE, optional bool bTransformOnly = TRUE);

public event function GainedChild(Actor Other);

public event simulated function GetActorEyesViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    out_Location = location;
    out_rotation = Rotation;
}
public event function FaceFXAsset GetActorFaceFXAsset();

public final native function PlayerController GetALocalPlayerController();

public final native function Vector GetAvoidanceVector(const out array<Actor> Obstacles, Vector GoalLocation, float CollisionRadius, float MaxSpeed, optional int NumSamples = 8, optional float VelocityStepRate = 0.100000001, optional float MaxTimeTilOverlap = 1.0);

public static final native function Vector GetBasedPosition(BasedPosition BP);

public native function Actor GetBaseMost();

public native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

public final native function GetComponentsBoundingBox(out Box ActorBox);

public final native function Vector GetDestination(Controller C);

public event simulated function AudioComponent GetFaceFXAudioComponent()
{
    return None;
}
public native function float GetGravityZ();

public native function SkeletalMeshComponent GetHeadSkelMeshComponent();

public final native function coerce SFXModule GetModule(Class<SFXModule> ModuleClass);

public static final native function Guid GetPackageGuid(Name PackageName);

public native function SkeletalMeshComponent GetPrimarySkelMeshComponent();

public simulated native function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

public simulated native function byte GetTeamNum();

public native function float GetTerminalVelocity();

public final native function float GetTimerCount(optional Name inTimerFunc = 'Timer', optional Object inObj);

public final native function float GetTimerRate(optional Name TimerFuncName = 'Timer', optional Object inObj);

public final native(547) function string GetURLMap();

public event function bool HealDamage(int Amount, Controller Healer, Class<DamageType> DamageType);

public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    TriggerEventClass(Class'SeqEvent_HitWall', Wall);
}
public event simulated function InterpolationChanged(SeqAct_Interp InterpAction);

public event simulated function InterpolationFinished(SeqAct_Interp InterpAction);

public event simulated function InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst);

public final native function bool IsBasedOn(Actor TestActor);

public final simulated function bool IsClient()
{
    return WorldInfo.NetMode != ENetMode.NM_DedicatedServer;
}
public final native function bool IsInPersistentLevel();

public final native function bool IsOverlapping(Actor A);

public final native function bool IsOwnedBy(Actor TestActor);

public simulated native function bool IsPlayerOwned();

public final simulated function bool IsServer()
{
    return WorldInfo.NetMode != ENetMode.NM_Client;
}
public final native function bool IsTimerActive(optional Name inTimerFunc = 'Timer', optional Object inObj);

public function KilledBy(Pawn EventInstigator);

public event function Landed(Vector HitNormal, Actor FloorActor);

public final iterator native function LocalPlayerControllers(Class<PlayerController> BaseClass, out PlayerController PC);

public final native function Vector LocalToWorld(Vector vLocal);

public event function LostChild(Actor Other);

public final native(512) function MakeNoise(float Loudness, optional Name NoiseType);

public event simulated function ModifyHearSoundComponent(AudioComponent AC);

public final native function ModifyTimerTimeDilation(const Name TimerName, const float InTimerTimeDilation, optional Object inObj);

public final native(266) function bool Move(Vector Delta);

public final native function bool MoveActorToFloor();

public final native(3969) function bool MoveSmooth(Vector Delta);

public native function EMoveDir MovingWhichWay(out float Amount);

public simulated native function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir);

public event simulated function NotifySkelControlBeyondLimit(SkelControlLookAt LookAt);

public event function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime);

public event function OnAnimPlay(AnimNodeSequence SeqNode);

public event function OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex);

public event simulated function OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance);

public event function OnSleepRBPhysics();

public event function OnWakeRBPhysics();

public event simulated function OutsideWorldBounds()
{
    Destroy();
}
public final iterator native function OverlappingActors(Class<Actor> BaseClass, out Actor out_Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

public event simulated function bool OverRotated(out Rotator out_Desired, out Rotator out_Actual);

public final native function PauseTimer(bool bPause, optional Name inTimerFunc = 'Timer', optional Object inObj);

public event function PhysicsVolumeChange(PhysicsVolume NewVolume);

public event function bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay);

public final native(532) function bool PlayerCanSeeMe();

public event function PlayFootStepSound(int FootDown);

public event function PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData);

public final native function PlaySound(WwiseBaseSoundObject InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation, optional bool bNoRepToRelevant);

public final native function bool PointCheckComponent(PrimitiveComponent InComponent, Vector PointLocation, Vector PointExtent);

public event function PostBeginPlay();

public event simulated function PostDemoRewind();

public event function PostInitAnimTree(SkeletalMeshComponent SkelComp);

public event simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir);

public event function PostTouch(Actor Other);

public event function PreBeginPlay()
{
    if (!bGameRelevant && !bStatic && WorldInfo.NetMode != ENetMode.NM_Client && !WorldInfo.Game.CheckRelevance(Self))
    {
        if (bNoDelete)
        {
            ShutDown();
        }
        else
        {
            Destroy();
        }
    }
}
public native function PrestreamTextures(float Seconds, bool bEnableStreaming, optional int CinematicTextureGroups = 0);

public event function RanInto(Actor Other);

public final native function ReattachComponent(ActorComponent ComponentToReattach);

public event simulated function ReceivedNewEvent(SequenceEvent Evt);

public native function RemoveSFXModule(SFXModule oModule);

public native function RemoveSFXModuleIndex(int nIndex);

public event simulated function ReplicatedDataBinding(Name VarName);

public event simulated function ReplicatedEvent(Name VarName);

public event simulated function ReplicationEnded();

public event function Reset();

public final native function ResetTimerTimeDilation(const Name TimerName, optional Object inObj);

public event function RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex);

public event simulated function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta);

public event simulated function RootMotionModeChanged(SkeletalMeshComponent SkelComp);

public event simulated function byte ScriptGetTeamNum()
{
    return 255;
}
public native function SetActive(bool bActive);

public event function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping);

public final native(298) function SetBase(Actor NewBase, optional Vector NewFloor, optional SkeletalMeshComponent SkelComp, optional Name AttachName);

public static final native function SetBasedPosition(out BasedPosition BP, Vector pos, optional Actor ForcedBase);

public final native(262) function SetCollision(optional bool bNewColActors, optional bool bNewBlockActors, optional bool bNewIgnoreEncroachers);

public final native(283) function SetCollisionSize(float NewRadius, float NewHeight);

public final native function SetCollisionType(ECollisionType NewCollisionType);

public final native function SetDrawScale(float NewScale);

public final native function SetDrawScale3D(Vector NewScale3D);

public final native function SetForcedInitialReplicatedProperty(Property PropToReplicate, bool bAdd);

public final native function SetHardAttach(optional bool bNewHardAttach);

public final native function SetHidden(bool bNewHidden);

public simulated native function SetHUDLocation(Vector NewHUDLocation);

public event simulated function SetInitialState()
{
    bScriptInitialized = TRUE;
    if (InitialState != 'None')
    {
        GotoState(InitialState, , , );
    }
    else
    {
        GotoState('Auto', , , );
    }
}
public final native(267) function bool SetLocation(Vector NewLocation, optional bool bDebugFailure = FALSE);

public event function SetMorphWeight(Name MorphNodeName, float MorphWeight);

public final native function SetNetUpdateTime(float NewUpdateTime);

public final native function SetOnlyOwnerSee(bool bNewOnlyOwnerSee);

public final native(272) function SetOwner(Actor NewOwner);

public final native(3970) function SetPhysics(EPhysics newPhysics);

public final native function bool SetRelativeLocation(Vector NewLocation);

public final native function bool SetRelativeRotation(Rotator NewRotation);

public final native(299) function bool SetRotation(Rotator NewRotation);

public event function SetSkelControlScale(Name SkelControlName, float Scale);

public final native function SetTickGroup(ETickingGroup NewTickGroup);

public final native function SetTickIsDisabled(bool bInDisabled);

public final native(280) function SetTimer(float InRate, optional bool inbLoop, optional Name inTimerFunc = 'Timer', optional Object inObj);

public final native function SetZone(bool bForceRefresh);

public event function SFXSetAudioComponentRTPCs(ActorComponent pWwiseAudioComponent);

public event simulated function ShutDown()
{
    SetPhysics(0);
    SetCollision(FALSE, FALSE, );
    if (CollisionComponent != None)
    {
        CollisionComponent.SetBlockRigidBody(FALSE);
    }
    SetHidden(TRUE);
    SetTickIsDisabled(TRUE);
    ForceNetRelevant();
    if (RemoteRole != ENetRole.ROLE_None)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'bCollideActors', bCollideActors == default.bCollideActors);
        SetForcedInitialReplicatedProperty(BoolProperty'bBlockActors', bBlockActors == default.bBlockActors);
        SetForcedInitialReplicatedProperty(BoolProperty'bHidden', bHidden == default.bHidden);
    }
    NetUpdateFrequency = 0.100000001;
    bForceNetUpdate = TRUE;
    ForceUpdateComponents(FALSE, FALSE);
}
public final latent native(256) function Sleep(float Seconds);

public final native function coerce Actor Spawn(Class<Actor> SpawnClass, optional Actor SpawnOwner, optional Name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail, optional bool bFindSafeLocation);

public event function SpawnedByKismet();

public event function Actor SpecialHandling(Pawn Other);

public event function StopActorFaceFXAnim();

public final native function StopAllSounds();

public final native function StopSound(WwiseBaseSoundObject InSoundEvent);

public final native function bool SuggestTossVelocity(out Vector TossVelocity, Vector Destination, Vector Start, float TossSpeed, optional float BaseTossZ, optional float DesiredZPct, optional Vector CollisionSize, optional float TerminalVelocity, optional float OverrideGravityZ, optional bool bOnlyTraceUp);

public final native function bool SupportsKismetModification(SequenceOp AskingOp, out string Reason);

public event simulated function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int idx;
    local SeqEvent_TakeDamage dmgEvent;
    local SFXModule_DamageBase DmgModule;
    
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        dmgEvent = SeqEvent_TakeDamage(GeneratedEvents[idx]);
        if (dmgEvent != None)
        {
            dmgEvent.HandleDamage(Self, EventInstigator, DamageType, DamageAmount, HitLocation, DamageCauser);
        }
    }
    DmgModule = GetModule(Class'SFXModule_DamageBase');
    if (DmgModule != None)
    {
        DmgModule.SFXTakeDamage(DamageAmount, HitInfo, HitLocation, Momentum, DamageType, EventInstigator, DamageCauser);
    }
}
public event simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    local float ColRadius;
    local float ColHeight;
    local float DamageScale;
    local float Dist;
    local float ScaledDamage;
    local Vector Dir;
    local SFXModule_DamageBase DmgModule;
    
    DmgModule = GetModule(Class'SFXModule_DamageBase');
    if (DmgModule != None)
    {
        DmgModule.SFXTakeRadiusDamage(BaseDamage, DamageRadius, bFullDamage, HurtOrigin, Momentum, DamageType, instigatedBy, DamageCauser, HitInfo);
        return;
    }
    GetBoundingCylinder(ColRadius, ColHeight);
    Dir = location - HurtOrigin;
    Dist = VSize(Dir);
    Dir = Normal(Dir);
    if (bFullDamage)
    {
        DamageScale = 1.0;
    }
    else
    {
        Dist = FMax(Dist - ColRadius, 0.0);
        DamageScale = FClamp(1.0 - Dist / DamageRadius, 0.0, 1.0);
        DamageScale = DamageScale ** DamageFalloffExponent;
    }
    if (DamageScale > 0.0)
    {
        ScaledDamage = DamageScale * BaseDamage;
        TakeDamage(ScaledDamage, instigatedBy, location - 0.5 * (ColHeight + ColRadius) * Dir, DamageScale * Momentum * Dir, DamageType, , DamageCauser);
    }
}
public final native function bool TexturePrestreamIsRequired();

public event function Tick(float DeltaTime);

public event function Timer();

public event function TornOff();

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal);

public final iterator native(307) function TouchingActors(Class<Actor> BaseClass, out Actor Actor, optional bool bReverse = FALSE);

public final native(277) function Actor Trace(out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags);

public final iterator native(309) function TraceActors(Class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags);

public final native function bool TraceAllPhysicsAssetInteractions(SkeletalMeshComponent SkelMeshComp, Vector EndTrace, Vector StartTrace, out array<ImpactInfo> out_Hits, optional Vector Extent);

public final native function bool TraceComponent(out Vector HitLocation, out Vector HitNormal, PrimitiveComponent InComponent, Vector TraceEnd, optional Vector TraceStart, optional Vector Extent, optional out TraceHitInfo HitInfo, optional bool bComplexCollision);

public event function TrailsNotify(const AnimNotify_Trails AnimNotifyData);

public event function TrailsNotifyEnd(const AnimNotify_Trails AnimNotifyData);

public event function TrailsNotifyTick(const AnimNotify_Trails AnimNotifyData);

public final native function UnClock(out float Time);

public event function UnTouch(Actor Other);

public static final native function Vect2BP(out BasedPosition BP, Vector pos, optional Actor ForcedBase);

public final iterator native(311) function VisibleActors(Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

public final iterator native(312) function VisibleCollidingActors(Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden, optional Vector Extent, optional bool bTraceActors, optional Class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo);

public final native function bool WillOverlap(Vector PosA, Vector VelA, Vector PosB, Vector VelB, float StepSize, float Radius, out float Time);

public simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
    local float Radius;
    local float Height;
    local float AdjustedVelocity;
    
    if (bAllowFluidSurfaceInteraction)
    {
        AdjustedVelocity = 0.00999999978 * Abs(Velocity.Z);
        GetBoundingCylinder(Radius, Height);
        Fluid.FluidComponent.ApplyForce(HitLocation, AdjustedVelocity * Fluid.FluidComponent.ForceImpact, Radius * 0.300000012, TRUE);
    }
}
public simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector HitNormal;
    local float Radius;
    local float Height;
    
    GetBoundingCylinder(Radius, Height);
    if (Trace(out_CamLoc, HitNormal, location - Vector(out_CamRot) * Radius * float(20), location, FALSE, , , ) == None)
    {
        out_CamLoc = location - Vector(out_CamRot) * Radius * float(20);
    }
    else
    {
        out_CamLoc = location + Height * Vector(Rotation);
    }
    return FALSE;
}
public simulated function bool CanActorPlayFaceFXAnim()
{
    return TRUE;
}
public simulated function bool CanSplash()
{
    return FALSE;
}
public function bool CheckForErrors();

public simulated function bool CheckMaxEffectDistance(PlayerController P, Vector SpawnLocation, optional float CullDistance)
{
    local float Dist;
    
    if (P.ViewTarget == None)
    {
        return TRUE;
    }
    if (Vector(P.Rotation) Dot (SpawnLocation - P.ViewTarget.location) < 0.0)
    {
        return VSize(P.ViewTarget.location - SpawnLocation) < float(1600);
    }
    Dist = VSize(SpawnLocation - P.ViewTarget.location);
    if (CullDistance > 0.0 && CullDistance < Dist * P.LODDistanceFactor)
    {
        return FALSE;
    }
    return !P.BeyondFogDistance(P.ViewTarget.location, SpawnLocation);
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Actor A;
    local float MyRadius;
    local float MyHeight;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.SetDrawColor(255, 0, 0);
    T = GetDebugName();
    if (bDeleteMe)
    {
        T = T $ " DELETED (bDeleteMe == true)";
    }
    if (T != "")
    {
        Canvas.DrawText(T, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    Canvas.SetDrawColor(255, 255, 255);
    if (HUD.ShouldDisplayDebug('net'))
    {
        if (WorldInfo.NetMode != ENetMode.NM_Standalone)
        {
            T = "ROLE:" @ Role @ "RemoteRole:" @ RemoteRole @ "NetMode:" @ WorldInfo.NetMode;
            if (bTearOff)
            {
                T = T @ "Tear Off";
            }
            Canvas.DrawText(T, FALSE);
            out_YPos += out_YL;
            Canvas.SetPos(4.0, out_YPos);
        }
    }
    Canvas.DrawText("Location:" @ location @ "Rotation:" @ Rotation, FALSE);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('Physics'))
    {
        T = "Physics" @ GetPhysicsName() @ "in physicsvolume" @ GetItemName(string(PhysicsVolume)) @ "on base" @ GetItemName(string(Base)) @ "gravity" @ GetGravityZ();
        if (bBounce)
        {
            T = T $ " - will bounce";
        }
        Canvas.DrawText(T, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("bHardAttach:" @ bHardAttach @ "RelativeLoc:" @ RelativeLocation @ "RelativeRot:" @ RelativeRotation @ "SkelComp:" @ BaseSkelComponent @ "Bone:" @ BaseBoneName, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Velocity:" @ Velocity @ "Speed:" @ VSize(Velocity) @ "Speed2D:" @ VSize2D(Velocity), FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Acceleration:" @ Acceleration, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    if (HUD.ShouldDisplayDebug('Collision'))
    {
        Canvas.DrawColor.B = 0;
        GetBoundingCylinder(MyRadius, MyHeight);
        Canvas.DrawText("Collision Radius:" @ MyRadius @ "Height:" @ MyHeight);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Collides with Actors:" @ bCollideActors @ " world:" @ bCollideWorld @ "proj. target:" @ bProjTarget);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("Blocks Actors:" @ bBlockActors);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        T = "Touching ";
        foreach TouchingActors(Class'Actor', A, )
        {
            T = T $ GetItemName(string(A)) $ " ";
        }
        if (T == "Touching ")
        {
            T = "Touching nothing";
        }
        Canvas.DrawText(T, FALSE);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
    Canvas.DrawColor.B = 255;
    Canvas.DrawText(" STATE:" @ GetStateName(), FALSE);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText(" Instigator:" @ GetItemName(string(Instigator)) @ "Owner:" @ GetItemName(string(Owner)));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
}
public function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors;
    local bool bOldBlockActors;
    local Vector X;
    local Vector Y;
    local Vector Z;
    
    Attachment.SetBase(None, , , );
    Attachment.SetHardAttach(Action.bHardAttach);
    if (Action.bUseRelativeOffset || Action.bUseRelativeRotation)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(FALSE, FALSE, );
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRotation(Rotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            GetAxes(Rotation, X, Y, Z);
            Attachment.SetLocation(location + Action.RelativeOffset.X * X + Action.RelativeOffset.Y * Y + Action.RelativeOffset.Z * Z, );
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors, );
    }
    Attachment.SetBase(Self, , , );
    Attachment.ForceNetRelevant();
    Attachment.bNetDirty = TRUE;
    if (Attachment.RemoteRole != ENetRole.ROLE_None && (Attachment.bStatic || Attachment.bNoDelete))
    {
        Attachment.SetForcedInitialReplicatedProperty(StructProperty'RelativeLocation', Attachment.RelativeLocation == Attachment.default.RelativeLocation);
        Attachment.SetForcedInitialReplicatedProperty(StructProperty'RelativeRotation', Attachment.RelativeRotation == Attachment.default.RelativeRotation);
    }
}
public simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float CullDistance)
{
    local PlayerController P;
    local bool bResult;
    
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        return bForceDedicated;
    }
    if (WorldInfo.NetMode == ENetMode.NM_ListenServer && WorldInfo.Game.NumPlayers > 1)
    {
        if (bForceDedicated)
        {
            return TRUE;
        }
        if (Instigator != None && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
        {
            return TRUE;
        }
    }
    else if (Instigator != None && Instigator.IsHumanControlled())
    {
        return TRUE;
    }
    if (SpawnLocation == location)
    {
        bResult = WorldInfo.TimeSeconds - LastRenderTime < 0.5;
    }
    else if (Instigator != None && WorldInfo.TimeSeconds - Instigator.LastRenderTime < 1.0)
    {
        bResult = TRUE;
    }
    if (bResult)
    {
        bResult = FALSE;
        foreach LocalPlayerControllers(Class'PlayerController', P)
        {
            if (P.ViewTarget != None)
            {
                if (P.Pawn == Instigator && Instigator != None)
                {
                    return TRUE;
                }
                else
                {
                    bResult = CheckMaxEffectDistance(P, SpawnLocation, CullDistance);
                    break;
                }
            }
        }
    }
    return bResult;
}
public simulated function FindGoodEndView(PlayerController PC, out Rotator GoodRotation)
{
    GoodRotation = PC.Rotation;
}
public simulated function GetAimAdhesionExtent(out float Width, out float Height, out Vector Center)
{
    if (bCanBeAdheredTo)
    {
        GetBoundingCylinder(Width, Height);
    }
    else
    {
        Width = 0.0;
        Height = 0.0;
    }
    Center = location;
}
public simulated function GetAimFrictionExtent(out float Width, out float Height, out Vector Center)
{
    if (bCanBeFrictionedTo)
    {
        GetBoundingCylinder(Width, Height);
    }
    else
    {
        Width = 0.0;
        Height = 0.0;
    }
    Center = location;
}
public function string GetDebugName()
{
    return GetItemName(string(Self));
}
public simulated function string GetHumanReadableName()
{
    return GetItemName(string(Class));
}
public simulated function string GetItemName(string FullName)
{
    local int pos;
    
    pos = InStr(FullName, ".", , , );
    while (pos != -1)
    {
        FullName = Right(FullName, Len(FullName) - pos - 1);
        pos = InStr(FullName, ".", , , );
    }
    return FullName;
}
public static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return "";
}
public simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return "";
}
public simulated function string GetPhysicsName()
{
    switch (Physics)
    {
        case EPhysics.PHYS_None:
            return "None";
            break;
        case EPhysics.PHYS_Walking:
            return "Walking";
            break;
        case EPhysics.PHYS_Falling:
            return "Falling";
            break;
        case EPhysics.PHYS_Swimming:
            return "Swimming";
            break;
        case EPhysics.PHYS_Flying:
            return "Flying";
            break;
        case EPhysics.PHYS_Rotating:
            return "Rotating";
            break;
        case EPhysics.PHYS_Projectile:
            return "Projectile";
            break;
        case EPhysics.PHYS_Interpolating:
            return "Interpolating";
            break;
        case EPhysics.PHYS_Spider:
            return "Spider";
            break;
        case EPhysics.PHYS_Ladder:
            return "Ladder";
            break;
        case EPhysics.PHYS_RigidBody:
            return "RigidBody";
            break;
        case EPhysics.PHYS_PathApproximation:
            return "PathApproximation";
            break;
        case EPhysics.PHYS_Unused:
            return "Unused";
            break;
        case EPhysics.PHYS_Custom:
            return "Custom";
            break;
        default:
    }
    return "Unknown";
}
public simulated function EPowerResistance GetPowerResistance(Pawn Caster, Vector HitLocation, Vector HitNormal, out float Damage, out Vector Force, Class<DamageType> DamageType, out Actor TargetOverride)
{
    return EPowerResistance.Resistance_None;
}
public simulated function bool HurtRadius(float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = Instigator != None ? Instigator.Controller : None, optional bool bDoFullDamage)
{
    local Actor Victim;
    local bool bCausedDamage;
    local TraceHitInfo HitInfo;
    local StaticMeshComponent HitComponent;
    local KActorFromStatic NewKActor;
    
    if (bHurtEntry)
    {
        return FALSE;
    }
    bHurtEntry = TRUE;
    bCausedDamage = FALSE;
    foreach VisibleCollidingActors(Class'Actor', Victim, DamageRadius, HurtOrigin, , , , , HitInfo)
    {
        if (Victim.bWorldGeometry)
        {
            HitComponent = StaticMeshComponent(HitInfo.HitComponent);
            if (HitComponent != None && HitComponent.CanBecomeDynamic())
            {
                NewKActor = Class'KActorFromStatic'.static.MakeDynamic(HitComponent);
                if (NewKActor != None)
                {
                    Victim = NewKActor;
                }
            }
        }
        if (!Victim.bWorldGeometry && Victim != Self && Victim != IgnoredActor && (Victim.bProjTarget || NavigationPoint(Victim) == None))
        {
            Victim.TakeRadiusDamage(InstigatedByController, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, Self);
            bCausedDamage = bCausedDamage || Victim.bProjTarget;
        }
    }
    bHurtEntry = FALSE;
    return bCausedDamage;
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType);

public simulated function bool IsActorPlayingFaceFXAnim()
{
    return FALSE;
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
public function bool IsInVolume(Volume aVolume)
{
    local Volume V;
    
    foreach TouchingActors(Class'Volume', V, )
    {
        if (V == aVolume)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function bool IsOwningClient()
{
    return WorldInfo.NetMode == ENetMode.NM_Standalone || Instigator != None && Instigator.IsLocallyControlled();
}
public function bool IsStationary()
{
    return TRUE;
}
public function MatchStarting();

public simulated function NotifyLocalPlayerTeamReceived();

public function OnAttachToActor(SeqAct_AttachToActor Action)
{
    local int idx;
    local Actor Attachment;
    local Controller C;
    local array<Object> objVars;
    
    Action.GetObjectVars(objVars, "Attachment");
    for (idx = 0; idx < objVars.Length && Attachment == None; idx++)
    {
        Attachment = Actor(objVars[idx]);
        C = Controller(Attachment);
        if (C != None && C.Pawn != None)
        {
            Attachment = C.Pawn;
        }
        if (Attachment != None)
        {
            if (Action.bDetach)
            {
                Attachment.SetBase(None, , , );
                Attachment.SetHardAttach(FALSE);
                continue;
            }
            C = Controller(Self);
            if (C != None && C.Pawn != None)
            {
                C.Pawn.BioEnqueueDoKismetAttachment(Attachment, Action.bDetach, Action.bHardAttach, Action.BoneName, Action.bUseRelativeOffset, Action.RelativeOffset, Action.bUseRelativeRotation, Action.RelativeRotation);
                continue;
            }
            BioEnqueueDoKismetAttachment(Attachment, Action.bDetach, Action.bHardAttach, Action.BoneName, Action.bUseRelativeOffset, Action.RelativeOffset, Action.bUseRelativeRotation, Action.RelativeRotation);
        }
    }
}
public function OnChangeCollision(SeqAct_ChangeCollision Action)
{
    if (Action.ObjInstanceVersion < Action.GetObjClassVersion())
    {
        SetCollision(Action.bCollideActors, Action.bBlockActors, Action.bIgnoreEncroachers);
    }
    else
    {
        SetCollisionType(Action.CollisionType);
    }
    ForceNetRelevant();
    if (RemoteRole != ENetRole.ROLE_None)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'bCollideActors', bCollideActors == default.bCollideActors);
        SetForcedInitialReplicatedProperty(BoolProperty'bBlockActors', bBlockActors == default.bBlockActors);
    }
}
public simulated function OnDestroy(SeqAct_Destroy Action)
{
    local int AttachIdx;
    local int IgnoreIdx;
    local Actor A;
    
    if (Action.bDestroyBasedActors)
    {
        for (AttachIdx = 0; AttachIdx < Attached.Length; AttachIdx++)
        {
            A = Attached[AttachIdx];
            for (IgnoreIdx = 0; IgnoreIdx < Action.IgnoreBasedClasses.Length; IgnoreIdx++)
            {
                if (ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
                {
                    A = None;
                    break;
                }
            }
            if (A == None)
            {
                continue;
            }
            A.OnDestroy(Action);
        }
    }
    if (bNoDelete || Role < ENetRole.ROLE_Authority)
    {
        ShutDown();
    }
    else if (!bDeleteMe)
    {
        Destroy();
    }
}
public simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
    local Controller InstigatorController;
    local Pawn InstigatorPawn;
    
    InstigatorController = Controller(Action.Instigator);
    if (InstigatorController == None)
    {
        InstigatorPawn = Pawn(Action.Instigator);
        if (InstigatorPawn != None)
        {
            InstigatorController = InstigatorPawn.Controller;
        }
    }
    if (Action.bHeal)
    {
        HealDamage(int(Action.Amount), InstigatorController, Action.DamageType);
    }
    else
    {
        TakeDamage(Action.Amount, InstigatorController, location, Vector(Rotation) * -Action.Momentum, Action.DamageType);
    }
}
public simulated function OnSetBlockRigidBody(SeqAct_SetBlockRigidBody Action)
{
    if (CollisionComponent != None)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            CollisionComponent.SetBlockRigidBody(TRUE);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            CollisionComponent.SetBlockRigidBody(FALSE);
        }
    }
}
public simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    ForceNetRelevant();
    SetPhysics(Action.newPhysics);
    if (RemoteRole != ENetRole.ROLE_None)
    {
        if (Physics != EPhysics.PHYS_None)
        {
            bUpdateSimulatedPosition = TRUE;
            if (bOnlyDirtyReplication)
            {
                bNetDirty = TRUE;
            }
        }
    }
}
public simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
    local Vector V;
    local float Mag;
    
    Mag = Action.VelocityMag;
    if (Mag <= 0.0)
    {
        Mag = VSize(Action.VelocityDir);
    }
    V = Normal(Action.VelocityDir) * Mag;
    if (Action.bVelocityRelativeToActorRotation)
    {
        V = V >> Rotation;
    }
    Velocity = V;
    if (Physics == EPhysics.PHYS_RigidBody && CollisionComponent != None)
    {
        CollisionComponent.SetRBLinearVelocity(Velocity);
    }
}
public simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Actor destActor;
    local Vector vLocation;
    local Rotator rRotation;
    
    if (Action.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        if (SetLocation(vLocation, ))
        {
            PlayTeleportEffect(FALSE, TRUE);
            if (Action.bUpdateRotation)
            {
                SetRotation(rRotation);
            }
            if (Action.m_bSnapToFloor)
            {
                MoveActorToFloor();
            }
            ForceNetRelevant();
            bUpdateSimulatedPosition = TRUE;
            bNetDirty = TRUE;
        }
    }
}
public simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    local int AttachIdx;
    local int IgnoreIdx;
    local Actor A;
    
    if (Action.bToggleBasedActors)
    {
        for (AttachIdx = 0; AttachIdx < Attached.Length; AttachIdx++)
        {
            A = Attached[AttachIdx];
            for (IgnoreIdx = 0; IgnoreIdx < Action.IgnoreBasedClasses.Length; IgnoreIdx++)
            {
                if (ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
                {
                    A = None;
                    break;
                }
            }
            if (A == None)
            {
                continue;
            }
            A.OnToggleHidden(Action);
        }
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        SetHidden(TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        SetHidden(FALSE);
    }
    else
    {
        SetHidden(!bHidden);
    }
    ForceNetRelevant();
    if (RemoteRole != ENetRole.ROLE_None)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'bHidden', bHidden == default.bHidden);
    }
}
public function PawnBaseDied();

public function PickedUpBy(Pawn P);

public function PlayTeleportEffect(bool bOut, bool bSound);

public function PostTeleport(Teleporter OutTeleporter);

public function bool PreTeleport(Teleporter InTeleporter);

public static function ReplaceText(out string Text, string Replace, string With)
{
    local int i;
    local string Input;
    
    Input = Text;
    Text = "";
    i = InStr(Input, Replace, , , );
    while (i != -1)
    {
        Text = Text $ Left(Input, i) $ With;
        Input = Mid(Input, i + Len(Replace), );
        i = InStr(Input, Replace, , , );
    }
    Text = Text $ Input;
}
public simulated function bool StopsProjectile(Projectile P)
{
    return bProjTarget || bBlockActors;
}
public simulated function bool TriggerEventClass(Class<SequenceEvent> InEventClass, Actor inInstigator, optional int ActivateIndex = -1, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local array<int> ActivateIndices;
    
    if (ActivateIndex >= 0)
    {
        ActivateIndices[0] = ActivateIndex;
    }
    return ActivateEventClass(InEventClass, inInstigator, GeneratedEvents, ActivateIndices, bTest, ActivatedEvents);
}
public simulated function bool TriggerGlobalEventClass(Class<SequenceEvent> InEventClass, Actor inInstigator, optional int ActivateIndex = -1)
{
    local array<SequenceObject> EventsToActivate;
    local array<int> ActivateIndices;
    local Sequence GameSeq;
    local bool bResult;
    local int i;
    
    if (ActivateIndex >= 0)
    {
        ActivateIndices[0] = ActivateIndex;
    }
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != None)
    {
        GameSeq.FindSeqObjectsByClass(InEventClass, TRUE, EventsToActivate);
        for (i = 0; i < EventsToActivate.Length; i++)
        {
            if (SequenceEvent(EventsToActivate[i]).CheckActivate(Self, inInstigator, , ActivateIndices))
            {
                bResult = TRUE;
            }
        }
    }
    return bResult;
}
public function bool UsedBy(Pawn User)
{
    return TriggerEventClass(Class'SeqEvent_Used', User, -1);
}
public simulated function VolumeBasedDestroy(PhysicsVolume PV)
{
    Destroy();
}
public final simulated function bool ActivateEventClass(Class<SequenceEvent> InClass, Actor inInstigator, const out array<SequenceEvent> EventList, optional const out array<int> ActivateIndices, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
    local SequenceEvent Evt;
    
    ActivatedEvents.Length = 0;
    foreach EventList(Evt, )
    {
        if (ClassIsChildOf(Evt.Class, InClass) && Evt.CheckActivate(Self, inInstigator, bTest, ActivateIndices))
        {
            ActivatedEvents.AddItem(Evt);
        }
    }
    return ActivatedEvents.Length > 0;
}
public final simulated function CheckHitInfo(out TraceHitInfo HitInfo, PrimitiveComponent FallBackComponent, Vector Dir, out Vector out_HitLocation)
{
    local Vector out_NewHitLocation;
    local Vector out_HitNormal;
    local Vector TraceEnd;
    local Vector TraceStart;
    local TraceHitInfo newHitInfo;
    
    if (SkeletalMeshComponent(HitInfo.HitComponent) != None && HitInfo.BoneName != 'None')
    {
        return;
    }
    if (HitInfo.HitComponent == None || SkeletalMeshComponent(HitInfo.HitComponent) == None && SkeletalMeshComponent(FallBackComponent) != None)
    {
        HitInfo.HitComponent = FallBackComponent;
    }
    if (SkeletalMeshComponent(HitInfo.HitComponent) != None && HitInfo.BoneName == 'None')
    {
        if (IsZero(Dir))
        {
            Dir = Vector(Rotation);
        }
        if (IsZero(out_HitLocation))
        {
            out_HitLocation = location;
        }
        TraceStart = out_HitLocation - float(128) * Normal(Dir);
        TraceEnd = out_HitLocation + float(128) * Normal(Dir);
        if (TraceComponent(out_NewHitLocation, out_HitNormal, HitInfo.HitComponent, TraceEnd, TraceStart, vect(0.0, 0.0, 0.0), newHitInfo))
        {
            HitInfo.BoneName = newHitInfo.BoneName;
            HitInfo.PhysMaterial = newHitInfo.PhysMaterial;
            out_HitLocation = out_NewHitLocation;
        }
    }
}
public final simulated function ClearLatentAction(Class<SeqAct_Latent> actionClass, optional bool bAborted, optional SeqAct_Latent exceptionAction, optional bool bCancelled)
{
    local int idx;
    local SeqAct_Latent oLatentAction;
    
    for (idx = 0; idx < LatentActions.Length; idx++)
    {
        if (LatentActions[idx] == None)
        {
            LatentActions.Remove(idx--, 1);
            continue;
        }
        if (ClassIsChildOf(LatentActions[idx].Class, actionClass) && LatentActions[idx] != exceptionAction)
        {
            oLatentAction = LatentActions[idx];
            LatentActions.Remove(idx--, 1);
            if (bAborted)
            {
                oLatentAction.AbortFor(Self);
                continue;
            }
            if (bCancelled)
            {
                oLatentAction.AbortFor(Self, TRUE);
            }
        }
    }
}
public final function bool FindActorsOfClass(Class<Actor> ActorClass, out array<Actor> out_Actors)
{
    local Actor TestActor;
    
    out_Actors.Length = 0;
    foreach AllActors(ActorClass, TestActor, )
    {
        out_Actors[out_Actors.Length] = TestActor;
    }
    return out_Actors.Length > 0;
}
public final simulated function float GetRemainingTimeForTimer(optional Name TimerFuncName = 'Timer', optional Object inObj)
{
    local float Count;
    local float Rate;
    
    Rate = GetTimerRate(TimerFuncName, inObj);
    if (Rate != -1.0)
    {
        Count = GetTimerCount(TimerFuncName, inObj);
        return Rate - Count;
    }
    return -1.0;
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (RemoteRole == ENetRole.ROLE_AutonomousProxy && bNetInitial || RemoteRole == ENetRole.ROLE_SimulatedProxy && (bNetInitial || bUpdateSimulatedPosition) && (Base == None || Base.bWorldGeometry)))
        location, Rotation;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && RemoteRole == ENetRole.ROLE_SimulatedProxy)
        Base;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (bNetInitial || bUpdateSimulatedPosition) && RemoteRole == ENetRole.ROLE_SimulatedProxy && Base != None && !Base.bWorldGeometry)
        RelativeLocation, RelativeRotation;
    if ((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement && (RemoteRole == ENetRole.ROLE_SimulatedProxy && (bNetInitial || bUpdateSimulatedPosition)))
        Velocity;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority)
        bHardAttach;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty)
        bHidden;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty && (bCollideActors || bCollideWorld))
        bBlockActors, bProjTarget;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority)
        bTearOff, bNetOwner, RemoteRole, Role;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty && bReplicateInstigator)
        Instigator;
    if ((!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty)
        DrawScale, bCollideActors, bCollideWorld, ReplicatedCollisionType;
    if (bNetOwner && (!bSkipActorPropertyReplication || bNetInitial) && Role == ENetRole.ROLE_Authority && bNetDirty)
        Owner;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MessageClass = Class'LocalMessage'
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    DrawScale = 1.0
    CustomTimeDilation = 1.0
    NetUpdateFrequency = 100.0
    NetPriority = 1.0
    m_fGravityScaling = 1.0
    DensityScaling = 1.0
    bPushedByEncroachers = TRUE
    bRouteBeginPlayEvenIfStatic = TRUE
    bCanStepUpOn = TRUE
    bReplicateMovement = TRUE
    bAllowFluidSurfaceInteraction = TRUE
    m_bBioBoneDependsOnBaseSkel = TRUE
    bMovable = TRUE
    bJustTeleported = TRUE
    Role = ENetRole.ROLE_Authority
    ReplicatedCollisionType = None
}
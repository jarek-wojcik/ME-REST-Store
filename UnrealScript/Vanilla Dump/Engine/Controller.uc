Class Controller extends Actor
    implements(Interface_NavigationHandle)
    native
    nativereplication
    abstract;

struct native VisiblePortalInfo 
{
    var Actor Source;
    var Actor Destination;
};
const LATENT_MOVETOWARD = 503;

var const native noexport Pointer VfTable_IInterface_NavigationHandle;
var array<NavigationPoint> RouteCache;
var array<VisiblePortalInfo> VisiblePortals;
var Class<NavigationHandle> NavigationHandleClass;
var BasedPosition DestinationPosition;
var BasedPosition FocalPosition;
var BasedPosition AdjustPosition;
var Actor GoalList[4];
var Vector CurrentPathDir;
var Vector ViewX;
var Vector ViewY;
var Vector ViewZ;
var const Vector FailedReachLocation;
var const Rotator OldBasedRotation;
var Vector NavMeshPath_SearchExtent_Modifier;
var Name PendingDoorState;
var repnotify Pawn Pawn;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var const int PlayerNum;
var const Controller NextController;
var float MinHitWall;
var NavigationHandle NavigationHandle;
var float MoveTimer;
var Actor MoveTarget;
var Actor Focus;
var NavigationPoint StartSpot;
var ReachSpec CurrentPath;
var ReachSpec NextRoutePath;
var Actor RouteGoal;
var float RouteDist;
var float LastRouteFind;
var InterpActor PendingMover;
var Actor FailedMoveTarget;
var int MoveFailureCount;
var Actor PendingDoor;
var float GroundPitchTime;
var Pawn ShotTarget;
var const Actor LastFailedReach;
var const float FailedReachTime;
var float SightCounter;
var float SightCounterInterval;
var float InUseNodeCostMultiplier;
var int HighJumpNodeCostModifier;
var float MaxMoveTowardPawnTargetTime;
var clearcrosslevel Pawn Enemy;
var float LaneOffset;
var bool bIsPlayer;
var bool bGodMode;
var bool bAffectedByHitEffects;
var bool bSoaking;
var bool bSlowerZAcquire;
var bool bNotifyPostLanded;
var bool bNotifyApex;
var bool bAdvancedTactics;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var bool bForceStrafe;
var const bool bLOSflag;
var bool bSkipExtraLOSChecks;
var bool bNotifyFallingHitWall;
var bool bPreciseDestination;
var bool bSeeFriendly;
var bool bUsingPathLanes;
var input byte bFire;
var input byte bAltFire;

public final native(520) function bool ActorReachable(Actor anActor);

public event function bool AllowDetourTo(NavigationPoint N)
{
    return TRUE;
}
public event simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
    Pawn.BeginAnimControl(InInterpGroup);
}
public final native function bool BeyondFogDistance(Vector Viewpoint, Vector OtherPoint);

public final native(537) function bool CanSeeByPoints(Vector ViewLocation, Vector TestLocation, Rotator ViewRotation);

public event function CurrentLevelUnloaded();

public event function Destroyed()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (bIsPlayer && WorldInfo.Game != None)
        {
            WorldInfo.Game.Logout(Self);
        }
        if (PlayerReplicationInfo != None)
        {
            if (!PlayerReplicationInfo.bOnlySpectator && PlayerReplicationInfo.Team != None)
            {
                PlayerReplicationInfo.Team.RemoveFromTeam(Self);
            }
            CleanupPRI();
        }
    }
    Super.Destroyed();
}
public native function EndClimbLadder();

public final native(518) function Actor FindPathTo(Vector aPoint, optional int MaxPathLength, optional bool bReturnPartial);

public final native function Actor FindPathToIntercept(Pawn P, Actor InRouteGoal, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

public final native(517) function Actor FindPathToward(Actor anActor, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

public final latent native function FindPathTowardIterative(Actor Goal, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

public final native function Actor FindPathTowardNearest(Class<NavigationPoint> GoalClass, optional bool bWeightDetours, optional int MaxPathLength, optional bool bReturnPartial);

public final native(525) function NavigationPoint FindRandomDest();

public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    Pawn.FinishAnimControl(InInterpGroup);
}
public final latent native(508) function FinishRotation();

public event simulated function GetActorEyesViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    if (Pawn != None)
    {
        Pawn.GetActorEyesViewPoint(out_Location, out_rotation);
    }
    else
    {
        out_Location = location;
        out_rotation = Rotation;
    }
}
public final native function Vector GetAdjustLocation();

public final native function Vector GetDestinationPosition();

public final native function Vector GetFocalPoint();

public event simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    out_Location = location;
    out_rotation = Rotation;
}
public simulated native function byte GetTeamNum();

public event function bool HandlePathObstruction(Actor BlockedBy);

public event function HearNoise(float Loudness, Actor NoiseMaker, optional Name NoiseType);

public final native function bool InLatentExecution(int LatentActionNumber);

public event simulated function InterpolationFinished(SeqAct_Interp InterpAction)
{
    if (Pawn != None)
    {
        Pawn.InterpolationFinished(InterpAction);
    }
    Super.InterpolationFinished(InterpAction);
}
public event simulated function InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    if (Pawn != None)
    {
        Pawn.InterpolationStarted(InterpAction, GroupInst);
    }
    Super.InterpolationStarted(InterpAction, GroupInst);
}
public function bool IsDead();

public event function bool IsInCombat(optional bool bForceCheck);

public native function bool IsLocalPlayerController();

public event function bool IsSpectating()
{
    return FALSE;
}
public final native(514) function bool LineOfSightTo(Actor Other, optional Vector chkLocation, optional bool bTryAlternateTargetLoc);

public event function LongFall();

public event function MayFall(bool bFloor, Vector FloorNormal);

public event function bool MoverFinished()
{
    if (Pawn == None || PendingMover.MyMarker == None || PendingMover.MyMarker.ProceedWithMove(Pawn))
    {
        PendingMover = None;
        bPreparingMove = FALSE;
        return TRUE;
    }
    return FALSE;
}
public final latent native(500) function MoveTo(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = Pawn != None ? Pawn.bIsWalking : FALSE);

public final latent native function MoveToDirectNonPathPos(Vector NewDestination, optional Actor ViewFocus, optional float DestinationOffset, optional bool bShouldWalk = Pawn != None ? Pawn.bIsWalking : FALSE);

public final latent native(502) function MoveToward(Actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk = Pawn != None ? Pawn.bIsWalking : FALSE);

public event function MoveUnreachable(Vector AttemptedDest, Actor AttemptedTarget);

public event function bool NotifyBump(Actor Other, Vector HitNormal);

public event simulated function NotifyCoverAdjusted();

public event function NotifyFallingHitWall(Vector HitNormal, Actor Wall);

public event function bool NotifyHeadVolumeChange(PhysicsVolume NewVolume);

public event function bool NotifyHitWall(Vector HitNormal, Actor Wall);

public event function NotifyJumpApex();

public event function bool NotifyLanded(Vector HitNormal, Actor FloorActor);

public event function NotifyMissedJump();

public event function NotifyPathChanged();

public event function NotifyPhysicsVolumeChange(PhysicsVolume NewVolume);

public event function NotifyPostLanded();

public final native(531) function Pawn PickTarget(Class<Pawn> TargetClass, out float bestAim, out float bestDist, Vector FireDir, Vector projStart, float MaxRange);

public final native(526) function bool PickWallAdjust(Vector HitNormal);

public event function bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return Pawn.PlayActorFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}
public final native(521) function bool PointReachable(Vector aPoint);

public event function Possess(Pawn inPawn, bool bVehicleTransition)
{
    if (inPawn.Controller != None)
    {
        inPawn.Controller.UnPossess();
    }
    inPawn.PossessedBy(Self, bVehicleTransition);
    Pawn = inPawn;
    if (PlayerReplicationInfo != None)
    {
        UpdateSex();
    }
    SetFocalPoint(Pawn.location + float(512) * Vector(Pawn.Rotation), TRUE);
    Restart(bVehicleTransition);
    if (Pawn.Weapon == None)
    {
        ClientSwitchToBestWeapon();
    }
}
public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (!bDeleteMe && WorldInfo.NetMode != ENetMode.NM_Client)
    {
        if (bIsPlayer)
        {
            InitPlayerReplicationInfo();
        }
        InitNavigationHandle();
    }
    SightCounter = SightCounterInterval * FRand();
}
public event function float RatePickup(Actor PickupHolder, Class<Inventory> inPickup);

public event function ReachedPreciseDestination();

public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'PlayerReplicationInfo')
    {
        if (PlayerReplicationInfo != None)
        {
            PlayerReplicationInfo.ClientInitialize(Self);
        }
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public function Reset()
{
    Super.Reset();
    Enemy = None;
    StartSpot = None;
    bAdjusting = FALSE;
    bPreparingMove = FALSE;
    MoveTimer = -1.0;
    MoveTarget = None;
    CurrentPath = None;
    RouteGoal = None;
}
public native function RouteCache_AddItem(NavigationPoint Nav);

public native function RouteCache_Empty();

public native function RouteCache_InsertItem(NavigationPoint Nav, optional int idx = 0);

public native function RouteCache_RemoveIndex(int InIndex, optional int Count = 1);

public native function RouteCache_RemoveItem(NavigationPoint Nav);

public function SendMessage(PlayerReplicationInfo Recipient, Name MessageType, float Wait, optional Class<DamageType> DamageType);

public final native function SetAdjustLocation(Vector NewLoc, bool bAdjust, optional bool bOffsetFromBase);

public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    Pawn.SetAnimPosition(SlotName, ChannelIndex, InAnimSeqName, InPosition, bFireNotifies, bLooping);
}
public final native function SetDestinationPosition(Vector Dest, optional bool bOffsetFromBase);

public final native function SetFocalPoint(Vector FP, optional bool bOffsetFromBase);

public event function SetMorphWeight(Name MorphNodeName, float MorphWeight)
{
    Pawn.SetMorphWeight(MorphNodeName, MorphWeight);
}
public event function SetSkelControlScale(Name SkelControlName, float Scale)
{
    Pawn.SetSkelControlScale(SkelControlName, Scale);
}
public event function SetupSpecialPathAbilities();

public event function StopActorFaceFXAnim()
{
    Pawn.StopActorFaceFXAnim();
}
public event function StopFiring()
{
    bFire = 0;
    if (Pawn != None)
    {
        Pawn.StopFiring();
    }
}
public final native function StopLatentExecution();

public event function UnPossess()
{
    if (Pawn != None)
    {
        Pawn.UnPossessed();
        Pawn = None;
    }
}
public final latent native(527) function WaitForLanding(optional float waitDuration);

public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    if (Pawn == None)
    {
        if (PlayerReplicationInfo == None)
        {
            Canvas.DrawText("NO PLAYERREPLICATIONINFO", FALSE);
        }
        else
        {
            PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Super.DisplayDebug(HUD, out_YL, out_YPos);
        return;
    }
    Canvas.SetDrawColor(255, 0, 0);
    Canvas.DrawText("CONTROLLER " $ GetItemName(string(Self)) $ " Pawn " $ GetItemName(string(Pawn)));
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText(" bPreciseDestination:" @ bPreciseDestination);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        if (Enemy != None)
        {
            Canvas.DrawText("     STATE: " $ GetStateName() $ " Enemy " $ Enemy.GetHumanReadableName(), FALSE);
        }
        else
        {
            Canvas.DrawText("     STATE: " $ GetStateName() $ " NO Enemy ", FALSE);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}
public simulated function string GetHumanReadableName()
{
    if (PlayerReplicationInfo != None)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    else
    {
        return GetItemName(string(Self));
    }
}
public simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
    if (Pawn != None)
    {
        Pawn.OnModifyHealth(Action);
    }
}
public simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
    if (Pawn != None)
    {
        Pawn.OnSetPhysics(Action);
    }
    else
    {
        Super.OnSetPhysics(Action);
    }
}
public simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
    if (Pawn != None)
    {
        Pawn.OnSetVelocity(Action);
    }
    else
    {
        Super.OnSetVelocity(Action);
    }
}
public simulated function OnTeleport(SeqAct_Teleport Action)
{
    if (Action != None)
    {
        if (Pawn != None)
        {
            Pawn.OnTeleport(Action);
        }
        else
        {
            Super.OnTeleport(Action);
        }
    }
}
public simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    if (Pawn != None)
    {
        Pawn.OnToggleHidden(Action);
    }
}
public function CheckNearMiss(Pawn Shooter, Weapon W, Vector WeapLoc, Vector LineDir, Vector HitLocation);

public function CleanupPRI()
{
    PlayerReplicationInfo.Destroy();
    PlayerReplicationInfo = None;
}
public reliable client function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    SetRotation(NewRotation);
    if (Pawn != None)
    {
        if (Rotation.Pitch > Pawn.MaxPitchLimit && Rotation.Pitch < 65536 - Pawn.MaxPitchLimit)
        {
            if (Rotation.Pitch < 32768)
            {
                NewRotation.Pitch = Pawn.MaxPitchLimit;
            }
            else
            {
                NewRotation.Pitch = 65536 - Pawn.MaxPitchLimit;
            }
        }
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation);
        Pawn.SetLocation(NewLocation, );
    }
}
public reliable client function ClientSetRotation(Rotator NewRotation, optional bool bResetCamera)
{
    SetRotation(NewRotation);
    if (Pawn != None)
    {
        NewRotation.Pitch = 0;
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation);
    }
}
public reliable client function ClientSetWeapon(Class<Weapon> WeaponClass)
{
    local Inventory Inv;
    
    if (Pawn == None)
    {
        return;
    }
    Inv = Pawn.FindInventoryType(WeaponClass);
    if (Weapon(Inv) != None)
    {
        Pawn.SetActiveWeapon(Weapon(Inv));
    }
}
public reliable client function ClientSwitchToBestWeapon(optional bool bForceNewWeapon)
{
    SwitchToBestWeapon(bForceNewWeapon);
}
public function EnemyJustTeleported()
{
    LineOfSightTo(Enemy, , );
}
public function bool FireWeaponAt(Actor InActor);

public function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    GotoState('RoundEnded', , , );
}
public function bool GamePlayEndedState()
{
    return FALSE;
}
public function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    if (Pawn != None)
    {
        return Pawn.GetBaseAimRotation();
    }
    return Rotation;
}
public function float GetDestinationOffset();

public function Actor GetRouteGoalAfter(int RouteIdx)
{
    if (RouteIdx + 1 < RouteCache.Length)
    {
        return RouteCache[RouteIdx + 1];
    }
    return RouteGoal;
}
public function HandlePickup(Inventory Inv);

public function InitNavigationHandle()
{
    if (NavigationHandleClass != None)
    {
        NavigationHandle = new (Self) NavigationHandleClass;
    }
}
public function InitPlayerReplicationInfo()
{
    PlayerReplicationInfo = Spawn(WorldInfo.Game.PlayerReplicationInfoClass, Self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
    if (PlayerReplicationInfo.PlayerName == "")
    {
        PlayerReplicationInfo.PlayerName = Class'GameInfo'.default.DefaultPlayerName;
    }
}
public function InstantWarnTarget(Actor InTarget, Weapon FiredWeapon, Vector FireDir)
{
    local Pawn P;
    
    P = Pawn(InTarget);
    if (P != None && P.Controller != None)
    {
        P.Controller.ReceiveWarning(Pawn, -1.0, FireDir);
    }
}
public simulated function bool IsAimingAt(Actor ATarget, float Epsilon)
{
    local Vector Loc;
    local Rotator Rot;
    
    GetPlayerViewPoint(Loc, Rot);
    return Normal(ATarget.location - Loc) Dot Vector(Rot) >= Epsilon;
}
public simulated function bool LandingShake()
{
    return FALSE;
}
public function NotifyAddInventory(Inventory NewItem);

public function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon);

public simulated function bool NotifyCoverClaimViolation(Controller NewClaim, CoverLink Link, int SlotIdx);

public simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx);

public function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    if (Pawn != None)
    {
        Pawn.TriggerEventClass(Class'SeqEvent_SeeDeath', KilledPawn);
    }
    if (Enemy == KilledPawn)
    {
        Enemy = None;
    }
}
public function NotifyProjLanded(Projectile Proj)
{
    if (Proj != None && Pawn != None)
    {
        Pawn.TriggerEventClass(Class'SeqEvent_ProjectileLanded', Proj);
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum);

public function OnPossess(SeqAct_Possess inAction)
{
    local Pawn OldPawn;
    local Vehicle V;
    
    V = Vehicle(Pawn);
    if (inAction.bTryToLeaveVehicle && V != None)
    {
        V.DriverLeave(TRUE);
    }
    if (inAction.PawnToPossess != None)
    {
        V = Vehicle(inAction.PawnToPossess);
        if (Pawn != None && V != None)
        {
            V.TryToDrive(Pawn);
        }
        else
        {
            OldPawn = Pawn;
            UnPossess();
            Possess(inAction.PawnToPossess, FALSE);
            if (inAction.bKillOldPawn && OldPawn != None)
            {
                OldPawn.Destroy();
            }
        }
    }
}
public function OnToggleAffectedByHitEffects(SeqAct_ToggleAffectedByHitEffects inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bAffectedByHitEffects = TRUE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bAffectedByHitEffects = FALSE;
    }
    else
    {
        bAffectedByHitEffects = !bAffectedByHitEffects;
    }
}
public function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bGodMode = TRUE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bGodMode = FALSE;
    }
    else
    {
        bGodMode = !bGodMode;
    }
}
public function PawnDied(Pawn inPawn)
{
    local int idx;
    
    if (inPawn != Pawn)
    {
        return;
    }
    TriggerEventClass(Class'SeqEvent_Death', Self);
    for (idx = 0; idx < LatentActions.Length; idx++)
    {
        if (LatentActions[idx] != None)
        {
            LatentActions[idx].AbortFor(Self);
        }
    }
    LatentActions.Length = 0;
    if (Pawn != None)
    {
        SetLocation(Pawn.location, );
        Pawn.UnPossessed();
    }
    Pawn = None;
    if (bIsPlayer)
    {
        if (!GamePlayEndedState())
        {
            GotoState('Dead', , , );
        }
    }
    else
    {
        Destroy();
    }
}
public function ReadyForLift();

public function ReceiveProjectileWarning(Projectile Proj);

public function ReceiveWarning(Pawn Shooter, float projSpeed, Vector FireDir);

public function Restart(bool bVehicleTransition)
{
    Pawn.Restart();
    if (!bVehicleTransition)
    {
        Enemy = None;
    }
    if (bVehicleTransition == FALSE && Pawn.InvManager != None)
    {
        Pawn.InvManager.UpdateController();
    }
}
public function RoundHasEnded(optional Actor EndRoundFocus)
{
    GotoState('RoundEnded', , , );
}
public function ServerGivePawn();

public reliable server function ServerRestartPlayer()
{
    if (WorldInfo.NetMode != ENetMode.NM_Client && Pawn != None)
    {
        ServerGivePawn();
    }
}
public function SetCharacter(string InCharacter);

public exec function SwitchToBestWeapon(optional bool bForceNewWeapon)
{
    if (Pawn == None || Pawn.InvManager == None)
    {
        return;
    }
    Pawn.InvManager.SwitchToBestWeapon(bForceNewWeapon);
}
public function UnderLift(LiftCenter Lift);

public function UpdateSex()
{
    if (Vehicle(Pawn) != None && Vehicle(Pawn).Driver != None)
    {
        PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;
    }
    else
    {
        PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
    }
}
public function WaitForMover(InterpActor M)
{
    PendingMover = M;
    M.bMonitorMover = TRUE;
    bPreparingMove = TRUE;
    Pawn.Acceleration = vect(0.0, 0.0, 0.0);
}
public function WarnProjExplode(Projectile Proj);


state RoundEnded 
{
    ignores HitWall, Falling, SeePlayer, HearNoise, NotifyBump, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange
    ;
    public event function BeginState(Name PreviousStateName)
    {
        if (Pawn != None)
        {
            Pawn.TurnOff();
            StopFiring();
            if (!bIsPlayer)
            {
                Pawn.UnPossessed();
                Pawn = None;
            }
        }
        if (!bIsPlayer)
        {
            Destroy();
        }
    }
    public function bool GamePlayEndedState()
    {
        return TRUE;
    }
    public function ReceiveWarning(Pawn Shooter, float projSpeed, Vector FireDir);
    
    public function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
    
    public function KilledBy(Pawn EventInstigator);
    
    
    stop;
};
state Dead 
{
    ignores SeePlayer, HearNoise
    ;
    public reliable server function ServerRestartPlayer()
    {
        if (WorldInfo.NetMode == ENetMode.NM_Client)
        {
            return;
        }
        if (Pawn != None)
        {
            UnPossess();
        }
        WorldInfo.Game.RestartPlayer(Self);
    }
    public function PawnDied(Pawn P)
    {
        if (WorldInfo.NetMode != ENetMode.NM_Client)
        {
        }
    }
    public function bool IsDead()
    {
        return TRUE;
    }
    public function KilledBy(Pawn EventInstigator);
    
    
    stop;
};

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        Pawn, PlayerReplicationInfo;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NavigationHandleClass = Class'NavigationHandle'
    MinHitWall = -1.0
    SightCounterInterval = 0.200000003
    MaxMoveTowardPawnTargetTime = 1.20000005
    bAffectedByHitEffects = TRUE
    bSlowerZAcquire = TRUE
    Components = (None)
    RotationRate = {Pitch = 30000, Yaw = 30000, Roll = 2048}
    bHidden = TRUE
    bOnlyRelevantToOwner = TRUE
    bHiddenEd = TRUE
}
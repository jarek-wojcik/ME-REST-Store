Class Vehicle extends Pawn
    native
    placeable
    nativereplication
    abstract
    config(Game);

var(Vehicle) array<Vector> ExitPositions;
var Class<DamageType> CrushedDamageType;
var Vector ExitOffset;
var Vector TargetLocationAdjustment;
var repnotify Pawn Driver;
var float ExitRadius;
var(Vehicle) float Steering;
var(Vehicle) float Throttle;
var(Vehicle) float Rise;
var float DriverDamageMult;
var(Vehicle) float MomentumMult;
var float MinCrushSpeed;
var float ForceCrushPenetration;
var float ThrottleTime;
var float StuckTime;
var float OldSteering;
var float OnlySteeringStartTime;
var float OldThrottle;
var const float AIMoveCheckTime;
var float VehicleMovingTime;
var float TurnTime;
var repnotify bool bDriving;
var bool bDriverIsVisible;
var bool bAttachDriver;
var bool bTurnInPlace;
var bool bSeparateTurretFocus;
var bool bFollowLookDir;
var bool bHasHandbrake;
var bool bScriptedRise;
var bool bDuckObstacles;
var bool bAvoidReversing;
var bool bRetryPathfindingWithDriver;
var(Vehicle) bool bIgnoreStallZ;
var bool bDoExtraNetRelevancyTraces;
var byte StuckCount;

public event function bool ContinueOnFoot()
{
    if (AIController(Controller) != None)
    {
        return DriverLeave(FALSE);
    }
    else
    {
        return FALSE;
    }
}
public event simulated function Destroyed()
{
    if (Driver != None)
    {
        Destroyed_HandleDriver();
    }
    Super.Destroyed();
}
public event function bool DriverLeave(bool bForceLeave)
{
    local Controller C;
    local PlayerController PC;
    local Rotator ExitRotation;
    
    if (Role < ENetRole.ROLE_Authority)
    {
        ScriptTrace();
        return FALSE;
    }
    if (!bForceLeave && !WorldInfo.Game.CanLeaveVehicle(Self, Driver))
    {
        return FALSE;
    }
    if (Controller == None)
    {
        return FALSE;
    }
    if (Driver != None)
    {
        Driver.SetHardAttach(FALSE);
        Driver.bCollideWorld = TRUE;
        Driver.Mesh.SetBlockRigidBody(TRUE);
        Driver.SetCollision(TRUE, TRUE, );
        if (!PlaceExitingDriver())
        {
            if (!bForceLeave)
            {
                Driver.SetHardAttach(TRUE);
                Driver.bCollideWorld = FALSE;
                Driver.SetCollision(FALSE, FALSE, );
                return FALSE;
            }
            else
            {
                Driver.SetLocation(GetTargetLocation(), );
            }
        }
    }
    ExitRotation = GetExitRotation(Controller);
    SetDriving(FALSE);
    C = Controller;
    if (C.RouteGoal == Self)
    {
        C.RouteGoal = None;
    }
    if (C.MoveTarget == Self)
    {
        C.MoveTarget = None;
    }
    Controller.UnPossess();
    if (Driver != None && Driver.Health > 0)
    {
        Driver.SetRotation(ExitRotation);
        Driver.SetOwner(C);
        C.Possess(Driver, TRUE);
        PC = PlayerController(C);
        if (PC != None)
        {
            PC.ClientSetViewTarget(Driver);
        }
        Driver.StopDriving(Self);
    }
    if (C == Controller)
    {
        Controller = None;
    }
    WorldInfo.Game.DriverLeftVehicle(Self, Driver);
    DriverLeft();
    return TRUE;
}
public event function EncroachedBy(Actor Other);

public event function bool EncroachingOn(Actor Other)
{
    local Pawn P;
    local Vector PushVelocity;
    local Vector CheckExtent;
    local bool bSlowEncroach;
    local bool bDeepEncroach;
    
    P = Pawn(Other);
    if (P == None)
    {
        return FALSE;
    }
    bSlowEncroach = VSize(Velocity) < MinCrushSpeed;
    if (bSlowEncroach)
    {
        CheckExtent.X = P.CylinderComponent.CollisionRadius - ForceCrushPenetration;
        CheckExtent.Y = CheckExtent.X;
        CheckExtent.Z = P.CylinderComponent.CollisionHeight - ForceCrushPenetration;
        bDeepEncroach = PointCheckComponent(CollisionComponent, P.location, CheckExtent);
    }
    if (Other == Instigator && !bDeepEncroach || Vehicle(Other) != None || Other.Role != ENetRole.ROLE_Authority || !Other.bCollideActors && !Other.bBlockActors || bSlowEncroach && !bDeepEncroach)
    {
        if (P.Velocity Dot (location - P.location) > float(0))
        {
            PushVelocity = Normal(P.location - location) * float(200);
            PushVelocity.Z = 100.0;
            P.AddVelocity(PushVelocity, location, CrushedDamageType);
        }
        return FALSE;
    }
    if (P.Base == Self)
    {
        RanInto(P);
        if (P.Base != None)
        {
            P.JumpOffPawn();
        }
        if (P.Base == None)
        {
            return FALSE;
        }
    }
    PancakeOther(P);
    return FALSE;
}
public event simulated function Vector GetEntryLocation()
{
    return location;
}
public native function float GetMaxRiseForce();

public simulated native function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

public event function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (!bDeleteMe)
    {
        AddDefaultInventory();
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bDriving')
    {
        DrivingStatusChanged();
    }
    else if (VarName == 'Driver')
    {
        if (PlayerReplicationInfo != None && Driver != None)
        {
            Driver.NotifyTeamChanged();
        }
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    bForceNetUpdate = TRUE;
    if (DamageType != None)
    {
        Damage *= DamageType.static.VehicleDamageScalingFor(Self);
        Momentum *= DamageType.default.VehicleMomentumScaling * MomentumMult;
    }
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        Super(Actor).TakeRadiusDamage(instigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
        if (Health > 0)
        {
            DriverRadiusDamage(BaseDamage, DamageRadius, instigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
        }
    }
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string DriverText;
    
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.SetDrawColor(255, 255, 255);
    HUD.Canvas.DrawText("Steering " $ Steering $ " throttle " $ Throttle $ " rise " $ Rise);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
    HUD.Canvas.SetDrawColor(255, 0, 0);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
    if (Driver == None)
    {
        DriverText = "NO DRIVER";
    }
    else
    {
        DriverText = "Driver Mesh " $ Driver.Mesh $ " hidden " $ Driver.bHidden;
    }
    HUD.Canvas.DrawText(DriverText);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0, out_YPos);
}
public function AdjustDriverDamage(out float Damage, Controller instigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
    if (InGodMode())
    {
        Damage = 0.0;
    }
    else if (!DamageType.default.bIgnoreDriverDamageMult)
    {
        Damage *= DriverDamageMult;
    }
}
public function bool AnySeatAvailable()
{
    return Driver == None;
}
public simulated function AttachDriver(Pawn P)
{
    if (!bAttachDriver)
    {
        return;
    }
    P.SetCollision(FALSE, FALSE, );
    P.bCollideWorld = FALSE;
    P.Mesh.SetBlockRigidBody(FALSE);
    P.SetBase(None, , , );
    P.SetHardAttach(TRUE);
    P.SetPhysics(0);
    if (P.Mesh != None && Mesh != None)
    {
        P.Mesh.SetShadowParent(Mesh);
    }
    if (!bDriverIsVisible)
    {
        P.SetHidden(TRUE);
        P.SetLocation(location, );
    }
    P.SetBase(Self, , , );
    P.SetPhysics(0);
}
public function bool CanEnterVehicle(Pawn P)
{
    return AnySeatAvailable() && P.DrivenVehicle == None && P.Controller != None && P.Controller.bIsPlayer && !P.IsA('Vehicle') && Health > 0;
}
public function bool CheatFly()
{
    return FALSE;
}
public function bool CheatGhost()
{
    return FALSE;
}
public function bool CheatWalk()
{
    return FALSE;
}
public function CrushedBy(Pawn OtherPawn);

public simulated function Destroyed_HandleDriver()
{
    local Pawn OldDriver;
    
    Driver.LastRenderTime = LastRenderTime;
    if (Role == ENetRole.ROLE_Authority)
    {
        OldDriver = Driver;
        Driver = None;
        OldDriver.DrivenVehicle = None;
        OldDriver.Destroy();
    }
    else if (Driver.DrivenVehicle == Self)
    {
        Driver.StopDriving(Self);
    }
}
public simulated function DetachDriver(Pawn P);

public function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    if (Super.Died(Killer, DamageType, HitLocation))
    {
        SetDriving(FALSE);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function DriverDied(Class<DamageType> DamageType)
{
    local Controller C;
    local PlayerReplicationInfo RealPRI;
    
    if (Driver == None)
    {
        return;
    }
    WorldInfo.Game.DiscardInventory(Driver);
    C = Controller;
    Driver.StopDriving(Self);
    Driver.Controller = C;
    Driver.DrivenVehicle = Self;
    if (Controller == None)
    {
        return;
    }
    if (PlayerController(Controller) != None)
    {
        Controller.SetLocation(location, );
        PlayerController(Controller).SetViewTarget(Driver);
        PlayerController(Controller).ClientSetViewTarget(Driver);
    }
    Controller.UnPossess();
    if (Controller == C)
    {
        Controller = None;
    }
    C.Pawn = Driver;
    RealPRI = Driver.PlayerReplicationInfo;
    if (RealPRI == None)
    {
        Driver.PlayerReplicationInfo = C.PlayerReplicationInfo;
    }
    WorldInfo.Game.DriverLeftVehicle(Self, Driver);
    Driver.PlayerReplicationInfo = RealPRI;
    DriverLeft();
}
public function bool DriverEnter(Pawn P)
{
    local Controller C;
    
    C = P.Controller;
    Driver = P;
    Driver.StartDriving(Self);
    if (Driver.Health <= 0)
    {
        Driver = None;
        return FALSE;
    }
    SetDriving(TRUE);
    C.UnPossess();
    Driver.SetOwner(Self);
    C.Possess(Self, TRUE);
    if (PlayerController(C) != None)
    {
        PlayerController(C).GotoState(LandMovementState, , , );
    }
    WorldInfo.Game.DriverEnteredVehicle(Self, P);
    return TRUE;
}
public function DriverLeft()
{
    Driver = None;
    SetDriving(FALSE);
}
public function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, Class<DamageType> DamageType, float Momentum, Vector HitLocation, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (EventInstigator != None && Driver != None && bAttachDriver && !Driver.bCollideActors && !Driver.bBlockActors)
    {
        Driver.TakeRadiusDamage(EventInstigator, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation, FALSE, DamageCauser, DamageFalloffExponent);
    }
}
public simulated function DrivingStatusChanged()
{
    if (!bDriving)
    {
        Throttle = 0.0;
        Steering = 0.0;
        Rise = 0.0;
    }
}
public function EntryAnnouncement(Controller C);

public simulated function FaceRotation(Rotator NewRotation, float DeltaTime);

public function bool FindAutoExit(Pawn ExitingDriver)
{
    local Vector FacingDir;
    local Vector CrossProduct;
    local float PlaceDist;
    
    FacingDir = Vector(Rotation);
    CrossProduct = Normal(FacingDir Cross vect(0.0, 0.0, 1.0));
    if (ExitRadius == float(0))
    {
        ExitRadius = GetCollisionRadius() + ExitingDriver.VehicleCheckRadius;
    }
    PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
    return TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * CrossProduct, FALSE) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * CrossProduct, FALSE) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset - PlaceDist * FacingDir, FALSE) || TryExitPos(ExitingDriver, GetTargetLocation() + ExitOffset + PlaceDist * FacingDir, FALSE);
}
public function Controller GetCollisionDamageInstigator()
{
    if (Controller != None)
    {
        return Controller;
    }
    else
    {
        return Instigator != None ? Instigator.Controller : None;
    }
}
public simulated function Name GetDefaultCameraMode(PlayerController RequestedBy)
{
    if (RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'ThirdPerson';
}
public function Rotator GetExitRotation(Controller C)
{
    local Rotator Rot;
    
    Rot.Yaw = Controller.Rotation.Yaw;
    return Rot;
}
public function HandleDeadVehicleDriver();

public function NotifyDriverTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum);

public simulated function NotifyTeamChanged()
{
    if (PlayerReplicationInfo != None && Driver != None)
    {
        Driver.NotifyTeamChanged();
    }
}
public function PancakeOther(Pawn Other)
{
    Other.TakeDamage(10000.0, GetCollisionDamageInstigator(), Other.location, Velocity * Other.Mass, CrushedDamageType);
}
public function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    local int i;
    local Vector tryPlace;
    local Vector Extent;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector ZOffset;
    
    if (ExitingDriver == None)
    {
        ExitingDriver = Driver;
    }
    if (ExitingDriver == None)
    {
        return FALSE;
    }
    Extent = ExitingDriver.GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Extent.Z = ExitingDriver.GetCollisionHeight();
    ZOffset = Extent.Z * vect(0.0, 0.0, 1.0);
    if (ExitPositions.Length > 0)
    {
        for (i = 0; i < ExitPositions.Length; i++)
        {
            if (ExitPositions[0].Z != float(0))
            {
                ZOffset = vect(0.0, 0.0, 1.0) * ExitPositions[0].Z;
            }
            else
            {
                ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0.0, 0.0, 2.0);
            }
            tryPlace = location + (ExitPositions[i] - ZOffset >> Rotation) + ZOffset;
            if (Trace(HitLocation, HitNormal, tryPlace, location + ZOffset, FALSE, Extent, , ) != None)
            {
                continue;
            }
            if (!ExitingDriver.SetLocation(tryPlace, ))
            {
                continue;
            }
            return TRUE;
        }
    }
    else
    {
        return FindAutoExit(ExitingDriver);
    }
    return FALSE;
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc);

public function PlayerChangedTeam()
{
    if (Driver != None)
    {
        Driver.KilledBy(Driver);
    }
    else
    {
        Super.PlayerChangedTeam();
    }
}
public function PossessedBy(Controller C, bool bVehicleTransition)
{
    Super.PossessedBy(C, bVehicleTransition);
    EntryAnnouncement(C);
    NetPriority = 3.0;
    NetUpdateFrequency = 100.0;
    ThrottleTime = WorldInfo.TimeSeconds;
    OnlySteeringStartTime = WorldInfo.TimeSeconds;
}
public simulated function SetBaseEyeheight()
{
    BaseEyeHeight = default.BaseEyeHeight;
    EyeHeight = BaseEyeHeight;
}
public simulated function SetDriving(bool B)
{
    if (bDriving != B)
    {
        bDriving = B;
        DrivingStatusChanged();
    }
}
public simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    Rise = InUp;
}
public function Controller SetKillInstigator(Controller instigatedBy, Class<DamageType> DamageType)
{
    return instigatedBy;
}
public function Suicide()
{
    if (Driver != None)
    {
        Driver.KilledBy(Driver);
    }
    else
    {
        KilledBy(Self);
    }
}
public function ThrowActiveWeapon();

public function bool TryExitPos(Pawn ExitingDriver, Vector ExitPos, bool bMustFindGround)
{
    local Vector Slice;
    local Vector HitLocation;
    local Vector HitNormal;
    local Vector StartLocation;
    local Vector NewActorPos;
    local Actor HitActor;
    
    Slice = ExitingDriver.GetCollisionRadius() * vect(1.0, 1.0, 0.0);
    Slice.Z = 2.0;
    StartLocation = GetTargetLocation();
    if (Trace(HitLocation, HitNormal, ExitPos, StartLocation, FALSE, Slice, , ) != None)
    {
        return FALSE;
    }
    HitActor = Trace(HitLocation, HitNormal, ExitPos - ExitingDriver.GetCollisionHeight() * vect(0.0, 0.0, 5.0), ExitPos, TRUE, Slice, , );
    if (HitActor == None)
    {
        if (bMustFindGround)
        {
            return FALSE;
        }
        HitLocation = ExitPos;
    }
    NewActorPos = HitLocation + (ExitingDriver.GetCollisionHeight() + ExitingDriver.MaxStepHeight) * vect(0.0, 0.0, 1.0);
    if (PointCheckComponent(Mesh, NewActorPos, ExitingDriver.GetCollisionExtent()))
    {
        return FALSE;
    }
    return ExitingDriver.SetLocation(NewActorPos, );
}
public function bool TryToDrive(Pawn P)
{
    if (!CanEnterVehicle(P))
    {
        return FALSE;
    }
    return DriverEnter(P);
}
public function UnPossessed()
{
    NetPriority = default.NetPriority;
    bForceNetUpdate = TRUE;
    NetUpdateFrequency = 8.0;
    Super.UnPossessed();
}
public simulated function ZeroMovementVariables()
{
    Super.ZeroMovementVariables();
    Steering = 0.0;
    Rise = 0.0;
    Throttle = 0.0;
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        bDriving;
    if (bNetDirty && (bNetOwner || Driver == None || !Driver.bHidden) && Role == ENetRole.ROLE_Authority)
        Driver;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CrushedDamageType = Class'DmgType_Crushed'
    MomentumMult = 1.0
    MinCrushSpeed = 20.0
    ForceCrushPenetration = 10.0
    TurnTime = 2.0
    bAttachDriver = TRUE
    bRetryPathfindingWithDriver = TRUE
    bDoExtraNetRelevancyTraces = TRUE
    LandMovementState = 'PlayerDriving'
    CylinderComponent = CollisionCylinder
    bCanBeBaseForPawns = TRUE
    bDontPossess = TRUE
    bPathfindsAsVehicle = TRUE
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}
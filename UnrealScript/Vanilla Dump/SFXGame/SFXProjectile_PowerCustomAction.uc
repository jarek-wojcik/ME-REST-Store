Class SFXProjectile_PowerCustomAction extends SFXProjectile_Explosive
    native
    nativereplication
    config(Game);

struct native ReplicatedPowerProjInit 
{
    var Vector location;
    var Vector Direction;
    var Actor Caster;
    var Actor TargetActor;
    var float TravelSpeed;
    var float Radius;
    var int Power;
    var byte Trigger;
};

var transient array<Name> SentNofications;
var transient repnotify ReplicatedPowerProjInit ReplicatedPowerProjInitInfo;
var transient Vector LastLocation;
var transient Vector TargetLocation;
var transient Vector CameraLocation;
var transient Rotator CameraRotation;
var transient clearcrosslevel SFXPowerCustomAction Power;
var transient BioPawn Caster;
var transient int ReservationID;
var transient int ImpactedCount;
var transient Actor TargetActor;
var repnotify float ReplicatedTravelSpeed;
var transient Actor TouchedActor;
var float PassThroughCoverDistSq;
var transient bool bUsePowerReservation;
var transient bool ShowPowerAiming;

public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (IsShuttingDown() || bClientPredictionActive)
    {
        return;
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        ReplicateExplode(HitLocation, HitNormal);
    }
    if (Owner != None && Owner.WorldInfo != None && BioWorldInfo(Owner.WorldInfo).m_oPowerManager != None)
    {
    }
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && !bSuppressExplosionFX)
    {
        SpawnExplosionEffects(HitLocation, HitNormal);
    }
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
    if (Power != None)
    {
        Power.OnPowerDetonated(HitLocation, HitNormal, Self, TouchedActor);
    }
}
public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local SFXPawn_Player PlayerPawn;
    
    if (bShuttingDown || bClientPredictionActive)
    {
        return;
    }
    PlayerPawn = SFXPawn_Player(Owner);
    if (PlayerPawn != None && PlayerPawn.IsInCover() && VSizeSq(location - Owner.location) < PassThroughCoverDistSq && VSizeSq(location - TargetLocation) > PassThroughCoverDistSq)
    {
        SetLocation(location + Velocity * 0.100000001, );
        return;
    }
    TouchedActor = Wall;
    Super.HitWall(HitNormal, Wall, WallComp);
}
public simulated function Init(Vector Direction)
{
    Super.Init(Direction);
    SetRotation(Rotator(Direction));
    Velocity = Speed * Direction;
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
}
public simulated function Recycle()
{
    Super.Recycle();
    Power = default.Power;
    Caster = default.Caster;
    bUsePowerReservation = default.bUsePowerReservation;
    ReservationID = default.ReservationID;
    ImpactedCount = default.ImpactedCount;
    ShowPowerAiming = default.ShowPowerAiming;
    LastLocation = default.LastLocation;
    TargetActor = default.TargetActor;
    TargetLocation = default.TargetLocation;
    CameraLocation = default.CameraLocation;
    CameraRotation = default.CameraRotation;
    ReplicatedTravelSpeed = default.ReplicatedTravelSpeed;
    TouchedActor = None;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedPowerProjInitInfo':
            if (int(LastReplicatedInitInfoTrigger) != int(ReplicatedPowerProjInitInfo.Trigger))
            {
                ReplicatedInitUpdated();
                LastReplicatedInitInfoTrigger = ReplicatedPowerProjInitInfo.Trigger;
            }
            break;
        case 'ReplicatedTravelSpeed':
            ChangeSpeedDynamically(ReplicatedTravelSpeed);
            break;
        default:
            Super.ReplicatedEvent(VarName);
            break;
    }
}
public simulated function ShutDown()
{
    if (bShuttingDown)
    {
        return;
    }
    Super(SFXProjectile).ShutDown();
}
public simulated function Tick(float DeltaTime)
{
    local Vector Extent;
    
    Super(SFXProjectile).Tick(DeltaTime);
    if (ShowPowerAiming && location != LastLocation)
    {
        Extent.X = 2.0;
        Extent.Y = 2.0;
        Extent.Z = 2.0;
        DrawDebugBox(location, Extent, 0, 0, 255, TRUE);
        LastLocation = location;
    }
    UpdateImpactNotifications();
    if (bActive && WorldInfo.TimeSeconds != NetInitTime)
    {
        ReplicatedPowerProjInitInfo.location = location;
        ReplicatedPowerProjInitInfo.Direction = Vector(Rotation) * 1000.0;
        ReplicatedPowerProjInitInfo.TravelSpeed = Speed;
    }
}
public simulated function float GetDamageRadius()
{
    if (Power != None)
    {
        return Power.ImpactRadius.CurrentValue;
    }
    return 0.0;
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if (bShuttingDown || bClientPredictionActive)
    {
        return;
    }
    if (IgnoreOther(Other))
    {
        return;
    }
    if ((StaticMeshActor(Other) != None || DynamicSMActor(Other) != None) && VSize(HitLocation - Caster.location) <= 200.0)
    {
        return;
    }
    TouchedActor = Other;
    Explode(HitLocation, HitNormal);
}
public function bool ProjectileHurtRadius(float InDamageAmount, float InDamageRadius, float Momentum, Vector HurtOrigin, Vector HitNormal);

public simulated function ChangeSpeedDynamically(float NewSpeed)
{
    Speed = NewSpeed;
    MaxSpeed = NewSpeed;
    Velocity = Speed * Vector(Rotation);
    if (Role == ENetRole.ROLE_Authority)
    {
        if (WorldInfo.TimeSeconds == NetInitTime)
        {
            ReplicatedPowerProjInitInfo.TravelSpeed = NewSpeed;
        }
        else
        {
            ReplicatedTravelSpeed = NewSpeed;
        }
    }
}
public final function bool IgnoreOther(Actor Other)
{
    local SFXPawn_Player Player;
    
    if (Caster != None && Caster == Other)
    {
        return TRUE;
    }
    Player = SFXPawn_Player(Instigator);
    if (Player != None && Pawn(Other) != None && Player.IsFriendly(Pawn(Other)))
    {
        return TRUE;
    }
    if (Pawn(Other) == None && StaticMeshActor(Other) == None && DynamicSMActor(Other) == None)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function bool InitializePowerProjectile(Actor oCaster, float fTravelSpeed, float fRadius, SFXPowerCustomAction oPower)
{
    local BioWorldInfo TheWorldInfo;
    local BioPlayerController PlayerController;
    local BioCheatManager CheatManager;
    local Vector vParams;
    
    Caster = BioPawn(oCaster);
    Power = oPower;
    SentNofications.Length = 0;
    DamageRadius = fRadius;
    Speed = fTravelSpeed;
    MaxSpeed = fTravelSpeed;
    if (oPower != None && bClientPredictionTarget == FALSE)
    {
        if (oPower.CE_ProjectileTemplate != None)
        {
            vParams.X = Power.VFXIntensity.CurrentValue;
            vParams.Y = fRadius;
            vParams.Z = fTravelSpeed;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(oPower.CE_ProjectileTemplate, Self, vParams);
        }
    }
    TheWorldInfo = BioWorldInfo(Caster.WorldInfo);
    if (TheWorldInfo != None)
    {
        PlayerController = TheWorldInfo.GetLocalPlayerController();
        if (PlayerController != None)
        {
            CheatManager = BioCheatManager(PlayerController.CheatManager);
            if (CheatManager != None)
            {
                ShowPowerAiming = CheatManager.m_bShowPowerAiming;
            }
        }
    }
    Init(Vector(Rotation));
    ProjectileOwner = Caster;
    return TRUE;
}
public function PawnEvadedPower(BioPawn Pawn, Name Label, float TimeBeforeImpact);

public simulated function ReplicatedInitUpdated()
{
    local SFXPowerCustomAction oPower;
    local BioPawn oCaster;
    
    if (ReplicatedPowerProjInitInfo.Caster != None)
    {
        oCaster = BioPawn(ReplicatedPowerProjInitInfo.Caster);
        oCaster.VerifyCAHasBeenInstanced(132, ReplicatedPowerProjInitInfo.Power);
        oPower = SFXPowerCustomAction(oCaster.PowerCustomActions[ReplicatedPowerProjInitInfo.Power]);
        if (oPower != None)
        {
            if (bPooled)
            {
                if (bActive)
                {
                    Reset();
                }
                Class'SFXObjectPool'.static.ResetActorParticleSystemComponents(Self);
                Reuse();
            }
            oPower.OnClientPowerProjectileSpawned(Self);
            TargetActor = ReplicatedPowerProjInitInfo.TargetActor;
            if (TargetActor != None)
            {
                TargetLocation = TargetActor.location;
            }
            SetLocation(ReplicatedPowerProjInitInfo.location, );
            SetRotation(Rotator(ReplicatedPowerProjInitInfo.Direction * 0.00100000005));
            InitializePowerProjectile(oCaster, ReplicatedPowerProjInitInfo.TravelSpeed, ReplicatedPowerProjInitInfo.Radius, oPower);
            if (LatestExplodeTime > 0.0 && Abs(WorldInfo.TimeSeconds - LatestExplodeTime) < ExplodeTimeOut)
            {
                Explode(ReplicatedExplosionInfo.HitLocation, ReplicatedExplosionInfo.HitNormal);
            }
        }
    }
}
public function ReplicateInit(Vector Direction)
{
    if (Caster != None)
    {
        ReplicatedPowerProjInitInfo.Trigger++;
        ReplicatedPowerProjInitInfo.location = location;
        ReplicatedPowerProjInitInfo.Direction = Vector(Rotation) * 1000.0;
        ReplicatedPowerProjInitInfo.Caster = Caster;
        ReplicatedPowerProjInitInfo.TargetActor = TargetActor;
        ReplicatedPowerProjInitInfo.TravelSpeed = Speed;
        ReplicatedPowerProjInitInfo.Radius = DamageRadius;
        ReplicatedPowerProjInitInfo.Power = Caster.CurrentPowerCustomAction;
        bForceNetUpdate = TRUE;
        NetInitTime = WorldInfo.TimeSeconds;
        InitEventEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
    }
}
public function UpdateImpactNotifications()
{
    local SFXPawn TargetPawn;
    local SFXAI_Core AIController;
    local float Distance;
    local float TimeBeforeImpact;
    local int Index;
    
    if (bClientPredictionActive)
    {
        return;
    }
    if (Power != None)
    {
        TargetPawn = SFXPawn(TargetActor);
        if (TargetPawn != None && TargetPawn.PowerImpactNotifications.Length > 0)
        {
            AIController = SFXAI_Core(TargetPawn.Controller);
            if (AIController != None)
            {
                if (Speed > 0.0)
                {
                    Distance = VSize(TargetPawn.location - location);
                    TimeBeforeImpact = Distance / Speed;
                    for (Index = 0; Index < TargetPawn.PowerImpactNotifications.Length; Index++)
                    {
                        if (SentNofications.Find(TargetPawn.PowerImpactNotifications[Index].Label) == -1)
                        {
                            if (TimeBeforeImpact <= TargetPawn.PowerImpactNotifications[Index].TimeBeforeImpact)
                            {
                                SentNofications.AddItem(TargetPawn.PowerImpactNotifications[Index].Label);
                                AIController.NotifyPendingPowerImpact(TargetPawn.PowerImpactNotifications[Index].Label, TargetPawn.PowerImpactNotifications[Index].TimeBeforeImpact, Power, Self);
                            }
                        }
                    }
                }
            }
        }
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < InitEventEndReplicationTime)
        ReplicatedPowerProjInitInfo;
    if (bNetDirty && ReplicatedTravelSpeed >= float(0) && Role == ENetRole.ROLE_Authority)
        ReplicatedTravelSpeed;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ReplicatedTravelSpeed = -1.0
    PassThroughCoverDistSq = 40000.0
    WwiseDuckEvent = None
    fFuseLength = 8.0
    ExplosionDecal = None
    Speed = 1300.0
    MaxSpeed = 1300.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    LifeSpan = 10.0
    CollisionComponent = CollisionCylinder
}
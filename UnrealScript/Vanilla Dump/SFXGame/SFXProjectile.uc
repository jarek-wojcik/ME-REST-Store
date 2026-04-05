Class SFXProjectile extends Projectile
    native
    nativereplication
    config(Weapon);

const REPLICATION_DURATION = 3.0f;
struct native ReplicatedExplosion 
{
    var Vector HitLocation;
    var Vector HitNormal;
    var byte Trigger;
};
struct native ReplicatedInit 
{
    var Vector Direction;
    var Vector location;
    var float Speed;
    var Pawn Instigator;
    var byte Trigger;
};

var transient repnotify ReplicatedInit ReplicatedInitInfo;
var transient repnotify ReplicatedExplosion ReplicatedExplosionInfo;
var transient clearcrosslevel Actor ProjectileOwner;
var(SFXProjectile) editinline export MeshComponent Mesh;
var editinline export ParticleSystemComponent ProjEffectsTrail;
var editinline export ParticleSystemComponent ProjEffectsHead;
var ParticleSystem ProjEffectsTrailTemplate;
var ParticleSystem ProjEffectsHeadTemplate;
var RvrClientEffectInterface CE_ProjectileTemplate;
var const float ProjEffectsTrailWaitTime;
var float LatestExplodeTime;
var const float ExplodeTimeOut;
var float CoefficientOfRestitution;
var float CoefficientOfFriction;
var float ExplodeSpeedThreshold;
var(Sounds) WwiseEvent BounceSound;
var SFXProjectile TargetProjectile;
var config float PredictionInitialSpeedGain;
var config float PredictionMaxSpeedGain;
var config float PredictionSpeedInterpolationSpeed;
var config float PredictionAccelerationRate;
var transient float NetInitTime;
var float InitEventEndReplicationTime;
var float ExplosionEventEndReplicationTime;
var(Debug) bool bSuppressAudio;
var bool bShuttingDown;
var const bool bArcing;
var bool bBouncing;
var bool bStopAiming;
var config bool bClientPredictProjectile;
var bool bClientPredictionActive;
var bool bClientPredictionTarget;
var bool bGotAPredictionTarget;
var repnotify bool bPooled;
var bool bActive;
var transient byte LastReplicatedInitInfoTrigger;

public simulated function Destroyed()
{
    Super.Destroyed();
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
}
public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (IsShuttingDown() || bClientPredictionActive)
    {
        return;
    }
    SpawnImpactEffect(HitLocation, HitNormal);
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        ReplicateExplode(HitLocation, HitNormal);
    }
}
public simulated function FellOutOfWorld(Class<DamageType> dmgType);

public event function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    if (bShuttingDown || bClientPredictionActive)
    {
        return;
    }
    if (bBouncing)
    {
        Bounce(Wall, location, HitNormal);
    }
    else
    {
        ImpactedActor = Wall;
        if (!Wall.bStatic && !Wall.bWorldGeometry)
        {
            if (DamageRadius == float(0))
            {
                Wall.TakeDamage(Damage, InstigatorController, location, GetMomentum() * Normal(Velocity), MyDamageType, , Self);
            }
        }
        Explode(location, HitNormal);
        ImpactedActor = None;
        ShutDown();
    }
}
public simulated function Init(Vector Direction)
{
    Super.Init(Direction);
    if (Instigator != None)
    {
        if (Instigator.Weapon != None)
        {
            ProjectileOwner = Instigator.Weapon;
        }
        else
        {
            ProjectileOwner = Instigator;
        }
    }
    else
    {
        ProjectileOwner = None;
    }
    if (bClientPredictionActive)
    {
        SetPredictedInitialSpeed();
    }
    if (!bClientPredictionTarget)
    {
        SpawnFlightEffects();
    }
    if (Role == ENetRole.ROLE_Authority)
    {
        ReplicateInit(Direction);
    }
    bActive = TRUE;
}
public simulated function OutsideWorldBounds()
{
    Reset();
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    ClientEffects.PrimeClass(default.Class);
}
public event simulated function Recycle()
{
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
    bShuttingDown = FALSE;
    bSuppressAudio = default.bSuppressAudio;
    bClientPredictProjectile = default.bClientPredictProjectile;
    bClientPredictionActive = default.bClientPredictionActive;
    bClientPredictionTarget = default.bClientPredictionTarget;
    bGotAPredictionTarget = default.bGotAPredictionTarget;
    TargetProjectile = None;
    bStopAiming = FALSE;
    GotoState(InitialState != 'None' ? InitialState : 'Auto', , , );
    ClearTimer('ShutdownPostEffects');
    SetCollision(FALSE, FALSE, );
    SetPhysics(7);
    Speed = default.Speed;
    SetHidden(TRUE);
    if (ProjEffectsTrail == None && ProjEffectsTrailTemplate != None || ProjEffectsHead == None && ProjEffectsHeadTemplate != None)
    {
        SpawnFlightEffects();
    }
    if (ProjEffectsTrail != None)
    {
        ProjEffectsTrail.__OnSystemFinished__Delegate = None;
        ProjEffectsTrail.KillParticlesForced();
        ProjEffectsTrail.DeactivateSystem();
    }
    if (ProjEffectsHead != None)
    {
        ProjEffectsHead.__OnSystemFinished__Delegate = None;
        ProjEffectsHead.KillParticlesForced();
        ProjEffectsHead.DeactivateSystem();
    }
    SetOwner(None);
    Self.Instigator = None;
    Self.InstigatorController = None;
    LifeSpan = 0.0;
    SetTickIsDisabled(TRUE);
}
public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedInitInfo':
            if (int(LastReplicatedInitInfoTrigger) != int(ReplicatedInitInfo.Trigger))
            {
                ReplicatedInitUpdated();
                LastReplicatedInitInfoTrigger = ReplicatedInitInfo.Trigger;
            }
            break;
        case 'ReplicatedExplosionInfo':
            ReplicatedExplosionUpdated();
            break;
        case 'bPooled':
            if (bPooled == TRUE && bActive == FALSE)
            {
                Recycle();
            }
            break;
        default:
            Super(Actor).ReplicatedEvent(VarName);
            break;
    }
}
public simulated function Reset()
{
    bActive = FALSE;
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
    if (bPooled)
    {
        Recycle();
    }
    else
    {
        Super.Reset();
    }
}
public final event simulated function Reuse()
{
    if (bPooled)
    {
        SetCollision(default.bCollideActors, default.bBlockActors, );
        SetPhysics(6);
        SetProjectileHidden(FALSE);
        SetHidden(FALSE);
        LifeSpan = default.LifeSpan;
        SetTickIsDisabled(FALSE);
        GotoState(InitialState != 'None' ? InitialState : 'Auto', , , );
    }
}
public simulated function ShutDown()
{
    if (bShuttingDown)
    {
        return;
    }
    if (bClientPredictionActive)
    {
        SetPrediction(FALSE, FALSE);
    }
    bShuttingDown = TRUE;
    SetCollision(FALSE, FALSE, );
    SetProjectileHidden(TRUE);
    SetPhysics(7);
    if (ProjEffectsHead != None)
    {
        ProjEffectsHead.SetActive(FALSE);
    }
    if (ProjEffectsTrail != None && ProjEffectsTrail.bIsActive)
    {
        ProjEffectsTrail.SetActive(FALSE);
        SetTimer(ProjEffectsTrailWaitTime, FALSE, 'ShutdownPostEffects', );
        LifeSpan = 0.0;
    }
    else
    {
        ShutdownPostEffects();
    }
}
public simulated function SpawnImpactEffect(Vector HitLocation, Vector HitNormal);

public simulated function Tick(float DeltaTime)
{
    Super(Actor).Tick(DeltaTime);
    if (!bStopAiming && bArcing)
    {
        Velocity.Z += WorldInfo.GetGravityZ() * DeltaTime;
    }
    if (bActive && WorldInfo.TimeSeconds != NetInitTime)
    {
        ReplicatedInitInfo.location = location;
        ReplicatedInitInfo.Direction = Vector(Rotation) * 1000.0;
        ReplicatedInitInfo.Speed = Speed;
    }
    if (bClientPredictionActive)
    {
        Tick_Prediction(DeltaTime);
    }
}
public simulated function float GetDamageRadius()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(ProjectileOwner);
    if (Weapon != None)
    {
        return Weapon.GetDamageType().default.DamageRadius;
    }
    return 0.0;
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if (bShuttingDown || bClientPredictionActive)
    {
        return;
    }
    if (bBouncing)
    {
        if (SFXPawn_Player(Instigator) != None && SFXPawn_Henchman(Other) != None)
        {
            return;
        }
        if (Pawn(Other) == None && StaticMeshActor(Other) == None && BioPhysicsActor(Other) == None && DynamicSMActor(Other) == None)
        {
            return;
        }
        if (StaticMeshActor(Other) != None || BioPhysicsActor(Other) != None || DynamicSMActor(Other) != None)
        {
            if (VSizeSq(location - Owner.location) < float(40000))
            {
                return;
            }
        }
        Bounce(Other, HitLocation, HitNormal);
    }
    else if (Other != Instigator)
    {
        if (SFXPawn_Player(Instigator) == None || SFXPawn_Henchman(Other) == None)
        {
            Explode(HitLocation, HitNormal);
            ShutDown();
        }
    }
}
public simulated function ApplyExternalForce()
{
    bStopAiming = TRUE;
    bReplicateMovement = default.bReplicateMovement;
    bUpdateSimulatedPosition = default.bUpdateSimulatedPosition;
}
public simulated function Bounce(Actor HitActor, Vector HitLocation, Vector HitNormal)
{
    local float EnergyLost;
    
    bReplicateMovement = TRUE;
    bUpdateSimulatedPosition = TRUE;
    SetLocation(location + HitNormal * float(1), );
    if (HitNormal Dot Normal(Velocity) > float(0))
    {
        return;
    }
    ImpactedActor = HitActor;
    EnergyLost = Lerp(CoefficientOfFriction, CoefficientOfRestitution, Abs(Normal(Velocity) Dot HitNormal));
    Velocity -= HitNormal * (Velocity Dot HitNormal) * float(2);
    Velocity *= float(1) - EnergyLost;
    Speed = VSize(Velocity);
    if (Velocity.Z > float(400))
    {
        Velocity.Z = 0.5 * (float(400) + Velocity.Z);
    }
    if (ExplodeSpeedThreshold > float(0))
    {
        if (Speed < ExplodeSpeedThreshold)
        {
            Explode(location, HitNormal);
            if (IsShuttingDown() == FALSE)
            {
                ShutDown();
            }
        }
        else if (BounceSound != None)
        {
            PlaySound(BounceSound);
        }
    }
    else if (BounceSound != None)
    {
        PlaySound(BounceSound);
    }
}
public simulated function float GetDamage()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(ProjectileOwner);
    if (Weapon != None)
    {
        return Weapon.GetFireModeBaseDamage();
    }
    return 0.0;
}
public simulated function float GetMomentum()
{
    local SFXWeapon Weapon;
    local int FireMode;
    
    Weapon = SFXWeapon(ProjectileOwner);
    if (Weapon != None)
    {
        FireMode = int(Weapon.DefaultFireMode);
        return Weapon.InstantHitMomentum[FireMode];
    }
    return MomentumTransfer;
}
public final simulated function bool IsShuttingDown()
{
    return bShuttingDown;
}
public static function bool IsTargettedProjectile()
{
    return FALSE;
}
private final simulated function ProjEffectsTrailFinished(ParticleSystemComponent PSC)
{
    if (PSC == ProjEffectsTrail)
    {
        if (bShuttingDown)
        {
            SetTimer(0.00100000005, FALSE, 'ShutdownPostEffects', );
        }
    }
}
public simulated function ReplicatedExplosionUpdated()
{
    if (bActive)
    {
        Explode(ReplicatedExplosionInfo.HitLocation, ReplicatedExplosionInfo.HitNormal);
        LatestExplodeTime = 0.0;
    }
    else
    {
        LatestExplodeTime = WorldInfo.TimeSeconds;
    }
    if (IsShuttingDown() == FALSE)
    {
        ShutDown();
    }
}
public simulated function ReplicatedInitUpdated()
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
    Instigator = ReplicatedInitInfo.Instigator;
    if (Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy && SFXWeapon(Instigator.Weapon) != None)
    {
        SFXWeapon(Instigator.Weapon).OnClientProjectileSpawned(Self);
    }
    SetLocation(ReplicatedInitInfo.location, );
    Speed = ReplicatedInitInfo.Speed;
    Init(ReplicatedInitInfo.Direction * 0.00100000005);
    if (LatestExplodeTime > 0.0 && Abs(WorldInfo.TimeSeconds - LatestExplodeTime) < ExplodeTimeOut)
    {
        Explode(ReplicatedExplosionInfo.HitLocation, ReplicatedExplosionInfo.HitNormal);
    }
}
public function ReplicateExplode(Vector HitLocation, Vector HitNormal)
{
    ReplicatedExplosionInfo.Trigger++;
    ReplicatedExplosionInfo.HitLocation = HitLocation;
    ReplicatedExplosionInfo.HitNormal = HitNormal;
    bForceNetUpdate = TRUE;
    ExplosionEventEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
}
public function ReplicateInit(Vector Direction)
{
    ReplicatedInitInfo.Trigger++;
    ReplicatedInitInfo.location = location;
    ReplicatedInitInfo.Direction = Direction * 1000.0;
    ReplicatedInitInfo.Speed = Speed;
    ReplicatedInitInfo.Instigator = Instigator;
    bForceNetUpdate = TRUE;
    NetInitTime = WorldInfo.TimeSeconds;
    InitEventEndReplicationTime = WorldInfo.TimeSeconds + 3.0;
}
public final function SetPredictedInitialSpeed()
{
    Speed = FClamp(Speed * PredictionInitialSpeedGain, 0.0, MaxSpeed);
    Velocity = Speed * Vector(Rotation);
}
public final simulated function SetPrediction(bool Active, bool bIsATarget)
{
    if (bIsATarget == TRUE && Role == ENetRole.ROLE_SimulatedProxy)
    {
        if (Active)
        {
            SetProjectileHidden(TRUE);
            SetHidden(TRUE);
            bClientPredictionTarget = TRUE;
        }
        else
        {
            SetProjectileHidden(FALSE);
            SetHidden(FALSE);
            bClientPredictionTarget = FALSE;
        }
    }
    else if (Role == ENetRole.ROLE_Authority)
    {
        if (Active && !bClientPredictionActive)
        {
            SetCollision(FALSE, FALSE, );
            bCollideWhenPlacing = FALSE;
            bCollideWorld = FALSE;
            bBlockActors = FALSE;
            bNoEncroachCheck = TRUE;
            LifeSpan = 20.0;
            bClientPredictionActive = TRUE;
        }
        else if (!Active && bClientPredictionActive)
        {
            TargetProjectile = None;
            SetCollision(default.bCollideActors, default.bBlockActors, );
            bCollideWhenPlacing = default.bCollideWhenPlacing;
            bCollideWorld = default.bCollideWorld;
            bBlockActors = default.bBlockActors;
            bNoEncroachCheck = default.bNoEncroachCheck;
            LifeSpan = default.LifeSpan;
            bClientPredictionActive = FALSE;
        }
    }
}
public final function SetPredictionTarget(SFXProjectile NewTargetProjectile)
{
    if (!bActive || bShuttingDown)
    {
        return;
    }
    if (NewTargetProjectile != None)
    {
        bGotAPredictionTarget = TRUE;
    }
    else
    {
        bGotAPredictionTarget = FALSE;
    }
    TargetProjectile = NewTargetProjectile;
}
public simulated function SetProjectileHidden(bool bHide)
{
    if (Mesh != None)
    {
        Mesh.SetHidden(bHide);
    }
}
public simulated function ShutdownPostEffects()
{
    Reset();
}
private final simulated function SpawnFlightEffects()
{
    local int idx;
    local Vector Params;
    
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer)
    {
        if (CE_ProjectileTemplate != None)
        {
            Params.X = 1.0;
            Params.Y = DamageRadius;
            Params.Z = Speed;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(CE_ProjectileTemplate, Self, Params);
        }
        if (ProjEffectsTrail == None && ProjEffectsTrailTemplate != None)
        {
            ProjEffectsTrail = new (Self) Class'ParticleSystemComponent';
            ProjEffectsTrail.bAutoActivate = FALSE;
            ProjEffectsTrail.bUpdateComponentInTick = TRUE;
            ProjEffectsTrail.SetTemplate(ProjEffectsTrailTemplate);
            for (idx = 0; idx < ProjEffectsTrail.EmitterInstances.Length; ++idx)
            {
                ProjEffectsTrail.SetKillOnDeactivate(idx, FALSE);
                ProjEffectsTrail.SetKillOnCompleted(idx, FALSE);
            }
            Self.AttachComponent(ProjEffectsTrail);
        }
        if (ProjEffectsHead == None && ProjEffectsHeadTemplate != None)
        {
            ProjEffectsHead = new (Self) Class'ParticleSystemComponent';
            ProjEffectsHead.bAutoActivate = FALSE;
            ProjEffectsHead.bUpdateComponentInTick = TRUE;
            ProjEffectsHead.SetTemplate(ProjEffectsHeadTemplate);
            if (ProjEffectsHead.Template.bUseFixedRelativeBoundingBox == FALSE)
            {
                SetBioRwBox(ProjEffectsHead.Template.FixedRelativeBoundingBox, vect(-32.0, -32.0, -32.0), vect(32.0, 32.0, 32.0));
                ProjEffectsHead.Template.bUseFixedRelativeBoundingBox = TRUE;
            }
            for (idx = 0; idx < ProjEffectsHead.EmitterInstances.Length; ++idx)
            {
                ProjEffectsHead.SetKillOnDeactivate(idx, FALSE);
                ProjEffectsHead.SetKillOnCompleted(idx, FALSE);
            }
            Self.AttachComponent(ProjEffectsHead);
        }
        if (ProjEffectsTrail != None)
        {
            ProjEffectsTrail.SetAbsolute(FALSE, FALSE, FALSE);
            ProjEffectsTrail.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
            ProjEffectsTrail.__OnSystemFinished__Delegate = ProjEffectsTrailFinished;
            ProjEffectsTrail.SetActive(TRUE);
        }
        if (ProjEffectsHead != None)
        {
            ProjEffectsHead.SetAbsolute(FALSE, FALSE, FALSE);
            ProjEffectsHead.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
            ProjEffectsHead.__OnSystemFinished__Delegate = None;
            ProjEffectsHead.SetActive(TRUE);
        }
    }
}
public function Tick_Prediction(float DeltaTime)
{
    local float DesiredSpeed;
    
    DesiredSpeed = FClamp(Speed * PredictionAccelerationRate, 0.0, MaxSpeed * PredictionMaxSpeedGain);
    if (bGotAPredictionTarget)
    {
        if (TargetProjectile != None && TargetProjectile.bActive == TRUE && TargetProjectile.IsShuttingDown() == FALSE)
        {
            if ((location - TargetProjectile.location) Dot TargetProjectile.Velocity <= 0.0)
            {
                DesiredSpeed = TargetProjectile.Speed;
            }
        }
        else
        {
            TargetProjectile = None;
            if (IsShuttingDown() == FALSE)
            {
                ShutDown();
                return;
            }
        }
    }
    if (Speed != DesiredSpeed)
    {
        Speed = FInterpTo(Speed, DesiredSpeed, DeltaTime, PredictionSpeedInterpolationSpeed);
        Velocity = Speed * Vector(Rotation);
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        bPooled;
    if (bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < InitEventEndReplicationTime)
        ReplicatedInitInfo;
    if (bNetDirty && Role == ENetRole.ROLE_Authority && WorldInfo.TimeSeconds < ExplosionEventEndReplicationTime)
        ReplicatedExplosionInfo;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ProjEffectsTrailWaitTime = 10.0
    ExplodeTimeOut = 0.200000003
    CoefficientOfRestitution = 0.100000001
    CoefficientOfFriction = 0.100000001
    PredictionInitialSpeedGain = 0.400000006
    PredictionMaxSpeedGain = 0.800000012
    PredictionSpeedInterpolationSpeed = 28.0
    PredictionAccelerationRate = 1.00999999
    CylinderComponent = CollisionCylinder
    Components = (None, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bNetTemporary = FALSE
    bAlwaysRelevant = TRUE
    bReplicateMovement = FALSE
}
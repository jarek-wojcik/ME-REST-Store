Class Projectile extends Actor
    native
    abstract;

var delegate<OnExplode> __OnExplode__Delegate;
var Class<DamageType> MyDamageType;
var float Speed;
var float MaxSpeed;
var Actor ZeroCollider;
var editinline export PrimitiveComponent ZeroColliderComponent;
var float Damage;
var float DamageRadius;
var float MomentumTransfer;
var SoundCue SpawnSound;
var SoundCue ImpactSound;
var Controller InstigatorController;
var Actor ImpactedActor;
var float NetCullDistanceSquared;
var editinline export CylinderComponent CylinderComponent;
var Projectile NextProjectile;
var bool bSwitchToZeroCollision;
var bool bBlockedByInstigator;
var bool bBegunPlay;
var bool bRotationFollowsVelocity;
var bool bNotBlockedByShield;

public simulated function Destroyed()
{
    local Projectile CurrentProj;
    
    Super.Destroyed();
    CurrentProj = WorldInfo.ProjectileList;
    if (CurrentProj == Self)
    {
        WorldInfo.ProjectileList = NextProjectile;
    }
    else
    {
        while (CurrentProj != None)
        {
            if (CurrentProj.NextProjectile == Self)
            {
                CurrentProj.NextProjectile = NextProjectile;
                break;
            }
            CurrentProj = CurrentProj.NextProjectile;
        }
    }
}
public event simulated function EncroachedBy(Actor Other)
{
    HitWall(Normal(location - Other.location), Other, None);
}
public event function bool EncroachingOn(Actor Other)
{
    if (Brush(Other) != None)
    {
        return TRUE;
    }
    return FALSE;
}
public simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    if (Damage > float(0) && DamageRadius > float(0))
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            MakeNoise(1.0, );
        }
        ProjectileHurtRadius(Damage, DamageRadius, 1.0, HitLocation, HitNormal);
    }
    if (__OnExplode__Delegate != None)
    {
        __OnExplode__Delegate(Self);
        __OnExplode__Delegate = None;
    }
    Destroy();
}
public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    Explode(location, vect(0.0, 0.0, 1.0));
}
public simulated native function byte GetTeamNum();

public event singular function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local KActorFromStatic NewKActor;
    local StaticMeshComponent HitStaticMesh;
    
    Super.HitWall(HitNormal, Wall, WallComp);
    if (Wall.bWorldGeometry)
    {
        HitStaticMesh = StaticMeshComponent(WallComp);
        if (HitStaticMesh != None && HitStaticMesh.CanBecomeDynamic())
        {
            NewKActor = Class'KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
            if (NewKActor != None)
            {
                Wall = NewKActor;
            }
        }
    }
    ImpactedActor = Wall;
    if (!Wall.bStatic && DamageRadius == float(0))
    {
        Wall.TakeDamage(Damage, InstigatorController, location, MomentumTransfer * Normal(Velocity), MyDamageType, , Self);
    }
    Explode(location, HitNormal);
    ImpactedActor = None;
}
public simulated function Init(Vector Direction)
{
    SetRotation(Rotator(Direction));
    Velocity = Speed * Direction;
}
public delegate function OnExplode(Projectile pProjectile);

public event simulated function PostBeginPlay()
{
    bBegunPlay = TRUE;
    NextProjectile = WorldInfo.ProjectileList;
    WorldInfo.ProjectileList = Self;
}
public event function PreBeginPlay()
{
    if (Instigator != None)
    {
        InstigatorController = Instigator.Controller;
    }
    Super.PreBeginPlay();
    if (!bDeleteMe && InstigatorController != None && InstigatorController.ShotTarget != None && InstigatorController.ShotTarget.Controller != None)
    {
        InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning(Self);
    }
}
public simulated function Reset()
{
    Destroy();
}
public event singular simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (Other == None || Other.bDeleteMe)
    {
        return;
    }
    if (Other.StopsProjectile(Self) && (Role == ENetRole.ROLE_Authority || bBegunPlay) && (bBlockedByInstigator || Other != Instigator))
    {
        ImpactedActor = Other;
        ProcessTouch(Other, HitLocation, HitNormal);
        ImpactedActor = None;
    }
}
public simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
    Super.ApplyFluidSurfaceImpact(Fluid, HitLocation);
    if (CanSplash())
    {
        if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && Instigator != None && Instigator.IsPlayerPawn() && Instigator.IsLocallyControlled())
        {
            WorldInfo.MyEmitterPool.SpawnEmitter(Fluid.ProjectileEntryEffect, HitLocation, Rotator(vect(0.0, 0.0, 1.0)), Self);
        }
    }
}
public simulated function bool CanSplash()
{
    return bBegunPlay;
}
public simulated function bool HurtRadius(float DamageAmount, float InDamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = Instigator != None ? Instigator.Controller : None, optional bool bDoFullDamage)
{
    local bool bCausedDamage;
    local bool bResult;
    
    if (bHurtEntry)
    {
        return FALSE;
    }
    bCausedDamage = FALSE;
    if (InstigatedByController == None)
    {
        InstigatedByController = InstigatorController;
    }
    if (ImpactedActor != None && ImpactedActor != Self)
    {
        ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, TRUE, Self);
        bCausedDamage = ImpactedActor.bProjTarget;
    }
    bResult = Super.HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
    return bResult || bCausedDamage;
}
public function bool IsStationary()
{
    return FALSE;
}
public static simulated function float GetRange()
{
    if (default.LifeSpan == 0.0)
    {
        return 15000.0;
    }
    else
    {
        return default.MaxSpeed * default.LifeSpan;
    }
}
public simulated function float GetTimeToLocation(Vector TargetLoc)
{
    return VSize(TargetLoc - location) / Speed;
}
public function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if (Other != Instigator)
    {
        Explode(HitLocation, HitNormal);
    }
}
public function bool ProjectileHurtRadius(float inDamage, float InRadius, float InMomentum, Vector HurtOrigin, Vector HitNormal)
{
    local Vector AltOrigin;
    local Vector TraceHitLocation;
    local Vector TraceHitNormal;
    local Actor TraceHitActor;
    
    if (bHurtEntry)
    {
        return FALSE;
    }
    AltOrigin = HurtOrigin;
    if (ImpactedActor != None && ImpactedActor.bWorldGeometry)
    {
        AltOrigin = HurtOrigin + 2.0 * Class'Pawn'.default.MaxStepHeight * HitNormal;
        TraceHitActor = Trace(TraceHitLocation, TraceHitNormal, AltOrigin, HurtOrigin, FALSE, , , 1);
        if (TraceHitActor == None)
        {
            AltOrigin = HurtOrigin + Class'Pawn'.default.MaxStepHeight * HitNormal;
        }
        else
        {
            AltOrigin = HurtOrigin + 0.5 * (TraceHitLocation - HurtOrigin);
        }
    }
    return HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, AltOrigin);
}
public final simulated function RandSpin(float spinRate)
{
    RotationRate.Yaw = int(spinRate * float(2) * FRand() - spinRate);
    RotationRate.Pitch = int(spinRate * float(2) * FRand() - spinRate);
    RotationRate.Roll = int(spinRate * float(2) * FRand() - spinRate);
}
public static simulated function float StaticGetTimeToLocation(Vector TargetLoc, Vector StartLoc, Controller RequestedBy)
{
    return VSize(TargetLoc - StartLoc) / default.Speed;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 0.0
        CollisionRadius = 0.0
        ReplacementPrimitive = None
    End Object
    MyDamageType = Class'DamageType'
    Speed = 2000.0
    MaxSpeed = 2000.0
    DamageRadius = 220.0
    NetCullDistanceSquared = 400000000.0
    CylinderComponent = CollisionCylinder
    bBlockedByInstigator = TRUE
    Components = (None, CollisionCylinder)
    NetPriority = 2.5
    LifeSpan = 14.0
    CollisionComponent = CollisionCylinder
    bNetTemporary = TRUE
    bReplicateInstigator = TRUE
    bGameRelevant = TRUE
    bCanBeDamaged = TRUE
    bCollideActors = TRUE
    bCollideWorld = TRUE
    Physics = EPhysics.PHYS_Projectile
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}
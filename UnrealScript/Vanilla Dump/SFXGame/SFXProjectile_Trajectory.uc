Class SFXProjectile_Trajectory extends Projectile
    native;

public event simulated function Destroyed()
{
    ScriptTrace();
    Super.Destroyed();
}
public simulated function Explode(Vector HitLocation, Vector HitNormal);

public event singular function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp);

public simulated function PostBeginPlay()
{
    local ParticleSystemComponent PSC;
    
    foreach ComponentList(Class'ParticleSystemComponent', PSC)
    {
        PSC.SetActorParameter('FollowActor', Self);
    }
}
public native function RunPhysicsSimulationTilEnd(float GrenadeLifeSpan);

public function Tick(float DeltaTime)
{
    RunPhysicsSimulationTilEnd(5.0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ParticleSystemComponent Name=PSCTrail0
        ReplacementPrimitive = None
    End Object
    Speed = 3000.0
    MaxSpeed = 3000.0
    MomentumTransfer = 100.0
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, PSCTrail0)
    LifeSpan = 0.0
    CollisionComponent = CollisionCylinder
    bNetInitialRotation = TRUE
    bBounce = TRUE
    Physics = EPhysics.PHYS_Falling
    RemoteRole = ENetRole.ROLE_None
    TickGroup = ETickingGroup.TG_PostAsyncWork
}
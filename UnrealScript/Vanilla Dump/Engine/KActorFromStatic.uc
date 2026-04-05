Class KActorFromStatic extends KActor
    native;

var Actor MyStaticMeshActor;
var float MaxImpulseSpeed;

public event function ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo, optional Class<DamageType> DamageType)
{
    local float BodyMass;
    
    BodyMass = StaticMeshComponent.BodyInstance.GetBodyMass();
    if (BodyMass > 0.0 && (DamageType == None || !DamageType.default.bRadialDamageVelChange))
    {
        if (BodyMass < 1.0)
        {
            BodyMass = Sqrt(BodyMass);
        }
        ImpulseMag = FMin(ImpulseMag / BodyMass, MaxImpulseSpeed);
    }
    CollisionComponent.AddImpulse(Normal(ImpulseDir) * ImpulseMag, HitLocation, , TRUE);
}
public event function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    local Vector HitDir;
    local float ImpulseMag;
    
    HitDir = location - Other.location;
    HitDir.Z = FMax(HitDir.Z, 0.0);
    HitDir = Normal(HitDir);
    ImpulseMag = FMax(0.5 * Pawn(Other).GroundSpeed, (Other.Velocity - Velocity) Dot HitDir);
    ApplyImpulse(HitDir, ImpulseMag, location);
}
public static native function KActorFromStatic MakeDynamic(StaticMeshComponent MovableMesh);

public static native function MakeStatic();

public event function OnSleepRBPhysics()
{
    SetTimer(3.0, FALSE, 'BecomeStatic', );
}
public event function OnWakeRBPhysics()
{
    ClearTimer('BecomeStatic');
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    local int idx;
    local SeqEvent_TakeDamage DmgEvt;
    
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        DmgEvt = SeqEvent_TakeDamage(GeneratedEvents[idx]);
        if (DmgEvt != None)
        {
            DmgEvt.HandleDamage(Self, instigatedBy, DamageType, BaseDamage);
        }
    }
    if (bDamageAppliesImpulse && DamageType.default.RadialDamageImpulse > float(0) && Role == ENetRole.ROLE_Authority)
    {
        ApplyImpulse(location - HurtOrigin, DamageType.default.RadialDamageImpulse, location, , DamageType);
    }
}
public function BecomeStatic()
{
    if (StaticMeshComponent.RigidBodyIsAwake())
    {
        return;
    }
    MakeStatic();
    Destroy();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxImpulseSpeed = 900.0
    StaticMeshComponent = None
    LightEnvironment = None
    Components = ()
    CollisionComponent = None
    bNoDelete = FALSE
    bCallRigidBodyWakeEvents = TRUE
}
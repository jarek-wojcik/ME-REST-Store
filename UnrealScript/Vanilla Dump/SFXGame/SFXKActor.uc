Class SFXKActor extends KActor
    native
    placeable;

var transient float m_fPhysicsSoundLastTimePlayed;
var transient Actor m_aLastCollidedActor;
var(Physics) bool bImmovable;
var(Physics) bool bKinematicUntilMoved;

public event function ExceededPhysicsThreshold(Actor instigatedBy)
{
    Super(Actor).ExceededPhysicsThreshold(instigatedBy);
    SetPhysics(10);
}
public native function ImpulseFragments(Vector Source, Vector Momentum, Vector Extent, optional bool bVelChange);

public event simulated function TakeDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (VSize(Momentum) * DamageType.default.KDamageImpulse > m_fPhysicsThreshold)
    {
        ExceededPhysicsThreshold(instigatedBy);
    }
    else
    {
        Momentum = vect(0.0, 0.0, 0.0);
    }
    Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    if (Momentum * DamageType.default.KDamageImpulse > m_fPhysicsThreshold)
    {
        ExceededPhysicsThreshold(instigatedBy);
    }
    else
    {
        Momentum = 0.0;
    }
    Super.TakeRadiusDamage(instigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent, HitInfo);
}
public simulated function bool ImpactWithPower(EPowerResistance Resistance, Pawn Caster, Vector HitLocation, Vector HitNormal, float Damage, Vector Force, Class<DamageType> DamageType)
{
    if (Damage > float(0))
    {
        TakeDamage(Damage, Caster.Controller, HitLocation, vect(0.0, 0.0, 0.0), DamageType, , Caster);
    }
    if (VSize(Force) > float(0) && bImmovable == FALSE && CollisionComponent != None)
    {
        CollisionComponent.AddForce(Force, location, 'None');
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    bImmovable = TRUE
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
}
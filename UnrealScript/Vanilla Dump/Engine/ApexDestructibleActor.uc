Class ApexDestructibleActor extends Actor
    native
    placeable;

var init array<byte> VisibilityFactors;
var(ApexDestructibleActor) const editinline editconst export ApexStaticDestructibleComponent StaticDestructibleComponent;

public simulated native function ApexTakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser);

public simulated native function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ApexStaticDestructibleComponent Name=DestructibleComponent0
        ReplacementPrimitive = None
        LightEnvironment = LightEnvironment0
        bAllowApproximateOcclusion = TRUE
        bForceDirectLightMap = TRUE
        bCastDynamicShadow = FALSE
    End Object
    Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironment0
        bEnabled = FALSE
    End Object
    StaticDestructibleComponent = DestructibleComponent0
    Components = (LightEnvironment0, DestructibleComponent0)
    CollisionComponent = DestructibleComponent0
    bNoDelete = TRUE
    bRouteBeginPlayEvenIfStatic = FALSE
    bGameRelevant = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bProjTarget = TRUE
    bNoEncroachCheck = TRUE
    bEdShouldSnap = TRUE
}
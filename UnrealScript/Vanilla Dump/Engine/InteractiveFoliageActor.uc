Class InteractiveFoliageActor extends StaticMeshActor
    native
    placeable;

var transient Vector TouchingActorEntryPosition;
var transient Vector FoliageVelocity;
var transient Vector FoliageForce;
var transient Vector FoliagePosition;
var editinline export CylinderComponent CylinderComponent;
var(FoliagePhysics) float FoliageDamageImpulseScale;
var(FoliagePhysics) float FoliageTouchImpulseScale;
var(FoliagePhysics) float FoliageStiffness;
var(FoliagePhysics) float FoliageStiffnessQuadratic;
var(FoliagePhysics) float FoliageDamping;
var(FoliagePhysics) float MaxDamageImpulse;
var(FoliagePhysics) float MaxTouchImpulse;
var(FoliagePhysics) float MaxForce;
var float Mass;

public event simulated native function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

public event simulated native function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 200.0
        CollisionRadius = 60.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockZeroExtent = FALSE
    End Object
    Begin Object Class=InteractiveFoliageComponent Name=FoliageMeshComponent0
        ReplacementPrimitive = None
        bAllowApproximateOcclusion = TRUE
        bAcceptsStaticDecals = FALSE
        bAcceptsDynamicDecals = FALSE
        bForceDirectLightMap = TRUE
        bUsePrecomputedShadows = TRUE
    End Object
    CylinderComponent = CollisionCylinder
    FoliageDamageImpulseScale = 20.0
    FoliageTouchImpulseScale = 10.0
    FoliageStiffness = 10.0
    FoliageStiffnessQuadratic = 0.300000012
    FoliageDamping = 2.0
    MaxDamageImpulse = 100000.0
    MaxTouchImpulse = 1000.0
    MaxForce = 100000.0
    Mass = 1.0
    StaticMeshComponent = FoliageMeshComponent0
    Components = (FoliageMeshComponent0, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
    bNoDelete = TRUE
    bWorldGeometry = FALSE
    bBlockActors = FALSE
    bProjTarget = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}
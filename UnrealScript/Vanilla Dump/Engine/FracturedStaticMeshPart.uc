Class FracturedStaticMeshPart extends FracturedStaticMeshActor
    native;

var Vector OldVelocity;
var float DestroyPartRadiusFactor;
var transient FracturedStaticMeshActor BaseFracturedMeshActor;
var float LastSpawnTime;
var int PartPoolIndex;
var float FracPartGravScale;
var float CurrentVibrationLevel;
var float LastImpactSoundTime;
var bool bHasBeenRecycled;
var bool bChangeRBChannelWhenAsleep;
var bool bCompositeThatExplodesOnImpact;
var ERBCollisionChannel AsleepRBChannel;

public event simulated function BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{
    if (bCompositeThatExplodesOnImpact)
    {
        Super.BreakOffPartsInRadius(Origin, Radius, RBStrength, bWantPhysChunksAndParticles);
    }
}
public event simulated function Explode()
{
    if (!bHasBeenRecycled)
    {
        Super.Explode();
        RecyclePart(TRUE);
    }
}
public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    RecyclePart(TRUE);
}
public simulated native function Initialize();

public simulated native function RecyclePart(bool bAddToFreePool);

public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    FracturedStaticMeshComponent.AddImpulse(Normal(Momentum) * DamageType.default.KDamageImpulse, HitLocation);
}
public simulated function TryToCleanUp()
{
    if (WorldInfo.TimeSeconds - BaseFracturedMeshActor.SkinnedComponent.LastRenderTime > 1.0)
    {
        RecyclePart(TRUE);
    }
    else
    {
        SetTimer(2.0, FALSE, 'TryToCleanUp', );
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=FracturedStaticMeshComponent Name=FracturedStaticMeshComponent0
        bUseSkinnedRendering = TRUE
        bUseVisibleVertsForBounds = TRUE
        bInitialVisibilityValue = FALSE
        bUseDynamicIndexBuffer = FALSE
        bUseDynamicIBWithHiddenFragments = FALSE
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_FracturedMeshPart
        bAcceptsDynamicDecals = FALSE
        bForceDirectLightMap = FALSE
        bCastDynamicShadow = FALSE
        bUsePrecomputedShadows = FALSE
        BlockZeroExtent = FALSE
        BlockNonZeroExtent = FALSE
        bSkipRBGeomCreation = TRUE
        RBCollideWithChannels = {Default = TRUE, GameplayPhysics = TRUE, EffectPhysics = TRUE, FracturedMeshPart = TRUE}
    End Template
    DestroyPartRadiusFactor = 10.0
    FracPartGravScale = 2.0
    AsleepRBChannel = ERBCollisionChannel.RBCC_GameplayPhysics
    FracturedStaticMeshComponent = FracturedStaticMeshComponent0
    SkinnedComponent = None
    Components = (FracturedStaticMeshComponent0)
    LifeSpan = 15.0
    CollisionComponent = FracturedStaticMeshComponent0
    bNoDelete = FALSE
    bWorldGeometry = FALSE
    bNetInitialRotation = TRUE
    bMovable = TRUE
    bBlockActors = FALSE
    bNoEncroachCheck = TRUE
    bPathColliding = FALSE
    Physics = EPhysics.PHYS_RigidBody
    TickGroup = ETickingGroup.TG_PostAsyncWork
}
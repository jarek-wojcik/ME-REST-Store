Class PhysXDestructiblePart extends Actor
    native;

var editinline export array<SkeletalMeshComponent> SkeletalMeshComponents;
var array<byte> NumChunksRemaining;
var transient int FirstChunk;
var transient int NumChunks;
var PhysXDestructibleStructure Structure;
var PhysXDestructibleActor DestructibleActor;
var PhysXDestructibleAsset DestructibleAsset;
var editinline export LightEnvironmentComponent LightEnvironment;
var byte NumMeshesRemaining;

public event simulated native function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

public simulated native function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironment0
        bEnabled = FALSE
    End Object
    LightEnvironment = LightEnvironment0
    Components = (LightEnvironment0)
    bAlwaysRelevant = TRUE
    bUpdateSimulatedPosition = TRUE
    bNetInitialRotation = TRUE
    bReplicateRigidBodyLocation = TRUE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bProjTarget = TRUE
    bNoEncroachCheck = TRUE
    bEdShouldSnap = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
    TickGroup = ETickingGroup.TG_PostAsyncWork
}
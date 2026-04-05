Class PhysXDestructibleActor extends FracturedStaticMeshActor
    native
    placeable;

struct native SpawnBasis 
{
    var Vector location;
    var Rotator Rotation;
    var float Scale;
};

var(Destructible) PhysXDestructibleParameters DestructibleParameters;
var transient native array<SpawnBasis> EffectBases;
var array<int> PartFirstChunkIndices;
var array<PhysXDestructiblePart> Parts;
var array<int> Neighbors;
var transient native Pointer VolumeFill;
var editinline export PhysXDestructibleComponent DestructibleComponent;
var editinline export LightEnvironmentComponent LightEnvironment;
var PhysXDestructible PhysXDestructible;
var PhysXDestructibleStructure Structure;
var transient native float LinearSize;
var(Destructible) const int PerFrameProcessBudget;
var(Destructible) const int SupportDepth;
var transient native bool bPlayFractureSound;
var(Destructible) const bool bSupportChunksTouchWorld;
var(Destructible) const bool bSupportChunksInSupportFragment;
var byte NumPartsRemaining;

public event function Destroyed()
{
    Super(Actor).Destroyed();
    Term();
}
public event simulated function Explode();

public native function Init();

public native function NativeSpawnEffects();

public native function NativeTakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Init();
}
public event simulated function SpawnEffects()
{
    local int i;
    local EmitterSpawnable Effect;
    local FracturedStaticMesh FracMesh;
    local ParticleSystem EffectPSys;
    
    FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);
    if (FracMesh.FragmentDestroyEffects.Length > 0 && EffectBases.Length > 0)
    {
        EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.Length)];
        if (EffectPSys != None)
        {
            for (i = 0; i < EffectBases.Length; i++)
            {
                Effect = Spawn(Class'EmitterSpawnable', Self, , EffectBases[i].location, EffectBases[i].Rotation);
                Effect.SetTemplate(EffectPSys, TRUE);
                Effect.ParticleSystemComponent.SetScale(FracMesh.FragmentDestroyEffectScale * EffectBases[i].Scale);
                Effect.LifeSpan = 1.0;
            }
            EffectBases.Remove(0, EffectBases.Length);
        }
    }
}
public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int Item;
    
    Item = HitInfo.Item;
    HitInfo.Item = FracturedStaticMeshComponent.GetCoreFragmentIndex();
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    HitInfo.Item = Item;
    NativeTakeDamage(int(Damage), EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}
public simulated native function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo);

public native function Term();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=LightEnvironment0
    End Template
    Begin Template Class=FracturedSkinnedMeshComponent Name=FracturedSkinnedComponent0
        ReplacementPrimitive = None
        LightEnvironment = LightEnvironment0
    End Template
    Begin Template Class=FracturedStaticMeshComponent Name=FracturedStaticMeshComponent0
        ReplacementPrimitive = None
        bUsePrecomputedShadows = FALSE
    End Template
    DestructibleParameters = {
                              DepthParameters = (), 
                              DamageThreshold = 5.0, 
                              DamageToRadius = 0.100000001, 
                              DamageCap = 0.0, 
                              ForceToDamage = 0.0, 
                              FractureSound = None, 
                              CrumbleParticleSystem = None, 
                              CrumbleParticleSize = 10.0, 
                              ScaledDamageToRadius = 0.0, 
                              bAccumulateDamage = TRUE
                             }
    PerFrameProcessBudget = 100
    bSupportChunksTouchWorld = TRUE
    FracturedStaticMeshComponent = FracturedStaticMeshComponent0
    SkinnedComponent = FracturedSkinnedComponent0
    Components = (LightEnvironment0, FracturedSkinnedComponent0, FracturedStaticMeshComponent0)
    CollisionComponent = FracturedStaticMeshComponent0
    bWorldGeometry = FALSE
    bNoEncroachCheck = TRUE
}
Class SFXDuringAsyncWorkTicker extends Actor
    native
    transient
    config(Game);

struct native SFXDuringAsyncWorkCachedInfo 
{
    var Vector LocalPlayerLocation;
    var float LODfactor;
    var Actor LocalPlayer;
    var float TimeSeconds;
};
struct native SFXDuringAsyncWorkQueuedEffect 
{
    var Vector location;
    var Rotator Rotation;
    var ParticleSystem Effect;
    var float Lifetime;
    var float Scale;
    var Actor Instigator;
};
struct native SFXDuringAsyncWorkQueuedTracer 
{
    var Vector TracerScale3D;
    var Vector StartLocation;
    var Vector HitLocation;
    var StaticMesh TracerMesh;
    var ParticleSystem TracerVFX;
    var float TracerSpeed;
    var float TracerSpawnOffset;
    var Actor Instigator;
};
struct native SFXDuringAsyncWorkQueuedImpactDecal 
{
    var Vector HitLocation;
    var Vector HitNormal;
    var Name HitBoneName;
    var MaterialInterface Material;
    var float FadeTime;
    var float Width;
    var float Height;
    var float FarPlane;
    var editinline export PrimitiveComponent HitComponent;
    var int HitItem;
    var int HitLevelIndex;
    var Actor Instigator;
    var bool bNoClip;
};
struct native SFXDuringAsyncWorkQueuedImpactPSC 
{
    var Vector HitLocation;
    var Vector HitNormal;
    var Vector VectorParameter;
    var Name HitBoneName;
    var Name VectorParameterName;
    var ParticleSystem Template;
    var Actor HitActor;
    var editinline export PrimitiveComponent HitComponent;
    var float Scale;
    var Actor Instigator;
};

var editinline array<SFXDuringAsyncWorkQueuedImpactPSC> QueuedImpactPSCs;
var editinline array<SFXDuringAsyncWorkQueuedImpactDecal> QueuedImpactDecals;
var array<SFXDuringAsyncWorkQueuedTracer> QueuedTracers;
var array<SFXDuringAsyncWorkQueuedEffect> QueuedEffects;
var config float PSCCullDistance;
var config float DecalCullDistanceBase;
var config float TracerCullDistance;
var config float LocalPlayerCullDistanceBias;
var bool bNoQueuedImpactPSCs;
var bool bNoQueuedImpactDecals;
var bool bNoQueuedTracers;
var bool bNoQueuedEffects;
var bool bUseLocalPawnLocation;
var bool bNoPSCCull;
var bool bNoDecalCull;
var bool bNoTracerCull;
var bool bNoEffectCull;

private final event function SetEffectLifetime(Emitter Emit, float Lifetime)
{
    local SFXEmitter SFXEmit;
    
    SFXEmit = SFXEmitter(Emit);
    if (SFXEmit != None)
    {
        SFXEmit.SetLifetime(Lifetime);
    }
}
public final native function SpawnEffectAtLocation(Actor inInstigator, ParticleSystem Effect, Vector EffectLocation, Rotator EffectRotation, optional float Lifetime = -1.0, optional float Scale = 1.0);

public final native function SpawnImpactDecal(Actor inInstigator, MaterialInterface ImpactDecalMaterial, const out ImpactInfo Impact, float ImpactDecalWidth, float ImpactDecalHeight, float ImpactDecalFarPlane, bool ImpactDecalNoClip, float ImpactDecalFadeTime, const out array<Name> ImpactDecalFadingParameters);

public final native function SpawnImpactDecalAtLocation(Actor inInstigator, MaterialInterface ImpactDecalMaterial, Vector ImpactLocation, Vector ImpactNormal, float ImpactDecalWidth, float ImpactDecalHeight, float ImpactDecalFarPlane, bool ImpactDecalNoClip, float ImpactDecalFadeTime, optional const out array<Name> ImpactDecalFadingParameters);

public final native function SpawnImpactEffect(Actor inInstigator, ParticleSystem Effect, const out ImpactInfo Impact, float ImpactScale);

public final native function SpawnImpactEffectAtLocation(Actor inInstigator, ParticleSystem Effect, Actor HitActor, Vector HitLocation, Vector HitNormal, PrimitiveComponent HitComponent, Name HitBoneName, optional float Scale = 1.0, optional Name VectorParameterName, optional Vector VectorParameter);

public final native function SpawnTracer(Actor inInstigator, StaticMesh TracerMesh, ParticleSystem TracerVFX, Vector TracerScale3D, float TracerSpeed, float TracerSpawnOffset, Vector StartLocation, Vector HitLocation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PSCCullDistance = 4000.0
    DecalCullDistanceBase = 2.0
    TracerCullDistance = 4000.0
    LocalPlayerCullDistanceBias = 2000.0
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}
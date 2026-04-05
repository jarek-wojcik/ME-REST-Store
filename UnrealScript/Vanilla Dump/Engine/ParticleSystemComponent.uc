Class ParticleSystemComponent extends PrimitiveComponent
    native
    editinlinenew;

struct native ParticleEventKismetData extends ParticleEventData 
{
    var RwVector3 Normal;
    var bool UsePSysCompLocation;
};
struct native ParticleEventCollideData extends ParticleEventData 
{
    var RwVector3 Normal;
    var Name BoneName;
    var float ParticleTime;
    var float Time;
    var int Item;
};
struct native ParticleEventDeathData extends ParticleEventData 
{
    var float ParticleTime;
};
struct native ParticleEventSpawnData extends ParticleEventData 
{
};
struct native ParticleEventData 
{
    var RwVector3 location;
    var RwVector3 Direction;
    var RwVector3 Velocity;
    var Name EventName;
    var int Type;
    var float EmitterTime;
};
enum EParticleEventType
{
    EPET_Any,
    EPET_Spawn,
    EPET_Death,
    EPET_Collision,
    EPET_Kismet,
};
enum ParticleReplayState
{
    PRS_Disabled,
    PRS_Capturing,
    PRS_Replaying,
};
struct native ParticleSysParam 
{
    var(ParticleSysParam) RwVector3 Vector;
    var(ParticleSysParam) Name Name;
    var(ParticleSysParam) float Scalar;
    var(ParticleSysParam) Color Color;
    var(ParticleSysParam) Actor Actor;
    var(ParticleSysParam) MaterialInterface Material;
    var(ParticleSysParam) EParticleSysParamType ParamType;
};
enum EParticleSysParamType
{
    PSPT_None,
    PSPT_Scalar,
    PSPT_Vector,
    PSPT_Color,
    PSPT_Actor,
    PSPT_Material,
};
struct native ViewParticleEmitterInstanceMotionBlurInfo 
{
    var const transient native Map_Mirror EmitterInstanceMBInfoMap;
};
struct native ParticleEmitterInstanceMotionBlurInfo 
{
    var const transient native Map_Mirror ParticleMBInfoMap;
};
struct ParticleEmitterInstance 
{
};

var RwVector3 OldPosition;
var RwVector3 PartSysVelocity;
var const transient native array<Pointer> EmitterInstances;
var const transient native array<ViewParticleEmitterInstanceMotionBlurInfo> ViewMBInfoArray;
var const editinline transient duplicatetransient export array<StaticMeshComponent> SMComponents;
var const transient duplicatetransient array<MaterialInterface> SMMaterialInterfaces;
var(ParticleSystemComponent) array<ParticleSysParam> InstanceParameters;
var const transient array<MaterialViewRelevance> CachedViewRelevanceFlags;
var(ParticleSystemComponent) const array<ParticleSystemReplay> ReplayClips;
var transient array<ParticleEventSpawnData> SpawnEvents;
var transient array<ParticleEventDeathData> DeathEvents;
var transient array<ParticleEventCollideData> CollisionEvents;
var transient array<ParticleEventKismetData> KismetEvents;
var delegate<OnSystemFinished> __OnSystemFinished__Delegate;
var Class<ParticleLightEnvironmentComponent> LightEnvironmentClass;
var const transient native Pointer ReleaseResourcesFence;
var transient native Pointer ListPrev;
var transient native Pointer ListNext;
var(ParticleSystemComponent) const ParticleSystem Template;
var float WarmupTime;
var int LODLevel;
var(ParticleSystemComponent) float SecondsBeforeInactive;
var transient float TimeSinceLastForceUpdateTransform;
var float MaxTimeBeforeForceUpdateTransform;
var transient float AccumTickTime;
var const transient int ReplayClipIDNumber;
var const transient int ReplayFrameIndex;
var transient float AccumLODDistanceCheckTime;
var(ParticleSystemComponent) float CustomTimeDilation;
var transient float EmitterDelay;
var(ParticleSystemComponent) bool bAutoActivate;
var const bool bWasCompleted;
var const bool bSuppressSpawning;
var const bool bWasDeactivated;
var(ParticleSystemComponent) bool bResetOnDetach;
var bool bUpdateOnDedicatedServer;
var bool bJustAttached;
var transient bool bIsActive;
var bool bWarmingUp;
var bool bIsCachedInPool;
var(LOD) bool bOverrideLODMethod;
var bool bSkipUpdateDynamicDataDuringTick;
var bool bUpdateComponentInTick;
var bool bDeferredBeamUpdate;
var transient bool bForcedInActive;
var transient bool bIsWarmingUp;
var transient bool bIsViewRelevanceDirty;
var transient bool bRecacheViewRelevance;
var transient bool bLODUpdatePending;
var transient bool bSkipSpawnCountCheck;
var(LOD) ParticleSystemLODMethod LODMethod;
var const transient ParticleReplayState ReplayState;

public final native function ActivateSystem(optional bool bFlagAsJustAttached = FALSE);

public final native function ClearAllParameters();

public final native function ClearParameter(Name ParameterName, optional EParticleSysParamType ParameterType);

public final native function DeactivateSystem();

public native function int DetermineLODLevelForLocation(Vector EffectLocation);

public native function bool GetActorParameter(const Name InName, out Actor OutActor);

public native function bool GetColorParameter(const Name InName, out Color OutColor);

public final native function int GetEditorLODLevel();

public native function bool GetFloatParameter(const Name InName, out float OutFloat);

public final native function int GetLODLevel();

public native function bool GetMaterialParameter(const Name InName, out MaterialInterface OutMaterial);

public native function float GetMaxLifespan();

public final native function bool GetSkipUpdateDynamicDataDuringTick();

public native function bool GetVectorParameter(const Name InName, out Vector OutVector);

public final native function KillParticlesForced();

public delegate function OnSystemFinished(ParticleSystemComponent PSystem);

public final native function ResetToDefaults();

public native function RewindEmitterInstance(int EmitterIndex);

public native function RewindEmitterInstances();

public final native function SetActive(bool bNowActive);

public final native function SetActorParameter(Name ParameterName, Actor Param);

public native function SetBeamDistance(int EmitterIndex, float Distance);

public native function SetBeamEndPoint(int EmitterIndex, Vector NewEndPoint);

public native function SetBeamSourcePoint(int EmitterIndex, Vector NewSourcePoint, int SourceIndex);

public native function SetBeamSourceStrength(int EmitterIndex, float NewSourceStrength, int SourceIndex);

public native function SetBeamSourceTangent(int EmitterIndex, Vector NewTangentPoint, int SourceIndex);

public native function SetBeamTargetPoint(int EmitterIndex, Vector NewTargetPoint, int TargetIndex);

public native function SetBeamTargetStrength(int EmitterIndex, float NewTargetStrength, int TargetIndex);

public native function SetBeamTargetTangent(int EmitterIndex, Vector NewTangentPoint, int TargetIndex);

public native function SetBeamTessellationFactor(int EmitterIndex, float NewFactor);

public native function SetBeamType(int EmitterIndex, int NewMethod);

public final native function SetColorParameter(Name ParameterName, Color Param);

public final native function SetEditorLODLevel(int InLODLevel);

public final native function SetFloatParameter(Name ParameterName, float Param);

public native function SetKillOnCompleted(int EmitterIndex, bool bKill);

public native function SetKillOnDeactivate(int EmitterIndex, bool bKill);

public final native function SetLODLevel(int InLODLevel);

public final native function SetMaterialParameter(Name ParameterName, MaterialInterface Param);

public final native function SetSkipUpdateDynamicDataDuringTick(bool bInSkipUpdateDynamicDataDuringTick);

public final native function SetStopSpawning(int InEmitterIndex, bool bInStopSpawning);

public final native function SetTemplate(ParticleSystem NewTemplate);

public final native function SetVectorParameter(Name ParameterName, Vector Param);

public final native function SuppressSpawning();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightEnvironmentClass = Class'ParticleLightEnvironmentComponent'
    SecondsBeforeInactive = 1.0
    MaxTimeBeforeForceUpdateTransform = 5.0
    CustomTimeDilation = 1.0
    bAutoActivate = TRUE
    bIsViewRelevanceDirty = TRUE
    ReplacementPrimitive = None
    bAllowApproximateOcclusion = TRUE
    bTickInEditor = TRUE
    ComponentType = EComponentType.COMPONENT_Particles
}
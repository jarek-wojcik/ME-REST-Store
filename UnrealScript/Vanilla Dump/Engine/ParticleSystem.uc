Class ParticleSystem
    native;

struct native LODSoloTrack 
{
    var transient array<byte> SoloEnableSetting;
    
    structdefaultproperties
    {
        SoloEnableSetting = ""
    }
};
enum EParticleSystemOcclusionBoundsMethod
{
    EPSOBM_None,
    EPSOBM_ParticleBounds,
    EPSOBM_CustomBounds,
};
struct native DebugParticleParameterVector 
{
    var(DebugParticleParameterVector) Vector vValue;
    var(DebugParticleParameterVector) Name nmValue;
};
struct native DebugParticleParameterFloat 
{
    var(DebugParticleParameterFloat) Name nmValue;
    var(DebugParticleParameterFloat) float fValue;
};
struct native ParticleSystemLOD 
{
    var(ParticleSystemLOD) bool bLit;
};
enum ParticleSystemLODMethod
{
    PARTICLESYSTEMLODMETHOD_Automatic,
    PARTICLESYSTEMLODMETHOD_DirectSet,
    PARTICLESYSTEMLODMETHOD_ActivateAutomatic,
};
enum EParticleSystemUpdateMode
{
    EPSUM_RealTime,
    EPSUM_FixedTime,
};

var(Bounds) BioRwBox FixedRelativeBoundingBox;
var export array<ParticleEmitter> Emitters;
var(LOD) editfixedsize array<float> LODDistances;
var(LOD) array<ParticleSystemLOD> LODSettings;
var transient array<LODSoloTrack> SoloTracking;
var(Occlusion) Box CustomOcclusionBounds;
var Rotator ThumbnailAngle;
var(MacroUV) Vector MacroUVPosition;
var(ParticleSystem) float UpdateTime_FPS;
var float UpdateTime_Delta;
var(ParticleSystem) float WarmupTime;
var editinline transient export ParticleSystemComponent PreviewComponent;
var float ThumbnailDistance;
var(Thumbnail) float ThumbnailWarmup;
var export InterpCurveEdSetup CurveEdSetup;
var(LOD) float LODDistanceCheckTime;
var(LOD) float LODDistanceMultiplayerBias;
var int EditorLODSetting;
var(ParticleSystem) float SecondsBeforeInactive;
var(Delay) float Delay;
var(Delay) float DelayLow;
var(MacroUV) float MacroUVRadius;
var(ParticleSystem) bool bOrientZAxisTowardCamera;
var bool bRegenerateLODDuplicate;
var(Bounds) bool bUseFixedRelativeBoundingBox;
var(ParticleSystem) bool BioLockLowestLODToHighest;
var bool bShouldResetPeakCounts;
var transient bool bHasPhysics;
var transient bool bBioDependsOnPhysics;
var(Thumbnail) bool bUseRealtimeThumbnail;
var bool ThumbnailImageOutOfDate;
var(ParticleSystem) bool bSkipSpawnCountCheck;
var(Delay) bool bUseDelayRange;
var(ParticleSystem) EParticleSystemUpdateMode SystemUpdateMode;
var(LOD) ParticleSystemLODMethod LODMethod;
var(Occlusion) EParticleSystemOcclusionBoundsMethod OcclusionBoundsMethod;

public native function ParticleSystemLODMethod GetCurrentLODMethod();

public native function float GetLODDistance(int LODLevelIndex);

public native function int GetLODLevelCount();

public native function float GetMaxLifespan(float InComponentDelay);

public native function SetCurrentLODMethod(ParticleSystemLODMethod InMethod);

public native function bool SetLODDistance(int LODLevelIndex, float InDistance);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FixedRelativeBoundingBox = {
                                Min = {X = -1.0, Y = -1.0, Z = -1.0}, 
                                Max = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                IsValid = 0
                               }
    UpdateTime_FPS = 60.0
    UpdateTime_Delta = 1.0
    ThumbnailDistance = 200.0
    ThumbnailWarmup = 1.0
    LODDistanceCheckTime = 0.25
    MacroUVRadius = 200.0
    BioLockLowestLODToHighest = TRUE
    ThumbnailImageOutOfDate = TRUE
}
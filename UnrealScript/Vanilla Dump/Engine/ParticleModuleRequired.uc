Class ParticleModuleRequired extends ParticleModule
    native
    editinlinenew;

enum EEmitterNormalsMode
{
    ENM_CameraFacing,
    ENM_Spherical,
    ENM_Cylindrical,
};
enum EParticleSortMode
{
    PSORTMODE_None,
    PSORTMODE_ViewProjDepth,
    PSORTMODE_DistanceToView,
    PSORTMODE_Age_OldestFirst,
    PSORTMODE_Age_NewestFirst,
};

var editinline RawDistributionFloat SpawnRate;
var export noclear array<ParticleBurst> BurstList;
var(Normals) Vector NormalsSphereCenter;
var(Normals) Vector NormalsCylinderDirection;
var(Emitter) MaterialInterface Material;
var(Duration) float EmitterDuration;
var(Duration) float EmitterDurationLow;
var(Duration) int EmitterLoops;
var(Delay) float EmitterDelay;
var(Delay) float EmitterDelayLow;
var(SubUV) int SubImages_Horizontal;
var(SubUV) int SubImages_Vertical;
var float RandomImageTime;
var(SubUV) int RandomImageChanges;
var(Rendering) int MaxDrawCount;
var(Rendering) float DownsampleThresholdScreenFraction;
var(Emitter) bool bUseLocalSpace;
var(Emitter) bool bKillOnDeactivate;
var(Emitter) bool bKillOnCompleted;
var(Emitter) bool bUseLegacyEmitterTime;
var(Duration) bool bEmitterDurationUseRange;
var(Duration) bool bDurationRecalcEachLoop;
var(Delay) bool bEmitterDelayUseRange;
var(Delay) bool bDelayFirstLoopOnly;
var(SubUV) bool bScaleUV;
var bool bDirectUV;
var(Rendering) bool bUseMaxDrawCount;
var(Emitter) EParticleScreenAlignment ScreenAlignment;
var(Emitter) EParticleSortMode SortMode;
var EParticleBurstMethod ParticleBurstMethod;
var(SubUV) EParticleSubUVInterpMethod InterpolationMethod;
var(Normals) EEmitterNormalsMode EmitterNormalsMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=RequiredDistributionSpawnRate
    End Object
    SpawnRate = {
                 Distribution = RequiredDistributionSpawnRate, 
                 Type = 0, 
                 Op = 1, 
                 LookupTableNumElements = 1, 
                 LookupTableChunkSize = 1, 
                 LookupTable = (0.0, 0.0, 0.0, 0.0), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    NormalsSphereCenter = {X = 0.0, Y = 0.0, Z = 100.0}
    NormalsCylinderDirection = {X = 0.0, Y = 0.0, Z = 1.0}
    EmitterDuration = 1.0
    SubImages_Horizontal = 1
    SubImages_Vertical = 1
    MaxDrawCount = 500
    bUseLegacyEmitterTime = TRUE
    bUseMaxDrawCount = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
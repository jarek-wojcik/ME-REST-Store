Class EngineTypes
    native
    abstract;

struct native MeshMaterialRef 
{
    var editinline export MeshComponent MeshComp;
    var int MaterialIndex;
};
struct native RootMotionCurve 
{
    var(RootMotionCurve) InterpCurveVector Curve;
    var(RootMotionCurve) Name AnimName;
    var(RootMotionCurve) float MaxCurveTime;
};
struct native SwarmDebugOptions 
{
    var(SwarmDebugOptions) bool bDistributionEnabled;
    var(SwarmDebugOptions) bool bForceContentExport;
    var bool bInitialized;
    
    structdefaultproperties
    {
        bDistributionEnabled = TRUE
    }
};
struct native LightmassDebugOptions 
{
    var(LightmassDebugOptions) float CoplanarTolerance;
    var(LightmassDebugOptions) float ExecutionTimeDivisor;
    var(LightmassDebugOptions) bool bDebugMode;
    var(LightmassDebugOptions) bool bStatsEnabled;
    var(LightmassDebugOptions) bool bGatherBSPSurfacesAcrossComponents;
    var(LightmassDebugOptions) bool bUseDeterministicLighting;
    var(LightmassDebugOptions) bool bUseImmediateImport;
    var(LightmassDebugOptions) bool bImmediateProcessMappings;
    var(LightmassDebugOptions) bool bSortMappings;
    var(LightmassDebugOptions) bool bDumpBinaryFiles;
    var(LightmassDebugOptions) bool bDebugMaterials;
    var(LightmassDebugOptions) bool bPadMappings;
    var(LightmassDebugOptions) bool bDebugPaddings;
    var(LightmassDebugOptions) bool bOnlyCalcDebugTexelMappings;
    var(LightmassDebugOptions) bool bUseRandomColors;
    var(LightmassDebugOptions) bool bColorBordersGreen;
    var(LightmassDebugOptions) bool bColorByExecutionTime;
    var bool bInitialized;
    
    structdefaultproperties
    {
        CoplanarTolerance = 0.00100000005
        ExecutionTimeDivisor = 15.0
        bGatherBSPSurfacesAcrossComponents = TRUE
        bUseDeterministicLighting = TRUE
        bUseImmediateImport = TRUE
        bImmediateProcessMappings = TRUE
        bSortMappings = TRUE
        bPadMappings = TRUE
    }
};
struct LightmassPrimitiveSettings 
{
    var(LightmassPrimitiveSettings) bool bUseTwoSidedLighting;
    var(LightmassPrimitiveSettings) bool bShadowIndirectOnly;
    var(LightmassPrimitiveSettings) bool bUseEmissiveForStaticLighting;
    var(LightmassPrimitiveSettings) float EmissiveLightFalloffExponent;
    var(LightmassPrimitiveSettings) float EmissiveLightExplicitInfluenceRadius;
    var(LightmassPrimitiveSettings) float EmissiveBoost;
    var(LightmassPrimitiveSettings) float DiffuseBoost;
    var float SpecularBoost;
    var(LightmassPrimitiveSettings) float FullyOccludedSamplesFraction;
};
struct native LightmassDirectionalLightSettings extends LightmassLightSettings 
{
    var(Directional) float LightSourceAngle;
    
    structdefaultproperties
    {
        LightSourceAngle = 3.0
        IndirectLightingScale = 0.0
        IndirectLightingSaturation = 0.0
        ShadowExponent = 0.0
    }
};
struct native LightmassPointLightSettings extends LightmassLightSettings 
{
    var(Point) float LightSourceRadius;
    
    structdefaultproperties
    {
        LightSourceRadius = 100.0
        IndirectLightingScale = 0.0
        IndirectLightingSaturation = 0.0
        ShadowExponent = 0.0
    }
};
struct native LightmassLightSettings 
{
    var(General) float IndirectLightingScale;
    var(General) float IndirectLightingSaturation;
    var(General) float ShadowExponent;
    
    structdefaultproperties
    {
        IndirectLightingScale = 1.0
        IndirectLightingSaturation = 1.0
        ShadowExponent = 2.0
    }
};
struct native DominantShadowInfo 
{
    var Matrix WorldToLight;
    var Matrix LightToWorld;
    var Box LightSpaceImportanceBounds;
    var int ShadowMapSizeX;
    var int ShadowMapSizeY;
};
enum ELightingBuildQuality
{
    Quality_Preview,
    Quality_Medium,
    Quality_High,
    Quality_Production,
};
struct native LocalizedSubtitle 
{
    var array<SubtitleCue> Subtitles;
    var bool bMature;
    var bool bManualWordWrap;
};
struct native SubtitleCue 
{
    var(SubtitleCue) const localized string Text;
    var(SubtitleCue) const localized float Time;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
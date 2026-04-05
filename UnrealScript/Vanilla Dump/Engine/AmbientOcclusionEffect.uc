Class AmbientOcclusionEffect extends PostProcessEffect
    native;

enum EAmbientOcclusionQuality
{
    AO_High,
    AO_Medium,
    AO_Low,
};

var(Color) interp LinearColor OcclusionColor;
var(Color) float OcclusionPower;
var(Color) float OcclusionScale;
var(Color) float OcclusionBias;
var(Color) float MinOcclusion;
var(Occlusion) float OcclusionRadius;
var(Occlusion) float OcclusionAttenuation;
var(Occlusion) float OcclusionFadeoutMinDistance;
var(Occlusion) float OcclusionFadeoutMaxDistance;
var(Halo) float HaloDistanceThreshold;
var(Halo) float HaloDistanceScale;
var(Halo) float HaloOcclusion;
var(Filter) float EdgeDistanceThreshold;
var(Filter) float EdgeDistanceScale;
var(Filter) float FilterDistanceScale;
var(Filter) int FilterSize;
var(History) float HistoryConvergenceTime;
var float HistoryWeightConvergenceTime;
var(AmbientOcclusionEffect) bool SSAO2;
var(Occlusion) EAmbientOcclusionQuality OcclusionQuality;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OcclusionColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    OcclusionPower = 4.0
    OcclusionScale = 20.0
    MinOcclusion = 0.100000001
    OcclusionRadius = 25.0
    OcclusionAttenuation = 50.0
    OcclusionFadeoutMinDistance = 4000.0
    OcclusionFadeoutMaxDistance = 4500.0
    HaloDistanceThreshold = 40.0
    HaloDistanceScale = 0.100000001
    HaloOcclusion = 0.0399999991
    EdgeDistanceThreshold = 10.0
    EdgeDistanceScale = 0.00300000003
    FilterDistanceScale = 10.0
    FilterSize = 12
    HistoryConvergenceTime = 0.5
    HistoryWeightConvergenceTime = 0.0700000003
    OcclusionQuality = EAmbientOcclusionQuality.AO_Medium
    bAffectsLightingOnly = TRUE
    SceneDPG = ESceneDepthPriorityGroup.SDPG_World
}
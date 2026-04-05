Class ParticleModuleTypeDataRibbon extends ParticleModuleTypeDataBase
    native
    editinlinenew;

enum ETrailsRenderAxisOption
{
    Trails_CameraUp,
    Trails_SourceUp,
    Trails_WorldUp,
};

var int MaxTessellationBetweenParticles;
var(Trail) int SheetsPerTrail;
var(Trail) int MaxTrailCount;
var(Trail) int MaxParticleInTrailCount;
var(Spawn) float TangentSpawningScalar;
var(Rendering) float TilingDistance;
var(Rendering) float DistanceTessellationStepSize;
var(Rendering) float TangentTessellationScalar;
var(Trail) bool bDeadTrailsOnDeactivate;
var(Trail) bool bClipSourceSegement;
var(Trail) bool bEnablePreviousTangentRecalculation;
var(Trail) bool bTangentRecalculationEveryFrame;
var(Rendering) bool bRenderGeometry;
var(Rendering) bool bRenderSpawnPoints;
var(Rendering) bool bRenderTangents;
var(Rendering) bool bRenderTessellation;
var(Trail) ETrailsRenderAxisOption RenderAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxTessellationBetweenParticles = 25
    SheetsPerTrail = 1
    MaxTrailCount = 1
    MaxParticleInTrailCount = 500
    DistanceTessellationStepSize = 15.0
    TangentTessellationScalar = 5.0
    bDeadTrailsOnDeactivate = TRUE
    bClipSourceSegement = TRUE
    bEnablePreviousTangentRecalculation = TRUE
    bRenderGeometry = TRUE
}
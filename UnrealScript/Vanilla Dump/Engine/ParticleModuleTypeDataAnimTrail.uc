Class ParticleModuleTypeDataAnimTrail extends ParticleModuleTypeDataBase
    native
    editinlinenew;

var(Anim) Name ControlEdgeName;
var(Trail) int SheetsPerTrail;
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SheetsPerTrail = 1
    DistanceTessellationStepSize = 10.0
    bDeadTrailsOnDeactivate = TRUE
    bClipSourceSegement = TRUE
    bEnablePreviousTangentRecalculation = TRUE
    bRenderGeometry = TRUE
}
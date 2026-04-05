Class ParticleModuleTypeDataTrail2 extends ParticleModuleTypeDataBase
    native
    editinlinenew;

var(Trail) int TessellationFactor;
var float TessellationFactorDistance;
var(Trail) float TessellationStrength;
var(Trail) int TextureTile;
var int Sheets;
var(Trail) int MaxTrailCount;
var(Trail) int MaxParticleInTrailCount;
var(Trail) bool bClipSourceSegement;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TessellationFactor = 1
    TessellationStrength = 25.0
    TextureTile = 1
    Sheets = 1
    MaxTrailCount = 1
    RenderGeometry = TRUE
}
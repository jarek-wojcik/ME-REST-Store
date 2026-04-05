Class ParticleModuleTypeDataTrail extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories;

var(Trail) editinline RawDistributionFloat Tension;
var(Trail) Vector SpawnDistance;
var(Trail) int TessellationFactor;
var(Trail) bool RenderGeometry;
var(Trail) bool RenderLines;
var(Trail) bool RenderTessellation;
var(Trail) bool Tapered;
var(Trail) bool SpawnByDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionTension
    End Object
    Tension = {
               Distribution = DistributionTension, 
               Type = 0, 
               Op = 1, 
               LookupTableNumElements = 1, 
               LookupTableChunkSize = 1, 
               LookupTable = (0.0, 0.0, 0.0, 0.0), 
               LookupTableTimeScale = 0.0, 
               LookupTableStartTime = 0.0
              }
    SpawnDistance = {X = 5.0, Y = 5.0, Z = 5.0}
    TessellationFactor = 1
    RenderGeometry = TRUE
}
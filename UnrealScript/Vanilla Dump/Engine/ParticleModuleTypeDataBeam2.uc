Class ParticleModuleTypeDataBeam2 extends ParticleModuleTypeDataBase
    native
    editinlinenew;

enum EBeamTaperMethod
{
    PEBTM_None,
    PEBTM_Full,
    PEBTM_Partial,
};
struct BeamTargetData 
{
    var(BeamTargetData) Name TargetName;
    var(BeamTargetData) float TargetPercentage;
};
enum EBeam2Method
{
    PEB2M_Distance,
    PEB2M_Target,
    PEB2M_Branch,
};

var(Distance) editinline RawDistributionFloat Distance;
var(Taper) editinline RawDistributionFloat TaperFactor;
var(Taper) editinline RawDistributionFloat TaperScale;
var(Branching) Name BranchParentName;
var(Beam) int TextureTile;
var(Beam) float TextureTileDistance;
var(Beam) int Sheets;
var(Beam) int MaxBeamCount;
var(Beam) float Speed;
var(Beam) int InterpolationPoints;
var(Beam) int UpVectorStepSize;
var(Beam) bool bAlwaysOn;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;
var(Beam) EBeam2Method BeamMethod;
var(Taper) EBeamTaperMethod TaperMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionDistance
        Constant = 25.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionTaperFactor
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionTaperScale
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionNoiseSpeed
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Distance = {
                Distribution = DistributionDistance, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (25.0, 25.0, 25.0, 25.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    TaperFactor = {
                   Distribution = DistributionTaperFactor, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (1.0, 1.0, 1.0, 1.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    TaperScale = {
                  Distribution = DistributionTaperScale, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (1.0, 1.0, 1.0, 1.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    TextureTile = 1
    Sheets = 1
    Speed = 10.0
    RenderGeometry = TRUE
    BeamMethod = EBeam2Method.PEB2M_Target
}
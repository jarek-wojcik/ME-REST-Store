Class ParticleModuleTypeDataBeam extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories;

enum EBeamEndPointMethod
{
    PEBEPM_Calculated,
    PEBEPM_Distribution,
    PEBEPM_Distribution_Constant,
};
enum EBeamMethod
{
    PEBM_Distance,
    PEBM_EndPoints,
    PEBM_EndPoints_Interpolated,
    PEBM_UserSet_EndPoints,
    PEBM_UserSet_EndPoints_Interpolated,
};

var(Beam) editinline BioRawDistributionRwVector3 EndPointRw;
var(Beam) editinline BioRawDistributionRwVector3 EndPointDirectionRw;
var(Beam) editinline RawDistributionFloat Distance;
var(Beam) editinline RawDistributionFloat EmitterStrength;
var(Beam) editinline RawDistributionFloat TargetStrength;
var(Beam) int TessellationFactor;
var(Beam) int TextureTile;
var(Beam) bool RenderGeometry;
var(Beam) bool RenderDirectLine;
var(Beam) bool RenderLines;
var(Beam) bool RenderTessellation;
var(Beam) EBeamMethod BeamMethod;
var(Beam) EBeamEndPointMethod EndPointMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionDistance
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionEmitterStrength
        Constant = 1000.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionTargetStrength
        Constant = 1000.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionEndPoint
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionEndPointDirection
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionEndPointDirectionRw
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionEndPointRw
    End Object
    EndPointRw = {
                  Distribution = DistributionEndPointRw, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTableMinOut = 0.0, 
                  LookupTableMaxOut = 0.0, 
                  LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}
                                ), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    EndPointDirectionRw = {
                           Distribution = DistributionEndPointDirectionRw, 
                           Type = 0, 
                           Op = 1, 
                           LookupTableNumElements = 1, 
                           LookupTableChunkSize = 1, 
                           LookupTableMinOut = 0.0, 
                           LookupTableMaxOut = 1.0, 
                           LookupTable = ({X = 1.0, Y = 0.0, Z = 0.0}
                                         ), 
                           LookupTableTimeScale = 0.0, 
                           LookupTableStartTime = 0.0
                          }
    Distance = {
                Distribution = DistributionDistance, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (0.0, 0.0, 0.0, 0.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    EmitterStrength = {
                       Distribution = DistributionEmitterStrength, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTable = (1000.0, 1000.0, 1000.0, 1000.0), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    TargetStrength = {
                      Distribution = DistributionTargetStrength, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (1000.0, 1000.0, 1000.0, 1000.0), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    TessellationFactor = 1
    RenderGeometry = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
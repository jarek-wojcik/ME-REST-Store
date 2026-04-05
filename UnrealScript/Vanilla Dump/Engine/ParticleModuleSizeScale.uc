Class ParticleModuleSizeScale extends ParticleModuleSizeBase
    native
    editinlinenew;

var(ParticleModuleSizeScale) editinline BioRawDistributionRwVector3 SizeScaleRw;
var(ParticleModuleSizeScale) bool EnableX;
var(ParticleModuleSizeScale) bool EnableY;
var(ParticleModuleSizeScale) bool EnableZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstant Name=DistributionSizeScale
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSizeScaleRw
    End Object
    SizeScaleRw = {
                   Distribution = DistributionSizeScaleRw, 
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
    EnableX = TRUE
    EnableY = TRUE
    EnableZ = TRUE
    bUpdateModule = TRUE
}
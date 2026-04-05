Class ParticleModuleSizeMultiplyVelocity extends ParticleModuleSizeBase
    native
    editinlinenew;

var(Size) editinline BioRawDistributionRwVector3 VelocityMultiplierRw;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstant Name=DistributionVelocityMultiplier
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionVelocityMultiplierRw
    End Object
    VelocityMultiplierRw = {
                            Distribution = DistributionVelocityMultiplierRw, 
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
    MultiplyX = TRUE
    MultiplyY = TRUE
    MultiplyZ = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
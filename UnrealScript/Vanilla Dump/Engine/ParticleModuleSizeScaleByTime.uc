Class ParticleModuleSizeScaleByTime extends ParticleModuleSizeBase
    native
    editinlinenew;

var(ParticleModuleSizeScaleByTime) editinline BioRawDistributionRwVector3 SizeScaleByTimeRw;
var(ParticleModuleSizeScaleByTime) bool bEnableX;
var(ParticleModuleSizeScaleByTime) bool bEnableY;
var(ParticleModuleSizeScaleByTime) bool bEnableZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionSizeScaleByTime
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionSizeScaleByTimeRw
    End Object
    SizeScaleByTimeRw = {
                         Distribution = DistributionSizeScaleByTimeRw, 
                         Type = 0, 
                         Op = 1, 
                         LookupTableNumElements = 1, 
                         LookupTableChunkSize = 1, 
                         LookupTableMinOut = 0.0, 
                         LookupTableMaxOut = 0.0, 
                         LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                        {X = 0.0, Y = 0.0, Z = 0.0}
                                       ), 
                         LookupTableTimeScale = 0.0, 
                         LookupTableStartTime = 0.0
                        }
    bEnableX = TRUE
    bEnableY = TRUE
    bEnableZ = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
Class ParticleModuleAcceleration extends ParticleModuleAccelerationBase
    native
    editinlinenew;

var(Acceleration) editinline BioRawDistributionRwVector3 AccelerationRw;
var(Acceleration) bool bApplyOwnerScale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorUniform Name=DistributionAcceleration
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionAccelerationRw
    End Object
    AccelerationRw = {
                      Distribution = DistributionAccelerationRw, 
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
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
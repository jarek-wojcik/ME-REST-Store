Class ParticleModuleVelocity extends ParticleModuleVelocityBase
    native
    editinlinenew;

var(Velocity) editinline BioRawDistributionRwVector3 StartVelocityRw;
var(Velocity) editinline RawDistributionFloat StartVelocityRadial;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionStartVelocityRadial
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartVelocity
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartVelocityRw
    End Object
    StartVelocityRw = {
                       Distribution = DistributionStartVelocityRw, 
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
    StartVelocityRadial = {
                           Distribution = DistributionStartVelocityRadial, 
                           Type = 0, 
                           Op = 1, 
                           LookupTableNumElements = 1, 
                           LookupTableChunkSize = 1, 
                           LookupTable = (0.0, 0.0, 0.0, 0.0), 
                           LookupTableTimeScale = 0.0, 
                           LookupTableStartTime = 0.0
                          }
    bSpawnModule = TRUE
}
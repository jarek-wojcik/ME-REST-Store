Class ParticleModuleEventReceiverSpawn extends ParticleModuleEventReceiverBase
    native
    editinlinenew;

var(Velocity) editinline BioRawDistributionRwVector3 InheritVelocityScaleRw;
var(Spawn) editinline RawDistributionFloat SpawnCount;
var(Spawn) bool bUseParticleTime;
var(location) bool bUsePSysLocation;
var(Velocity) bool bInheritVelocity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=RequiredDistributionSpawnCount
    End Object
    Begin Object Class=DistributionVectorConstant Name=RequiredDistributionInheritVelocityScale
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=RequiredDistributionInheritVelocityScaleRw
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    InheritVelocityScaleRw = {
                              Distribution = RequiredDistributionInheritVelocityScaleRw, 
                              Type = 0, 
                              Op = 1, 
                              LookupTableNumElements = 1, 
                              LookupTableChunkSize = 1, 
                              LookupTableMinOut = 1.0, 
                              LookupTableMaxOut = 1.0, 
                              LookupTable = ({X = 1.0, Y = 1.0, Z = 1.0}
                                            ), 
                              LookupTableTimeScale = 0.0, 
                              LookupTableStartTime = 0.0
                             }
    SpawnCount = {
                  Distribution = RequiredDistributionSpawnCount, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (0.0, 0.0, 0.0, 0.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
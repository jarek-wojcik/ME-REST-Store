Class ParticleModuleSpawn extends ParticleModuleSpawnBase
    native
    editinlinenew;

var(Spawn) editinline RawDistributionFloat Rate;
var(Spawn) editinline RawDistributionFloat RateScale;
var(Burst) export noclear array<ParticleBurst> BurstList;
var(Burst) EParticleBurstMethod ParticleBurstMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=RequiredDistributionSpawnRate
        Constant = 20.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=RequiredDistributionSpawnRateScale
        Constant = 1.0
    End Object
    Rate = {
            Distribution = RequiredDistributionSpawnRate, 
            Type = 0, 
            Op = 1, 
            LookupTableNumElements = 1, 
            LookupTableChunkSize = 1, 
            LookupTable = (20.0, 20.0, 20.0, 20.0), 
            LookupTableTimeScale = 0.0, 
            LookupTableStartTime = 0.0
           }
    RateScale = {
                 Distribution = RequiredDistributionSpawnRateScale, 
                 Type = 0, 
                 Op = 1, 
                 LookupTableNumElements = 1, 
                 LookupTableChunkSize = 1, 
                 LookupTable = (1.0, 1.0, 1.0, 1.0), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    LODDuplicate = FALSE
}
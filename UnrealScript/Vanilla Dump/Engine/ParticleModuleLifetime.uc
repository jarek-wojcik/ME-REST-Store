Class ParticleModuleLifetime extends ParticleModuleLifetimeBase
    native
    editinlinenew;

var(Lifetime) editinline RawDistributionFloat Lifetime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionLifetime
    End Object
    Lifetime = {
                Distribution = DistributionLifetime, 
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
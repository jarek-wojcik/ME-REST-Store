Class ParticleModuleLocation extends ParticleModuleLocationBase
    native
    editinlinenew;

var(location) editinline BioRawDistributionRwVector3 StartLocationRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Object Class=DistributionVectorUniform Name=DistributionStartLocation
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartLocationRw
    End Object
    StartLocationRw = {
                       Distribution = DistributionStartLocationRw, 
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
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
    bSupported3DDrawMode = TRUE
}
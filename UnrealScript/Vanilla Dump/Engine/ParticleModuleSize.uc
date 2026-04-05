Class ParticleModuleSize extends ParticleModuleSizeBase
    native
    editinlinenew;

var(Size) editinline BioRawDistributionRwVector3 StartSizeRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorUniform Name=DistributionStartSize
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
        Min = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartSizeRw
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
        Min = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    StartSizeRw = {
                   Distribution = DistributionStartSizeRw, 
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
    bSpawnModule = TRUE
}
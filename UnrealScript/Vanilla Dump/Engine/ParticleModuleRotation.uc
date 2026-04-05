Class ParticleModuleRotation extends ParticleModuleRotationBase
    native
    editinlinenew;

var(Rotation) editinline RawDistributionFloat StartRotation;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionStartRotation
        Max = 1.0
    End Object
    StartRotation = {
                     Distribution = DistributionStartRotation, 
                     Type = 0, 
                     Op = 2, 
                     LookupTableNumElements = 2, 
                     LookupTableChunkSize = 2, 
                     LookupTable = (0.0, 1.0, 0.0, 1.0, 0.0, 1.0), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    bSpawnModule = TRUE
}
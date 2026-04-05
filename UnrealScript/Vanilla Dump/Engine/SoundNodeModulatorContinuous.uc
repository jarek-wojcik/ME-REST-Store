Class SoundNodeModulatorContinuous extends SoundNode
    native
    editinlinenew;

var(SoundNodeModulatorContinuous) editinline RawDistributionFloat PitchModulation;
var(SoundNodeModulatorContinuous) editinline RawDistributionFloat VolumeModulation;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionPitch
        Min = 0.949999988
        Max = 1.04999995
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionVolume
        Min = 0.949999988
        Max = 1.04999995
    End Object
    PitchModulation = {
                       Distribution = DistributionPitch, 
                       Type = 0, 
                       Op = 2, 
                       LookupTableNumElements = 2, 
                       LookupTableChunkSize = 2, 
                       LookupTable = (0.949999988, 1.04999995, 0.949999988, 1.04999995, 0.949999988, 1.04999995), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    VolumeModulation = {
                        Distribution = DistributionVolume, 
                        Type = 0, 
                        Op = 2, 
                        LookupTableNumElements = 2, 
                        LookupTableChunkSize = 2, 
                        LookupTable = (0.949999988, 1.04999995, 0.949999988, 1.04999995, 0.949999988, 1.04999995), 
                        LookupTableTimeScale = 0.0, 
                        LookupTableStartTime = 0.0
                       }
}
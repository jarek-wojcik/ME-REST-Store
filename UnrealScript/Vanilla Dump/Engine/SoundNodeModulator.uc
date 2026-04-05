Class SoundNodeModulator extends SoundNode
    native
    editinlinenew;

var(Modulation) float PitchMin;
var(Modulation) float PitchMax;
var(Modulation) float VolumeMin;
var(Modulation) float VolumeMax;

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
    PitchMin = 0.949999988
    PitchMax = 1.04999995
    VolumeMin = 0.949999988
    VolumeMax = 1.04999995
}
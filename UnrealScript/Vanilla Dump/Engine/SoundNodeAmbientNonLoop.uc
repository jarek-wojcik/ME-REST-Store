Class SoundNodeAmbientNonLoop extends SoundNodeAmbient
    native
    editinlinenew;

var(Delay) float DelayMin;
var(Delay) float DelayMax;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionDelayTime
        Min = 1.0
        Max = 1.0
    End Object
    Begin Template Class=DistributionFloatUniform Name=DistributionLPFMaxRadius
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionLPFMinRadius
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionMaxRadius
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionMinRadius
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionPitch
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionVolume
    End Template
}
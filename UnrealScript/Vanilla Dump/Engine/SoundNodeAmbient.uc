Class SoundNodeAmbient extends SoundNode
    native
    editinlinenew;

struct native AmbientSoundSlot 
{
    var(AmbientSoundSlot) SoundNodeWave Wave;
    var(AmbientSoundSlot) float PitchScale;
    var(AmbientSoundSlot) float VolumeScale;
    var(AmbientSoundSlot) float Weight;
    
    structdefaultproperties
    {
        PitchScale = 1.0
        VolumeScale = 1.0
        Weight = 1.0
    }
};

var(Sounds) array<AmbientSoundSlot> SoundSlots;
var(Attenuation) float dBAttenuationAtMax;
var(Attenuation) float RadiusMin;
var(Attenuation) float RadiusMax;
var(LowPassFilter) float LPFRadiusMin;
var(LowPassFilter) float LPFRadiusMax;
var(Modulation) float PitchMin;
var(Modulation) float PitchMax;
var(Modulation) float VolumeMin;
var(Modulation) float VolumeMax;
var(Attenuation) bool bAttenuate;
var(Attenuation) bool bSpatialize;
var(LowPassFilter) bool bAttenuateWithLPF;
var(Attenuation) SoundDistanceModel DistanceModel;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionMinRadius
        Min = 400.0
        Max = 400.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionMaxRadius
        Min = 5000.0
        Max = 5000.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLPFMinRadius
        Min = 1500.0
        Max = 1500.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLPFMaxRadius
        Min = 2500.0
        Max = 2500.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionPitch
        Min = 1.0
        Max = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionVolume
        Min = 0.699999988
        Max = 0.699999988
    End Object
    dBAttenuationAtMax = -60.0
    RadiusMin = 2000.0
    RadiusMax = 5000.0
    LPFRadiusMin = 3500.0
    LPFRadiusMax = 7000.0
    PitchMin = 1.0
    PitchMax = 1.0
    VolumeMin = 0.699999988
    VolumeMax = 0.699999988
    bAttenuate = TRUE
    bSpatialize = TRUE
}
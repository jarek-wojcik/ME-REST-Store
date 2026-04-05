Class SoundNodeAttenuation extends SoundNode
    native
    editinlinenew;

enum ESoundDistanceCalc
{
    SOUNDDISTANCE_Normal,
    SOUNDDISTANCE_InfiniteXYPlane,
    SOUNDDISTANCE_InfiniteXZPlane,
    SOUNDDISTANCE_InfiniteYZPlane,
};
enum SoundDistanceModel
{
    ATTENUATION_Linear,
    ATTENUATION_Logarithmic,
    ATTENUATION_Inverse,
    ATTENUATION_LogReverse,
    ATTENUATION_NaturalSound,
};

var(Attenuation) float dBAttenuationAtMax;
var(Attenuation) float RadiusMin;
var(Attenuation) float RadiusMax;
var(LowPassFilter) float LPFRadiusMin;
var(LowPassFilter) float LPFRadiusMax;
var(Attenuation) bool bAttenuate;
var(Attenuation) bool bSpatialize;
var(LowPassFilter) bool bAttenuateWithLPF;
var(Attenuation) SoundDistanceModel DistanceAlgorithm;
var(Attenuation) ESoundDistanceCalc DistanceType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionLPFMaxRadius
        Min = 5000.0
        Max = 5000.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLPFMinRadius
        Min = 1500.0
        Max = 1500.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionMaxRadius
        Min = 5000.0
        Max = 5000.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionMinRadius
        Min = 400.0
        Max = 400.0
    End Object
    dBAttenuationAtMax = -60.0
    RadiusMin = 400.0
    RadiusMax = 4000.0
    LPFRadiusMin = 3000.0
    LPFRadiusMax = 6000.0
    bAttenuate = TRUE
    bSpatialize = TRUE
}
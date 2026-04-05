Class ApexClothingAsset extends ApexAsset
    native;

var native Pointer MApexAsset;
var(ApexClothingAsset) const int UVChannelForTangentUpdate;
var(ApexClothingAsset) const float MaxDistanceBlendTime;
var(ApexClothingAsset) const float ContinuousRotationThreshold;
var(ApexClothingAsset) const float ContinuousDistanceThreshold;
var(ApexClothingAsset) const float LodWeightsMaxDistance;
var(ApexClothingAsset) const float LodWeightsDistanceWeight;
var(ApexClothingAsset) const float LodWeightsBias;
var(ApexClothingAsset) const float LodWeightsBenefitsBias;
var(ApexClothingAsset) const bool bUseHardwareCloth;
var(ApexClothingAsset) const bool bFallbackSkinning;
var(ApexClothingAsset) const bool bSlowStart;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxDistanceBlendTime = 1.0
    ContinuousRotationThreshold = 84.0
    ContinuousDistanceThreshold = 50.0
    LodWeightsMaxDistance = 2000.0
    LodWeightsDistanceWeight = 1.0
    bUseHardwareCloth = TRUE
    bSlowStart = TRUE
}
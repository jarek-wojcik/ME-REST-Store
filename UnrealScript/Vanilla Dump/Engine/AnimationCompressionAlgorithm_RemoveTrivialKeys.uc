Class AnimationCompressionAlgorithm_RemoveTrivialKeys extends AnimationCompressionAlgorithm
    native;

var(AnimationCompressionAlgorithm_RemoveTrivialKeys) float MaxPosDiff;
var(AnimationCompressionAlgorithm_RemoveTrivialKeys) float MaxAngleDiff;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPosDiff = 0.0000999999975
    MaxAngleDiff = 0.000300000014
    Description = "Remove Trivial Keys"
}
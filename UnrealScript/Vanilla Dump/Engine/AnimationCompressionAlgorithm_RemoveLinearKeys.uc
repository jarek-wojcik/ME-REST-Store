Class AnimationCompressionAlgorithm_RemoveLinearKeys extends AnimationCompressionAlgorithm
    native;

var(AnimationCompressionAlgorithm_RemoveLinearKeys) float MaxPosDiff;
var(AnimationCompressionAlgorithm_RemoveLinearKeys) float MaxAngleDiff;
var(AnimationCompressionAlgorithm_RemoveLinearKeys) float MaxEffectorDiff;
var(AnimationCompressionAlgorithm_RemoveLinearKeys) float MinEffectorDiff;
var(AnimationCompressionAlgorithm_RemoveLinearKeys) float ParentKeyScale;
var(AnimationCompressionAlgorithm_RemoveLinearKeys) bool bRetarget;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPosDiff = 0.100000001
    MaxAngleDiff = 0.0250000004
    MaxEffectorDiff = 0.00999999978
    MinEffectorDiff = 0.0199999996
    ParentKeyScale = 2.0
    bRetarget = TRUE
    Description = "Remove Linear Keys"
    bNeedsSkeleton = TRUE
}
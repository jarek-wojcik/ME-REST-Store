Class SkelControlWheel extends SkelControlSingleBone
    native;

var(Wheel) transient float WheelDisplacement;
var(Wheel) float WheelMaxRenderDisplacement;
var(Wheel) transient float WheelRoll;
var(Wheel) transient float WheelSteering;
var(Wheel) bool bInvertWheelRoll;
var(Wheel) bool bInvertWheelSteering;
var(Wheel) EAxis WheelRollAxis;
var(Wheel) EAxis WheelSteeringAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WheelMaxRenderDisplacement = 50.0
    WheelRollAxis = EAxis.AXIS_X
    WheelSteeringAxis = EAxis.AXIS_Z
    bApplyTranslation = TRUE
    bApplyRotation = TRUE
    bAddTranslation = TRUE
    bAddRotation = TRUE
    BoneTranslationSpace = EBoneControlSpace.BCS_BoneSpace
    BoneRotationSpace = EBoneControlSpace.BCS_BoneSpace
    bIgnoreWhenNotRendered = TRUE
}
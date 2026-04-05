Class SkelControlHandlebars extends SkelControlSingleBone
    native;

var(Handlebars) Name WheelBoneName;
var int SteerWheelBoneIndex;
var(Handlebars) bool bInvertRotation;
var(Handlebars) EAxis WheelRollAxis;
var(Handlebars) EAxis HandlebarRotateAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SteerWheelBoneIndex = -1
    WheelRollAxis = EAxis.AXIS_Y
    HandlebarRotateAxis = EAxis.AXIS_Z
    bApplyRotation = TRUE
    BoneTranslationSpace = EBoneControlSpace.BCS_BoneSpace
    BoneRotationSpace = EBoneControlSpace.BCS_BoneSpace
    bIgnoreWhenNotRendered = TRUE
}
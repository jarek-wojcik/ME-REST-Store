Class SkelControlLimb extends SkelControlBase
    native;

var(Effector) Vector EffectorLocation;
var(Joint) Vector JointTargetLocation;
var(Effector) Name EffectorSpaceBoneName;
var(Joint) Name JointTargetSpaceBoneName;
var(SkelControlLimb) Vector2D StretchLimits;
var(SkelControlLimb) Name StretchRollBoneName;
var(Limb) bool bInvertBoneAxis;
var(Limb) bool bInvertJointAxis;
var(Limb) bool bMaintainEffectorRelRot;
var(Limb) bool bTakeRotationFromEffectorSpace;
var(SkelControlLimb) bool bAllowStretching;
var(Effector) EBoneControlSpace EffectorLocationSpace;
var(Joint) EBoneControlSpace JointTargetLocationSpace;
var(Limb) EAxis BoneAxis;
var(Limb) EAxis JointAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StretchLimits = {X = 0.709999979, Y = 1.20000005}
    BoneAxis = EAxis.AXIS_X
    JointAxis = EAxis.AXIS_Y
    bIgnoreWhenNotRendered = TRUE
}
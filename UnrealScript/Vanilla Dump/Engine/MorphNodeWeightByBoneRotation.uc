Class MorphNodeWeightByBoneRotation extends MorphNodeWeightBase
    native;

var(MorphNodeWeightByBoneRotation) array<BoneAngleMorph> WeightArray;
var(MorphNodeWeightByBoneRotation) Name BoneName;
var(Material) Name ScalarParameterName;
var const transient float Angle;
var const transient float NodeWeight;
var(Material) int MaterialSlotId;
var transient MaterialInstanceConstant MaterialInstanceConstant;
var(MorphNodeWeightByBoneRotation) bool bInvertBoneAxis;
var(Material) bool bControlMaterialParameter;
var(MorphNodeWeightByBoneRotation) EAxis BoneAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeightArray = ({Angle = 0.0, TargetWeight = 0.0}, 
                   {Angle = 90.0, TargetWeight = 1.0}
                  )
    BoneAxis = EAxis.AXIS_Y
    NodeConns = ({
                  ChildNodes = (), 
                  ConnName = 'In', 
                  DrawY = 0
                 }
                )
}
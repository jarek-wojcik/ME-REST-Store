Class MorphNodeWeightByBoneAngle extends MorphNodeWeightBase
    native;

struct native BoneAngleMorph 
{
    var(BoneAngleMorph) float Angle;
    var(BoneAngleMorph) float TargetWeight;
    
    structdefaultproperties
    {
        TargetWeight = 1.0
    }
};

var(MorphNodeWeightByBoneAngle) array<BoneAngleMorph> WeightArray;
var(BaseBone) Name BaseBoneName;
var(AngleBone) Name AngleBoneName;
var(Material) Name ScalarParameterName;
var const transient float Angle;
var const transient float NodeWeight;
var(Material) int MaterialSlotId;
var transient MaterialInstanceConstant MaterialInstanceConstant;
var(BaseBone) bool bInvertBaseBoneAxis;
var(AngleBone) bool bInvertAngleBoneAxis;
var(Material) bool bControlMaterialParameter;
var(BaseBone) EAxis BaseBoneAxis;
var(AngleBone) EAxis AngleBoneAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeightArray = ({Angle = 0.0, TargetWeight = 0.0}, 
                   {Angle = 180.0, TargetWeight = 1.0}
                  )
    BaseBoneAxis = EAxis.AXIS_X
    AngleBoneAxis = EAxis.AXIS_X
    NodeConns = ({
                  ChildNodes = (), 
                  ConnName = 'In', 
                  DrawY = 0
                 }
                )
}
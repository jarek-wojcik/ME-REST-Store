Class SkelControl_CCD_IK extends SkelControlBase
    native;

var(CCD) const array<float> AngleConstraint;
var(Effector) Vector EffectorLocation;
var(Effector) Vector EffectorTranslationFromBone;
var(Effector) Name EffectorSpaceBoneName;
var(CCD) int NumBones;
var(CCD) int MaxPerBoneIterations;
var const int IterationsCount;
var(CCD) float Precision;
var(CCD) float MaxAngleSteps;
var(CCD) bool bStartFromTail;
var(CCD) bool bNoTurnOptimization;
var(Effector) EBoneControlSpace EffectorLocationSpace;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NumBones = 2
    MaxPerBoneIterations = 3
    Precision = 0.100000001
    MaxAngleSteps = 0.400000006
}
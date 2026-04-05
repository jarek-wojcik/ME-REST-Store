Class SkelControlSingleBone extends SkelControlBase
    native;

var(Translation) Vector BoneTranslation;
var(Rotation) Rotator BoneRotation;
var(Translation) Name TranslationSpaceBoneName;
var(Rotation) Name RotationSpaceBoneName;
var(Adjustments) bool bApplyTranslation;
var(Adjustments) bool bApplyRotation;
var(Translation) bool bAddTranslation;
var(Rotation) bool bAddRotation;
var(Rotation) bool bRemoveMeshRotation;
var(Translation) EBoneControlSpace BoneTranslationSpace;
var(Rotation) EBoneControlSpace BoneRotationSpace;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
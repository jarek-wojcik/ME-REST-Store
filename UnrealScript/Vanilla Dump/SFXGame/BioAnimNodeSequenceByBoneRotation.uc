Class BioAnimNodeSequenceByBoneRotation extends AnimNodeSequence
    native;

struct native AnimByRotation 
{
    var(AnimByRotation) Rotator DesiredRotation;
    var(AnimByRotation) Name AnimName;
    var const transient AnimSequence AnimSeq;
};

var(BioAnimNodeSequenceByBoneRotation) array<AnimByRotation> AnimList;
var(BioAnimNodeSequenceByBoneRotation) Name BoneName;
var(BioAnimNodeSequenceByBoneRotation) EAxis BoneAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BoneAxis = EAxis.AXIS_X
}
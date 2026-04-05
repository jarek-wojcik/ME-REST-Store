Class MorphNodeMultiPose extends MorphNodeBase
    native;

var transient array<MorphTarget> Targets;
var(MorphNodeMultiPose) array<Name> MorphNames;
var(MorphNodeMultiPose) array<float> Weights;

public final native function bool AddMorphTarget(Name MorphTargetName, optional float InWeight = 1.0);

public final native function RemoveMorphTarget(Name MorphTargetName);

public final native function bool UpdateMorphTarget(MorphTarget Target, float InWeight);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
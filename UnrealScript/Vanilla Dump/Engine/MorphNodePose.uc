Class MorphNodePose extends MorphNodeBase
    native;

var(MorphNodePose) Name MorphName;
var transient MorphTarget Target;
var(MorphNodePose) float Weight;

public final native function SetMorphTarget(Name MorphTargetName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Weight = 1.0
}
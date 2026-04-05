Class SkelControl_TwistBone extends SkelControlBase
    native;

var(SkelControl_TwistBone) Name SourceBoneName;
var(SkelControl_TwistBone) float TwistAngleScale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TwistAngleScale = -0.5
    bIgnoreWhenNotRendered = TRUE
}
Class BioSkelControlAdditiveLookAt extends SkelControlLookAt
    native;

var(Limit) float MaxAngleUpDown;
var(Limit) bool bSeparateUpDownLimit;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bIgnoreWhenNotRendered = FALSE
}
Class SFXJumpReachSpec extends SFXCustomReachSpec
    native;

var(SFXJumpReachSpec) float MaxHeight;
var(SFXJumpReachSpec) float MovePercentToReachMaxHeight;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxHeight = 100.0
    MovePercentToReachMaxHeight = 0.5
}
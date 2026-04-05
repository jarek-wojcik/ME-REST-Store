Class PBRuleNodeRepeat extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeRepeat) float RepeatMaxSize;
var(PBRuleNodeRepeat) EProcBuildingAxis RepeatAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RepeatMaxSize = 512.0
    RepeatAxis = EProcBuildingAxis.EPBAxis_Z
}
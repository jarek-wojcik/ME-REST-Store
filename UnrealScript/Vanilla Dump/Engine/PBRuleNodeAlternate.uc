Class PBRuleNodeAlternate extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeAlternate) float ASize;
var(PBRuleNodeAlternate) float BMaxSize;
var(PBRuleNodeAlternate) bool bInvertPatternOrder;
var(PBRuleNodeAlternate) bool bEqualSizeAB;
var(PBRuleNodeAlternate) EProcBuildingAxis RepeatAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ASize = 512.0
    NextRules = ({LinkName = 'A', NextRule = None}, 
                 {LinkName = 'B', NextRule = None}
                )
}
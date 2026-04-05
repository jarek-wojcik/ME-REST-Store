Class PBRuleNodeSize extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeSize) float DecisionSize;
var(PBRuleNodeSize) bool bUseTopLevelScopeSize;
var(PBRuleNodeSize) EProcBuildingAxis SizeAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DecisionSize = 512.0
    NextRules = ({LinkName = 'Less', NextRule = None}, 
                 {LinkName = 'Greater/Equal', NextRule = None}
                )
}
Class PBRuleNodeEdgeMesh extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeEdgeMesh) float FlatThreshold;
var(PBRuleNodeEdgeMesh) float MainXPullIn;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FlatThreshold = 5.0
    NextRules = ({LinkName = 'Main', NextRule = None}, 
                 {LinkName = 'Edge', NextRule = None}
                )
}
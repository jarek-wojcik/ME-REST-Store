Class PBRuleNodeRandom extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeRandom) int NumOutputs;
var(PBRuleNodeRandom) int MinNumExecuted;
var(PBRuleNodeRandom) int MaxNumExecuted;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NumOutputs = 2
    MinNumExecuted = 1
    MaxNumExecuted = 1
    NextRules = ({LinkName = '0', NextRule = None}, 
                 {LinkName = '1', NextRule = None}
                )
}
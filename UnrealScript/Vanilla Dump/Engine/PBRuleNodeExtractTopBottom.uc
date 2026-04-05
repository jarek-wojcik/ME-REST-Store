Class PBRuleNodeExtractTopBottom extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeExtractTopBottom) float ExtractTopZ;
var(PBRuleNodeExtractTopBottom) float ExtractNotTopZ;
var(PBRuleNodeExtractTopBottom) float ExtractBottomZ;
var(PBRuleNodeExtractTopBottom) float ExtractNotBottomZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ExtractTopZ = 512.0
    ExtractBottomZ = 512.0
    NextRules = ({LinkName = 'Top', NextRule = None}, 
                 {LinkName = 'Not Top', NextRule = None}, 
                 {LinkName = 'Mid', NextRule = None}, 
                 {LinkName = 'Bottom', NextRule = None}, 
                 {LinkName = 'Not Bottom', NextRule = None}
                )
}
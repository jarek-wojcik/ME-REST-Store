Class PBRuleNodeBase
    native
    editinlinenew
    abstract
    collapsecategories;

struct native PBRuleLink 
{
    var(PBRuleLink) Name LinkName;
    var(PBRuleLink) export PBRuleNodeBase NextRule;
};

var editfixedsize array<PBRuleLink> NextRules;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NextRules = ({LinkName = 'Next', NextRule = None}
                )
}
Class PBRuleNodeSplit extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

struct native RBSplitInfo 
{
    var(RBSplitInfo) Name SplitName;
    var(RBSplitInfo) float FixedSize;
    var(RBSplitInfo) float ExpandRatio;
    var(RBSplitInfo) bool bFixSize;
    
    structdefaultproperties
    {
        FixedSize = 512.0
        ExpandRatio = 1.0
    }
};

var(PBRuleNodeSplit) array<RBSplitInfo> SplitSetup;
var(PBRuleNodeSplit) EProcBuildingAxis SplitAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplitAxis = EProcBuildingAxis.EPBAxis_Z
    NextRules = ()
}
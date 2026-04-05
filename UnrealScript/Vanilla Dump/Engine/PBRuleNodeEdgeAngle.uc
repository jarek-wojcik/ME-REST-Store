Class PBRuleNodeEdgeAngle extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

struct native RBEdgeAngleInfo 
{
    var(RBEdgeAngleInfo) float Angle;
};
enum EProcBuildingEdge
{
    EPBE_Top,
    EPBE_Bottom,
    EPBE_Left,
    EPBE_Right,
};

var(PBRuleNodeEdgeAngle) array<RBEdgeAngleInfo> Angles;
var(PBRuleNodeEdgeAngle) EProcBuildingEdge Edge;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Edge = EProcBuildingEdge.EPBE_Left
    NextRules = ()
}
Class PBRuleNodeCorner extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

struct native RBCornerAngleInfo 
{
    var(RBCornerAngleInfo) float Angle;
    var(RBCornerAngleInfo) float CornerSize;
};

var(PBRuleNodeCorner) array<RBCornerAngleInfo> Angles;
var(PBRuleNodeCorner) float CornerSize;
var(PBRuleNodeCorner) float FlatThreshold;
var(PBRuleNodeCorner) float CornerShapeOffset;
var(PBRuleNodeCorner) int RoundTesselation;
var(PBRuleNodeCorner) float RoundCurvature;
var(PBRuleNodeCorner) bool bNoMeshForConcaveCorners;
var(PBRuleNodeCorner) bool bUseAdjacentRulesetForRightGap;
var(PBRuleNodeCorner) EPBCornerType CornerType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Angles = ({Angle = 90.0, CornerSize = 0.0}, 
              {Angle = -90.0, CornerSize = 0.0}
             )
    CornerSize = 256.0
    FlatThreshold = 5.0
    RoundTesselation = 4
    RoundCurvature = 1.0
}
Class PBRuleNodeWindowWall extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeWindowWall) float CellMaxSizeX;
var(PBRuleNodeWindowWall) float CellMaxSizeZ;
var(PBRuleNodeWindowWall) float WindowSizeX;
var(PBRuleNodeWindowWall) float WindowSizeZ;
var(PBRuleNodeWindowWall) float WindowPosX;
var(PBRuleNodeWindowWall) float WindowPosZ;
var(PBRuleNodeWindowWall) float YOffset;
var(PBRuleNodeWindowWall) MaterialInterface Material;
var(PBRuleNodeWindowWall) bool bScaleWindowWithCell;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CellMaxSizeX = 512.0
    CellMaxSizeZ = 512.0
    WindowSizeX = 128.0
    WindowSizeZ = 232.0
    WindowPosX = 0.5
    WindowPosZ = 0.5
}
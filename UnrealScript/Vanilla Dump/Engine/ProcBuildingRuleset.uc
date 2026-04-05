Class ProcBuildingRuleset
    native;

enum EProcBuildingAxis
{
    EPBAxis_X,
    EPBAxis_Z,
};
struct native PBVariationInfo 
{
    var(PBVariationInfo) Name VariationName;
    var(PBVariationInfo) bool bMeshOnTopOfFacePoly;
};

var(ProcBuildingRuleset) array<PBVariationInfo> Variations;
var(ProcBuildingRuleset) MaterialInterface DefaultRoofMaterial;
var(ProcBuildingRuleset) MaterialInterface DefaultFloorMaterial;
var(ProcBuildingRuleset) MaterialInterface DefaultNonRectWallMaterial;
var(ProcBuildingRuleset) float RoofZOffset;
var(ProcBuildingRuleset) float NotRoofZOffset;
var(ProcBuildingRuleset) float FloorZOffset;
var(ProcBuildingRuleset) float NotFloorZOffset;
var(ProcBuildingRuleset) float RoofPolyInset;
var(ProcBuildingRuleset) float FloorPolyInset;
var(ProcBuildingRuleset) float BuildingLODSpecular;
var(ProcBuildingRuleset) float RoofEdgeScopeRaise;
var(ProcBuildingRuleset) Texture LODCubemap;
var(ProcBuildingRuleset) Texture InteriorTexture;
var export PBRuleNodeBase RootRule;
var(ProcBuildingRuleset) bool bEnableInteriorTexture;
var(ProcBuildingRuleset) bool bLODOnlyRoof;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BuildingLODSpecular = 2.0
    bEnableInteriorTexture = TRUE
}
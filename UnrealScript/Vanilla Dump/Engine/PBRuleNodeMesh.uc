Class PBRuleNodeMesh extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

struct native BuildingMeshInfo 
{
    var array<MaterialInterface> MaterialOverrides;
    var(BuildingMeshInfo) array<BuildingMatOverrides> SectionOverrides;
    var(BuildingMeshInfo) StaticMesh Mesh;
    var(BuildingMeshInfo) float DimX;
    var(BuildingMeshInfo) float DimZ;
    var(BuildingMeshInfo) float Chance;
    var(BuildingMeshInfo) editinline export DistributionVector Translation;
    var(BuildingMeshInfo) editinline export DistributionVector Rotation;
    var(BuildingMeshInfo) int OverriddenMeshLightMapRes;
    var(BuildingMeshInfo) bool bMeshScaleTranslation;
    var(BuildingMeshInfo) bool bOverrideMeshLightMapRes;
    
    structdefaultproperties
    {
        DimX = 512.0
        DimZ = 512.0
        Chance = 1.0
        OverriddenMeshLightMapRes = 32
    }
};
struct native BuildingMatOverrides 
{
    var(BuildingMatOverrides) array<MaterialInterface> MaterialOptions;
};

var(PBRuleNodeMesh) editinline BuildingMeshInfo PartialOccludedBuildingMesh;
var(PBRuleNodeMesh) editinline array<BuildingMeshInfo> BuildingMeshes;
var(PBRuleNodeMesh) bool bDoOcclusionTest;
var(PBRuleNodeMesh) bool bBlockAll;

public native function int PickRandomBuildingMesh();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PartialOccludedBuildingMesh = {
                                   MaterialOverrides = (), 
                                   SectionOverrides = (), 
                                   Mesh = None, 
                                   DimX = 512.0, 
                                   DimZ = 512.0, 
                                   Chance = 1.0, 
                                   Translation = None, 
                                   Rotation = None, 
                                   OverriddenMeshLightMapRes = 32, 
                                   bMeshScaleTranslation = FALSE, 
                                   bOverrideMeshLightMapRes = FALSE
                                  }
    bDoOcclusionTest = TRUE
    NextRules = ()
}
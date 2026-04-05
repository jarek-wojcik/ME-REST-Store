Class TerrainMaterial
    native;

struct native TerrainFoliageMesh 
{
    var(TerrainFoliageMesh) StaticMesh StaticMesh;
    var(TerrainFoliageMesh) MaterialInterface Material;
    var(TerrainFoliageMesh) int Density;
    var(TerrainFoliageMesh) float MaxDrawRadius;
    var(TerrainFoliageMesh) float MinTransitionRadius;
    var(TerrainFoliageMesh) float MinScale;
    var(TerrainFoliageMesh) float MaxScale;
    var(TerrainFoliageMesh) float MinUniformScale;
    var(TerrainFoliageMesh) float MaxUniformScale;
    var(TerrainFoliageMesh) float MinThinningRadius;
    var(TerrainFoliageMesh) int Seed;
    var(TerrainFoliageMesh) float SwayScale;
    var(TerrainFoliageMesh) float AlphaMapThreshold;
    var(TerrainFoliageMesh) float SlopeRotationBlend;
    
    structdefaultproperties
    {
        MaxDrawRadius = 1024.0
        MinScale = 1.0
        MaxScale = 1.0
        MinUniformScale = 1.0
        MaxUniformScale = 1.0
        MinThinningRadius = 1024.0
        SwayScale = 1.0
    }
};
enum ETerrainMappingType
{
    TMT_Auto,
    TMT_XY,
    TMT_XZ,
    TMT_YZ,
};

var Matrix LocalToMapping;
var(Foliage) array<TerrainFoliageMesh> FoliageMeshes;
var(Material) float MappingScale;
var(Material) float MappingRotation;
var(Material) float MappingPanU;
var(Material) float MappingPanV;
var(Material) MaterialInterface Material;
var(Displacement) Texture2D DisplacementMap;
var(Displacement) float DisplacementScale;
var(Material) ETerrainMappingType MappingType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MappingScale = 4.0
    DisplacementScale = 0.25
}
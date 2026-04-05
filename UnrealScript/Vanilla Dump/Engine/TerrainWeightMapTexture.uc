Class TerrainWeightMapTexture extends Texture2D
    native
    config(Engine);

struct TerrainWeightedMaterial 
{
};

var const native array<Pointer> WeightedMaterials;
var const Terrain ParentTerrain;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
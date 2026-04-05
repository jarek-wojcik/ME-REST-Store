Class TerrainLayerSetup
    native
    collapsecategories;

struct TerrainFilteredMaterial 
{
    var(TerrainFilteredMaterial) bool UseNoise;
    var(TerrainFilteredMaterial) float NoiseScale;
    var(TerrainFilteredMaterial) float NoisePercent;
    var(TerrainFilteredMaterial) FilterLimit MinHeight;
    var(TerrainFilteredMaterial) FilterLimit MaxHeight;
    var(TerrainFilteredMaterial) FilterLimit MinSlope;
    var(TerrainFilteredMaterial) FilterLimit MaxSlope;
    var(TerrainFilteredMaterial) float Alpha;
    var(TerrainFilteredMaterial) TerrainMaterial Material;
    
    structdefaultproperties
    {
        Alpha = 1.0
    }
};
struct FilterLimit 
{
    var(FilterLimit) bool Enabled;
    var(FilterLimit) float Base;
    var(FilterLimit) float NoiseScale;
    var(FilterLimit) float NoiseAmount;
};

var(TerrainLayerSetup) const array<TerrainFilteredMaterial> Materials;

public simulated function PostBeginPlay();

public final native function SetMaterials(array<TerrainFilteredMaterial> NewMaterials);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
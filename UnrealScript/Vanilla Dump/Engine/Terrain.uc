Class Terrain extends Info
    native
    placeable;

struct SelectedTerrainVertex 
{
    var int X;
    var int Y;
    var int Weight;
};
struct native CachedTerrainMaterialArray 
{
    var const native duplicatetransient array<Pointer> CachedMaterials;
};
struct TerrainMaterialResource 
{
};
struct TerrainDecoLayer 
{
    var(TerrainDecoLayer) string Name;
    var(TerrainDecoLayer) editinline array<TerrainDecoration> Decorations;
    var int AlphaMapIndex;
    
    structdefaultproperties
    {
        AlphaMapIndex = -1
    }
};
struct TerrainDecoration 
{
    var(TerrainDecoration) PrimitiveComponentFactory Factory;
    var(TerrainDecoration) float MinScale;
    var(TerrainDecoration) float MaxScale;
    var(TerrainDecoration) float Density;
    var(TerrainDecoration) float SlopeRotationBlend;
    var(TerrainDecoration) int RandSeed;
    var(TerrainDecoration) bool bRandomlyRotateYaw;
    var editinline array<TerrainDecorationInstance> Instances;
    
    structdefaultproperties
    {
        MinScale = 1.0
        MaxScale = 1.0
        Density = 0.00999999978
        bRandomlyRotateYaw = TRUE
    }
};
struct TerrainDecorationInstance 
{
    var editinline export PrimitiveComponent Component;
    var float X;
    var float Y;
    var float Scale;
    var int Yaw;
};
struct AlphaMap 
{
};
struct TerrainLayer 
{
    var(TerrainLayer) string Name;
    var(TerrainLayer) TerrainLayerSetup Setup;
    var int AlphaMapIndex;
    var(TerrainLayer) bool Highlighted;
    var(TerrainLayer) bool WireframeHighlighted;
    var(TerrainLayer) bool Hidden;
    var(TerrainLayer) Color HighlightColor;
    var(TerrainLayer) Color WireframeColor;
    var int MinX;
    var int MinY;
    var int MaxX;
    var int MaxY;
    
    structdefaultproperties
    {
        AlphaMapIndex = -1
        HighlightColor = {B = 255, G = 255, R = 255, A = 0}
    }
};
struct TerrainWeightedMaterial 
{
};
struct TerrainInfoData 
{
};
struct TerrainHeight 
{
};

var const native CachedTerrainMaterialArray CachedTerrainMaterials[2];
var const native array<TerrainHeight> Heights;
var const native array<TerrainInfoData> InfoData;
var const native array<AlphaMap> AlphaMaps;
var const native array<TerrainWeightedMaterial> WeightedMaterials;
var const native array<TerrainWeightMapTexture> WeightedTextureMaps;
var const native array<byte> CachedDisplacements;
var(Terrain) const array<TerrainLayer> Layers;
var(Terrain) const editinline array<TerrainDecoLayer> DecoLayers;
var const editinline export nontransactional array<TerrainComponent> TerrainComponents;
var transient array<SelectedTerrainVertex> SelectedVertices;
var const native Pointer ReleaseResourcesFence;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
var const Guid LightingGuid;
var(Terrain) int NormalMapLayer;
var const int NumSectionsX;
var const int NumSectionsY;
var const int SectionSize;
var const native float MaxCollisionDisplacement;
var(Terrain) int MaxTesselationLevel;
var(Terrain) int MinTessellationLevel;
var(Terrain) float TesselationDistanceScale;
var(Terrain) float TessellationCheckDistance;
var(Collision) int CollisionTesselationLevel;
var const int NumVerticesX;
var const int NumVerticesY;
var(Terrain) int NumPatchesX;
var(Terrain) int NumPatchesY;
var(Terrain) int MaxComponentSize;
var(Lighting) int StaticLightingResolution;
var(Physics) const PhysicalMaterial TerrainPhysMaterialOverride;
var(Lighting) const LightingChannelContainer LightingChannels;
var(Terrain) transient int EditorTessellationLevel;
var(Terrain) Color WireframeColor;
var(Lighting) bool bIsOverridingLightResolution;
var(Lighting) bool bBilinearFilterLightmapGeneration;
var(Lighting) bool bCastShadow;
var(Lighting) const bool bForceDirectLightMap;
var(Lighting) const bool bCastDynamicShadow;
var(Lighting) bool bEnableSpecular;
var(Collision) const bool bBlockRigidBody;
var(Collision) const bool bAllowRigidBodyUnderneath;
var(Terrain) const bool bNoPhysCollision;
var(Lighting) const bool bAcceptsDynamicLights;
var(Terrain) bool bMorphingEnabled;
var(Terrain) bool bMorphingGradientsEnabled;
var bool bLocked;
var bool bHeightmapLocked;
var bool bShowingCollision;
var(Terrain) bool bShowWireframe;

public final native function CalcLayerBounds();

public event simulated function PostBeginPlay()
{
    local int i;
    
    CalcLayerBounds();
    for (i = 0; i < Layers.Length; i++)
    {
        if (Layers[i].Setup != None)
        {
            Layers[i].Setup.PostBeginPlay();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightmassSettings = {
                         bUseTwoSidedLighting = FALSE, 
                         bShadowIndirectOnly = FALSE, 
                         bUseEmissiveForStaticLighting = FALSE, 
                         EmissiveLightFalloffExponent = 2.0, 
                         EmissiveLightExplicitInfluenceRadius = 0.0, 
                         EmissiveBoost = 1.0, 
                         DiffuseBoost = 1.0, 
                         SpecularBoost = 1.0, 
                         FullyOccludedSamplesFraction = 1.0
                        }
    NormalMapLayer = -1
    MaxTesselationLevel = 4
    MinTessellationLevel = 1
    TesselationDistanceScale = 1.0
    TessellationCheckDistance = -1.0
    CollisionTesselationLevel = 1
    NumPatchesX = 1
    NumPatchesY = 1
    MaxComponentSize = 16
    StaticLightingResolution = 4
    LightingChannels = {
                        bInitialized = TRUE, 
                        BSP = FALSE, 
                        Static = TRUE, 
                        Dynamic = FALSE, 
                        CompositeDynamic = FALSE, 
                        Skybox = FALSE, 
                        Unnamed_1 = FALSE, 
                        Unnamed_2 = FALSE, 
                        Unnamed_3 = FALSE, 
                        Unnamed_4 = FALSE, 
                        Unnamed_5 = FALSE, 
                        Unnamed_6 = FALSE, 
                        Cinematic_1 = FALSE, 
                        Cinematic_2 = FALSE, 
                        Cinematic_3 = FALSE, 
                        Cinematic_4 = FALSE, 
                        Cinematic_5 = FALSE, 
                        Cinematic_6 = FALSE, 
                        Cinematic_7 = FALSE, 
                        Cinematic_8 = FALSE, 
                        Cinematic_9 = FALSE, 
                        Cinematic_10 = FALSE, 
                        Gameplay_1 = FALSE, 
                        Gameplay_2 = FALSE, 
                        Gameplay_3 = FALSE, 
                        Gameplay_4 = FALSE, 
                        Crowd = FALSE
                       }
    WireframeColor = {B = 255, G = 255, R = 0, A = 0}
    bBilinearFilterLightmapGeneration = TRUE
    bCastShadow = TRUE
    bForceDirectLightMap = TRUE
    bCastDynamicShadow = TRUE
    bBlockRigidBody = TRUE
    bAcceptsDynamicLights = TRUE
    DrawScale3D = {X = 256.0, Y = 256.0, Z = 256.0}
    bStatic = TRUE
    bHidden = FALSE
    bNoDelete = TRUE
    bWorldGeometry = TRUE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
}
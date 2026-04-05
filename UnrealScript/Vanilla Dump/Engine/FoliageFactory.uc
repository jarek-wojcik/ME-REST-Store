Class FoliageFactory extends Volume
    native
    placeable;

struct native FoliageMesh 
{
    var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
    var(FoliageMesh) Vector MinScale;
    var(FoliageMesh) Vector MaxScale;
    var(FoliageMesh) StaticMesh InstanceStaticMesh;
    var(FoliageMesh) MaterialInterface Material;
    var(FoliageMesh) float MaxDrawRadius;
    var(FoliageMesh) float MinTransitionRadius;
    var(FoliageMesh) float MinThinningRadius;
    var(FoliageMesh) float MinUniformScale;
    var(FoliageMesh) float MaxUniformScale;
    var(FoliageMesh) float SwayScale;
    var(FoliageMesh) int Seed;
    var(FoliageMesh) float SurfaceAreaPerInstance;
    var editinline export FoliageComponent Component;
    var(FoliageMesh) bool bCreateInstancesOnBSP;
    var(FoliageMesh) bool bCreateInstancesOnStaticMeshes;
    var(FoliageMesh) bool bCreateInstancesOnTerrain;
    
    structdefaultproperties
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
                             FullyOccludedSamplesFraction = 0.0
                            }
        MinScale = {X = 1.0, Y = 1.0, Z = 1.0}
        MaxScale = {X = 1.0, Y = 1.0, Z = 1.0}
        MaxDrawRadius = 2000.0
        MinThinningRadius = 2000.0
        MinUniformScale = 1.0
        MaxUniformScale = 1.0
        SwayScale = 1.0
        SurfaceAreaPerInstance = 1000.0
        bCreateInstancesOnBSP = TRUE
        bCreateInstancesOnStaticMeshes = TRUE
        bCreateInstancesOnTerrain = TRUE
    }
};

var(Foliage) const editinline array<FoliageMesh> Meshes;
var(Foliage) const float VolumeFalloffRadius;
var(Foliage) const float VolumeFalloffExponent;
var(Foliage) const float SurfaceDensityUpFacing;
var(Foliage) const float SurfaceDensityDownFacing;
var(Foliage) const float SurfaceDensitySideFacing;
var(Foliage) const float FacingFalloffExponent;
var(Foliage) const int MaxInstanceCount;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    VolumeFalloffExponent = 1.0
    SurfaceDensityUpFacing = 1.0
    SurfaceDensityDownFacing = 1.0
    SurfaceDensitySideFacing = 1.0
    FacingFalloffExponent = 2.0
    MaxInstanceCount = 10000
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bHidden = FALSE
    bMovable = FALSE
}
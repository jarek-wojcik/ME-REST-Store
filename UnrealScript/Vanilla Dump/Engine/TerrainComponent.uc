Class TerrainComponent extends PrimitiveComponent
    native
    noexport;

struct TerrainBVTree 
{
    var const native array<int> Nodes;
};
struct TerrainkDOPTree 
{
    var const native array<int> Nodes;
    var const native array<int> Triangles;
};

var const array<ShadowMap2D> ShadowMaps;
var const array<Guid> IrrelevantLights;
var const transient native Pointer TerrainObject;
var const int SectionBaseX;
var const int SectionBaseY;
var const int SectionSizeX;
var const int SectionSizeY;
var const int TrueSectionSizeX;
var const int TrueSectionSizeY;
var const native Pointer LightMap;
var const transient native array<int> PatchBounds;
var const transient native array<int> PatchBatches;
var const transient native array<int> BatchMaterials;
var const transient native int FullBatch;
var const transient native Pointer PatchBatchOffsets;
var const transient native Pointer WorkingOffsets;
var const transient native Pointer PatchBatchTriangles;
var const transient native Pointer PatchCachedTessellationValues;
var const transient native Pointer TesselationLevels;
var const transient native TerrainBVTree BVTree;
var const transient native array<Vector> CollisionVertices;
var const native Pointer RBHeightfield;
var const bool bDisplayCollisionLevel;
var transient native bool bPhysicsMeshDirty;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
    bAllowCullDistanceVolume = FALSE
    bUseAsOccluder = TRUE
    bAcceptsStaticDecals = TRUE
    CastShadow = TRUE
    bAcceptsLights = TRUE
    bUsePrecomputedShadows = TRUE
    CollideActors = TRUE
    BlockActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    BlockRigidBody = TRUE
}
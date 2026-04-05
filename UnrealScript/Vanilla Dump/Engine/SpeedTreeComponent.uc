Class SpeedTreeComponent extends PrimitiveComponent
    native
    editinlinenew;

struct LightMapRef 
{
    var const native Pointer Reference;
};
struct native SpeedTreeStaticLight 
{
    var const Guid Guid;
    var const ShadowMap1D BranchShadowMap;
    var const ShadowMap1D FrondShadowMap;
    var const ShadowMap1D LeafMeshShadowMap;
    var const ShadowMap1D LeafCardShadowMap;
    var const ShadowMap1D BillboardShadowMap;
};
enum ESpeedTreeMeshType
{
    STMT_MinMinusOne,
    STMT_Branches1,
    STMT_Branches2,
    STMT_Fronds,
    STMT_LeafCards,
    STMT_LeafMeshes,
    STMT_Billboards,
};

var const native Matrix RotationOnlyMatrix;
var const array<SpeedTreeStaticLight> StaticLights;
var const native LightMapRef BranchLightMap;
var const native LightMapRef FrondLightMap;
var const native LightMapRef LeafMeshLightMap;
var const native LightMapRef LeafCardLightMap;
var const native LightMapRef BillboardLightMap;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
var(SpeedTree) const SpeedTree SpeedTree;
var(SpeedTree) float Lod3DStart;
var(SpeedTree) float Lod3DEnd;
var(SpeedTree) float LodBillboardStart;
var(SpeedTree) float LodBillboardEnd;
var(SpeedTree) float LodLevelOverride;
var(SpeedTree) MaterialInterface Branch1Material;
var(SpeedTree) MaterialInterface Branch2Material;
var(SpeedTree) MaterialInterface FrondMaterial;
var(SpeedTree) MaterialInterface LeafCardMaterial;
var(SpeedTree) MaterialInterface LeafMeshMaterial;
var(SpeedTree) MaterialInterface BillboardMaterial;
var(SpeedTree) bool bUseLeafCards;
var(SpeedTree) bool bUseLeafMeshes;
var(SpeedTree) bool bUseBranches;
var(SpeedTree) bool bUseFronds;
var(SpeedTree) bool bUseBillboards;

public native function MaterialInterface GetMaterial(ESpeedTreeMeshType MeshType);

public native function SetMaterial(ESpeedTreeMeshType MeshType, MaterialInterface Material);


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
    Lod3DStart = 500.0
    Lod3DEnd = 3000.0
    LodBillboardStart = 3500.0
    LodBillboardEnd = 4000.0
    LodLevelOverride = 1.0
    bUseLeafCards = TRUE
    bUseLeafMeshes = TRUE
    bUseBranches = TRUE
    bUseFronds = TRUE
    bUseBillboards = TRUE
    ReplacementPrimitive = None
    bUseAsOccluder = TRUE
    CastShadow = TRUE
    bAcceptsLights = TRUE
    bUsePrecomputedShadows = TRUE
    CollideActors = TRUE
    BlockActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    BlockRigidBody = TRUE
}
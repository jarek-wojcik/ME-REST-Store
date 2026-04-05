Class StaticMeshComponent extends MeshComponent
    native
    noexport
    editinlinenew;

struct StaticMeshComponentLODInfo 
{
    var const array<ShadowMap2D> ShadowMaps;
    var const array<Object> ShadowVertexBuffers;
    var const native Pointer LightMap;
    var const native Pointer OverrideVertexColors;
};
enum LightMapEncodingType
{
    LMET_UE3,
    LMET_Vector,
    LMET_Simple,
};

var(StaticMeshComponent) int ForcedLodModel;
var int PreviousLODLevel;
var(StaticMeshComponent) const StaticMesh StaticMesh;
var(StaticMeshComponent) Color WireframeColor;
var(StaticMeshComponent) float OverriddenLODMaxRange;
var(Audio) float AudioObstruction;
var(Audio) float AudioOcclusion;
var(StaticMeshComponent) bool bIgnoreInstanceForTextureStreaming;
var const transient bool bForceStaticDecals;
var(Physics) bool bNeverBecomeDynamic;
var const bool bBioIsReceivingDecals;
var(Audio) bool OverridePhysMat;
var(AdvancedLighting) const bool bLockLightingCache;
var(AdvancedLighting) LightMapEncodingType LightMapEncoding;
var const array<Guid> IrrelevantLights;
var const native serializetext array<StaticMeshComponentLODInfo> LODData;

public native function bool CanBecomeDynamic();

public simulated native function DisableRBCollisionWithSMC(PrimitiveComponent OtherSMC, bool bDisabled);

public final native function SetForceStaticDecals(bool bInForceStaticDecals);

public simulated native function bool SetStaticMesh(StaticMesh NewMesh, optional bool bForce);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WireframeColor = {B = 255, G = 255, R = 0, A = 255}
    ReplacementPrimitive = None
    bAcceptsStaticDecals = TRUE
    CollideActors = TRUE
    BlockActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    BlockRigidBody = TRUE
    TickGroup = ETickingGroup.TG_PreAsyncWork
    ComponentType = EComponentType.COMPONENT_StaticMesh
}
Class ProcBuilding extends Volume
    native
    placeable;

struct native PBMemUsageInfo 
{
    var ProcBuilding Building;
    var ProcBuildingRuleset Ruleset;
    var int NumStaticMeshComponent;
    var int NumInstancedStaticMeshComponents;
    var int NumInstancedTris;
    var int LightmapMemBytes;
    var int ShadowmapMemBytes;
    var int LODDiffuseMemBytes;
    var int LODLightingMemBytes;
};
enum EBuildingStatsBrowserColumns
{
    BSBC_Name,
    BSBC_Ruleset,
    BSBC_NumStaticMeshComps,
    BSBC_NumInstancedStaticMeshComps,
    BSBC_NumInstancedTris,
    BSBC_LightmapMemBytes,
    BSBC_ShadowmapMemBytes,
    BSBC_LODDiffuseMemBytes,
    BSBC_LODLightingMemBytes,
};
struct native PBMaterialParam 
{
    var(PBMaterialParam) LinearColor Color;
    var(PBMaterialParam) Name ParamName;
};
struct native PBFracMeshCompInfo 
{
    var editinline export FracturedStaticMeshComponent FracMeshComp;
    var int TopLevelScopeIndex;
};
struct native PBMeshCompInfo 
{
    var editinline export StaticMeshComponent MeshComp;
    var int TopLevelScopeIndex;
};
enum EPBCornerType
{
    EPBC_Default,
    EPBC_Chamfer,
    EPBC_Round,
};
struct native PBEdgeInfo 
{
    var Vector EdgeEnd;
    var Vector EdgeStart;
    var int ScopeAIndex;
    var int ScopeBIndex;
    var float EdgeAngle;
    var EScopeEdge ScopeAEdge;
    var EScopeEdge ScopeBEdge;
};
enum EScopeEdge
{
    EPSA_Top,
    EPSA_Bottom,
    EPSA_Left,
    EPSA_Right,
    EPSA_None,
};
struct native PBFaceUVInfo 
{
    var Vector2D Offset;
    var Vector2D Size;
};
struct native PBScopeProcessInfo 
{
    var Name RulesetVariation;
    var ProcBuilding OwningBuilding;
    var ProcBuildingRuleset Ruleset;
    var bool bGenerateLODPoly;
    var bool bPartOfNonRect;
};
struct native PBScope2D 
{
    var Matrix ScopeFrame;
    var float DimX;
    var float DimZ;
};
const PROCBUILDING_VERSION = 1;
const ROOF_MINZ = 0.7;

var(ProcBuilding) const editinline editconst array<PBMeshCompInfo> BuildingMeshCompInfos;
var(ProcBuilding) const editinline editconst array<PBFracMeshCompInfo> BuildingFracMeshCompInfos;
var const editinline export array<StaticMeshComponent> LODMeshComps;
var transient array<ProcBuilding> OverlappingBuildings;
var(ProcBuilding) array<PBMaterialParam> BuildingMaterialParams;
var(ProcBuilding) const editinline editconst export StaticMeshComponent SimpleMeshComp;
var int NumMeshedTopLevelScopes;
var float MaxFacadeZ;
var float MinFacadeZ;
var(ProcBuilding) float SimpleMeshMassiveLODDistance;
var(ProcBuilding) float RenderToTexturePullBackAmount;
var(ProcBuilding) int RoofLightmapRes;
var(ProcBuilding) int NonRectWallLightmapRes;
var(ProcBuilding) const editconst crosslevelpassive StaticMeshActor LowLODPersistentActor;
var editinline transient export StaticMeshComponent CurrentSimpleMeshComp;
var transient Actor CurrentSimpleMeshActor;
var const int BuildingInstanceVersion;
var(ProcBuilding) bool bGenerateRoofMesh;
var(ProcBuilding) bool bGenerateFloorMesh;
var(ProcBuilding) bool bApplyRulesToRoof;
var(ProcBuilding) bool bApplyRulesToFloor;
var(ProcBuilding) bool bSplitWallsAtRoofLevels;
var(ProcBuilding) bool bSplitWallsAtWallEdges;
var transient bool bQuickEdited;
var(ProcBuilding) bool bBuildingBrushCollision;
var(Debug) bool bDebugDrawEdgeInfo;
var(Debug) bool bDebugDrawScopes;

public native function BreakFractureComponent(FracturedStaticMeshComponent Comp, Vector BoxMin, Vector BoxMax);

public native function ClearBuildingMeshes();

public native function array<StaticMeshComponent> FindComponentsForTopLevelScope(int TopLevelScopeIndex);

public native function int FindEdgeForTopLevelScope(int TopLevelScopeIndex, EScopeEdge Edge);

public native function GetAllGroupedProcBuildings(out array<ProcBuilding> OutSet);

public native function ProcBuilding GetBaseMostBuilding();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_BlockingVolume
        BlockActors = TRUE
        BlockRigidBody = TRUE
        bDisableAllRigidBody = FALSE
    End Template
    SimpleMeshMassiveLODDistance = 10000.0
    RenderToTexturePullBackAmount = 125.0
    RoofLightmapRes = 64
    NonRectWallLightmapRes = 64
    LowLODPersistentActor = None
    bGenerateRoofMesh = TRUE
    bSplitWallsAtRoofLevels = TRUE
    bSplitWallsAtWallEdges = TRUE
    bBuildingBrushCollision = TRUE
    BrushColor = {B = 135, G = 255, R = 222, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bHidden = FALSE
    bWorldGeometry = TRUE
    bRouteBeginPlayEvenIfStatic = FALSE
    bGameRelevant = TRUE
    bMovable = FALSE
    bBlockActors = TRUE
    bPathColliding = TRUE
}
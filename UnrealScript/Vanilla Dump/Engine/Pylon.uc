Class Pylon extends NavigationPoint
    implements(EditorLinkSelectionInterface)
    native
    placeable;

struct native immutablewhencooked PolyReference 
{
    var ActorReference OwningPylon;
    var int PolyId;
};
enum ENavMeshEdgeType
{
    NAVEDGE_Normal,
    NAVEDGE_Mantle,
    NAVEDGE_Coverslip,
    NAVEDGE_SwatTurn,
    NAVEDGE_DropDown,
    NAVEDGE_PathObject,
};

var const native noexport Pointer VfTable_IEditorLinkSelectionInterface;
var const transient array<Vector> NextPassSeedList;
var(MeshGeneration) array<Volume> ExpansionVolumes;
var const native OctreeElementId OctreeId;
var const native Pointer NavMeshPtr;
var const native Pointer ObstacleMesh;
var const native Pointer DynamicObstacleMesh;
var const transient native Pointer WorkingSetPtr;
var const transient native Pointer PathObjectsThatAffectThisPylon;
var const native Pointer OctreeIWasAddedTo;
var Vector ExpansionSphereCenter;
var const Pylon NextPylon;
var(MeshGeneration) float ExpansionRadius;
var const float MaxExpansionRadius;
var editinline export DrawPylonRadiusComponent PylonRadiusPreview;
var editinline export NavMeshRenderingComponent RenderingComp;
var const editinline transient export SpriteComponent BrokenSprite;
var(Debug) int DebugEdgeCount;
var bool bImportedMesh;
var bool bUseExpansionSphereOverride;
var bool bNeedsCostCheck;
var(Debug) bool bDrawEdgePolys;
var(Debug) bool bDrawPolyBounds;
var(Display) bool bRenderInShowPaths;
var(Display) bool bDrawWalkableSurface;
var(Display) bool bDrawObstacleSurface;
var transient bool bBuildThisPylon;
var bool bDisabled;
var bool bForceObstacleMeshCollision;

public native function bool CanReachPylon(Pylon DestPylon, Controller C);

public event function bool IsEnabled()
{
    return !bDisabled;
}
public function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SetEnabled(TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        SetEnabled(FALSE);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        SetEnabled(!IsEnabled());
    }
}
public event function SetEnabled(bool bEnabled)
{
    bDisabled = !bEnabled;
    bForceObstacleMeshCollision = bDisabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    ExpansionRadius = 2048.0
    MaxExpansionRadius = 7168.0
    DebugEdgeCount = -1
    bRenderInShowPaths = TRUE
    bDrawWalkableSurface = TRUE
    bDrawObstacleSurface = TRUE
    CylinderComponent = CollisionCylinder
    bDestinationOnly = TRUE
    Components = (None, 
                  None, 
                  None, 
                  CollisionCylinder, 
                  None, 
                  None, 
                  None, 
                  None
                 )
    CollisionComponent = CollisionCylinder
}
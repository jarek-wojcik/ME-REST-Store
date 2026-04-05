Class Route extends Info
    implements(EditorLinkSelectionInterface)
    native
    placeable;

enum ERouteType
{
    ERT_Linear,
    ERT_Loop,
    ERT_Circle,
};
enum ERouteDirection
{
    ERD_Forward,
    ERD_Reverse,
};
enum ERouteFillAction
{
    RFA_Overwrite,
    RFA_Add,
    RFA_Remove,
    RFA_Clear,
};

var const native noexport Pointer VfTable_IEditorLinkSelectionInterface;
var(Route) array<ActorReference> RouteList;
var(Route) float FudgeFactor;
var(Route) ERouteType RouteType;

public final native function int MoveOntoRoutePath(Pawn P, optional ERouteDirection RouteDirection = 0, optional float DistFudgeFactor = 1.0);

public final native function int ResolveRouteIndex(int idx, ERouteDirection RouteDirection, out byte out_bComplete, out byte out_bReverse);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FudgeFactor = 1.0
    Components = (None, None, None)
    bStatic = TRUE
}
Class NavigationPoint extends Actor
    native;

struct CheckpointRecord 
{
    var bool bDisabled;
    var bool bBlocked;
};
struct native DebugNavCost 
{
    var string Desc;
    var int Cost;
};
struct native NavigationOctreeObject 
{
    var const transient native Pointer OctreeNode;
    var Box BoundingBox;
    var Vector BoxCenter;
    var const noexport Object Owner;
    var const noexport byte OwnerType;
};
const INFINITE_PATH_COST = 10000000;

var const transient native NavigationOctreeObject NavOctreeObject;
var(NavigationPoint) const editconst duplicatetransient array<ReachSpec> PathList;
var(NavigationPoint) const editconst array<ActorReference> Volumes;
var transient array<DebugNavCost> CostArray;
var(NavigationPoint) const editconst duplicatetransient Guid NavGuid;
var(NavigationPoint) const editconst Cylinder MaxPathSize;
var int visitedWeight;
var const int bestPathWeight;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint previousPath;
var int Cost;
var(NavigationPoint) int ExtraCost;
var transient int TransientCost;
var transient int FearCost;
var DroppedPickup InventoryCache;
var float InventoryDist;
var const float LastDetourWeight;
var editinline export CylinderComponent CylinderComponent;
var const editinline transient export SpriteComponent GoodSprite;
var const editinline transient export SpriteComponent BadSprite;
var(NavigationPoint) const editconst int NetworkID;
var transient Pawn AnchoredPawn;
var transient float LastAnchoredPawnTime;
var transient int PathfindTag;
var int ApproximateLineOfFire;
var transient bool bEndPoint;
var transient bool bTransientEndPoint;
var transient bool bHideEditorPaths;
var transient bool bCanReach;
var bool bNoPathWarnings;
var(NavigationPoint) bool bBlocked;
var(NavigationPoint) bool bOneWayPath;
var bool bNeverUseStrafing;
var bool bAlwaysUseStrafing;
var const bool bForceNoStrafing;
var const bool bAutoBuilt;
var bool bSpecialMove;
var bool bNoAutoConnect;
var const bool bNotBased;
var const bool bPathsChanged;
var bool bDestinationOnly;
var bool bSourceOnly;
var bool bSpecialForced;
var bool bMustBeReachable;
var bool bBlockable;
var bool bFlyingPreferred;
var bool bMayCausePain;
var transient bool bAlreadyVisited;
var(NavigationPoint) bool bVehicleDestination;
var(NavigationPoint) bool bMakeSourceOnly;
var bool bMustTouchToReach;
var bool bCanWalkOnToReach;
var bool bBuildLongPaths;
var(VehicleUsage) bool bBlockedForVehicles;
var(VehicleUsage) bool bPreferredVehiclePath;
var(NavigationPoint) bool bRequiresPrecisionMovement;
var const bool bHasCrossLevelPaths;
var transient bool bShouldSaveForCheckpoint;

public event function bool Accept(Actor Incoming, Actor Source)
{
    local bool bResult;
    
    bResult = Incoming.SetLocation(location, );
    if (bResult)
    {
        Incoming.Velocity = vect(0.0, 0.0, 0.0);
        Incoming.SetRotation(Rotation);
    }
    Incoming.PlayTeleportEffect(TRUE, FALSE);
    return bResult;
}
public native function bool CanTeleport(Actor A);

public event function float DetourWeight(Pawn Other, float PathWeight);

public static final native function bool GetAllNavInRadius(Actor ChkActor, Vector ChkPoint, float Radius, out array<NavigationPoint> out_NavList, optional bool bSkipBlocked, optional int inNetworkID = -1, optional Cylinder MinSize);

public native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

public event simulated function string GetDebugAbbrev()
{
    return "NP?";
}
public final native function ReachSpec GetReachSpecTo(NavigationPoint Nav, optional Class<ReachSpec> SpecClass);

public final native function bool IsOnDifferentNetwork(NavigationPoint Nav);

public final native function bool IsUsableAnchorFor(Pawn P);

public function OnToggle(SeqAct_Toggle inAction)
{
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bBlocked = FALSE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bBlocked = TRUE;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bBlocked = !bBlocked;
    }
    WorldInfo.Game.NotifyNavigationChanged(Self);
    bShouldSaveForCheckpoint = TRUE;
}
public event simulated function ShutDown()
{
    Super.ShutDown();
    bBlocked = TRUE;
    WorldInfo.Game.NotifyNavigationChanged(Self);
    bShouldSaveForCheckpoint = TRUE;
}
public event function int SpecialCost(Pawn Seeker, ReachSpec Path);

public event function bool SuggestMovePreparation(Pawn Other)
{
    return Other.SpecialMoveTo(Other.Anchor, Self, Other.Controller.MoveTarget);
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bBlocked = Record.bBlocked;
    bShouldSaveForCheckpoint = TRUE;
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bBlocked = bBlocked;
}
public static final function NavigationPoint GetNearestNavToActor(Actor ChkActor, optional Class<NavigationPoint> RequiredClass, optional array<NavigationPoint> ExcludeList, optional float MinDist)
{
    local NavigationPoint Nav;
    local NavigationPoint BestNav;
    local float Dist;
    local float bestDist;
    
    if (ChkActor != None)
    {
        foreach ChkActor.WorldInfo.AllNavigationPoints(Class'NavigationPoint', Nav)
        {
            if ((RequiredClass == None || Nav.Class == RequiredClass) && ExcludeList.Find(Nav) == -1)
            {
                Dist = VSize(Nav.location - ChkActor.location);
                if (Dist > MinDist)
                {
                    if (BestNav == None || Dist < bestDist)
                    {
                        BestNav = Nav;
                        bestDist = Dist;
                    }
                }
            }
        }
    }
    return BestNav;
}
public static final function NavigationPoint GetNearestNavToPoint(Actor ChkActor, Vector ChkPoint, optional Class<NavigationPoint> RequiredClass, optional array<NavigationPoint> ExcludeList)
{
    local NavigationPoint Nav;
    local NavigationPoint BestNav;
    local float Dist;
    local float bestDist;
    
    if (ChkActor != None)
    {
        foreach ChkActor.WorldInfo.AllNavigationPoints(Class'NavigationPoint', Nav)
        {
            if ((RequiredClass == None || Nav.Class == RequiredClass) && ExcludeList.Find(Nav) == -1)
            {
                Dist = VSize(Nav.location - ChkPoint);
                if (BestNav == None || Dist < bestDist)
                {
                    BestNav = Nav;
                    bestDist = Dist;
                }
            }
        }
    }
    return BestNav;
}
public function bool ProceedWithMove(Pawn Other)
{
    return TRUE;
}
public function bool ShouldSaveForCheckpoint()
{
    return bShouldSaveForCheckpoint;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 90.0
        CollisionRadius = 50.0
        ReplacementPrimitive = None
    End Object
    CylinderComponent = CollisionCylinder
    NetworkID = -1
    bMayCausePain = TRUE
    bMustTouchToReach = TRUE
    bBuildLongPaths = TRUE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bStatic = TRUE
    bNoDelete = TRUE
    bCollideWhenPlacing = TRUE
    bForceAllowKismetModification = TRUE
}
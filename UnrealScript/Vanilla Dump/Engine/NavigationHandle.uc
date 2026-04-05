Class NavigationHandle within Actor
    native;

struct native NavMeshPathParams 
{
    var native Pointer Interface;
    var Vector SearchExtent;
    var Vector SearchStart;
    var float MaxDropHeight;
    var float MinWalkableZ;
    var float MaxHoverDistance;
    var bool bCanMantle;
    var bool bNeedsMantleValidityTest;
    var bool bAbleToSearch;
};
const NUM_PATHFINDING_PARAMS = 8;
const LINECHECK_GRANULARITY = 768.f;
struct native PathStore 
{
    var const native array<EdgePointer> EdgeList;
};
struct EdgePointer 
{
    var const native Pointer Dummy;
};
struct native PolySegmentSpan 
{
    var native Pointer Poly;
    var Vector P1;
    var Vector P2;
};

var NavMeshPathParams CachedPathParams;
var PathStore PathCache;
var native Pointer AnchorPoly;
var transient native Pointer BestUnfinishedPathPoint;
var const native Pointer CurrentEdge;
var const native Pointer SubGoal_DestPoly;
var BasedPosition FinalDestination;
var Pylon AnchorPylon;
var NavMeshPathConstraint PathConstraintList;
var NavMeshPathGoalEvaluator PathGoalList;
var bool bSkipRouteCacheUpdates;
var bool bUseORforEvaluateGoal;
var(PathDebug) bool bDebugConstraintsAndGoalEvals;
var(PathDebug) bool bUltraVerbosePathDebugging;

public native function bool ActorReachable(Actor A);

public native function AddGoalEvaluator(NavMeshPathGoalEvaluator Evaluator);

public native function AddPathConstraint(NavMeshPathConstraint Constraint);

public native function float CalculatePathDistance(optional Vector FinalDest);

public native function ClearConstraints();

public native function bool ComputeValidFinalDestination(out Vector out_ComputedPosition);

public native function DrawPathCache(optional Vector DrawOffset, optional bool bPersistent, optional Color DrawColor);

public native function bool FindPath(optional out Actor out_DestActor, optional out int out_DestItem);

public native function bool FindPylon();

public native function GetAllPolyCentersWithinBounds(Vector pos, Vector Extent, out array<Vector> out_PolyCtrs);

public native function Vector GetBestUnfinishedPathPoint();

public native function Vector GetFirstMoveLocation();

public native function bool GetNextMoveLocation(out Vector out_MoveDest, float ArrivalDistance);

public static native function Pylon GetPylonFromPos(Vector Position);

public native function GetValidPositionsForBox(Vector pos, float Radius, Vector Extent, bool bMustBeReachableFromStartPos, out array<Vector> out_ValidPositions, optional int MaxPositions = -1, optional float MinRadius, optional Vector ValidBoxAroundStartPos = vect(0.0, 0.0, 0.0));

public native function bool IsAnchorInescapable();

public native function LimitPathCacheDistance(float MaxDist);

public native function bool LineCheck(Vector Start, Vector End, Vector Extent, optional out Vector out_HitLocation, optional out Vector out_HitNormal);

public static final native function bool ObstacleLineCheck(Vector Start, Vector End, Vector Extent, optional out Vector out_HitLoc, optional out Vector out_HitNorm);

public static final native function bool ObstaclePointCheck(Vector Pt, Vector Extent);

public native function PathCache_Empty();

public native function Vector PathCache_GetGoalPoint();

public native function PathCache_RemoveIndex(int InIdx, optional int Count = 1);

public native function bool PointCheck(Vector Pt, Vector Extent);

public native function bool PointReachable(Vector Point);

public native function bool SetFinalDestination(Vector FinalDest);

public native function bool SuggestMovePreparation(Vector MovePt, Controller C);

public function NavMeshPathConstraint CreatePathConstraint(Class<NavMeshPathConstraint> ConstraintClass)
{
    return Outer.WorldInfo.GetNavMeshPathConstraintFromCache(ConstraintClass, Self);
}
public function NavMeshPathGoalEvaluator CreatePathGoalEvaluator(Class<NavMeshPathGoalEvaluator> GoalEvalClass)
{
    return Outer.WorldInfo.GetNavMeshPathGoalEvaluatorFromCache(GoalEvalClass, Self);
}
public function int GetPathCacheLength()
{
    return PathCache.EdgeList.Length;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
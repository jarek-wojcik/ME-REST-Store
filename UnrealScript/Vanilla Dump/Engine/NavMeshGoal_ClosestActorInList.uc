Class NavMeshGoal_ClosestActorInList extends NavMeshPathGoalEvaluator
    native;

struct native BiasedGoalActor 
{
    var Actor Goal;
    var int ExtraCost;
};

var const transient native MultiMap_Mirror PolyToGoalActorMap;
var array<BiasedGoalActor> GoalList;
var native Pointer CachedAnchorPoly;

public event function Recycle()
{
    Super.Recycle();
    GoalList.Length = 0;
    RecycleInternal();
}
public native function RecycleInternal();

public static function NavMeshGoal_ClosestActorInList ClosestActorInList(NavigationHandle NavHandle, const out array<BiasedGoalActor> InGoalList)
{
    local NavMeshGoal_ClosestActorInList Eval;
    
    Eval = NavMeshGoal_ClosestActorInList(NavHandle.CreatePathGoalEvaluator(default.Class));
    Eval.GoalList = InGoalList;
    NavHandle.AddGoalEvaluator(Eval);
    return Eval;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 3000
}
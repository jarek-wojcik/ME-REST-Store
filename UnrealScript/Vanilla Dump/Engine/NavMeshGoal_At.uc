Class NavMeshGoal_At extends NavMeshPathGoalEvaluator
    native;

var native Pointer GoalPoly;
var native Pointer PartialGoal;
var Vector Goal;
var float GoalDist;
var bool bKeepPartial;

public function Recycle()
{
    Goal = vect(0.0, 0.0, 0.0);
    GoalDist = default.GoalDist;
    bKeepPartial = default.bKeepPartial;
    RecycleNative();
    Super.Recycle();
}
public native function RecycleNative();

public static function bool AtActor(NavigationHandle NavHandle, Actor GoalActor, optional float Dist, optional bool bReturnPartial)
{
    local Controller GoalController;
    local Controller MyController;
    
    if (NavHandle != None)
    {
        GoalController = Controller(GoalActor);
        if (GoalController != None)
        {
            GoalActor = GoalController.Pawn;
        }
        if (GoalActor != None)
        {
            MyController = Controller(NavHandle.Outer);
            return AtLocation(NavHandle, GoalActor.GetDestination(MyController), Dist, bReturnPartial);
        }
    }
    return FALSE;
}
public static function bool AtLocation(NavigationHandle NavHandle, Vector GoalLocation, optional float Dist, optional bool bReturnPartial)
{
    local NavMeshGoal_At Eval;
    
    if (NavHandle != None)
    {
        Eval = NavMeshGoal_At(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != None)
        {
            Eval.Goal = GoalLocation;
            Eval.GoalDist = Dist;
            Eval.bKeepPartial = bReturnPartial;
            NavHandle.AddGoalEvaluator(Eval);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
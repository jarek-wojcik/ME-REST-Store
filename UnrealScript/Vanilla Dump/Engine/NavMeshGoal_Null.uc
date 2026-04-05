Class NavMeshGoal_Null extends NavMeshPathGoalEvaluator
    native;

var native Pointer PartialGoal;

public function Recycle()
{
    Super.Recycle();
    MaxPathVisits = default.MaxPathVisits;
    RecycleNative();
}
public native function RecycleNative();

public static function bool GoUntilBust(NavigationHandle NavHandle, optional int InMaxPathVisits = -1)
{
    local NavMeshGoal_Null Eval;
    
    if (NavHandle != None)
    {
        Eval = NavMeshGoal_Null(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != None)
        {
            if (InMaxPathVisits > 0)
            {
                Eval.MaxPathVisits = InMaxPathVisits;
            }
            NavHandle.AddGoalEvaluator(Eval);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 2048
}
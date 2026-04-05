Class NavMeshGoal_PolyEncompassesAI extends NavMeshPathGoalEvaluator
    native;

public function Recycle()
{
    Super.Recycle();
}
public static function bool MakeSureAIFits(NavigationHandle NavHandle)
{
    local NavMeshGoal_PolyEncompassesAI Eval;
    
    if (NavHandle != None)
    {
        Eval = NavMeshGoal_PolyEncompassesAI(NavHandle.CreatePathGoalEvaluator(default.Class));
        if (Eval != None)
        {
            NavHandle.AddGoalEvaluator(Eval);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 64
}
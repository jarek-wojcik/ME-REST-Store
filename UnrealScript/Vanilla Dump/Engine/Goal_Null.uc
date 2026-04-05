Class Goal_Null extends PathGoalEvaluator
    native;

public function Recycle()
{
    Super.Recycle();
    MaxPathVisits = default.MaxPathVisits;
}
public static function bool GoUntilBust(Pawn P, optional int InMaxPathVisits = -1)
{
    local Goal_Null Eval;
    
    if (P != None)
    {
        Eval = Goal_Null(P.CreatePathGoalEvaluator(default.Class));
        if (Eval != None)
        {
            if (InMaxPathVisits > 0)
            {
                Eval.MaxPathVisits = InMaxPathVisits;
            }
            P.AddGoalEvaluator(Eval);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 2048
    CacheIdx = 5
}
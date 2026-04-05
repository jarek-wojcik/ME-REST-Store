Class Goal_AwayFromPosition extends PathGoalEvaluator
    native;

var Vector AvoidPos;
var Vector AvoidDir;
var int MaxDist;
var NavigationPoint BestNode;
var int BestRating;

public event function Recycle()
{
    Super.Recycle();
    AvoidPos = vect(0.0, 0.0, 0.0);
    AvoidDir = vect(0.0, 0.0, 0.0);
    MaxDist = 0;
    BestNode = None;
    BestRating = 0;
}
public static function bool FleeFrom(Pawn P, Vector InAvoidPos, int InMaxDist)
{
    local Goal_AwayFromPosition Eval;
    
    Eval = Goal_AwayFromPosition(P.CreatePathGoalEvaluator(default.Class));
    if (Eval != None)
    {
        Eval.AvoidPos = InAvoidPos;
        Eval.AvoidDir = Normal(InAvoidPos - P.location);
        Eval.MaxDist = InMaxDist;
        P.AddGoalEvaluator(Eval);
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 2
}
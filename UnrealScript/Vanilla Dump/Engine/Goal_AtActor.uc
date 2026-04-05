Class Goal_AtActor extends PathGoalEvaluator
    native;

var Actor GoalActor;
var float GoalDist;
var bool bKeepPartial;

public function Recycle()
{
    GoalActor = None;
    GoalDist = default.GoalDist;
    bKeepPartial = default.bKeepPartial;
    Super.Recycle();
}
public static function bool AtActor(Pawn P, Actor Goal, optional float Dist, optional bool bReturnPartial)
{
    local Goal_AtActor Eval;
    local Pawn GoalPawn;
    local Controller GoalController;
    local float AnchorDist;
    
    if (P != None)
    {
        GoalPawn = Pawn(Goal);
        GoalController = Controller(Goal);
        if (GoalController != None)
        {
            if (GoalController.Pawn != None)
            {
                GoalPawn = GoalController.Pawn;
            }
            else
            {
                Goal = None;
            }
        }
        if (GoalPawn != None)
        {
            if (GoalPawn.ValidAnchor() && GoalPawn.Anchor.IsUsableAnchorFor(P))
            {
                Goal = GoalPawn.Anchor;
            }
            else
            {
                Goal = P.GetBestAnchor(GoalPawn, GoalPawn.location, FALSE, FALSE, AnchorDist);
            }
        }
        else if (NavigationPoint(Goal) == None)
        {
            Goal = P.GetBestAnchor(Goal, Goal.location, FALSE, FALSE, AnchorDist);
            if (Goal == None)
            {
            }
        }
        if (Goal != None)
        {
            Eval = Goal_AtActor(P.CreatePathGoalEvaluator(default.Class));
            if (Eval != None)
            {
                Eval.GoalActor = Goal;
                Eval.GoalDist = Dist;
                Eval.bKeepPartial = bReturnPartial;
                P.AddGoalEvaluator(Eval);
                return TRUE;
            }
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 0
}
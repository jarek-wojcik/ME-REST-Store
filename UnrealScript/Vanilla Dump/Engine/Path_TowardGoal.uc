Class Path_TowardGoal extends PathConstraint
    native;

var Actor GoalActor;

public function Recycle()
{
    Super.Recycle();
    GoalActor = None;
}
public static function bool TowardGoal(Pawn P, Actor Goal)
{
    local Path_TowardGoal Con;
    
    if (P != None && Goal != None)
    {
        Con = Path_TowardGoal(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.GoalActor = Goal;
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 1
}
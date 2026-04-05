Class SFXPath_AwayFromGoal extends PathConstraint
    native;

var Actor GoalActor;
var float fDistAway;

public static function bool AwayFromGoal(BioPawn Pawn, Actor Goal, float fDist)
{
    local SFXPath_AwayFromGoal Constraint;
    
    if (Pawn != None && Goal != None)
    {
        Constraint = SFXPath_AwayFromGoal(Pawn.CreatePathConstraint(default.Class));
        if (Constraint != None)
        {
            Constraint.GoalActor = Goal;
            Constraint.fDistAway = fDist;
            Pawn.AddPathConstraint(Constraint);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 11
}
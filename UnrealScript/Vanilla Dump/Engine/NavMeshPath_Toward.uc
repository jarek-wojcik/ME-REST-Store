Class NavMeshPath_Toward extends NavMeshPathConstraint
    native;

var Vector GoalPoint;
var Actor GoalActor;

public function Recycle()
{
    Super.Recycle();
    GoalActor = None;
    GoalPoint = default.GoalPoint;
}
public static function bool TowardGoal(NavigationHandle NavHandle, Actor Goal)
{
    local NavMeshPath_Toward Con;
    
    if (NavHandle != None && Goal != None)
    {
        Con = NavMeshPath_Toward(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.GoalActor = Goal;
            NavHandle.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}
public static function bool TowardPoint(NavigationHandle NavHandle, Vector Point)
{
    local NavMeshPath_Toward Con;
    
    if (NavHandle != None && Point != vect(0.0, 0.0, 0.0))
    {
        Con = NavMeshPath_Toward(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.GoalPoint = Point;
            NavHandle.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
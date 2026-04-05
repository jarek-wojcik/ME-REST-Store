Class NavMeshPath_AlongLine extends NavMeshPathConstraint
    native;

var Vector Direction;

public function Recycle()
{
    Super.Recycle();
    Direction = vect(0.0, 0.0, 0.0);
}
public static function bool AlongLine(NavigationHandle NavHandle, Vector Dir)
{
    local NavMeshPath_AlongLine Con;
    
    if (NavHandle != None && !IsZero(Dir))
    {
        Con = NavMeshPath_AlongLine(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.Direction = Dir;
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
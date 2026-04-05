Class NavMeshPath_EnforceTwoWayEdges extends NavMeshPathConstraint
    native;

public static function bool EnforceTwoWayEdges(NavigationHandle NavHandle)
{
    local NavMeshPath_EnforceTwoWayEdges Con;
    
    if (NavHandle != None)
    {
        Con = NavMeshPath_EnforceTwoWayEdges(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
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
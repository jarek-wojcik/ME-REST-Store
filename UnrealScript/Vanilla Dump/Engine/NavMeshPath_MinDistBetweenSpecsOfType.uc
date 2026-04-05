Class NavMeshPath_MinDistBetweenSpecsOfType extends NavMeshPathConstraint
    native;

var Vector InitLocation;
var float MinDistBetweenEdgeTypes;
var ENavMeshEdgeType EdgeType;

public function Recycle()
{
    Super.Recycle();
    MinDistBetweenEdgeTypes = default.MinDistBetweenEdgeTypes;
    EdgeType = ENavMeshEdgeType.NAVEDGE_Normal;
    InitLocation = vect(0.0, 0.0, 0.0);
}
public static function bool EnforceMinDist(NavigationHandle NavHandle, float InMinDist, ENavMeshEdgeType InEdgeType, optional Vector LastLocation)
{
    local NavMeshPath_MinDistBetweenSpecsOfType Con;
    
    if (NavHandle != None && InMinDist > 0.0)
    {
        Con = NavMeshPath_MinDistBetweenSpecsOfType(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.MinDistBetweenEdgeTypes = InMinDist;
            Con.InitLocation = LastLocation;
            Con.EdgeType = InEdgeType;
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
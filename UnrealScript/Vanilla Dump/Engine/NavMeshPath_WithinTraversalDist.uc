Class NavMeshPath_WithinTraversalDist extends NavMeshPathConstraint
    native;

var(NavMeshPath_WithinTraversalDist) float MaxTraversalDist;
var(NavMeshPath_WithinTraversalDist) float SoftStartPenalty;
var(NavMeshPath_WithinTraversalDist) bool bSoft;

public function Recycle()
{
    Super.Recycle();
    MaxTraversalDist = default.MaxTraversalDist;
    bSoft = default.bSoft;
    SoftStartPenalty = default.SoftStartPenalty;
}
public static function bool DontExceedMaxDist(NavigationHandle NavHandle, float InMaxTraversalDist, optional bool bInSoft = TRUE)
{
    local NavMeshPath_WithinTraversalDist Con;
    
    if (NavHandle != None && InMaxTraversalDist > 0.0)
    {
        Con = NavMeshPath_WithinTraversalDist(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.MaxTraversalDist = InMaxTraversalDist;
            Con.bSoft = bInSoft;
            NavHandle.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SoftStartPenalty = 320.0
    bSoft = TRUE
}
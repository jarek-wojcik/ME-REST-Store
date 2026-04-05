Class Path_WithinTraversalDist extends PathConstraint
    native;

var(Path_WithinTraversalDist) float MaxTraversalDist;
var(Path_WithinTraversalDist) float SoftStartPenalty;
var(Path_WithinTraversalDist) bool bSoft;

public function Recycle()
{
    Super.Recycle();
    MaxTraversalDist = default.MaxTraversalDist;
    bSoft = default.bSoft;
    SoftStartPenalty = default.SoftStartPenalty;
}
public static function bool DontExceedMaxDist(Pawn P, float InMaxTraversalDist, optional bool bInSoft = TRUE)
{
    local Path_WithinTraversalDist Con;
    
    if (P != None && InMaxTraversalDist > 0.0)
    {
        Con = Path_WithinTraversalDist(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.MaxTraversalDist = InMaxTraversalDist;
            Con.bSoft = bInSoft;
            P.AddPathConstraint(Con);
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
    CacheIdx = 4
}
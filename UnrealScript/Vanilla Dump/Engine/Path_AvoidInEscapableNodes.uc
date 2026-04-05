Class Path_AvoidInEscapableNodes extends PathConstraint
    native;

var int Radius;
var int Height;
var int MaxFallSpeed;
var int MoveFlags;

private final native function CachePawnReacFlags(Pawn P);

public function Recycle()
{
    Super.Recycle();
    Radius = 0;
    Height = 0;
    MaxFallSpeed = 0;
    MoveFlags = 0;
}
public static function bool DontGetStuck(Pawn P)
{
    local Path_AvoidInEscapableNodes Con;
    
    if (P != None)
    {
        Con = Path_AvoidInEscapableNodes(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.CachePawnReacFlags(P);
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 6
}
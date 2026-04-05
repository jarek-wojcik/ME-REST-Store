Class Path_AlongLine extends PathConstraint
    native;

var Vector Direction;

public function Recycle()
{
    Super.Recycle();
    Direction = vect(0.0, 0.0, 0.0);
}
public static function bool AlongLine(Pawn P, Vector Dir)
{
    local Path_AlongLine Con;
    
    if (P != None && !IsZero(Dir))
    {
        Con = Path_AlongLine(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.Direction = Dir;
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 0
}
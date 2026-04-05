Class Path_TowardPoint extends PathConstraint
    native;

var Vector GoalPoint;

public function Recycle()
{
    Super.Recycle();
    GoalPoint = default.GoalPoint;
}
public static function bool TowardPoint(Pawn P, Vector Point)
{
    local Path_TowardPoint Con;
    
    if (P != None && Point != vect(0.0, 0.0, 0.0))
    {
        Con = Path_TowardPoint(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.GoalPoint = Point;
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 2
}
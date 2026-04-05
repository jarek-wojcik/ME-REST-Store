Class Path_MinDistBetweenSpecsOfType extends PathConstraint
    native;

var Class<ReachSpec> ReachSpecClass;
var Vector InitLocation;
var float MinDistBetweenSpecTypes;

public function Recycle()
{
    Super.Recycle();
    MinDistBetweenSpecTypes = default.MinDistBetweenSpecTypes;
    ReachSpecClass = None;
    InitLocation = vect(0.0, 0.0, 0.0);
}
public static function bool EnforceMinDist(Pawn P, float InMinDist, Class<ReachSpec> InSpecClass, optional Vector LastLocation)
{
    local Path_MinDistBetweenSpecsOfType Con;
    
    if (P != None && P.bCanMantle && InMinDist > 0.0)
    {
        Con = Path_MinDistBetweenSpecsOfType(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.MinDistBetweenSpecTypes = InMinDist;
            Con.InitLocation = LastLocation;
            Con.ReachSpecClass = InSpecClass;
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 5
}
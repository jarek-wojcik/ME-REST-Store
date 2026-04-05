Class SFXPath_TowardCombatZone extends PathConstraint
    native;

var Vector CombatZoneOrigin;

public static function bool TowardCombatZone(BioPawn Pawn)
{
    local SFXPath_TowardCombatZone Constraint;
    local Vector Origin;
    
    if (Pawn == None || Pawn.Squad == None)
    {
        return FALSE;
    }
    if (Pawn.Squad.GetClosestCombatZoneOrigin(Pawn.location, Origin) == FALSE)
    {
        return FALSE;
    }
    Constraint = SFXPath_TowardCombatZone(Pawn.CreatePathConstraint(default.Class));
    if (Constraint == None)
    {
        return FALSE;
    }
    Constraint.CombatZoneOrigin = Origin;
    Pawn.AddPathConstraint(Constraint);
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 14
}
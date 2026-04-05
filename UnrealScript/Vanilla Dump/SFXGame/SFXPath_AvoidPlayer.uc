Class SFXPath_AvoidPlayer extends PathConstraint
    native;

public static function bool AvoidPlayer(BioPawn Pawn)
{
    local SFXPath_AvoidPlayer Constraint;
    
    if (Pawn != None)
    {
        Constraint = SFXPath_AvoidPlayer(Pawn.CreatePathConstraint(default.Class));
        if (Constraint != None)
        {
            Pawn.AddPathConstraint(Constraint);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 8
}
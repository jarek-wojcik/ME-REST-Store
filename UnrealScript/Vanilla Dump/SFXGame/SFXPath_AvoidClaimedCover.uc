Class SFXPath_AvoidClaimedCover extends PathConstraint
    native;

public static function bool AvoidClaimedCover(BioPawn P)
{
    local SFXPath_AvoidClaimedCover Con;
    
    if (P != None)
    {
        Con = SFXPath_AvoidClaimedCover(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            P.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 9
}
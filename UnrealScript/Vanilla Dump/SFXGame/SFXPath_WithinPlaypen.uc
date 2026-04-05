Class SFXPath_WithinPlaypen extends PathConstraint
    native;

var transient bool m_bOnlyAvoidSubtractive;

public static function bool WithinPlaypen(BioPawn P, bool bAvoidSubtractive)
{
    local SFXPath_WithinPlaypen Con;
    
    if (P != None && P.Squad != None && P.Squad.HasPlaypen())
    {
        Con = SFXPath_WithinPlaypen(P.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            P.AddPathConstraint(Con);
            Con.m_bOnlyAvoidSubtractive = bAvoidSubtractive;
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 7
}
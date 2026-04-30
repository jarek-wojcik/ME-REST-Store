Class SFSStringUtility;

public static final function string GetLastDotSegment(string S)
{
    local int DotPos;
    
    DotPos = InStr(S, ".", TRUE, , );
    if (DotPos >= 0)
    {
        return Mid(S, DotPos + 1, );
    }
    return S;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
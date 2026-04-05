Class SFSArrayUtility;

public static final function int GetRandomExistingIndex(int ArrayLength)
{
    local int idx;
    
    // Returns -1 when the array is empty (no valid index).
    if (ArrayLength <= 0)
    {
        return -1;
    }
    idx = Rand(ArrayLength);
    // 0 .. ArrayLength-1
    return idx;
}
static function SplitStringIntoParts(string src, string Delim, out array<string> Parts)
{
    local string Remaining;
    local int Pos;
    
    Parts.Length = 0;
    Remaining = src;
    Pos = InStr(Remaining, Delim, , , );
    while (Pos != -1)
    {
        Parts.AddItem(Left(Remaining, Pos));
        Remaining = Mid(Remaining, Pos + Len(Delim), );
        Pos = InStr(Remaining, Delim, , , );
    }
    Parts.AddItem(Remaining);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
Class SFSPowerModel;

struct SFSPowerModelStruct 
{
    var string PowerID;
    var int Rank;
    var string Evo0;
    var string Evo1;
    var string Evo2;
};

static function bool FromToken(string Token, out SFSPowerModelStruct Power)
{
    local string Remaining;
    local array<string> Parts;
    local int Pos;
    
    if (Token == "")
    {
        return FALSE;
    }
    Remaining = Token;
    Pos = InStr(Remaining, ":", , , );
    while (Pos != -1)
    {
        Parts.AddItem(Left(Remaining, Pos));
        Remaining = Mid(Remaining, Pos + 1, );
        Pos = InStr(Remaining, ":", , , );
    }
    Parts.AddItem(Remaining);
    Power.PowerID = Parts[0];
    Power.Rank = int(Parts[1]);
    if (Parts.Length > 2)
    {
        Power.Evo0 = Parts[2];
    }
    if (Parts.Length > 3)
    {
        Power.Evo1 = Parts[3];
    }
    if (Parts.Length > 4)
    {
        Power.Evo2 = Parts[4];
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
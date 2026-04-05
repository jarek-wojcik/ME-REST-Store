Class SFSTransferPowerCommand extends SFSConsoleCommand within SFXPawn;

public function Execute(string Arguments)
{
    local int i;
    
    Super.Execute(Arguments);
}
public function SFSEvent generateEvent(string botId)
{
    local SFSEvent Event;
    
    Event = new (Outer) Class'SFSEvent';
    Event.eType = SFSEventType.EVT_ChangeSkin;
    return Event;
}
public function Name getKitNameFromArgs(string Arguments)
{
    local array<string> Tokens;
    
    ParseStringIntoArray(Arguments, Tokens, " ", TRUE);
    
    if (Tokens.Length < 1)
    {
        return 'None';
    }
    
    return Name(Tokens[0]);
}
public function getPowersArrayFromArgs(string Arguments, out int Powers[3])
{
    local array<string> Tokens;
    local array<string> PowerTokens;
    local int i;
    
    Powers[0] = 0;
    Powers[1] = 0;
    Powers[2] = 0;
    
    ParseStringIntoArray(Arguments, Tokens, " ", TRUE);
    
    if (Tokens.Length < 2)
    {
        return;
    }
    
    ParseStringIntoArray(Tokens[1], PowerTokens, ",", TRUE);
    
    for (i = 0; i < PowerTokens.Length && i < 3; ++i)
    {
        Powers[i] = int(PowerTokens[i]);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    sCommand = "transferPowers"
    Description = "Transfers powers from one of your saved kits, to current character- for the MATCH ONLY"
}

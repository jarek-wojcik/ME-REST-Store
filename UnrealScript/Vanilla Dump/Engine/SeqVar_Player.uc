Class SeqVar_Player extends SeqVar_Object
    native;

var transient array<Object> Players;
var transient array<Object> PlayersPawns;
var(SeqVar_Player) int PlayerIdx;
var(SeqVar_Player) bool bAllPlayers;
var(SeqVar_Player) bool bReturnPawns;

public final native function UpdatePlayersList();

public function Object GetObjectValue()
{
    local Controller C;
    
    UpdatePlayersList();
    if (Players.Length > 0)
    {
        if (bAllPlayers || PlayerIdx < 0 || PlayerIdx >= Players.Length)
        {
            C = Controller(Players[0]);
        }
        else
        {
            C = Controller(Players[PlayerIdx]);
        }
    }
    return C != None && C.Pawn != None ? C.Pawn : C;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAllPlayers = TRUE
    SupportedClasses = (Class'Controller', Class'Pawn')
}
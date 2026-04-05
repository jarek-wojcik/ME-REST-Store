Class SeqAct_ConsoleCommand extends SequenceAction;

var string Command;
var(SeqAct_ConsoleCommand) array<string> Commands;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public function VersionUpdated(int OldVersion, int NewVersion)
{
    if (OldVersion < 2 && (Commands.Length == 0 || Commands[0] == ""))
    {
        Commands[0] = Command;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Commands = ("")
}
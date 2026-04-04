Class SFSSpectrePortalRefreshConsoleCommand extends SFSConsoleCommand within SFXPawn;

public function Execute(string Arguments)
{
    Class'SFSCore'.static.log(Self.Name, "Spectre Portal Refresh", Outer);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    sCommand = "GetMorinth"
    Description = "This command does nothing by itself, please do not use it. It is a built-in command I am using to trigger Spectre Portal refreshes."
}
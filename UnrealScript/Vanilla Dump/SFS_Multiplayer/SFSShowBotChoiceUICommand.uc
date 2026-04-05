Class SFSShowBotChoiceUICommand extends SFSConsoleCommand within SFXPawn;

public function Execute(string Arguments)
{
    local SFSBotManagerChoiceUI SFSUI;
    
    Class'SFSCore'.static.log(Self.Name, "Executing SFShowBotChoiceUICommand", Outer);
    SFSUI = Outer.GetModule(Class'SFSBotManagerChoiceUI');
    if (SFSUI != None)
    {
        Class'SFSCore'.static.log(Self.Name, "Showing SFS UI", Outer);
        SFSUI.ShowBotChoiceGui();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = FALSE
    sCommand = "ShowBotChoiceUI"
    Description = "Shows the SFS menu. Meant to be executed through a keybind but it does not work. This being deprecated and will be removed in a future release"
}
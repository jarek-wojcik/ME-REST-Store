Class MCPTools extends GameInfo
    native
    config(Game);

public native function DoLoggedIn();

public event function InitGame(string Options, out string ErrorMessage)
{
    Super.InitGame(Options, ErrorMessage);
    if (OnlineSub == None)
    {
    }
}
public function RegisterServer()
{
    DoLoggedIn();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
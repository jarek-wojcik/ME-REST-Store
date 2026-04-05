Class HelpCommandlet extends Commandlet
    native
    transient;

public event native function int Main(string Params);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HelpDescription = "This commandlet displays help information on other commandlets"
    HelpUsage = "gamename.exe help <list | commandletname | webhelp commandletname>"
    HelpWebLink = "https://udn.epicgames.com/bin/view/Three/HelpCommandlet"
    HelpParamNames = ("list", "commandlet name", "webhelp")
    HelpParamDescriptions = ("Lists all commandlets that are available", "Displays help information for the specified commandlet", "Launches a browser with the URL of the web page that documents the commandlet")
}
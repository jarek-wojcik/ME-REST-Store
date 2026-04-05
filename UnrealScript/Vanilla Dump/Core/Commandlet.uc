Class Commandlet
    native
    abstract
    transient;

var const localized string HelpDescription;
var const localized string HelpUsage;
var const localized string HelpWebLink;
var const localized array<string> HelpParamNames;
var const localized array<string> HelpParamDescriptions;
var bool IsServer;
var bool IsClient;
var bool IsEditor;
var bool LogToConsole;
var bool ShowErrorCount;
var bool BioLoadConsoleSupport;
var bool bBioUseSound;

public event native function int Main(string Params);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IsServer = TRUE
    IsClient = TRUE
    IsEditor = TRUE
    ShowErrorCount = TRUE
}
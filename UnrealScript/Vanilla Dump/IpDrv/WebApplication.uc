Class WebApplication;

var string Path;
var WorldInfo WorldInfo;
var WebServer WebServer;

public final function Cleanup();

public function Init();

public function Query(WebRequest request, WebResponse Response);

public function CleanupApp()
{
    if (WorldInfo != None)
    {
        WorldInfo = None;
    }
    if (WebServer != None)
    {
        WebServer = None;
    }
}
public function PostQuery(WebRequest request, WebResponse Response);

public function bool PreQuery(WebRequest request, WebResponse Response)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
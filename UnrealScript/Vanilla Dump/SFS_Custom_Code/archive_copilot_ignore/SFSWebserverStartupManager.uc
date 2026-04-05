Class SFSWebServerStartupManager extends SFSManager within SFXPawn;

var WebServer WebServer;

public event simulated function HandlePostAdd()
{
    local WorldInfo WI;
    local Class<WebApplication> AppClass;
    local IpAddr LocalIP;
    local string ServerURLString;
    
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    if (WI == None)
    {
        return;
    }
    // Spawn the WebServer actor
    WebServer = WI.Spawn(Class'WebServer');
    if (WebServer == None)
    {
        return;
    }
    //Assign player to the webserver
    WebServer.Player = Outer;
    // Configure WebServer properties before manual initialization
    WebServer.bEnabled = TRUE;
    WebServer.ListenPort = 8080;
    WebServer.MaxConnections = 18;
    WebServer.ExpirationSeconds = 86400;
    WebServer.DefaultApplication = -1;
    // Set up HelloWeb application
    WebServer.Applications[0] = "IpDrv.HelloWeb";
    WebServer.ApplicationPaths[0] = "/hello";
    // Build the server URL
    WebServer.GetLocalIP(LocalIP);
    ServerURLString = WebServer.IpAddrToString(LocalIP);
    if (InStr(ServerURLString, ":", , , ) != -1)
    {
        ServerURLString = Left(ServerURLString, InStr(ServerURLString, ":", , , ));
    }
    WebServer.ServerURL = "http://" $ ServerURLString $ ":8080";
    // Manually bind and listen (PostBeginPlay will destroy server in Standalone mode)
    if (WebServer.BindPort(8080) > 0)
    {
        if (WebServer.Listen())
        {
            // Manually initialize HelloWeb application
            AppClass = Class<WebApplication>(DynamicLoadObject("IpDrv.HelloWeb", Class'Class'));
            if (AppClass != None)
            {
                WebServer.ApplicationObjects[0] = new (None) AppClass;
                WebServer.ApplicationObjects[0].WorldInfo = WI;
                WebServer.ApplicationObjects[0].WebServer = WebServer;
                WebServer.ApplicationObjects[0].Path = "/hello";
                WebServer.ApplicationObjects[0].Init();
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
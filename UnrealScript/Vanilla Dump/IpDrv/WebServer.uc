Class WebServer extends TcpLink
    transient
    config(Web);

var config string Applications[10];
var config string ApplicationPaths[10];
var config string ServerName;
var string ServerURL;
var WebApplication ApplicationObjects[10];
var config int ListenPort;
var config int MaxConnections;
var config int DefaultApplication;
var config int ExpirationSeconds;
var int ConnectionCount;
var int ConnId;
var config bool bEnabled;

public event function Destroyed()
{
    local int i;
    
    for (i = 0; i < 10; i++)
    {
        if (ApplicationObjects[i] != None)
        {
            ApplicationObjects[i].CleanupApp();
        }
    }
    Super(Actor).Destroyed();
}
public event function GainedChild(Actor C)
{
    Super(Actor).GainedChild(C);
    ConnectionCount++;
    if (MaxConnections > 0 && ConnectionCount > MaxConnections && LinkState == ELinkState.STATE_Listening)
    {
        Close();
    }
}
public event function LostChild(Actor C)
{
    Super(Actor).LostChild(C);
    ConnectionCount--;
    if (ConnectionCount <= MaxConnections && LinkState != ELinkState.STATE_Listening)
    {
        Listen();
    }
}
public function PostBeginPlay()
{
    local int i;
    local Class<WebApplication> ApplicationClass;
    local IpAddr L;
    local string S;
    
    if (WorldInfo.NetMode == ENetMode.NM_Standalone || WorldInfo.NetMode == ENetMode.NM_Client)
    {
        Destroy();
        return;
    }
    if (!bEnabled)
    {
        Destroy();
        return;
    }
    Super(Actor).PostBeginPlay();
    if (ServerName == "")
    {
        GetLocalIP(L);
        S = IpAddrToString(L);
        i = InStr(S, ":", , , );
        if (i != -1)
        {
            S = Left(S, i);
        }
        ServerURL = "http://" $ S;
    }
    else
    {
        ServerURL = "http://" $ ServerName;
    }
    if (ListenPort != 80)
    {
        ServerURL = ServerURL $ ":" $ ListenPort;
    }
    if (BindPort(ListenPort) > 0)
    {
        if (Listen() == TRUE)
        {
            for (i = 0; i < 10; i++)
            {
                if (Applications[i] == "")
                {
                    break;
                }
                ApplicationClass = Class<WebApplication>(DynamicLoadObject(Applications[i], Class'Class'));
                if (ApplicationClass != None)
                {
                    ApplicationObjects[i] = new (None) ApplicationClass;
                    ApplicationObjects[i].WorldInfo = WorldInfo;
                    ApplicationObjects[i].WebServer = Self;
                    ApplicationObjects[i].Path = ApplicationPaths[i];
                    ApplicationObjects[i].Init();
                    continue;
                }
            }
            return;
        }
    }
    Destroy();
}
public function WebApplication GetApplication(string URI, out string SubURI)
{
    local int i;
    local int L;
    
    SubURI = "";
    for (i = 0; i < 10; i++)
    {
        if (ApplicationPaths[i] != "")
        {
            L = Len(ApplicationPaths[i]);
            if (Left(URI, L) ~= ApplicationPaths[i] && (Len(URI) == L || Mid(URI, L, 1) == "/"))
            {
                SubURI = Mid(URI, L, );
                return ApplicationObjects[i];
            }
        }
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AcceptClass = Class'WebConnection'
}
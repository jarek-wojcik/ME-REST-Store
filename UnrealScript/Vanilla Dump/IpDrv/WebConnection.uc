Class WebConnection extends TcpLink
    transient
    config(Web);

var string ReceivedData;
var WebServer WebServer;
var WebRequest request;
var WebResponse Response;
var WebApplication Application;
var int RawBytesExpecting;
var config int MaxValueLength;
var config int MaxLineLength;
var int ConnId;
var bool bDelayCleanup;

public function Cleanup()
{
    if (bDelayCleanup)
    {
        return;
    }
    if (request != None)
    {
        request = None;
    }
    if (Response != None)
    {
        Response.Connection = None;
        Response = None;
    }
    if (Application != None)
    {
        Application = None;
    }
    Close();
}
public event function Timer()
{
    bDelayCleanup = FALSE;
    Cleanup();
}
public event function Accepted()
{
    WebServer = WebServer(Owner);
    SetTimer(30.0, FALSE, , );
    ConnId = WebServer.ConnId++;
}
public event function Closed()
{
    Destroy();
}
public function ReceivedLine(string S)
{
    if (S == "")
    {
        EndOfHeaders();
    }
    else if (Left(S, 4) ~= "GET ")
    {
        ProcessGet(S);
    }
    else if (Left(S, 5) ~= "POST ")
    {
        ProcessPost(S);
    }
    else if (Left(S, 5) ~= "HEAD ")
    {
        ProcessHead(S);
    }
    else if (request != None)
    {
        request.ProcessHeaderString(S);
    }
}
public event function ReceivedText(string Text)
{
    local int i;
    local string S;
    
    ReceivedData $= Text;
    if (RawBytesExpecting > 0)
    {
        RawBytesExpecting -= Len(Text);
        CheckRawBytes();
        return;
    }
    if (Left(ReceivedData, 1) == Chr(10))
    {
        ReceivedData = Mid(ReceivedData, 1, );
    }
    i = InStr(ReceivedData, Chr(13), , , );
    while (i != -1)
    {
        S = Left(ReceivedData, i);
        i++;
        if (Mid(ReceivedData, i, 1) == Chr(10))
        {
            i++;
        }
        ReceivedData = Mid(ReceivedData, i, );
        ReceivedLine(S);
        if (LinkState != ELinkState.STATE_Connected)
        {
            return;
        }
        if (RawBytesExpecting > 0)
        {
            CheckRawBytes();
            return;
        }
        i = InStr(ReceivedData, Chr(13), , , );
    }
}
public function CheckRawBytes()
{
    if (RawBytesExpecting <= 0)
    {
        if (InStr(Locs(request.ContentType), "application/x-www-form-urlencoded", , , ) != 0)
        {
            Response.HTTPError(400);
        }
        else
        {
            request.DecodeFormData(ReceivedData);
            if (Application.PreQuery(request, Response))
            {
                Application.Query(request, Response);
                Application.PostQuery(request, Response);
            }
            ReceivedData = "";
        }
        Cleanup();
    }
}
public function CreateResponseObject()
{
    local int i;
    
    request = new (None) Class'WebRequest';
    request.RemoteAddr = IpAddrToString(RemoteAddr);
    i = InStr(request.RemoteAddr, ":", , , );
    if (i > -1)
    {
        request.RemoteAddr = Left(request.RemoteAddr, i);
    }
    Response = new (None) Class'WebResponse';
    Response.Connection = Self;
}
public function EndOfHeaders()
{
    if (Response == None)
    {
        CreateResponseObject();
        Response.HTTPError(400);
        Cleanup();
        return;
    }
    if (Application == None)
    {
        Response.HTTPError(404);
        Cleanup();
        return;
    }
    if (request.ContentLength != 0 && request.RequestType == ERequestType.Request_POST)
    {
        RawBytesExpecting = request.ContentLength;
        RawBytesExpecting -= Len(ReceivedData);
        CheckRawBytes();
    }
    else
    {
        if (Application.PreQuery(request, Response))
        {
            Application.Query(request, Response);
            Application.PostQuery(request, Response);
        }
        Cleanup();
    }
}
public final function bool IsHanging()
{
    return bDelayCleanup;
}
public function ProcessGet(string S)
{
    local int i;
    
    if (request == None)
    {
        CreateResponseObject();
    }
    request.RequestType = ERequestType.Request_GET;
    S = Mid(S, 4, );
    while (Left(S, 1) == " ")
    {
        S = Mid(S, 1, );
    }
    i = InStr(S, " ", , , );
    if (i != -1)
    {
        S = Left(S, i);
    }
    i = InStr(S, "?", , , );
    if (i != -1)
    {
        request.DecodeFormData(Mid(S, i + 1, ));
        S = Left(S, i);
    }
    Application = WebServer.GetApplication(S, request.URI);
    if (Application != None && request.URI == "")
    {
        Response.Redirect(S $ "/");
        Cleanup();
    }
    else if (Application == None && WebServer.DefaultApplication != -1)
    {
        Response.Redirect(WebServer.ApplicationPaths[WebServer.DefaultApplication] $ "/");
        Cleanup();
    }
}
public function ProcessHead(string S)
{
}
public function ProcessPost(string S)
{
    local int i;
    
    if (request == None)
    {
        CreateResponseObject();
    }
    request.RequestType = ERequestType.Request_POST;
    S = Mid(S, 5, );
    while (Left(S, 1) == " ")
    {
        S = Mid(S, 1, );
    }
    i = InStr(S, " ", , , );
    if (i != -1)
    {
        S = Left(S, i);
    }
    i = InStr(S, "?", , , );
    if (i != -1)
    {
        request.DecodeFormData(Mid(S, i + 1, ));
        S = Left(S, i);
    }
    Application = WebServer.GetApplication(S, request.URI);
    if (Application != None && request.URI == "")
    {
        Response.Redirect(S $ "/");
        Cleanup();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
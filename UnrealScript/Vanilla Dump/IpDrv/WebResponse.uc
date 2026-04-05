Class WebResponse
    native
    config(Web);

var const native Map_Mirror ReplacementMap;
var array<string> headers;
var const config string IncludePath;
var const localized string CharSet;
var WebConnection Connection;
var bool bSentText;
var bool bSentResponse;

public event function SendBinary(int Count, byte B[255])
{
    Connection.SendBinary(Count, B);
}
public event function SendText(string Text, optional bool bNoCRLF)
{
    if (!bSentText)
    {
        SendStandardHeaders();
        bSentText = TRUE;
    }
    if (bNoCRLF)
    {
        Connection.SendText(Text);
    }
    else
    {
        Connection.SendText(Text $ Chr(13) $ Chr(10));
    }
}
public function AddHeader(string Header, optional bool bReplace = TRUE)
{
    local int i;
    local int idx;
    local string Part;
    local string Entry;
    
    i = InStr(Header, ":", , , );
    if (i > -1)
    {
        Part = Caps(Left(Header, i + 1));
    }
    else
    {
        return;
    }
    foreach headers(Entry, idx)
    {
        if (InStr(Caps(Entry), Part, , , ) > -1)
        {
            if (bReplace)
            {
                if (i + 2 >= Len(Header))
                {
                    headers.Remove(idx, 1);
                }
                else
                {
                    headers[idx] = Header;
                }
            }
            return;
        }
    }
    if (Len(Header) > i + 2)
    {
        headers.AddItem(Header);
    }
}
public final native function ClearSubst();

public final native function Dump();

public final native function bool FileExists(string Filename);

public final native function string GetHTTPExpiration(optional int OffsetSeconds);

public final native function bool IncludeBinaryFile(string Filename);

public final native function bool IncludeUHTM(string Filename);

public final native function string LoadParsedUHTM(string Filename);

public final native function Subst(string Variable, coerce string Value, optional bool bClear);

public function bool SentText()
{
    return bSentText;
}
public function FailAuthentication(string Realm)
{
    HTTPError(401, Realm);
}
public function HTTPError(int ErrorNum, optional string Data)
{
    switch (ErrorNum)
    {
        case 400:
            HTTPResponse("HTTP/1.1 400 Bad Request");
            SendText("<HTML><HEAD><TITLE>400 Bad Request</TITLE></HEAD><BODY><H1>400 Bad Request</H1>If you got this error from a standard web browser, please mail epicgames.com and submit a bug report.</BODY></HTML>");
            break;
        case 401:
            HTTPResponse("HTTP/1.1 401 Unauthorized");
            AddHeader("WWW-authenticate: basic realm=\"" $ Data $ "\"");
            SendText("<HTML><HEAD><TITLE>401 Unauthorized</TITLE></HEAD><BODY><H1>401 Unauthorized</H1></BODY></HTML>");
            break;
        case 404:
            HTTPResponse("HTTP/1.1 404 Not Found");
            SendText("<HTML><HEAD><TITLE>404 File Not Found</TITLE></HEAD><BODY><H1>404 File Not Found</H1>The URL you requested was not found.</BODY></HTML>");
            break;
        default:
            break;
    }
}
public function HTTPHeader(string Header)
{
    if (bSentText)
    {
    }
    else
    {
        if (!bSentResponse)
        {
            HTTPResponse("HTTP/1.1 200 Ok");
        }
        if (Len(Header) == 0)
        {
            bSentText = TRUE;
        }
        Connection.SendText(Header $ Chr(13) $ Chr(10));
    }
}
public function HTTPResponse(string Header)
{
    bSentResponse = TRUE;
    HTTPHeader(Header);
}
public function Redirect(string URL)
{
    HTTPResponse("HTTP/1.1 302 Document Moved");
    AddHeader("Location: " $ URL);
    SendText("<html><head><title>Document Moved</title></head>");
    SendText("<body><h1>Object Moved</h1>This document may be found <a HREF=\"" $ URL $ "\">here</a>.</body></html>");
}
public function bool SendCachedFile(string Filename, optional string ContentType)
{
    if (!bSentText)
    {
        SendStandardHeaders(ContentType, TRUE);
        bSentText = TRUE;
    }
    return IncludeUHTM(Filename);
}
public function SendHeaders()
{
    local string hdr;
    
    foreach headers(hdr, )
    {
        HTTPHeader(hdr);
    }
}
public function SendStandardHeaders(optional string ContentType, optional bool bCache)
{
    if (ContentType == "")
    {
        ContentType = "text/html";
    }
    if (!bSentResponse)
    {
        HTTPResponse("HTTP/1.1 200 OK");
    }
    AddHeader("Server: UnrealEngine IpDrv Web Server Build " $ Connection.WorldInfo.EngineVersion, FALSE);
    AddHeader("Content-Type: " $ ContentType, FALSE);
    if (bCache)
    {
        AddHeader("Cache-Control: max-age=" $ Connection.WebServer.ExpirationSeconds, FALSE);
        AddHeader("Expires: " $ GetHTTPExpiration(Connection.WebServer.ExpirationSeconds), FALSE);
    }
    AddHeader("Connection: Close");
    SendHeaders();
    HTTPHeader("");
}
public function bool SentResponse()
{
    return bSentResponse;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
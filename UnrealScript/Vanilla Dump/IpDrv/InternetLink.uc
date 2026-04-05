Class InternetLink extends Info
    native
    transient;

enum EReceiveMode
{
    RMODE_Manual,
    RMODE_Event,
};
enum ELineMode
{
    LMODE_auto,
    LMODE_DOS,
    LMODE_UNIX,
    LMODE_MAC,
};
enum ELinkMode
{
    MODE_Text,
    MODE_Line,
    MODE_Binary,
};
struct IpAddr 
{
    var int Addr;
    var int Port;
};

var const Pointer Socket;
var const Pointer RemoteSocket;
var const native Pointer PrivateResolveInfo;
var const int Port;
var const int DataPending;
var ELinkMode LinkMode;
var ELineMode InLineMode;
var ELineMode OutLineMode;
var EReceiveMode ReceiveMode;

public native function int GetLastError();

public native function GetLocalIP(out IpAddr Arg);

public native function string IpAddrToString(IpAddr Arg);

public native function bool IsDataPending();

public native function bool ParseURL(coerce string URL, out string Addr, out int PortNum, out string LevelName, out string EntryName);

public native function Resolve(coerce string Domain);

public event function Resolved(IpAddr Addr);

public event function ResolveFailed();

public native function bool StringToIpAddr(string Str, out IpAddr Addr);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReceiveMode = EReceiveMode.RMODE_Event
}
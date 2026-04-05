Class TcpLink extends InternetLink
    native
    transient;

enum ELinkState
{
    STATE_Initialized,
    STATE_Ready,
    STATE_Listening,
    STATE_Connecting,
    STATE_Connected,
    STATE_ListenClosePending,
    STATE_ConnectClosePending,
    STATE_ListenClosing,
    STATE_ConnectClosing,
};

var const array<byte> SendFIFO;
var const string RecvBuf;
var Class<TcpLink> AcceptClass;
var IpAddr RemoteAddr;
var ELinkState LinkState;

public native function bool Close();

public native function bool IsConnected();

public native function bool Open(IpAddr Addr);

public native function int SendBinary(int Count, byte B[255]);

public native function int SendText(coerce string Str);

public event function Accepted();

public native function int BindPort(optional int PortNum, optional bool bUseNextAvailable);

public event function Closed();

public native function bool Listen();

public event function Opened();

public native function int ReadBinary(int Count, out byte B[255]);

public native function int ReadText(out string Str);

public event function ReceivedBinary(int Count, byte B[255]);

public event function ReceivedLine(string Line);

public event function ReceivedText(string Text);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAlwaysTick = TRUE
}
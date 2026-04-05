Class MeshBeaconClient extends MeshBeacon
    native
    config(Engine);

enum EMeshBeaconClientState
{
    MBCS_None,
    MBCS_Connecting,
    MBCS_Connected,
    MBCS_ConnectionFailed,
    MBCS_AwaitingResponse,
    MBCS_Closed,
};
struct native ClientBandwidthTestData 
{
    var int NumBytesToSendTotal;
    var int NumBytesSentTotal;
    var int NumBytesSentLast;
    var float ElapsedTestTime;
    var EMeshBeaconBandwidthTestType testType;
    var EMeshBeaconBandwidthTestState CurrentState;
};
struct native ClientConnectionRequest 
{
    var UniqueNetId PlayerNetId;
    var array<ConnectionBandwidthStats> BandwidthHistory;
    var float GoodHostRatio;
    var int MinutesSinceLastTest;
    var bool bCanHostVs;
    var ENATType NatType;
};

var const ClientConnectionRequest ClientPendingRequest;
var config string ResolverClassName;
var delegate<OnConnectionRequestResult> __OnConnectionRequestResult__Delegate;
var delegate<OnReceivedBandwidthTestRequest> __OnReceivedBandwidthTestRequest__Delegate;
var delegate<OnReceivedBandwidthTestResults> __OnReceivedBandwidthTestResults__Delegate;
var delegate<OnTravelRequestReceived> __OnTravelRequestReceived__Delegate;
var delegate<OnCreateNewSessionRequestReceived> __OnCreateNewSessionRequestReceived__Delegate;
var const OnlineGameSearchResult HostPendingRequest;
var Class<ClientBeaconAddressResolver> ResolverClass;
var ClientBandwidthTestData CurrentBandwidthTest;
var config float ConnectionRequestTimeout;
var float ConnectionRequestElapsedTime;
var ClientBeaconAddressResolver Resolver;
var transient bool bUsingRegisteredAddr;
var EMeshBeaconClientState ClientBeaconState;
var EMeshBeaconPacketType ClientBeaconRequestType;

public native function bool BeginBandwidthTest(EMeshBeaconBandwidthTestType testType, int TestBufferSize);

public event native function DestroyBeacon();

public delegate function OnConnectionRequestResult(EMeshBeaconConnectionResult ConnectionResult);

public delegate function OnCreateNewSessionRequestReceived(Name SessionName, Class<OnlineGameSearch> SearchClass, const out array<PlayerMember> Players);

public delegate function OnReceivedBandwidthTestRequest(EMeshBeaconBandwidthTestType testType);

public delegate function OnReceivedBandwidthTestResults(EMeshBeaconBandwidthTestType testType, EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats);

public delegate function OnTravelRequestReceived(Name SessionName, Class<OnlineGameSearch> SearchClass, const out byte PlatformSpecificInfo[80]);

public native function bool RequestConnection(const out OnlineGameSearchResult DesiredHost, const out ClientConnectionRequest ClientRequest, bool bRegisterSecureAddress);

public native function bool SendHostNewGameSessionResponse(bool bSuccess, Name SessionName, Class<OnlineGameSearch> SearchClass, const out byte PlatformSpecificInfo[80]);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
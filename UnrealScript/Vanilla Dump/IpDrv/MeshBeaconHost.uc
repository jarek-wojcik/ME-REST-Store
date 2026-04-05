Class MeshBeaconHost extends MeshBeacon
    native
    config(Engine);

struct native ClientMeshBeaconConnection 
{
    var ClientConnectionBandwidthTestData BandwidthTest;
    var UniqueNetId PlayerNetId;
    var array<ConnectionBandwidthStats> BandwidthHistory;
    var transient native Pointer Socket;
    var float ElapsedHeartbeatTime;
    var float GoodHostRatio;
    var int MinutesSinceLastTest;
    var bool bConnectionAccepted;
    var bool bCanHostVs;
    var ENATType NatType;
};
struct native ClientConnectionBandwidthTestData 
{
    var Double RequestTestStartTime;
    var Double TestStartTime;
    var ConnectionBandwidthStats BandwidthStats;
    var int BytesTotalNeeded;
    var int BytesReceived;
    var EMeshBeaconBandwidthTestState CurrentState;
    var EMeshBeaconBandwidthTestType testType;
};

var const UniqueNetId OwningPlayerId;
var const array<ClientMeshBeaconConnection> ClientConnections;
var array<UniqueNetId> PendingPlayerConnections;
var delegate<OnReceivedClientConnectionRequest> __OnReceivedClientConnectionRequest__Delegate;
var delegate<OnStartedBandwidthTest> __OnStartedBandwidthTest__Delegate;
var delegate<OnFinishedBandwidthTest> __OnFinishedBandwidthTest__Delegate;
var delegate<OnAllPendingPlayersConnected> __OnAllPendingPlayersConnected__Delegate;
var delegate<OnReceivedClientCreateNewSessionResult> __OnReceivedClientCreateNewSessionResult__Delegate;
var config int ConnectionBacklog;
var bool bAllowBandwidthTesting;

public native function bool AllPlayersConnected(const out array<UniqueNetId> Players);

public native function CancelInProgressBandwidthTests();

public native function CancelPendingBandwidthTests();

public event native function DestroyBeacon();

public native function int GetConnectionIndexForPlayer(UniqueNetId PlayerNetId);

public native function bool HasInProgressBandwidthTest();

public native function bool HasPendingBandwidthTest();

public native function bool InitHostBeacon(UniqueNetId InOwningPlayerId);

public delegate function OnAllPendingPlayersConnected();

public delegate function OnFinishedBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType testType, EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats);

public delegate function OnReceivedClientConnectionRequest(const out ClientMeshBeaconConnection NewClientConnection);

public delegate function OnReceivedClientCreateNewSessionResult(bool bSucceeded, Name SessionName, Class<OnlineGameSearch> SearchClass, const out byte PlatformSpecificInfo[80]);

public delegate function OnStartedBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType testType);

public native function bool RequestClientBandwidthTest(UniqueNetId PlayerNetId, EMeshBeaconBandwidthTestType testType, int TestBufferSize);

public native function bool RequestClientCreateNewSession(UniqueNetId PlayerNetId, Name SessionName, Class<OnlineGameSearch> SearchClass, const out array<PlayerMember> Players);

public native function TellClientsToTravel(Name SessionName, Class<OnlineGameSearch> SearchClass, const out byte PlatformSpecificInfo[80]);

public function AllowBandwidthTesting(bool bEnabled)
{
    bAllowBandwidthTesting = bEnabled;
}
public function SetPendingPlayerConnections(const out array<UniqueNetId> Players)
{
    PendingPlayerConnections = Players;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAllowBandwidthTesting = TRUE
}
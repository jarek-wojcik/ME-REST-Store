Class PartyBeaconClient extends PartyBeacon
    native
    config(Engine);

enum EPartyBeaconClientRequest
{
    PBClientRequest_NewReservation,
    PBClientRequest_UpdateReservation,
};
enum EPartyBeaconClientState
{
    PBCS_None,
    PBCS_Connecting,
    PBCS_Connected,
    PBCS_ConnectionFailed,
    PBCS_AwaitingResponse,
    PBCS_Closed,
};

var PartyReservation PendingRequest;
var config string ResolverClassName;
var delegate<OnReservationRequestComplete> __OnReservationRequestComplete__Delegate;
var delegate<OnReservationCountUpdated> __OnReservationCountUpdated__Delegate;
var delegate<OnTravelRequestReceived> __OnTravelRequestReceived__Delegate;
var delegate<OnHostIsReady> __OnHostIsReady__Delegate;
var delegate<OnHostHasCancelled> __OnHostHasCancelled__Delegate;
var const OnlineGameSearchResult HostPendingRequest;
var Class<ClientBeaconAddressResolver> ResolverClass;
var config float ReservationRequestTimeout;
var float ReservationRequestElapsedTime;
var ClientBeaconAddressResolver Resolver;
var EPartyBeaconClientState ClientBeaconState;
var EPartyBeaconClientRequest ClientBeaconRequestType;

public native function bool CancelReservation(UniqueNetId CancellingPartyLeader);

public event native function DestroyBeacon();

public delegate function OnHostHasCancelled();

public delegate function OnHostIsReady();

public delegate function OnReservationCountUpdated(int ReservationRemaining);

public delegate function OnReservationRequestComplete(EPartyReservationResult ReservationResult);

public delegate function OnTravelRequestReceived(Name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80]);

public native function bool RequestReservation(const out OnlineGameSearchResult DesiredHost, UniqueNetId RequestingPartyLeader, const out array<PlayerReservation> Players);

public native function bool RequestReservationUpdate(const out OnlineGameSearchResult DesiredHost, UniqueNetId RequestingPartyLeader, const out array<PlayerReservation> PlayersToAdd);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
Class PartyBeacon
    native
    config(Engine);

struct native PartyReservation 
{
    var UniqueNetId PartyLeader;
    var array<PlayerReservation> PartyMembers;
    var int TeamNum;
};
struct native PlayerReservation 
{
    var UniqueNetId NetId;
    var Double Mu;
    var Double Sigma;
    var int Skill;
    var int XPLevel;
    var float ElapsedSessionTime;
};
enum EPartyReservationResult
{
    PRR_GeneralError,
    PRR_PartyLimitReached,
    PRR_IncorrectPlayerCount,
    PRR_RequestTimedOut,
    PRR_ReservationDuplicate,
    PRR_ReservationNotFound,
    PRR_ReservationAccepted,
};
enum EReservationPacketType
{
    RPT_UnknownPacketType,
    RPT_ClientReservationRequest,
    RPT_ClientReservationUpdateRequest,
    RPT_ClientCancellationRequest,
    RPT_HostReservationResponse,
    RPT_HostReservationCountUpdate,
    RPT_HostTravelRequest,
    RPT_HostIsReady,
    RPT_HostHasCancelled,
    RPT_Heartbeat,
};

var const native noexport Pointer VfTable_FTickableObject;
var delegate<OnDestroyComplete> __OnDestroyComplete__Delegate;
var transient native Pointer Socket;
var Name BeaconName;
var config int PartyBeaconPort;
var config float HeartbeatTimeout;
var float ElapsedHeartbeatTime;
var bool bIsInTick;
var bool bWantsDeferredDestroy;
var bool bShouldTick;

public event native function DestroyBeacon();

public delegate function OnDestroyComplete();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShouldTick = TRUE
}
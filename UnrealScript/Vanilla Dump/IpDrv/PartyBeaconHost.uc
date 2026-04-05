Class PartyBeaconHost extends PartyBeacon
    native
    config(Engine);

struct native ClientBeaconConnection 
{
    var UniqueNetId PartyLeader;
    var transient native Pointer Socket;
    var float ElapsedHeartbeatTime;
};

var const array<ClientBeaconConnection> Clients;
var const array<PartyReservation> Reservations;
var delegate<OnReservationChange> __OnReservationChange__Delegate;
var delegate<OnReservationsFull> __OnReservationsFull__Delegate;
var delegate<OnClientCancellationReceived> __OnClientCancellationReceived__Delegate;
var Name OnlineSessionName;
var const int NumTeams;
var const int NumPlayersPerTeam;
var const int NumReservations;
var const int NumConsumedReservations;
var config int ConnectionBacklog;
var const int ReservedHostTeamNum;
var bool bBestFitTeamAssignment;

public native function EPartyReservationResult AddPartyReservationEntry(UniqueNetId PartyLeader, const out array<PlayerReservation> PlayerMembers, int TeamNum, bool bIsHost);

public native function AppendReservationSkillsToSearch(OnlineGameSearch Search);

public event native function DestroyBeacon();

public native function int GetMaxAvailableTeamSize();

public native function HandlePlayerLogout(UniqueNetId PlayerID, bool bMaintainParty);

public native function bool InitHostBeacon(int InNumTeams, int InNumPlayersPerTeam, int InNumReservations, Name InSessionName);

public delegate function OnClientCancellationReceived(UniqueNetId PartyLeader);

public delegate function OnReservationChange();

public delegate function OnReservationsFull();

public event function RegisterPartyMembers()
{
    local int Index;
    local int PartyIndex;
    local OnlineSubsystem OnlineSub;
    local OnlineRecentPlayersList PlayersList;
    local array<UniqueNetId> Members;
    local PlayerReservation PlayerRes;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            for (Index = 0; Index < Reservations[PartyIndex].PartyMembers.Length; Index++)
            {
                PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
                OnlineSub.GameInterface.RegisterPlayer(OnlineSessionName, PlayerRes.NetId, FALSE);
                Members.AddItem(PlayerRes.NetId);
            }
            PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
            if (PlayersList != None)
            {
                PlayersList.AddPartyToRecentParties(Reservations[PartyIndex].PartyLeader, Members);
            }
        }
    }
}
public native function TellClientsHostHasCancelled();

public native function TellClientsHostIsReady();

public native function TellClientsToTravel(Name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80]);

public event function UnregisterParty(UniqueNetId PartyLeader)
{
    local int PlayerIndex;
    local int PartyIndex;
    local OnlineSubsystem OnlineSub;
    local PlayerReservation PlayerRes;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            if (Reservations[PartyIndex].PartyLeader == PartyLeader)
            {
                for (PlayerIndex = 0; PlayerIndex < Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
                {
                    PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
                    OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
                }
            }
        }
    }
}
public event function UnregisterPartyMembers()
{
    local int Index;
    local int PartyIndex;
    local OnlineSubsystem OnlineSub;
    local PlayerReservation PlayerRes;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
        {
            for (Index = 0; Index < Reservations[PartyIndex].PartyMembers.Length; Index++)
            {
                PlayerRes = Reservations[PartyIndex].PartyMembers[Index];
                OnlineSub.GameInterface.UnregisterPlayer(OnlineSessionName, PlayerRes.NetId);
            }
        }
    }
}
public native function EPartyReservationResult UpdatePartyReservationEntry(UniqueNetId PartyLeader, const out array<PlayerReservation> PlayerMembers);

public function bool AreReservationsFull()
{
    return NumConsumedReservations == NumReservations;
}
public function GetPartyLeaders(out array<UniqueNetId> PartyLeaders)
{
    local int PartyIndex;
    
    for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
    {
        PartyLeaders.AddItem(Reservations[PartyIndex].PartyLeader);
    }
}
public function GetPlayers(out array<UniqueNetId> Players)
{
    local int PlayerIndex;
    local int PartyIndex;
    local PlayerReservation PlayerRes;
    
    for (PartyIndex = 0; PartyIndex < Reservations.Length; PartyIndex++)
    {
        for (PlayerIndex = 0; PlayerIndex < Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
        {
            PlayerRes = Reservations[PartyIndex].PartyMembers[PlayerIndex];
            Players.AddItem(PlayerRes.NetId);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
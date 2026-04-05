Class OnlineRecentPlayersList
    config(Engine);

struct CurrentPlayerMet 
{
    var UniqueNetId NetId;
    var int TeamNum;
    var int Skill;
};
struct RecentParty 
{
    var UniqueNetId PartyLeader;
    var array<UniqueNetId> PartyMembers;
};

var RecentParty LastParty;
var array<UniqueNetId> RecentPlayers;
var array<RecentParty> RecentParties;
var array<CurrentPlayerMet> CurrentPlayers;
var config int MaxRecentPlayers;
var config int MaxRecentParties;
var int RecentPlayersAddIndex;
var int RecentPartiesAddIndex;

public function AddPartyToRecentParties(UniqueNetId PartyLeader, const out array<UniqueNetId> PartyMembers)
{
    local int FindIndex;
    
    FindIndex = RecentParties.Find('PartyLeader', PartyLeader);
    if (FindIndex == -1)
    {
        if (RecentPartiesAddIndex >= MaxRecentParties)
        {
            RecentPartiesAddIndex = 0;
        }
        if (RecentPartiesAddIndex + 1 >= RecentParties.Length)
        {
            RecentParties.Length = RecentPartiesAddIndex + 1;
        }
        RecentParties[RecentPartiesAddIndex].PartyLeader = PartyLeader;
        RecentParties[RecentPartiesAddIndex].PartyMembers = PartyMembers;
        RecentPartiesAddIndex++;
    }
}
public function AddPlayerToRecentPlayers(UniqueNetId NewPlayer)
{
    local int FindIndex;
    
    FindIndex = RecentPlayers.Find('Uid', NewPlayer.Uid);
    if (FindIndex == -1)
    {
        if (RecentPlayersAddIndex >= MaxRecentPlayers)
        {
            RecentPlayersAddIndex = 0;
        }
        if (RecentPlayersAddIndex + 1 >= RecentPlayers.Length)
        {
            RecentPlayers.Length = RecentPlayersAddIndex + 1;
        }
        RecentPlayers[RecentPlayersAddIndex] = NewPlayer;
        RecentPlayersAddIndex++;
    }
}
public function ClearRecentParties()
{
    RecentPartiesAddIndex = 0;
    RecentParties.Length = 0;
}
public function ClearRecentPlayers()
{
    RecentPlayersAddIndex = 0;
    RecentPlayers.Length = 0;
}
public function DumpPlayersList(const out array<CurrentPlayerMet> Players);

public function int GetCurrentPlayersListCount()
{
    return CurrentPlayers.Length;
}
public function GetPlayersFromCurrentPlayers(out array<UniqueNetId> Players)
{
    local int PlayerIndex;
    
    Players.Length = 0;
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        Players.AddItem(CurrentPlayers[PlayerIndex].NetId);
    }
}
public function GetPlayersFromRecentParties(out array<UniqueNetId> Players)
{
    local int PartyIndex;
    local int MemberIndex;
    local int AddMemberAt;
    
    Players.Length = 0;
    AddMemberAt = 0;
    for (PartyIndex = 0; PartyIndex < RecentParties.Length; PartyIndex++)
    {
        for (MemberIndex = 0; MemberIndex < RecentParties[PartyIndex].PartyMembers.Length; MemberIndex++)
        {
            Players.Length = AddMemberAt + 1;
            Players[AddMemberAt] = RecentParties[PartyIndex].PartyMembers[MemberIndex];
        }
    }
}
public function int GetSkillForCurrentPlayer(UniqueNetId Player)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        if (CurrentPlayers[PlayerIndex].NetId == Player)
        {
            return CurrentPlayers[PlayerIndex].Skill;
        }
    }
    return 0;
}
public function int GetTeamForCurrentPlayer(UniqueNetId Player)
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
    {
        if (CurrentPlayers[PlayerIndex].NetId == Player)
        {
            return CurrentPlayers[PlayerIndex].TeamNum;
        }
    }
    return 255;
}
public function SetCurrentPlayersList(const array<CurrentPlayerMet> Players)
{
    CurrentPlayers = Players;
}
public function SetLastParty(UniqueNetId PartyLeader, const out array<UniqueNetId> PartyMembers)
{
    LastParty.PartyLeader = PartyLeader;
    LastParty.PartyMembers = PartyMembers;
}
public function bool ShowCurrentPlayersList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    local array<UniqueNetId> Players;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
    {
        GetPlayersFromCurrentPlayers(Players);
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
    }
    return FALSE;
}
public function bool ShowLastPartyPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
    {
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, LastParty.PartyMembers, Title, Description);
    }
    return FALSE;
}
public function bool ShowRecentPartiesPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    local array<UniqueNetId> Players;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
    {
        GetPlayersFromRecentParties(Players);
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, Players, Title, Description);
    }
    return FALSE;
}
public function bool ShowRecentPlayerList(byte LocalUserNum, string Title, string Description)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.PlayerInterfaceEx != None)
    {
        return OnlineSub.PlayerInterfaceEx.ShowCustomPlayersUI(LocalUserNum, RecentPlayers, Title, Description);
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxRecentPlayers = 100
    MaxRecentParties = 5
}
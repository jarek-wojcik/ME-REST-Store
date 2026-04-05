Class PlayerReplicationInfo extends ReplicationInfo
    native
    nativereplication;

struct native AutomatedTestingDatum 
{
    var int NumberOfMatchesPlayed;
    var int NumMapListCyclesDone;
};

var repnotify databinding UniqueNetId UniqueId;
var repnotify databinding string PlayerName;
var string OldName;
var const localized string StringSpectating;
var const localized string StringUnknown;
var string SavedNetworkAddress;
var Class<GameMessage> GameMessageClass;
var const Name SessionName;
var AutomatedTestingDatum AutomatedTestingData;
var repnotify databinding float Score;
var databinding int Deaths;
var Actor PlayerLocationHint;
var int NumLives;
var int PlayerID;
var repnotify TeamInfo Team;
var int SplitscreenIndex;
var int StartTime;
var databinding int Kills;
var float ExactPing;
var int StatConnectionCounts;
var int StatPingTotals;
var int StatPingMin;
var int StatPingMax;
var int StatPKLTotal;
var int StatPKLMin;
var int StatPKLMax;
var int StatMaxInBPS;
var int StatAvgInBPS;
var int StatMaxOutBPS;
var int StatAvgOutBPS;
var transient Texture2D Avatar;
var bool bAdmin;
var bool bIsFemale;
var bool bIsSpectator;
var bool bOnlySpectator;
var bool bWaitingPlayer;
var bool bReadyToPlay;
var bool bOutOfLives;
var bool bBot;
var bool bHasFlag;
var bool bHasBeenWelcomed;
var repnotify bool bIsInactive;
var bool bFromPreviousLevel;
var byte Ping;
var transient ETTSSpeaker TTSSpeaker;

public event simulated function Destroyed()
{
    local PlayerController PC;
    
    if (WorldInfo.GRI != None)
    {
        WorldInfo.GRI.RemovePRI(Self);
    }
    if (ShouldBroadCastWelcomeMessage(TRUE))
    {
        foreach LocalPlayerControllers(Class'PlayerController', PC)
        {
            PC.ReceiveLocalizedMessage(GameMessageClass, 4, Self);
        }
    }
    UnregisterPlayerFromSession();
    Super(Actor).Destroyed();
}
public native function string GetPlayerAlias();

public simulated native function byte GetTeamNum();

public event simulated function PostBeginPlay()
{
    if (WorldInfo.GRI != None)
    {
        WorldInfo.GRI.AddPRI(Self);
    }
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (AIController(Owner) != None)
    {
        bBot = TRUE;
    }
    StartTime = WorldInfo.GRI.ElapsedTime;
    Timer();
    SetTimer(1.5 + FRand(), TRUE, , );
}
public event simulated function ReplicatedDataBinding(Name VarName)
{
    Super(Actor).ReplicatedDataBinding(VarName);
    if (VarName == 'Team')
    {
        UpdateTeamDataProvider();
    }
    else
    {
        if (VarName == 'PlayerName' && IsInvalidName())
        {
            return;
        }
        UpdatePlayerDataProvider(VarName);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    local Pawn P;
    local PlayerController PC;
    local int WelcomeMessageNum;
    local Actor A;
    
    if (VarName == 'Team')
    {
        foreach DynamicActors(Class'Pawn', P, )
        {
            if (P.PlayerReplicationInfo == Self)
            {
                P.NotifyTeamChanged();
                break;
            }
        }
        foreach LocalPlayerControllers(Class'PlayerController', PC)
        {
            if (PC.PlayerReplicationInfo == Self)
            {
                foreach AllActors(Class'Actor', A, )
                {
                    A.NotifyLocalPlayerTeamReceived();
                }
                break;
            }
        }
        ReplicatedDataBinding('Team');
    }
    else if (VarName == 'PlayerName')
    {
        if (IsInvalidName())
        {
            return;
        }
        if (WorldInfo.TimeSeconds < float(2))
        {
            bHasBeenWelcomed = TRUE;
            OldName = PlayerName;
            return;
        }
        if (bHasBeenWelcomed)
        {
            if (ShouldBroadCastWelcomeMessage())
            {
                foreach LocalPlayerControllers(Class'PlayerController', PC)
                {
                    PC.ReceiveLocalizedMessage(GameMessageClass, 2, Self);
                }
            }
        }
        else
        {
            if (bOnlySpectator)
            {
                WelcomeMessageNum = 16;
            }
            else
            {
                WelcomeMessageNum = 1;
            }
            bHasBeenWelcomed = TRUE;
            if (ShouldBroadCastWelcomeMessage())
            {
                foreach LocalPlayerControllers(Class'PlayerController', PC)
                {
                    PC.ReceiveLocalizedMessage(GameMessageClass, WelcomeMessageNum, Self);
                }
            }
        }
        OldName = PlayerName;
    }
    else if (VarName == 'UniqueId')
    {
        RegisterPlayerWithSession();
    }
    else if (VarName == 'bIsInactive')
    {
        WorldInfo.GRI.RemovePRI(Self);
        WorldInfo.GRI.AddPRI(Self);
    }
}
public function Reset()
{
    Super(Actor).Reset();
    Score = 0.0;
    Kills = 0;
    Deaths = 0;
    bReadyToPlay = FALSE;
    NumLives = 0;
    bOutOfLives = FALSE;
    bForceNetUpdate = TRUE;
}
public event function SetPlayerName(string S)
{
    PlayerName = S;
    if (WorldInfo.NetMode == ENetMode.NM_Standalone || WorldInfo.NetMode == ENetMode.NM_ListenServer)
    {
        ReplicatedEvent('PlayerName');
        ReplicatedDataBinding('PlayerName');
    }
    OldName = PlayerName;
    bForceNetUpdate = TRUE;
}
public event function Timer()
{
    UpdatePlayerLocation();
    SetTimer(1.5 + FRand(), TRUE, , );
}
public final native function UpdatePing(float TimeStamp);

public simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    local float XS;
    local float YS;
    
    if (Team == None)
    {
        HUD.Canvas.SetDrawColor(255, 255, 0);
    }
    else if (Team.TeamIndex == 0)
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
    }
    else
    {
        HUD.Canvas.SetDrawColor(64, 64, 255);
    }
    HUD.Canvas.SetPos(4.0, YPos);
    HUD.Canvas.Font = Class'Engine'.static.GetSmallFont();
    HUD.Canvas.StrLen(PlayerName, XS, YS);
    HUD.Canvas.DrawText(PlayerName);
    HUD.Canvas.SetPos(4.0 + XS, YPos);
    HUD.Canvas.Font = Class'Engine'.static.GetTinyFont();
    HUD.Canvas.SetDrawColor(255, 255, 0);
    if (bHasFlag)
    {
        HUD.Canvas.DrawText("   has flag ");
    }
    YPos += YS;
    HUD.Canvas.SetPos(4.0, YPos);
    if (!bBot && PlayerController(HUD.Owner).ViewTarget != PlayerController(HUD.Owner).Pawn)
    {
        HUD.Canvas.SetDrawColor(128, 128, 255);
        HUD.Canvas.DrawText("      bIsSpec:" @ bIsSpectator @ "OnlySpec:" $ bOnlySpectator @ "Waiting:" $ bWaitingPlayer @ "Ready:" $ bReadyToPlay @ "OutOfLives:" $ bOutOfLives);
        YPos += YL;
        HUD.Canvas.SetPos(4.0, YPos);
    }
}
public simulated function string GetHumanReadableName()
{
    return PlayerName;
}
public simulated function NotifyLocalPlayerTeamReceived()
{
    Super(Actor).NotifyLocalPlayerTeamReceived();
    UpdateTeamDataProvider();
}
public simulated function BindPlayerOwnerDataProvider()
{
    local PlayerController PlayerOwner;
    local LocalPlayer LP;
    local CurrentGameDataStore CurrentGameData;
    local PlayerDataProvider DataProvider;
    
    PlayerOwner = PlayerController(Owner);
    if (PlayerOwner != None)
    {
        LP = LocalPlayer(PlayerOwner.Player);
        if (LP != None)
        {
            CurrentGameData = GetCurrentGameDS();
            if (CurrentGameData != None)
            {
                DataProvider = CurrentGameData.GetPlayerDataProvider(Self);
                if (DataProvider != None)
                {
                    PlayerOwner.SetPlayerDataProvider(DataProvider);
                }
            }
        }
    }
}
public simulated function ClientInitialize(Controller C)
{
    local Actor A;
    local PlayerController PlayerOwner;
    local PlayerController FirstPlayer;
    local LocalPlayer LP;
    
    SetOwner(C);
    PlayerOwner = PlayerController(C);
    if (PlayerOwner != None)
    {
        if (PlayerOwner.IsSplitscreenPlayer())
        {
            if (int(PlayerOwner.NetPlayerIndex) != 0)
            {
                LP = LocalPlayer(PlayerOwner.Player);
                FirstPlayer = LP.ViewportClient.Outer.GamePlayers[0].Actor;
                FirstPlayer.PlayerReplicationInfo.SetSplitscreenIndex(0);
            }
            SetSplitscreenIndex(PlayerOwner.NetPlayerIndex);
        }
        BindPlayerOwnerDataProvider();
        if (Team != default.Team)
        {
            foreach AllActors(Class'Actor', A, )
            {
                A.NotifyLocalPlayerTeamReceived();
            }
        }
    }
}
public function CopyProperties(PlayerReplicationInfo PRI)
{
    PRI.Score = Score;
    PRI.Deaths = Deaths;
    PRI.Ping = Ping;
    PRI.NumLives = NumLives;
    PRI.PlayerName = PlayerName;
    PRI.PlayerID = PlayerID;
    PRI.StartTime = StartTime;
    PRI.Kills = Kills;
    PRI.bOutOfLives = bOutOfLives;
    PRI.SavedNetworkAddress = SavedNetworkAddress;
    PRI.Team = Team;
    PRI.UniqueId = UniqueId;
    PRI.AutomatedTestingData = AutomatedTestingData;
}
public function PlayerReplicationInfo Duplicate()
{
    local PlayerReplicationInfo NewPRI;
    
    NewPRI = Spawn(Class);
    CopyProperties(NewPRI);
    return NewPRI;
}
public simulated function CurrentGameDataStore GetCurrentGameDS()
{
    local DataStoreClient DSClient;
    local CurrentGameDataStore Result;
    
    DSClient = Class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != None)
    {
        Result = CurrentGameDataStore(DSClient.FindDataStore('CurrentGame'));
        if (Result == None)
        {
        }
    }
    return Result;
}
public simulated function string GetLocationName()
{
    local string LocationString;
    
    if (PlayerLocationHint == None)
    {
        return StringSpectating;
    }
    LocationString = PlayerLocationHint.GetLocationStringFor(Self);
    return LocationString == "" ? StringUnknown : LocationString;
}
public function IncrementDeaths(optional int Amt = 1)
{
    Deaths += Amt;
}
public simulated function bool IsInvalidName()
{
    local LocalPlayer LocPlayer;
    local PlayerController PC;
    local string ProfileName;
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PC = PlayerController(Owner);
        if (PC != None)
        {
            LocPlayer = LocalPlayer(PC.Player);
            if (LocPlayer != None && OnlineSub.GameInterface != None && OnlineSub.PlayerInterface != None)
            {
                if (int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) == 2)
                {
                    ProfileName = OnlineSub.PlayerInterface.GetPlayerNickname(byte(LocPlayer.ControllerId));
                    if (ProfileName != PlayerName)
                    {
                        PC.SetName(ProfileName);
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}
public simulated function bool IsLocalPlayerPRI()
{
    local PlayerController PC;
    local LocalPlayer LP;
    
    PC = PlayerController(Owner);
    if (PC != None)
    {
        LP = LocalPlayer(PC.Player);
        return LP != None;
    }
    return FALSE;
}
public function OverrideWith(PlayerReplicationInfo PRI)
{
    bIsSpectator = PRI.bIsSpectator;
    bOnlySpectator = PRI.bOnlySpectator;
    bWaitingPlayer = PRI.bWaitingPlayer;
    bReadyToPlay = PRI.bReadyToPlay;
    bOutOfLives = PRI.bOutOfLives || bOutOfLives;
    Team = PRI.Team;
}
public simulated function RegisterPlayerWithSession()
{
    local OnlineSubsystem Online;
    local OnlineRecentPlayersList PlayersList;
    
    Online = Class'GameEngine'.static.GetOnlineSubsystem();
    if (Online != None && Online.GameInterface != None && SessionName != 'None' && Online.GameInterface.GetGameSettings(SessionName) != None)
    {
        Online.GameInterface.RegisterPlayer(SessionName, UniqueId, FALSE);
        if (!bNetOwner)
        {
            PlayersList = OnlineRecentPlayersList(Online.GetNamedInterface('RecentPlayersList'));
            if (PlayersList != None)
            {
                PlayersList.AddPlayerToRecentPlayers(UniqueId);
            }
        }
    }
}
public function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
    CopyProperties(NewPRI);
    NewPRI.bOnlySpectator = bOnlySpectator;
}
public reliable server function ServerSetSplitscreenIndex(byte PlayerIndex)
{
    SplitscreenIndex = int(PlayerIndex);
}
public function SetPlayerTeam(TeamInfo NewTeam)
{
    bForceNetUpdate = Team != NewTeam;
    Team = NewTeam;
    UpdateTeamDataProvider();
}
public simulated function SetSplitscreenIndex(byte PlayerIndex)
{
    SplitscreenIndex = int(PlayerIndex);
    ServerSetSplitscreenIndex(PlayerIndex);
}
public simulated function SetUniqueId(UniqueNetId PlayerUniqueId)
{
    UniqueId = PlayerUniqueId;
}
public function SetWaitingPlayer(bool B)
{
    bIsSpectator = B;
    bWaitingPlayer = B;
    bForceNetUpdate = TRUE;
}
public simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
    return !bIsInactive && WorldInfo.NetMode != ENetMode.NM_Standalone;
}
public simulated function UnregisterPlayerFromSession()
{
    local OnlineSubsystem OnlineSub;
    local UniqueNetId ZeroId;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (SessionName != 'None' && WorldInfo.NetMode == ENetMode.NM_Client && OnlineSub != None && OnlineSub.GameInterface != None && OnlineSub.GameInterface.GetGameSettings(SessionName) != None && UniqueId != ZeroId)
    {
        OnlineSub.GameInterface.UnregisterPlayer(SessionName, UniqueId);
    }
}
public simulated function UpdatePlayerDataProvider(optional Name PropertyName)
{
    local CurrentGameDataStore CurrentGameData;
    local PlayerDataProvider DataProvider;
    local TeamDataProvider TeamProvider;
    
    CurrentGameData = GetCurrentGameDS();
    if (CurrentGameData != None)
    {
        DataProvider = CurrentGameData.GetPlayerDataProvider(Self);
        if (DataProvider != None)
        {
            DataProvider.NotifyPropertyChanged(PropertyName);
            if (Team != None)
            {
                TeamProvider = CurrentGameData.GetTeamDataProvider(Team);
                if (TeamProvider != None && TeamProvider.Players.Find(DataProvider) != -1)
                {
                    TeamProvider.NotifyPropertyChanged(TeamProvider.PlayerListFieldName);
                }
            }
        }
    }
}
public function UpdatePlayerLocation()
{
    local Volume V;
    local Volume Best;
    local Pawn P;
    
    if (Controller(Owner) != None)
    {
        P = Controller(Owner).Pawn;
    }
    if (P == None)
    {
        PlayerLocationHint = None;
        return;
    }
    foreach P.TouchingActors(Class'Volume', V, )
    {
        if (V.LocationName == "")
        {
            continue;
        }
        if (Best != None && V.LocationPriority <= Best.LocationPriority)
        {
            continue;
        }
        if (V.Encompasses(P))
        {
            Best = V;
        }
    }
    PlayerLocationHint = Best != None ? Best : P.WorldInfo;
}
public simulated function UpdateTeamDataProvider()
{
    local CurrentGameDataStore CurrentGameData;
    
    CurrentGameData = GetCurrentGameDS();
    if (CurrentGameData != None)
    {
        CurrentGameData.NotifyTeamChange();
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        UniqueId, PlayerName, Score, Deaths, PlayerLocationHint, Team, StartTime, bAdmin, bIsFemale, bIsSpectator, bOnlySpectator, bWaitingPlayer, bReadyToPlay, bOutOfLives, bHasFlag;
    if (bNetDirty && Role == ENetRole.ROLE_Authority && !bNetOwner)
        SplitscreenIndex, Ping;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        PlayerID, bBot, bIsInactive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StringSpectating = "Spectating"
    StringUnknown = "Unknown"
    GameMessageClass = Class'GameMessage'
    SessionName = 'Game'
    SplitscreenIndex = -1
    NetUpdateFrequency = 1.0
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}
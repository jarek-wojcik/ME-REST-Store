Class GameReplicationInfo extends ReplicationInfo
    native
    nativereplication
    config(Game);

var databinding array<TeamInfo> Teams;
var(GameReplicationInfo) globalconfig databinding string ServerName;
var(GameReplicationInfo) globalconfig databinding string MessageOfTheDay;
var array<PlayerReplicationInfo> PRIArray;
var array<PlayerReplicationInfo> InactivePRIArray;
var repnotify Class<GameInfo> GameClass;
var CurrentGameDataStore CurrentGameData;
var databinding int RemainingTime;
var databinding int ElapsedTime;
var databinding int RemainingMinute;
var databinding int GoalScore;
var databinding int TimeLimit;
var Actor Winner;
var bool bStopCountDown;
var repnotify bool bMatchHasBegun;
var repnotify bool bMatchIsOver;

public event simulated function Destroyed()
{
    Super(Actor).Destroyed();
    CleanupGameDataStore();
}
public simulated native function bool OnSameTeam(Actor A, Actor B);

public event simulated function PostBeginPlay()
{
    local PlayerReplicationInfo PRI;
    local TeamInfo TI;
    
    if (WorldInfo.NetMode == ENetMode.NM_Client)
    {
        ServerName = "";
        MessageOfTheDay = "";
    }
    SetTimer(WorldInfo.TimeDilation, TRUE, , );
    WorldInfo.GRI = Self;
    InitializeGameDataStore();
    foreach DynamicActors(Class'PlayerReplicationInfo', PRI, )
    {
        AddPRI(PRI);
    }
    foreach DynamicActors(Class'TeamInfo', TI, )
    {
        if (TI.TeamIndex >= 0)
        {
            SetTeam(TI.TeamIndex, TI);
        }
    }
}
public event simulated function ReplicatedDataBinding(Name VarName)
{
    Super(Actor).ReplicatedDataBinding(VarName);
    if (CurrentGameData != None)
    {
        CurrentGameData.RefreshSubscribers(VarName, TRUE, CurrentGameData);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bMatchHasBegun')
    {
        if (bMatchHasBegun)
        {
            WorldInfo.NotifyMatchStarted();
        }
    }
    else if (VarName == 'bMatchIsOver')
    {
        if (bMatchIsOver)
        {
            EndGame();
        }
    }
    else if (VarName == 'GameClass')
    {
        ReceivedGameClass();
    }
    else
    {
        Super(Actor).ReplicatedEvent(VarName);
    }
}
public function Reset()
{
    Super(Actor).Reset();
    Winner = None;
}
public simulated function SetTeam(int Index, TeamInfo TI)
{
    if (Index >= 0)
    {
        if (CurrentGameData == None)
        {
            InitializeGameDataStore();
        }
        if (CurrentGameData != None)
        {
            if (Index < Teams.Length && Teams[Index] != None)
            {
                CurrentGameData.RemoveTeamDataProvider(Teams[Index]);
            }
            if (TI != None)
            {
                CurrentGameData.AddTeamDataProvider(TI);
            }
        }
        Teams[Index] = TI;
    }
}
public event simulated function bool ShouldShowGore()
{
    return TRUE;
}
public event simulated function Timer()
{
    if (WorldInfo.Game == None || WorldInfo.Game.MatchIsInProgress())
    {
        ElapsedTime++;
    }
    if (WorldInfo.NetMode == ENetMode.NM_Client)
    {
        if (RemainingMinute != 0)
        {
            RemainingTime = RemainingMinute;
            RemainingMinute = 0;
        }
    }
    if (RemainingTime > 0 && !bStopCountDown)
    {
        RemainingTime--;
        if (WorldInfo.NetMode != ENetMode.NM_Client)
        {
            if (RemainingTime %  60 == 0)
            {
                RemainingMinute = RemainingTime;
            }
        }
    }
    if (CurrentGameData != None)
    {
        CurrentGameData.Timer();
    }
    SetTimer(WorldInfo.TimeDilation, TRUE, , );
}
public simulated function AddPRI(PlayerReplicationInfo PRI)
{
    local int i;
    
    if (!PRI.bIsInactive)
    {
        for (i = 0; i < PRIArray.Length; i++)
        {
            if (PRIArray[i] == PRI)
            {
                return;
            }
        }
        PRIArray[PRIArray.Length] = PRI;
    }
    else if (InactivePRIArray.Find(PRI) == -1)
    {
        InactivePRIArray[InactivePRIArray.Length] = PRI;
    }
    if (CurrentGameData == None)
    {
        InitializeGameDataStore();
    }
    if (CurrentGameData != None)
    {
        CurrentGameData.AddPlayerDataProvider(PRI);
    }
}
public simulated function CleanupGameDataStore()
{
    if (CurrentGameData != None)
    {
        CurrentGameData.ClearDataProviders();
    }
    CurrentGameData = None;
}
public simulated function EndGame()
{
    bMatchIsOver = TRUE;
}
public simulated function PlayerReplicationInfo FindPlayerByID(int PlayerID)
{
    local int i;
    
    for (i = 0; i < PRIArray.Length; i++)
    {
        if (PRIArray[i].PlayerID == PlayerID)
        {
            return PRIArray[i];
        }
    }
    return None;
}
public simulated function GetPRIArray(out array<PlayerReplicationInfo> pris)
{
    local int i;
    local int Num;
    
    pris.Remove(0, pris.Length);
    for (i = 0; i < PRIArray.Length; i++)
    {
        if (PRIArray[i] != None)
        {
            pris[Num++] = PRIArray[i];
        }
    }
}
public simulated function InitializeGameDataStore()
{
    local DataStoreClient DataStoreManager;
    
    DataStoreManager = Class'UIInteraction'.static.GetDataStoreClient();
    if (DataStoreManager != None)
    {
        CurrentGameData = CurrentGameDataStore(DataStoreManager.FindDataStore('CurrentGame'));
        if (CurrentGameData != None)
        {
            CurrentGameData.CreateGameDataProvider(Self);
        }
    }
}
public simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    local LocalPlayer LP1;
    local LocalPlayer LP2;
    
    if (P1.bOnlySpectator)
    {
        return P2.bOnlySpectator;
    }
    else if (P2.bOnlySpectator)
    {
        return TRUE;
    }
    if (P1.Score < P2.Score)
    {
        return FALSE;
    }
    if (P1.Score == P2.Score)
    {
        if (P1.Deaths > P2.Deaths)
        {
            return FALSE;
        }
        if (P1.Deaths == P2.Deaths && PlayerController(P2.Owner) != None)
        {
            LP2 = LocalPlayer(PlayerController(P2.Owner).Player);
            if (LP2 != None)
            {
                if (!Class'Engine'.static.IsSplitScreen() || LP2.ViewportClient.Outer.GamePlayers[0] == LP2)
                {
                    return FALSE;
                }
                LP1 = LocalPlayer(PlayerController(P2.Owner).Player);
                return LP1 != None;
            }
        }
    }
    return TRUE;
}
public simulated function bool IsCoopMultiplayerGame()
{
    return FALSE;
}
public simulated function bool IsMultiplayerGame()
{
    return WorldInfo.NetMode != ENetMode.NM_Standalone;
}
public simulated function ReceivedGameClass();

public simulated function RemovePRI(PlayerReplicationInfo PRI)
{
    local int i;
    
    for (i = 0; i < PRIArray.Length; i++)
    {
        if (PRIArray[i] == PRI)
        {
            if (CurrentGameData != None)
            {
                CurrentGameData.RemovePlayerDataProvider(PRI);
            }
            PRIArray.Remove(i, 1);
            return;
        }
    }
}
public simulated function SortPRIArray()
{
    local int i;
    local int J;
    local PlayerReplicationInfo P1;
    local PlayerReplicationInfo P2;
    
    for (i = 0; i < PRIArray.Length - 1; i++)
    {
        P1 = PRIArray[i];
        for (J = i + 1; J < PRIArray.Length; J++)
        {
            P2 = PRIArray[J];
            if (!InOrder(P1, P2))
            {
                PRIArray[i] = P2;
                PRIArray[J] = P1;
                P1 = P2;
            }
        }
    }
}
public simulated function StartMatch()
{
    bMatchHasBegun = TRUE;
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        Winner, bStopCountDown, bMatchHasBegun, bMatchIsOver;
    if (!bNetInitial && bNetDirty && Role == ENetRole.ROLE_Authority)
        RemainingMinute;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        ServerName, MessageOfTheDay, GameClass, RemainingTime, ElapsedTime, GoalScore, TimeLimit;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ServerName = "Another Server"
    bStopCountDown = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}
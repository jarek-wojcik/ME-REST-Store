Class GameInfo extends Info
    native
    config(Game);

struct native GameTypePrefix 
{
    var string Prefix;
    var string GameType;
    var array<string> AdditionalGameTypes;
    var array<string> ForcedObjects;
    var string OverrideCommonPackage;
    var bool bUsesCommonPackage;
    var bool bIsMultiplayer;
};
struct native GameClassShortName 
{
    var string ShortName;
    var string GameClassName;
};
enum EStandbyType
{
    STDBY_Rx,
    STDBY_Tx,
    STDBY_BadPing,
};

var string CauseEventCommand;
var string BugLocString;
var string BugRotString;
var array<PlayerController> PendingArbitrationPCs;
var array<PlayerController> ArbitrationPCs;
var const localized string DefaultPlayerName;
var const localized string GameName;
var array<PlayerReplicationInfo> InactivePRIArray;
var array<delegate<CanUnpause>> Pausers;
var string ServerOptions;
var(GameInfo) const config array<GameClassShortName> GameInfoClassAliases;
var config string DefaultGameType;
var config array<GameTypePrefix> DefaultMapPrefixes;
var config array<GameTypePrefix> CustomMapPrefixes;
var delegate<CanUnpause> __CanUnpause__Delegate;
var Class<Pawn> DefaultPawnClass;
var Class<Scoreboard> ScoreBoardType;
var Class<HUD> HUDType;
var Class<LocalMessage> DeathMessageClass;
var Class<GameMessage> GameMessageClass;
var Class<AccessControl> AccessControlClass;
var Class<BroadcastHandler> BroadcastHandlerClass;
var Class<AutoTestManager> AutoTestManagerClass;
var Class<PlayerController> PlayerControllerClass;
var Class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var(GameInfo) Class<GameReplicationInfo> GameReplicationInfoClass;
var Class<OnlineStatsWrite> OnlineStatsWriteClass;
var const Class<OnlineGameSettings> OnlineGameSettingsClass;
var OnlineGameInterface GameInterface;
var globalconfig float ArbitrationHandshakeTimeout;
var globalconfig float GameDifficulty;
var globalconfig int GoreLevel;
var float GameSpeed;
var globalconfig int MaxSpectators;
var int MaxSpectatorsAllowed;
var int NumSpectators;
var globalconfig int MaxPlayers;
var int MaxPlayersAllowed;
var int NumPlayers;
var int NumBots;
var int NumTravellingPlayers;
var int CurrentID;
var float FearCostFallOff;
var config int GoalScore;
var config int MaxLives;
var config int TimeLimit;
var Mutator BaseMutator;
var AccessControl AccessControl;
var BroadcastHandler BroadcastHandler;
var AutoTestManager MyAutoTestManager;
var GameReplicationInfo GameReplicationInfo;
var globalconfig float MaxIdleTime;
var globalconfig float MaxTimeMargin;
var globalconfig float TimeMarginSlack;
var globalconfig float MinTimeMargin;
var OnlineSubsystem OnlineSub;
var const int LeaderboardId;
var const int ArbitratedLeaderboardId;
var CoverReplicator CoverReplicatorBase;
var int AdjustedNetSpeed;
var float LastNetSpeedUpdateTime;
var globalconfig int TotalNetBandwidth;
var globalconfig int MinDynamicBandwidth;
var globalconfig int MaxDynamicBandwidth;
var config float StandbyRxCheatTime;
var config float StandbyTxCheatTime;
var config int BadPingThreshold;
var config float PercentMissingForRxStandby;
var config float PercentMissingForTxStandby;
var config float PercentForBadPing;
var bool bRestartLevel;
var bool bPauseable;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool bAlreadyChanged;
var globalconfig bool bAdminCanPause;
var bool bGameRestarted;
var bool bLevelChange;
var globalconfig bool bKickLiveIdlers;
var bool bUsingArbitration;
var bool bHasArbitratedHandshakeBegun;
var bool bNeedsEndGameHandshake;
var bool bIsEndGameHandshakeComplete;
var bool bHasEndGameHandshakeBegun;
var bool bFixedPlayerStart;
var bool bDoFearCostFallOff;
var bool bUseSeamlessTravel;
var bool bHasNetworkError;
var const bool bRequiresPushToTalk;
var config bool bIsStandbyCheckingEnabled;
var bool bHasStandbyCheatTriggered;

public event function AcceptInventory(Pawn PlayerPawn);

public event function AddDefaultInventory(Pawn P)
{
    P.AddDefaultInventory();
    if (P.InvManager == None)
    {
    }
}
public event function Broadcast(Actor Sender, coerce string Msg, optional Name Type)
{
    BroadcastHandler.Broadcast(Sender, Msg, Type);
}
public event function BroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    BroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public event function BroadcastLocalizedTeam(int TeamIndex, Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    BroadcastHandler.AllowBroadcastLocalizedTeam(TeamIndex, Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
public delegate function bool CanUnpause()
{
    return TRUE;
}
public event function ClearPause()
{
    local int Index;
    local delegate<CanUnpause> CanUnpauseCriteriaMet;
    
    if (!AllowPausing() && Pausers.Length > 0)
    {
        Pausers.Length = 0;
    }
    for (Index = 0; Index < Pausers.Length; Index++)
    {
        CanUnpauseCriteriaMet = Pausers[Index];
        if (CanUnpauseCriteriaMet())
        {
            Pausers.Remove(Index--, 1);
        }
    }
    if (Pausers.Length == 0)
    {
        WorldInfo.Pauser = None;
    }
}
public function DiscardInventory(Pawn Other, optional Controller Killer)
{
    if (Other.InvManager != None)
    {
        Other.InvManager.DiscardInventory();
    }
}
public final native function DoNavFearCostFallOff();

public native function EnableStandbyCheatDetection(bool bIsEnabled);

public function EndLogging(string Reason);

public function EndOnlineGame()
{
    local PlayerController PC;
    
    GameReplicationInfo.EndGame();
    if (GameInterface != None)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                PC.ClientEndOnlineGame();
            }
        }
        GameInterface.EndOnlineGame(PlayerReplicationInfoClass.default.SessionName);
    }
}
public final native function ForceClearUnpauseDelegates(Actor PauseActor);

public event function ForceKickPlayer(PlayerController PC, string KickReason)
{
    AccessControl.ForceKickPlayer(PC, KickReason);
}
public event function GameEnding()
{
    EndLogging("serverquit");
}
public static event function string GetDefaultGameClassPath(string MapName, string Options, string Portal)
{
    return PathName(default.Class);
}
public native function bool GetMapCommonPackageName(const out string InFilename, out string OutCommonPackageName);

public native function string GetNetworkNumber();

public final native function int GetNextPlayerID();

public event function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    local int i;
    
    for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
    {
        WorldInfo.GRI.PRIArray[i].bFromPreviousLevel = TRUE;
        ActorList[ActorList.Length] = WorldInfo.GRI.PRIArray[i];
    }
    if (bToEntry)
    {
        ActorList[ActorList.Length] = WorldInfo.GRI;
        if (BroadcastHandler != None)
        {
            ActorList[ActorList.Length] = BroadcastHandler;
        }
    }
    if (BaseMutator != None)
    {
        BaseMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
    }
}
public native function bool GetSupportedGameTypes(const out string InFilename, out GameTypePrefix OutGameType, optional bool bCheckExt = FALSE);

public event function HandleSeamlessTravelPlayer(out Controller C)
{
    local Rotator StartRotation;
    local NavigationPoint StartSpot;
    local PlayerController PC;
    local PlayerController NewPC;
    local PlayerReplicationInfo OldPRI;
    
    PC = PlayerController(C);
    if (PC != None && PC.Class != PlayerControllerClass)
    {
        if (PC.Player != None)
        {
            NewPC = SpawnPlayerController(PC.location, PC.Rotation);
            if (NewPC == None)
            {
                PC.Destroy();
                return;
            }
            else
            {
                PC.CleanUpAudioComponents();
                PC.SeamlessTravelTo(NewPC);
                NewPC.SeamlessTravelFrom(PC);
                SwapPlayerControllers(PC, NewPC);
                PC = NewPC;
                C = NewPC;
            }
        }
        else
        {
            PC.Destroy();
        }
    }
    else
    {
        C.PlayerReplicationInfo.Reset();
        OldPRI = C.PlayerReplicationInfo;
        C.InitPlayerReplicationInfo();
        OldPRI.SeamlessTravelTo(C.PlayerReplicationInfo);
        OldPRI.Destroy();
    }
    if (!bTeamGame && C.PlayerReplicationInfo.Team != None)
    {
        C.PlayerReplicationInfo.Team.Destroy();
        C.PlayerReplicationInfo.Team = None;
    }
    StartSpot = FindPlayerStart(C, C.GetTeamNum());
    if (StartSpot == None)
    {
    }
    else
    {
        StartRotation.Yaw = StartSpot.Rotation.Yaw;
        C.SetLocation(StartSpot.location, );
        C.SetRotation(StartRotation);
    }
    C.StartSpot = StartSpot;
    if (PC != None)
    {
        PC.CleanUpAudioComponents();
        PC.ClientInitializeDataStores();
        SetSeamlessTravelViewTarget(PC);
        if (PC.PlayerReplicationInfo.bOnlySpectator)
        {
            PC.GotoState('Spectating', , , );
            PC.PlayerReplicationInfo.bIsSpectator = TRUE;
            PC.PlayerReplicationInfo.bOutOfLives = TRUE;
            NumSpectators++;
        }
        else
        {
            NumPlayers++;
            NumTravellingPlayers--;
            PC.GotoState('PlayerWaiting', , , );
        }
    }
    else
    {
        NumBots++;
        C.GotoState('RoundEnded', , , );
    }
    GenericPlayerInitialization(C);
}
public event function InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;
    local string LeftOpt;
    local int pos;
    local Class<AccessControl> ACClass;
    local OnlineGameSettings GameSettings;
    
    MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, MaxPlayersAllowed);
    MaxSpectators = Clamp(GetIntOption(Options, "MaxSpectators", MaxSpectators), 0, MaxSpectatorsAllowed);
    GameDifficulty = FMax(0.0, float(GetIntOption(Options, "Difficulty", int(GameDifficulty))));
    InOpt = ParseOption(Options, "GameSpeed");
    if (InOpt != "")
    {
        SetGameSpeed(float(InOpt));
    }
    TimeLimit = Max(0, GetIntOption(Options, "TimeLimit", TimeLimit));
    BroadcastHandler = Spawn(BroadcastHandlerClass);
    InOpt = ParseOption(Options, "AccessControl");
    if (InOpt != "")
    {
        ACClass = Class<AccessControl>(DynamicLoadObject(InOpt, Class'Class'));
    }
    if (ACClass == None)
    {
        ACClass = AccessControlClass;
    }
    LeftOpt = ParseOption(Options, "AdminName");
    InOpt = ParseOption(Options, "AdminPassword");
    if (WorldInfo.NetMode == ENetMode.NM_ListenServer || WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        AccessControl = Spawn(ACClass);
        if (AccessControl != None && InOpt != "")
        {
            AccessControl.SetAdminPassword(InOpt);
        }
    }
    InOpt = ParseOption(Options, "Mutator");
    if (InOpt != "")
    {
        for (; InOpt != ""; AddMutator(LeftOpt, TRUE))
        {
            pos = InStr(InOpt, ",", , , );
            if (pos > 0)
            {
                LeftOpt = Left(InOpt, pos);
                InOpt = Right(InOpt, Len(InOpt) - pos - 1);
                continue;
            }
            LeftOpt = InOpt;
            InOpt = "";
        }
    }
    InOpt = ParseOption(Options, "GamePassword");
    if (InOpt != "" && AccessControl != None)
    {
        AccessControl.SetGamePassword(InOpt);
    }
    bFixedPlayerStart = ParseOption(Options, "FixedPlayerStart") ~= "1";
    CauseEventCommand = ParseOption(Options, "causeevent");
    if (ParseOption(Options, "AutoTests") ~= "1")
    {
        if (MyAutoTestManager == None)
        {
            MyAutoTestManager = Spawn(AutoTestManagerClass);
        }
        MyAutoTestManager.InitializeOptions(Options);
    }
    BugLocString = ParseOption(Options, "BugLoc");
    BugRotString = ParseOption(Options, "BugRot");
    if (BaseMutator != None)
    {
        BaseMutator.InitMutator(Options, ErrorMessage);
    }
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
            if (GameSettings != None)
            {
                bUsingArbitration = GameSettings.bUsesArbitration;
            }
        }
    }
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && GameSettings == None)
    {
        ServerOptions = Options;
        if (ProcessServerLogin() == FALSE)
        {
            RegisterServer();
        }
    }
}
public event function KickIdler(PlayerController PC)
{
    AccessControl.KickPlayer(PC, AccessControl.IdleKickReason);
}
public event function PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    local NavigationPoint StartSpot;
    local PlayerController NewPlayer;
    local string InName;
    local string InCharacter;
    local string InPassword;
    local byte InTeam;
    local bool bSpectator;
    local bool bAdmin;
    local bool bPerfTesting;
    local Rotator SpawnRotation;
    local OnlineGameSettings GameSettings;
    local UniqueNetId ZeroId;
    
    bAdmin = FALSE;
    if (bUsingArbitration && bHasArbitratedHandshakeBegun)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
        return None;
    }
    if (BaseMutator != None)
    {
        BaseMutator.ModifyLogin(Portal, Options);
    }
    bPerfTesting = ParseOption(Options, "AutomatedPerfTesting") ~= "1";
    bSpectator = bPerfTesting || ParseOption(Options, "SpectatorOnly") ~= "1";
    InName = Left(ParseOption(Options, "Name"), 20);
    InTeam = byte(GetIntOption(Options, "Team", 255));
    InPassword = ParseOption(Options, "Password");
    if (AccessControl != None)
    {
        bAdmin = AccessControl.ParseAdminOptions(Options);
    }
    if (!bAdmin && AtCapacity(bSpectator))
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".MaxedOutMessage";
        return None;
    }
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    if (WorldInfo.Game.AccessControl != None && WorldInfo.Game.AccessControl.IsIDBanned(UniqueId))
    {
        ErrorMessage = "Engine.AccessControl.SessionBanned";
        return None;
    }
    else if (WorldInfo.IsConsoleBuild() && GameSettings != None && !GameSettings.bIsLanMatch && UniqueId == ZeroId)
    {
        ErrorMessage = "Engine.AccessControl.SessionBanned";
        return None;
    }
    if (bAdmin && AtCapacity(FALSE))
    {
        bSpectator = TRUE;
    }
    InTeam = PickTeam(InTeam, None);
    StartSpot = FindPlayerStart(None, InTeam, Portal);
    if (StartSpot == None)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedPlaceMessage";
        return None;
    }
    SpawnRotation.Yaw = StartSpot.Rotation.Yaw;
    NewPlayer = SpawnPlayerController(StartSpot.location, SpawnRotation);
    if (NewPlayer == None)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".FailedSpawnMessage";
        return None;
    }
    NewPlayer.StartSpot = StartSpot;
    NewPlayer.PlayerReplicationInfo.PlayerID = GetNextPlayerID();
    NewPlayer.PlayerReplicationInfo.SetUniqueId(UniqueId);
    if (OnlineSub != None && OnlineSub.GameInterface != None)
    {
        WorldInfo.Game.OnlineSub.GameInterface.RegisterPlayer(PlayerReplicationInfoClass.default.SessionName, UniqueId, HasOption(Options, "bIsFromInvite"));
    }
    RecalculateSkillRating();
    if (InName == "")
    {
        InName = DefaultPlayerName $ NewPlayer.PlayerReplicationInfo.PlayerID;
    }
    ChangeName(NewPlayer, InName, FALSE);
    InCharacter = ParseOption(Options, "Character");
    NewPlayer.SetCharacter(InCharacter);
    if (bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator || !ChangeTeam(NewPlayer, int(InTeam), FALSE))
    {
        NewPlayer.GotoState('Spectating', , , );
        NewPlayer.PlayerReplicationInfo.bOnlySpectator = TRUE;
        NewPlayer.PlayerReplicationInfo.bIsSpectator = TRUE;
        NewPlayer.PlayerReplicationInfo.bOutOfLives = TRUE;
        return NewPlayer;
    }
    if (AccessControl != None && AccessControl.AdminLogin(NewPlayer, InPassword))
    {
        AccessControl.AdminEntered(NewPlayer);
    }
    if (bDelayedStart)
    {
        NewPlayer.GotoState('PlayerWaiting', , , );
        return NewPlayer;
    }
    return NewPlayer;
}
public function Logout(Controller Exiting)
{
    local PlayerController PC;
    local int PCIndex;
    
    PC = PlayerController(Exiting);
    if (PC != None)
    {
        if (AccessControl != None && AccessControl.AdminLogout(PlayerController(Exiting)))
        {
            AccessControl.AdminExited(PlayerController(Exiting));
        }
        if (PC.PlayerReplicationInfo.bOnlySpectator)
        {
            NumSpectators--;
        }
        else
        {
            if (WorldInfo.IsInSeamlessTravel() || PC.HasClientLoadedCurrentWorld())
            {
                NumPlayers--;
            }
            else
            {
                NumTravellingPlayers--;
            }
            UpdateGameSettingsCounts();
        }
        if (bUsingArbitration && bHasArbitratedHandshakeBegun && !bHasEndGameHandshakeBegun)
        {
        }
        UnregisterPlayer(PC);
        if (bUsingArbitration)
        {
            PCIndex = ArbitrationPCs.Find(PC);
            if (PCIndex != -1)
            {
                ArbitrationPCs.Remove(PCIndex, 1);
            }
        }
    }
    if (BaseMutator != None)
    {
        BaseMutator.NotifyLogout(Exiting);
    }
    UpdateNetSpeeds();
}
public event function MatineeCancelled();

public event function NotifyPendingConnectionLost();

public function OnLoginChange(byte LocalUserNum)
{
    ClearAutoLoginDelegates();
    RegisterServer();
}
public function OnLoginFailed(byte LocalUserNum, EOnlineServerConnectionStatus errorCode)
{
    ClearAutoLoginDelegates();
}
public function OnStartOnlineGameComplete(Name SessionName, bool bWasSuccessful)
{
    local PlayerController PC;
    local string StatGuid;
    
    GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
    if (bWasSuccessful && OnlineSub.StatsInterface != None)
    {
        StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
        if (StatGuid != "")
        {
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController() == FALSE)
                {
                    PC.ClientRegisterHostStatGuid(StatGuid);
                }
            }
        }
    }
    GameReplicationInfo.StartMatch();
}
public event function PostBeginPlay()
{
    if (MaxIdleTime > float(0))
    {
        MaxIdleTime = FMax(MaxIdleTime, 20.0);
    }
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        UpdateGameSettings();
    }
}
public event function PostCommitMapChange();

public event function PostLogin(PlayerController NewPlayer)
{
    local string Address;
    local string StatGuid;
    local int pos;
    local int i;
    local Sequence GameSeq;
    local array<SequenceObject> AllInterpActions;
    
    if (NewPlayer.PlayerReplicationInfo.bOnlySpectator)
    {
        NumSpectators++;
    }
    else if (WorldInfo.IsInSeamlessTravel() || NewPlayer.HasClientLoadedCurrentWorld())
    {
        NumPlayers++;
    }
    else
    {
        NumTravellingPlayers++;
    }
    UpdateGameSettingsCounts();
    Address = NewPlayer.GetPlayerNetworkAddress();
    pos = InStr(Address, ":", , , );
    NewPlayer.PlayerReplicationInfo.SavedNetworkAddress = pos > 0 ? Left(Address, pos) : Address;
    FindInactivePRI(NewPlayer);
    if (!bDelayedStart)
    {
        bRestartLevel = FALSE;
        if (bWaitingToStartMatch)
        {
            StartMatch();
        }
        else
        {
            RestartPlayer(NewPlayer);
        }
        bRestartLevel = default.bRestartLevel;
    }
    if (NewPlayer.Pawn != None)
    {
        NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
    }
    NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
    UpdateNetSpeeds();
    GenericPlayerInitialization(NewPlayer);
    if (GameReplicationInfo.bMatchHasBegun && OnlineSub != None && OnlineSub.StatsInterface != None)
    {
        StatGuid = OnlineSub.StatsInterface.GetHostStatGuid();
        if (StatGuid != "")
        {
            NewPlayer.ClientRegisterHostStatGuid(StatGuid);
        }
    }
    if (bRequiresPushToTalk)
    {
        NewPlayer.ClientStopNetworkedVoice();
    }
    else
    {
        NewPlayer.ClientStartNetworkedVoice();
    }
    if (NewPlayer.PlayerReplicationInfo.bOnlySpectator)
    {
        NewPlayer.ClientGotoState('Spectating');
    }
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != None)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqAct_Interp', TRUE, AllInterpActions);
        for (i = 0; i < AllInterpActions.Length; i++)
        {
            SeqAct_Interp(AllInterpActions[i]).AddPlayerToDirectorTracks(NewPlayer);
        }
    }
}
public event function PostSeamlessTravel()
{
    local Controller C;
    
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        if (C.bIsPlayer)
        {
            if (PlayerController(C) == None)
            {
                HandleSeamlessTravelPlayer(C);
            }
            else
            {
                if (!C.PlayerReplicationInfo.bOnlySpectator)
                {
                    NumTravellingPlayers++;
                }
                if (PlayerController(C).HasClientLoadedCurrentWorld())
                {
                    HandleSeamlessTravelPlayer(C);
                }
            }
        }
    }
    if (bWaitingToStartMatch && !bDelayedStart && NumPlayers + NumBots > 0)
    {
        StartMatch();
    }
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer)
    {
        UpdateGameSettings();
    }
}
public event function PreBeginPlay()
{
    AdjustedNetSpeed = MaxDynamicBandwidth;
    SetGameSpeed(GameSpeed);
    GameReplicationInfo = Spawn(GameReplicationInfoClass);
    WorldInfo.GRI = GameReplicationInfo;
    InitGameReplicationInfo();
}
public event function PreCommitMapChange(string PreviousMapName, string NextMapName);

public event function PreExit();

public event function PreLogin(string Options, string Address, out string ErrorMessage)
{
    local bool bSpectator;
    local bool bPerfTesting;
    
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && bUsingArbitration && bHasArbitratedHandshakeBegun)
    {
        ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
        return;
    }
    bPerfTesting = ParseOption(Options, "AutomatedPerfTesting") ~= "1";
    bSpectator = bPerfTesting || ParseOption(Options, "SpectatorOnly") ~= "1";
    if (AccessControl != None)
    {
        AccessControl.PreLogin(Options, Address, ErrorMessage, bSpectator);
    }
}
public function Reset()
{
    Super(Actor).Reset();
    bGameEnded = FALSE;
    bOverTime = FALSE;
    InitGameReplicationInfo();
}
public function RestartGame()
{
    local string NextMap;
    local string TransitionMapCmdLine;
    local string URLString;
    local int URLMapLen;
    local int MapNameLen;
    
    if (bUsingArbitration)
    {
        if (bIsEndGameHandshakeComplete)
        {
            NotifyArbitratedMatchEnd();
        }
        return;
    }
    if (BaseMutator != None && BaseMutator.HandleRestartGame())
    {
        return;
    }
    if (bGameRestarted)
    {
        return;
    }
    bGameRestarted = TRUE;
    if (bChangeLevels && !bAlreadyChanged)
    {
        bAlreadyChanged = TRUE;
        if (MyAutoTestManager != None && MyAutoTestManager.bUsingAutomatedTestingMapList)
        {
            NextMap = MyAutoTestManager.GetNextAutomatedTestingMap();
        }
        else
        {
            NextMap = GetNextMap();
        }
        if (NextMap != "")
        {
            if (MyAutoTestManager == None || !MyAutoTestManager.bUsingAutomatedTestingMapList)
            {
                WorldInfo.ServerTravel(NextMap, GetTravelType());
            }
            else if (!MyAutoTestManager.bAutomatedTestingWithOpen)
            {
                URLString = WorldInfo.GetLocalURL();
                URLMapLen = Len(URLString);
                MapNameLen = InStr(URLString, "?", , , );
                if (MapNameLen != -1)
                {
                    URLString = Right(URLString, URLMapLen - MapNameLen);
                }
                TransitionMapCmdLine = NextMap $ URLString $ "?AutomatedTestingMapIndex=" $ MyAutoTestManager.AutomatedTestingMapIndex;
                WorldInfo.ServerTravel(TransitionMapCmdLine, GetTravelType());
            }
            else
            {
                TransitionMapCmdLine = "?AutomatedTestingMapIndex=" $ MyAutoTestManager.AutomatedTestingMapIndex $ "?NumberOfMatchesPlayed=" $ MyAutoTestManager.NumberOfMatchesPlayed $ "?NumMapListCyclesDone=" $ MyAutoTestManager.NumMapListCyclesDone;
                ConsoleCommand("open " $ NextMap $ TransitionMapCmdLine);
            }
            return;
        }
    }
    WorldInfo.ServerTravel("?Restart", GetTravelType());
}
public static event function Class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.Class;
}
public event function StandbyCheatDetected(EStandbyType StandbyType);

public function StartOnlineGame()
{
    local PlayerController PC;
    
    if (GameInterface != None)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (!PC.IsLocalPlayerController())
            {
                PC.ClientStartOnlineGame();
            }
        }
        GameInterface.AddStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);
        GameInterface.StartOnlineGame(PlayerReplicationInfoClass.default.SessionName);
    }
    else
    {
        GameReplicationInfo.StartMatch();
    }
}
public final native function SwapPlayerControllers(PlayerController OldPC, PlayerController NewPC);

public event function Timer()
{
    BroadcastHandler.UpdateSentText();
    if (bDoFearCostFallOff)
    {
        DoNavFearCostFallOff();
    }
}
public function UnregisterPlayer(PlayerController PC)
{
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && GameInterface != None && GameInterface.GetGameSettings(PC.PlayerReplicationInfo.SessionName) != None)
    {
        GameInterface.UnregisterPlayer(PC.PlayerReplicationInfo.SessionName, PC.PlayerReplicationInfo.UniqueId);
    }
}
public function WriteOnlineStats()
{
    local PlayerController PC;
    local OnlineGameSettings CurrentSettings;
    
    if (GameInterface != None)
    {
        CurrentSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
        if (CurrentSettings == None || CurrentSettings != None && CurrentSettings.bUsesStats)
        {
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController() == FALSE)
                {
                    PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
                }
            }
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (PC.IsLocalPlayerController())
                {
                    PC.ClientWriteLeaderboardStats(OnlineStatsWriteClass);
                }
            }
        }
    }
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("Game:" $ GameName);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (WorldInfo.PopulationManager != None)
    {
        WorldInfo.PopulationManager.DisplayDebug(HUD, out_YL, out_YPos);
    }
}
public function AddInactivePRI(PlayerReplicationInfo PRI, PlayerController PC)
{
    local int i;
    local PlayerReplicationInfo NewPRI;
    local PlayerReplicationInfo CurrentPRI;
    local bool bIsConsole;
    
    if (!PRI.bFromPreviousLevel && !PRI.bOnlySpectator)
    {
        NewPRI = PRI.Duplicate();
        WorldInfo.GRI.RemovePRI(NewPRI);
        NewPRI.RemoteRole = ENetRole.ROLE_None;
        NewPRI.LifeSpan = 300.0;
        bIsConsole = WorldInfo.IsConsoleBuild();
        for (i = 0; i < InactivePRIArray.Length; i++)
        {
            CurrentPRI = InactivePRIArray[i];
            if (CurrentPRI == None || CurrentPRI.bDeleteMe || !bIsConsole && CurrentPRI.SavedNetworkAddress == NewPRI.SavedNetworkAddress || bIsConsole && Class'OnlineSubsystem'.static.AreUniqueNetIdsEqual(CurrentPRI.UniqueId, NewPRI.UniqueId))
            {
                InactivePRIArray.Remove(i, 1);
                i--;
            }
        }
        InactivePRIArray[InactivePRIArray.Length] = NewPRI;
        if (InactivePRIArray.Length > 16)
        {
            InactivePRIArray.Remove(0, InactivePRIArray.Length - 16);
        }
    }
    PRI.Destroy();
    RecalculateSkillRating();
}
public function AddMutator(string mutname, optional bool bUserAdded)
{
    local Class<Mutator> mutClass;
    local Mutator mut;
    local int i;
    
    if (!AllowMutator(mutname))
    {
        return;
    }
    mutClass = Class<Mutator>(DynamicLoadObject(mutname, Class'Class'));
    if (mutClass == None)
    {
        return;
    }
    if (mutClass.default.GroupNames.Length > 0 && BaseMutator != None)
    {
        mut = BaseMutator;
        while (mut != None)
        {
            for (i = 0; i < mut.GroupNames.Length; i++)
            {
                if (mutClass.default.GroupNames.Find(mut.GroupNames[i]) != -1)
                {
                    return;
                }
            }
            mut = mut.NextMutator;
        }
    }
    mut = BaseMutator;
    while (mut != None)
    {
        if (mut.Class == mutClass)
        {
            return;
        }
        mut = mut.NextMutator;
    }
    mut = Spawn(mutClass);
    if (mut == None)
    {
        return;
    }
    mut.bUserAdded = bUserAdded;
    if (BaseMutator == None)
    {
        BaseMutator = mut;
    }
    else
    {
        BaseMutator.AddMutator(mut);
    }
}
public function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
    if (Scorer != None)
    {
        Scorer.Score += float(Score);
    }
    if (BaseMutator != None)
    {
        BaseMutator.ScoreObjective(Scorer, Score);
    }
}
public function bool AllowCheats(PlayerController P)
{
    return WorldInfo.NetMode == ENetMode.NM_Standalone;
}
public static function bool AllowMutator(string MutatorClassName)
{
    return !Class'WorldInfo'.static.IsDemoBuild();
}
public function bool AllowPausing(optional PlayerController PC)
{
    return bPauseable || WorldInfo.NetMode == ENetMode.NM_Standalone || bAdminCanPause && AccessControl.IsAdmin(PC);
}
public function ArbitrationRegistrationComplete(Name SessionName, bool bWasSuccessful);

public function bool AtCapacity(bool bSpectator)
{
    if (WorldInfo.NetMode == ENetMode.NM_Standalone)
    {
        return FALSE;
    }
    if (bSpectator)
    {
        return NumSpectators >= MaxSpectators && (WorldInfo.NetMode != ENetMode.NM_ListenServer || NumPlayers > 0);
    }
    else
    {
        return MaxPlayers > 0 && GetNumPlayers() >= MaxPlayers;
    }
}
public exec simulated function BeginBVT(optional coerce string TagDesc)
{
    if (MyAutoTestManager == None)
    {
        MyAutoTestManager = Spawn(AutoTestManagerClass);
    }
    MyAutoTestManager.BeginSentinelRun("BVT", "", TagDesc);
    MyAutoTestManager.SetTimer(3.0, TRUE, 'DoTimeBasedSentinelStatGathering', );
}
public function BroadcastDeathMessage(Controller Killer, Controller Other, Class<DamageType> DamageType)
{
    if (Killer == Other || Killer == None)
    {
        BroadcastLocalized(Self, DeathMessageClass, 1, None, Other.PlayerReplicationInfo, DamageType);
    }
    else
    {
        BroadcastLocalized(Self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
    }
}
public function BroadcastTeam(Controller Sender, coerce string Msg, optional Name Type)
{
    BroadcastHandler.BroadcastTeam(Sender, Msg, Type);
}
public function int CalculatedNetSpeed()
{
    return Clamp(TotalNetBandwidth / Max(NumPlayers, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
}
public function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator == None)
    {
        return TRUE;
    }
    return BaseMutator.CanLeaveVehicle(V, P);
}
public function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    return TRUE;
}
public function ChangeName(Controller Other, coerce string S, bool bNameChange)
{
    if (S == "")
    {
        return;
    }
    Other.PlayerReplicationInfo.SetPlayerName(S);
}
public function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    return TRUE;
}
public function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    
    if (CheckModifiedEndGame(Winner, Reason))
    {
        return FALSE;
    }
    foreach WorldInfo.AllControllers(Class'Controller', P)
    {
        P.GameHasEnded();
    }
    return TRUE;
}
public function bool CheckForSentinelRun()
{
    return MyAutoTestManager != None && MyAutoTestManager.CheckForSentinelRun();
}
public function bool CheckModifiedEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return BaseMutator != None && !BaseMutator.CheckEndGame(Winner, Reason);
}
public function bool CheckRelevance(Actor Other)
{
    if (BaseMutator == None)
    {
        return TRUE;
    }
    return BaseMutator.CheckRelevance(Other);
}
public function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return TRUE;
}
public function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart P;
    local PlayerStart BestStart;
    local float BestRating;
    local float NewRating;
    local byte Team;
    
    Team = Player != None && Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.Team != None ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam;
    foreach WorldInfo.AllNavigationPoints(Class'PlayerStart', P)
    {
        NewRating = RatePlayerStart(P, Team, Player);
        if (NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
    }
    return BestStart;
}
public function ClearAutoLoginDelegates()
{
    if (OnlineSub.PlayerInterface != None)
    {
        OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        OnlineSub.PlayerInterface.ClearLoginFailedDelegate(0, OnLoginFailed);
    }
}
public function DebugPause()
{
    local int Index;
    local delegate<CanUnpause> CanUnpauseCriteriaMet;
    
    for (Index = 0; Index < Pausers.Length; Index++)
    {
        CanUnpauseCriteriaMet = Pausers[Index];
        if (CanUnpauseCriteriaMet())
        {
            continue;
        }
    }
}
public exec function DoTravelTheWorld()
{
    if (MyAutoTestManager != None)
    {
        GotoState('TravelTheWorld', , , );
        MyAutoTestManager.DoTravelTheWorld();
    }
}
public function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator != None)
    {
        BaseMutator.DriverEnteredVehicle(V, P);
    }
}
public function DriverLeftVehicle(Vehicle V, Pawn P)
{
    if (BaseMutator != None)
    {
        BaseMutator.DriverLeftVehicle(V, P);
    }
}
public function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    if (!CheckEndGame(Winner, Reason))
    {
        bOverTime = TRUE;
        return;
    }
    SetTimer(1.5, FALSE, 'PerformEndGameHandling', );
    bGameEnded = TRUE;
    EndLogging(Reason);
}
public function bool FindInactivePRI(PlayerController PC)
{
    local string NewNetworkAddress;
    local string NewName;
    local int i;
    local PlayerReplicationInfo OldPRI;
    local PlayerReplicationInfo CurrentPRI;
    local bool bIsConsole;
    
    if (PC.PlayerReplicationInfo.bOnlySpectator)
    {
        return FALSE;
    }
    bIsConsole = WorldInfo.IsConsoleBuild();
    NewNetworkAddress = PC.PlayerReplicationInfo.SavedNetworkAddress;
    NewName = PC.PlayerReplicationInfo.PlayerName;
    for (i = 0; i < InactivePRIArray.Length; i++)
    {
        CurrentPRI = InactivePRIArray[i];
        if (CurrentPRI == None || CurrentPRI.bDeleteMe)
        {
            InactivePRIArray.Remove(i, 1);
            i--;
            continue;
        }
        if (bIsConsole && Class'OnlineSubsystem'.static.AreUniqueNetIdsEqual(CurrentPRI.UniqueId, PC.PlayerReplicationInfo.UniqueId) || !bIsConsole && CurrentPRI.SavedNetworkAddress ~= NewNetworkAddress && CurrentPRI.PlayerName ~= NewName)
        {
            OldPRI = PC.PlayerReplicationInfo;
            PC.PlayerReplicationInfo = CurrentPRI;
            PC.PlayerReplicationInfo.SetOwner(PC);
            PC.PlayerReplicationInfo.RemoteRole = ENetRole.ROLE_SimulatedProxy;
            PC.PlayerReplicationInfo.LifeSpan = 0.0;
            OverridePRI(PC, OldPRI);
            WorldInfo.GRI.AddPRI(PC.PlayerReplicationInfo);
            InactivePRIArray.Remove(i, 1);
            OldPRI.bIsInactive = TRUE;
            OldPRI.Destroy();
            return TRUE;
        }
    }
    return FALSE;
}
public function string FindPlayerByID(int PlayerID)
{
    local PlayerReplicationInfo PRI;
    
    PRI = GameReplicationInfo.FindPlayerByID(PlayerID);
    if (PRI != None)
    {
        return PRI.PlayerName;
    }
    return "";
}
public function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint N;
    local NavigationPoint BestStart;
    local Teleporter Tel;
    
    if (BaseMutator != None)
    {
        N = BaseMutator.FindPlayerStart(Player, InTeam, IncomingName);
        if (N != None)
        {
            return N;
        }
    }
    if (IncomingName != "")
    {
        foreach WorldInfo.AllNavigationPoints(Class'Teleporter', Tel)
        {
            if (string(Tel.Tag) ~= IncomingName)
            {
                return Tel;
            }
        }
    }
    if (ShouldSpawnAtStartSpot(Player) && (PlayerStart(Player.StartSpot) == None || RatePlayerStart(PlayerStart(Player.StartSpot), InTeam, Player) >= 0.0))
    {
        return Player.StartSpot;
    }
    BestStart = ChoosePlayerStart(Player, InTeam);
    if (BestStart == None && Player == None)
    {
        foreach AllActors(Class'NavigationPoint', N, )
        {
            BestStart = N;
            break;
        }
    }
    return BestStart;
}
public function GenericPlayerInitialization(Controller C)
{
    local PlayerController PC;
    
    PC = PlayerController(C);
    if (PC != None)
    {
        UpdateGameplayMuteList(PC);
        PC.ClientSetHUD(HUDType, ScoreBoardType);
        ReplicateStreamingStatus(PC);
        if (CoverReplicatorBase != None)
        {
            PC.SpawnCoverReplicator();
        }
        PC.ClientSetOnlineStatus();
    }
    if (BaseMutator != None)
    {
        BaseMutator.NotifyLogin(C);
    }
}
public function CoverReplicator GetCoverReplicator()
{
    if (CoverReplicatorBase == None && WorldInfo.NetMode != ENetMode.NM_Standalone)
    {
        CoverReplicatorBase = Spawn(Class'CoverReplicator');
    }
    return CoverReplicatorBase;
}
public function Class<Pawn> GetDefaultPlayerClass(Controller C)
{
    return DefaultPawnClass;
}
public static function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
    local string InOpt;
    
    InOpt = ParseOption(Options, ParseString);
    if (InOpt != "")
    {
        return int(InOpt);
    }
    return CurrentValue;
}
public static function GetKeyValue(string Pair, out string Key, out string Value)
{
    if (InStr(Pair, "=", , , ) >= 0)
    {
        Key = Left(Pair, InStr(Pair, "=", , , ));
        Value = Mid(Pair, InStr(Pair, "=", , , ) + 1, );
    }
    else
    {
        Key = Pair;
        Value = "";
    }
}
public function string GetNextMap();

public function int GetNumPlayers()
{
    return NumPlayers + NumTravellingPlayers;
}
public function int GetServerPort()
{
    local string S;
    local int i;
    
    S = WorldInfo.GetAddressURL();
    i = InStr(S, ":", , , );
    assert(i >= 0);
    return int(Mid(S, i + 1, ));
}
public function bool GetTravelType()
{
    return FALSE;
}
public static function bool GrabOption(out string Options, out string Result)
{
    if (Left(Options, 1) == "?")
    {
        Result = Mid(Options, 1, );
        if (InStr(Result, "?", , , ) >= 0)
        {
            Result = Left(Result, InStr(Result, "?", , , ));
        }
        Options = Mid(Options, 1, );
        if (InStr(Options, "?", , , ) >= 0)
        {
            Options = Mid(Options, InStr(Options, "?", , , ), );
        }
        else
        {
            Options = "";
        }
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public static function bool HasOption(string Options, string InKey)
{
    local string Pair;
    local string Key;
    local string Value;
    
    while (GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        if (Key ~= InKey)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function InitGameReplicationInfo()
{
    GameReplicationInfo.GameClass = Class;
    GameReplicationInfo.ReceivedGameClass();
}
public function bool IsAutomatedPerfTesting()
{
    return MyAutoTestManager != None && MyAutoTestManager.bAutomatedPerfTesting;
}
public function bool IsCheckingForFragmentation()
{
    return MyAutoTestManager != None && MyAutoTestManager.bCheckingForFragmentation;
}
public function bool IsCheckingForMemLeaks()
{
    return MyAutoTestManager != None && MyAutoTestManager.bCheckingForMemLeaks;
}
public function bool IsDoingASentinelRun()
{
    return MyAutoTestManager != None && MyAutoTestManager.bDoingASentinelRun;
}
public function Kick(string S)
{
    if (AccessControl != None)
    {
        AccessControl.Kick(S);
    }
}
public function KickBan(string S)
{
    if (AccessControl != None)
    {
        AccessControl.KickBan(S);
    }
}
public exec function KillBots();

public function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, Class<DamageType> DamageType)
{
    if (KilledPlayer != None && KilledPlayer.bIsPlayer)
    {
        KilledPlayer.PlayerReplicationInfo.IncrementDeaths();
        KilledPlayer.PlayerReplicationInfo.SetNetUpdateTime(FMin(KilledPlayer.PlayerReplicationInfo.NetUpdateTime, WorldInfo.TimeSeconds + 0.300000012 * FRand()));
        BroadcastDeathMessage(Killer, KilledPlayer, DamageType);
    }
    if (KilledPlayer != None)
    {
        ScoreKill(Killer, KilledPlayer);
    }
    DiscardInventory(KilledPawn, Killer);
    NotifyKilled(Killer, KilledPlayer, KilledPawn);
}
public function bool MatchIsInProgress()
{
    return TRUE;
}
public function ModifyScoreKill(Controller Killer, Controller Other)
{
    if (BaseMutator != None)
    {
        BaseMutator.ScoreKill(Killer, Other);
    }
}
public function Mutate(string MutateString, PlayerController Sender)
{
    if (BaseMutator != None)
    {
        BaseMutator.Mutate(MutateString, Sender);
    }
}
public function NotifyArbitratedMatchEnd()
{
    local PlayerController PC;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (PC.IsLocalPlayerController() == FALSE)
        {
            PC.ClientArbitratedMatchEnded();
        }
    }
    foreach WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (PC.IsLocalPlayerController())
        {
            PC.ClientArbitratedMatchEnded();
        }
    }
}
public function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local Controller C;
    
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        C.NotifyKilled(Killer, Killed, KilledPawn);
    }
}
public function NotifyNavigationChanged(NavigationPoint N);

public function OnServerCreateComplete(Name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings GameSettings;
    
    GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
    if (!bWasSuccessful)
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
        if (GameSettings.bIsLanMatch == FALSE)
        {
            GameSettings.bIsLanMatch = TRUE;
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
            if (!GameInterface.CreateOnlineGame(0, SessionName, GameSettings))
            {
                GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
            }
        }
    }
    else
    {
        UpdateGameSettings();
    }
}
public function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
    PC.PlayerReplicationInfo.OverrideWith(OldPRI);
}
public static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage)
{
    return Repl(Repl(DeathMessage, "`k", KillerName, ), "`o", VictimName, );
}
public static function string ParseOption(string Options, string InKey)
{
    local string Pair;
    local string Key;
    local string Value;
    
    while (GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        if (Key ~= InKey)
        {
            return Value;
        }
    }
    return "";
}
public function PerformEndGameHandling()
{
    if (GameInterface != None)
    {
        WriteOnlineStats();
        WriteOnlinePlayerScores();
        EndOnlineGame();
        if (bUsingArbitration)
        {
            PendingArbitrationPCs.Length = 0;
            ArbitrationPCs.Length = 0;
            NotifyArbitratedMatchEnd();
        }
    }
}
public function byte PickTeam(byte Current, Controller C)
{
    return Current;
}
public function bool PickupQuery(Pawn Other, Class<Inventory> ItemClass, Actor Pickup)
{
    local byte bAllowPickup;
    
    if (BaseMutator != None && BaseMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup))
    {
        return bool(bAllowPickup);
    }
    if (Other.InvManager == None)
    {
        return FALSE;
    }
    else
    {
        return Other.InvManager.HandlePickupQuery(ItemClass, Pickup);
    }
}
public function bool PlayerCanRestart(PlayerController aPlayer)
{
    return TRUE;
}
public function bool PlayerCanRestartGame(PlayerController aPlayer)
{
    return TRUE;
}
public function bool PreventDeath(Pawn KilledPawn, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    if (BaseMutator == None)
    {
        return FALSE;
    }
    return BaseMutator.PreventDeath(KilledPawn, Killer, DamageType, HitLocation);
}
public function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful);

public function PlayerController ProcessClientTravel(out string URL, Guid NextMapGuid, bool bSeamless, bool bAbsolute)
{
    local PlayerController P;
    local PlayerController LP;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        if (NetConnection(P.Player) != None)
        {
            P.ClientTravel(URL, 2, bSeamless, NextMapGuid);
        }
        else
        {
            LP = P;
            P.PreClientTravel(URL, bAbsolute ? 0 : 2, bSeamless);
        }
    }
    return LP;
}
public function bool ProcessServerLogin()
{
    if (OnlineSub != None)
    {
        if (OnlineSub.PlayerInterface != None)
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            OnlineSub.PlayerInterface.AddLoginFailedDelegate(0, OnLoginFailed);
            if (OnlineSub.PlayerInterface.AutoLogin() == FALSE)
            {
                ClearAutoLoginDelegates();
                return FALSE;
            }
            return TRUE;
        }
    }
    return FALSE;
}
public function ProcessServerTravel(string URL, optional bool bAbsolute)
{
    local PlayerController LocalPlayer;
    local bool bSeamless;
    local string NextMap;
    local Guid NextMapGuid;
    local int OptionStart;
    
    bLevelChange = TRUE;
    EndLogging("mapchange");
    bSeamless = bUseSeamlessTravel && WorldInfo.TimeSeconds < 172800.0;
    if (InStr(Caps(URL), "?RESTART", , , ) != -1)
    {
        NextMap = string(WorldInfo.GetPackageName());
    }
    else
    {
        OptionStart = InStr(URL, "?", , , );
        if (OptionStart == -1)
        {
            NextMap = URL;
        }
        else
        {
            NextMap = Left(URL, OptionStart);
        }
    }
    NextMapGuid = GetPackageGuid(Name(NextMap));
    LocalPlayer = ProcessClientTravel(URL, NextMapGuid, bSeamless, bAbsolute);
    WorldInfo.NextURL = URL;
    if (WorldInfo.NetMode == ENetMode.NM_ListenServer && LocalPlayer != None)
    {
        WorldInfo.NextURL $= "?Team=" $ LocalPlayer.GetDefaultURL("Team") $ "?Name=" $ LocalPlayer.GetDefaultURL("Name") $ "?Class=" $ LocalPlayer.GetDefaultURL("Class") $ "?Character=" $ LocalPlayer.GetDefaultURL("Character");
    }
    if (bSeamless)
    {
        WorldInfo.SeamlessTravel(WorldInfo.NextURL, bAbsolute);
        WorldInfo.NextURL = "";
    }
    else if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && WorldInfo.NetMode != ENetMode.NM_ListenServer)
    {
        WorldInfo.NextSwitchCountdown = 0.0;
    }
}
public function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Rating;
    
    if (!P.bEnabled)
    {
        return 5.0;
    }
    else
    {
        Rating = 10.0;
        if (P.bPrimaryStart)
        {
            Rating += 10.0;
        }
        if (P.TeamIndex == int(Team))
        {
            Rating += 15.0;
        }
        return Rating;
    }
}
public function RecalculateSkillRating()
{
    local int Index;
    local array<UniqueNetId> Players;
    local UniqueNetId ZeroId;
    
    if (WorldInfo.NetMode != ENetMode.NM_Standalone && OnlineSub != None && OnlineSub.GameInterface != None)
    {
        for (Index = 0; Index < GameReplicationInfo.PRIArray.Length; Index++)
        {
            if (ZeroId != GameReplicationInfo.PRIArray[Index].UniqueId)
            {
                Players[Players.Length] = GameReplicationInfo.PRIArray[Index].UniqueId;
            }
        }
        if (Players.Length > 0)
        {
            OnlineSub.GameInterface.RecalculateSkillRating(PlayerReplicationInfoClass.default.SessionName, Players);
        }
    }
}
public function ReduceDamage(out int Damage, Pawn injured, Controller instigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
    local int OriginalDamage;
    
    OriginalDamage = Damage;
    if (injured.PhysicsVolume.bNeutralZone || injured.InGodMode())
    {
        Damage = 0;
        return;
    }
    else if (Damage > 0 && injured.InvManager != None)
    {
        injured.InvManager.ModifyDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
    }
    if (BaseMutator != None)
    {
        BaseMutator.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    }
}
public function RegisterServer()
{
    local OnlineGameSettings GameSettings;
    
    if (OnlineGameSettingsClass != None && OnlineSub != None && OnlineSub.GameInterface != None)
    {
        GameSettings = new OnlineGameSettingsClass;
        GameSettings.UpdateFromURL(ServerOptions, Self);
        OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
        if (!OnlineSub.GameInterface.CreateOnlineGame(0, PlayerReplicationInfoClass.default.SessionName, GameSettings))
        {
            OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(OnServerCreateComplete);
        }
    }
}
public function RegisterServerForArbitration();

public function RemoveMutator(Mutator MutatorToRemove)
{
    local Mutator M;
    
    if (BaseMutator == MutatorToRemove)
    {
        BaseMutator = MutatorToRemove.NextMutator;
    }
    else if (BaseMutator != None)
    {
        M = BaseMutator;
        while (M != None)
        {
            if (M.NextMutator == MutatorToRemove)
            {
                M.NextMutator = MutatorToRemove.NextMutator;
                break;
            }
            M = M.NextMutator;
        }
    }
}
public function ReplicateStreamingStatus(PlayerController PC)
{
    local int LevelIndex;
    local LevelStreaming TheLevel;
    
    if (LocalPlayer(PC.Player) == None && ChildConnection(PC.Player) == None)
    {
        if (WorldInfo.CommittedPersistentLevelName != 'None')
        {
            PC.ClientPrepareMapChange(WorldInfo.CommittedPersistentLevelName, TRUE, TRUE);
            PC.ClientCommitMapChange();
        }
        if (WorldInfo.StreamingLevels.Length > 0)
        {
            for (LevelIndex = 0; LevelIndex < WorldInfo.StreamingLevels.Length; LevelIndex++)
            {
                TheLevel = WorldInfo.StreamingLevels[LevelIndex];
                if (TheLevel != None)
                {
                    PC.ClientUpdateLevelStreamingStatus(TheLevel.PackageName, TheLevel.bShouldBeLoaded, TheLevel.bShouldBeVisible, TheLevel.bShouldBlockOnLoad);
                }
            }
            PC.ClientFlushLevelStreaming();
        }
        if (WorldInfo.PreparingLevelNames.Length > 0)
        {
            for (LevelIndex = 0; LevelIndex < WorldInfo.PreparingLevelNames.Length; LevelIndex++)
            {
                PC.ClientPrepareMapChange(WorldInfo.PreparingLevelNames[LevelIndex], LevelIndex == 0, LevelIndex == WorldInfo.PreparingLevelNames.Length - 1);
            }
        }
    }
}
public function bool RequiresPassword()
{
    return AccessControl != None && AccessControl.RequiresPassword();
}
public function ResetLevel()
{
    local Controller C;
    local Actor A;
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;
    local array<int> ActivateIndices;
    local int i;
    
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        if (PlayerController(C) != None)
        {
            PlayerController(C).ClientReset();
        }
        C.Reset();
    }
    foreach AllActors(Class'Actor', A, )
    {
        if (A != Self && !A.IsA('Controller') && ShouldReset(A))
        {
            A.Reset();
        }
    }
    Reset();
    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq != None)
    {
        GameSeq.Reset();
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_LevelLoaded', TRUE, AllSeqEvents);
        ActivateIndices[0] = 2;
        for (i = 0; i < AllSeqEvents.Length; i++)
        {
            SeqEvent_LevelLoaded(AllSeqEvents[i]).CheckActivate(WorldInfo, None, FALSE, ActivateIndices);
        }
    }
}
public function RestartPlayer(Controller NewPlayer)
{
    local NavigationPoint StartSpot;
    local int TeamNum;
    local int idx;
    local array<SequenceObject> Events;
    local SeqEvent_PlayerSpawned SpawnedEvent;
    
    if (bRestartLevel && WorldInfo.NetMode != ENetMode.NM_DedicatedServer && WorldInfo.NetMode != ENetMode.NM_ListenServer)
    {
        return;
    }
    TeamNum = NewPlayer.PlayerReplicationInfo == None || NewPlayer.PlayerReplicationInfo.Team == None ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex;
    StartSpot = FindPlayerStart(NewPlayer, byte(TeamNum));
    if (StartSpot == None)
    {
        if (NewPlayer.StartSpot != None)
        {
            StartSpot = NewPlayer.StartSpot;
        }
        else
        {
            return;
        }
    }
    NewPlayer.StartSpot = StartSpot;
    if (NewPlayer.Pawn == None)
    {
        NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
    }
    if (NewPlayer.Pawn == None)
    {
        NewPlayer.GotoState('Dead', , , );
        if (PlayerController(NewPlayer) != None)
        {
            PlayerController(NewPlayer).ClientGotoState('Dead', 'Begin');
        }
    }
    else
    {
        NewPlayer.Pawn.SetAnchor(StartSpot);
        if (PlayerController(NewPlayer) != None)
        {
            PlayerController(NewPlayer).TimeMargin = -0.100000001;
            StartSpot.AnchoredPawn = None;
        }
        NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
        NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
        NewPlayer.Possess(NewPlayer.Pawn, FALSE);
        NewPlayer.Pawn.PlayTeleportEffect(TRUE, TRUE);
        NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation, TRUE);
        if (!WorldInfo.bNoDefaultInventoryForPlayer)
        {
            AddDefaultInventory(NewPlayer.Pawn);
        }
        SetPlayerDefaults(NewPlayer.Pawn);
        if (WorldInfo.GetGameSequence() != None)
        {
            WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_PlayerSpawned', TRUE, Events);
            for (idx = 0; idx < Events.Length; idx++)
            {
                SpawnedEvent = SeqEvent_PlayerSpawned(Events[idx]);
                if (SpawnedEvent != None && SpawnedEvent.CheckActivate(NewPlayer, NewPlayer))
                {
                    SpawnedEvent.SpawnPoint = StartSpot;
                    SpawnedEvent.PopulateLinkedVariableValues();
                }
            }
        }
    }
}
public function ScoreKill(Controller Killer, Controller Other)
{
    if (Killer == Other || Killer == None)
    {
        if (Other != None && Other.PlayerReplicationInfo != None)
        {
            Other.PlayerReplicationInfo.Score -= float(1);
            Other.PlayerReplicationInfo.bForceNetUpdate = TRUE;
        }
    }
    else if (Killer.PlayerReplicationInfo != None)
    {
        Killer.PlayerReplicationInfo.Score += float(1);
        Killer.PlayerReplicationInfo.bForceNetUpdate = TRUE;
        Killer.PlayerReplicationInfo.Kills++;
    }
    ModifyScoreKill(Killer, Other);
    if (Killer != None || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
}
public function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    AddObjectiveScore(Scorer, Score);
    CheckScore(Scorer);
}
public function SendPlayer(PlayerController aPlayer, string URL)
{
    aPlayer.ClientTravel(URL, 2);
}
public function SetGameSpeed(float T)
{
    GameSpeed = FMax(T, 0.00000999999975);
    WorldInfo.TimeDilation = GameSpeed;
    SetTimer(WorldInfo.TimeDilation, TRUE, , );
}
public function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    local int FoundIndex;
    
    if (AllowPausing(PC))
    {
        FoundIndex = Pausers.Find(CanUnpauseDelegate);
        if (FoundIndex == -1)
        {
            FoundIndex = Pausers.Length;
            Pausers.Length = FoundIndex + 1;
            Pausers[FoundIndex] = CanUnpauseDelegate;
        }
        if (WorldInfo.Pauser == None)
        {
            WorldInfo.Pauser = PC.PlayerReplicationInfo;
        }
        return TRUE;
    }
    return FALSE;
}
public function SetPlayerDefaults(Pawn PlayerPawn)
{
    PlayerPawn.AirControl = PlayerPawn.default.AirControl;
    PlayerPawn.GroundSpeed = PlayerPawn.default.GroundSpeed;
    PlayerPawn.WaterSpeed = PlayerPawn.default.WaterSpeed;
    PlayerPawn.AirSpeed = PlayerPawn.default.AirSpeed;
    PlayerPawn.Acceleration = PlayerPawn.default.Acceleration;
    PlayerPawn.AccelRate = PlayerPawn.default.AccelRate;
    PlayerPawn.JumpZ = PlayerPawn.default.JumpZ;
    if (BaseMutator != None)
    {
        BaseMutator.ModifyPlayer(PlayerPawn);
    }
    PlayerPawn.PhysicsVolume.ModifyPlayer(PlayerPawn);
}
public function SetSeamlessTravelViewTarget(PlayerController PC)
{
    PC.SetViewTarget(PC);
}
public function bool ShouldAutoContinueToNextRound()
{
    return MyAutoTestManager != None && MyAutoTestManager.bAutoContinueToNextRound;
}
public function bool ShouldReset(Actor ActorToReset)
{
    return TRUE;
}
public function bool ShouldRespawn(PickupFactory Other)
{
    return WorldInfo.NetMode != ENetMode.NM_Standalone;
}
public function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return WorldInfo.NetMode == ENetMode.NM_Standalone && Player != None && Player.StartSpot != None && (bWaitingToStartMatch || Player.PlayerReplicationInfo != None && Player.PlayerReplicationInfo.bWaitingPlayer);
}
public function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot, optional bool bNoCollisionFail = FALSE)
{
    local Class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;
    
    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rotation.Yaw;
    ResultPawn = Spawn(DefaultPlayerClass, , , StartSpot.location, StartRotation, , bNoCollisionFail);
    if (ResultPawn == None)
    {
    }
    return ResultPawn;
}
public function PlayerController SpawnPlayerController(Vector SpawnLocation, Rotator SpawnRotation)
{
    return Spawn(PlayerControllerClass, , , SpawnLocation, SpawnRotation);
}
public function StartArbitratedMatch();

public function StartArbitrationRegistration();

public function StartBots()
{
    local Controller P;
    
    foreach WorldInfo.AllControllers(Class'Controller', P)
    {
        if (P.bIsPlayer && !P.IsA('PlayerController'))
        {
            if (WorldInfo.NetMode == ENetMode.NM_Standalone)
            {
                RestartPlayer(P);
            }
            else
            {
                P.GotoState('Dead', 'MPStart', , );
            }
        }
    }
}
public function StartHumans()
{
    local PlayerController P;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        if (P.Pawn == None)
        {
            if (bGameEnded)
            {
                return;
            }
            else if (P.CanRestartPlayer())
            {
                RestartPlayer(P);
            }
        }
    }
}
public function StartMatch()
{
    local Actor A;
    
    if (MyAutoTestManager != None)
    {
        MyAutoTestManager.StartMatch();
    }
    foreach AllActors(Class'Actor', A, )
    {
        A.MatchStarting();
    }
    StartHumans();
    StartBots();
    bWaitingToStartMatch = FALSE;
    StartOnlineGame();
    WorldInfo.NotifyMatchStarted();
}
public function TellClientsToReturnToPartyHost()
{
    local PlayerController PC;
    local OnlineGameSettings GameSettings;
    local UniqueNetId RequestingPlayerId;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
            if (GameSettings != None)
            {
                RequestingPlayerId = GameSettings.OwningPlayerId;
            }
            else
            {
                foreach LocalPlayerControllers(Class'PlayerController', PC)
                {
                    if (PC.IsPrimaryPlayer() && PC.PlayerReplicationInfo != None)
                    {
                        RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
                        break;
                    }
                }
            }
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (PC.IsPrimaryPlayer())
                {
                    PC.ClientReturnToParty(RequestingPlayerId);
                }
            }
        }
    }
}
public function TellClientsToTravelToSession(Name SessionName, Class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    local PlayerController PC;
    
    foreach WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
        {
            PC.ClientTravelToSession(SessionName, SearchClass, PlatformSpecificInfo);
        }
    }
}
public function UpdateGameplayMuteList(PlayerController PC)
{
    PC.bHasVoiceHandshakeCompleted = TRUE;
    PC.ClientVoiceHandshakeComplete();
}
public function UpdateGameSettings();

public function UpdateGameSettingsCounts()
{
    local OnlineGameSettings GameSettings;
    
    if (GameInterface != None)
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
        if (GameSettings != None && GameSettings.bIsLanMatch)
        {
            GameSettings.NumOpenPublicConnections = GameSettings.NumPublicConnections - GetNumPlayers();
            if (GameSettings.NumOpenPublicConnections < 0)
            {
                GameSettings.NumOpenPublicConnections = 0;
            }
        }
    }
}
public function UpdateNetSpeeds()
{
    local int NewNetSpeed;
    local PlayerController PC;
    local OnlineGameSettings GameSettings;
    
    if (GameInterface != None)
    {
        GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    if (WorldInfo.NetMode == ENetMode.NM_DedicatedServer || WorldInfo.NetMode == ENetMode.NM_Standalone || GameSettings != None && GameSettings.bIsLanMatch)
    {
        return;
    }
    if (WorldInfo.TimeSeconds - LastNetSpeedUpdateTime < 1.0)
    {
        SetTimer(1.0, FALSE, 'UpdateNetSpeeds', );
        return;
    }
    LastNetSpeedUpdateTime = WorldInfo.TimeSeconds;
    NewNetSpeed = CalculatedNetSpeed();
    if (AdjustedNetSpeed != NewNetSpeed)
    {
        AdjustedNetSpeed = NewNetSpeed;
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.SetNetSpeed(AdjustedNetSpeed);
        }
    }
}
public static function bool UseLowGore(WorldInfo WI)
{
    return default.GoreLevel > 0 && WI.NetMode != ENetMode.NM_DedicatedServer;
}
public function WriteOnlinePlayerScores()
{
    local PlayerController PC;
    
    if (bUsingArbitration)
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.ClientWriteOnlinePlayerScores(ArbitratedLeaderboardId);
        }
    }
    else
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (PC.IsLocalPlayerController())
            {
                PC.ClientWriteOnlinePlayerScores(LeaderboardId);
                break;
            }
        }
    }
}

state TravelTheWorld 
{
    
    stop;
};
auto state PendingMatch 
{
    public event function EndState(Name NextStateName)
    {
        SetTimer(0.0, FALSE, 'ArbitrationTimeout', );
        if (GameInterface != None)
        {
            GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
        }
    }
    public function ProcessClientRegistrationCompletion(PlayerController PC, bool bWasSuccessful)
    {
        local int FoundIndex;
        
        FoundIndex = PendingArbitrationPCs.Find(PC);
        if (FoundIndex != -1)
        {
            PendingArbitrationPCs.Remove(FoundIndex, 1);
            if (bWasSuccessful)
            {
                ArbitrationPCs[ArbitrationPCs.Length] = PC;
            }
            else
            {
                AccessControl.KickPlayer(PC, GameMessageClass.default.MaxedOutMessage);
            }
        }
        if (PendingArbitrationPCs.Length == 0)
        {
            SetTimer(0.0, FALSE, 'ArbitrationTimeout', );
            RegisterServerForArbitration();
        }
    }
    public function StartArbitratedMatch()
    {
        bNeedsEndGameHandshake = TRUE;
        Global.StartMatch();
    }
    public function ArbitrationTimeout()
    {
        local int Index;
        
        for (Index = 0; Index < PendingArbitrationPCs.Length; Index++)
        {
            AccessControl.KickPlayer(PendingArbitrationPCs[Index], GameMessageClass.default.MaxedOutMessage);
        }
        PendingArbitrationPCs.Length = 0;
        RegisterServerForArbitration();
    }
    public function ArbitrationRegistrationComplete(Name SessionName, bool bWasSuccessful)
    {
        GameInterface.ClearArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
        if (bWasSuccessful)
        {
            StartArbitratedMatch();
        }
        else
        {
            ConsoleCommand("Disconnect");
        }
    }
    public function RegisterServerForArbitration()
    {
        if (GameInterface != None)
        {
            GameInterface.AddArbitrationRegistrationCompleteDelegate(ArbitrationRegistrationComplete);
            GameInterface.RegisterForArbitration(PlayerReplicationInfoClass.default.SessionName);
        }
        else
        {
            ArbitrationRegistrationComplete(PlayerReplicationInfoClass.default.SessionName, TRUE);
        }
    }
    public function StartArbitrationRegistration()
    {
        local PlayerController PC;
        local UniqueNetId HostId;
        local OnlineGameSettings GameSettings;
        
        if (!bHasArbitratedHandshakeBegun)
        {
            bHasArbitratedHandshakeBegun = TRUE;
            GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
            HostId = GameSettings.OwningPlayerId;
            PendingArbitrationPCs.Length = 0;
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (!PC.IsLocalPlayerController())
                {
                    PC.ClientSetHostUniqueId(HostId);
                    PC.ClientRegisterForArbitration();
                    PendingArbitrationPCs[PendingArbitrationPCs.Length] = PC;
                }
                else
                {
                    ArbitrationPCs[ArbitrationPCs.Length] = PC;
                }
            }
            SetTimer(ArbitrationHandshakeTimeout, FALSE, 'ArbitrationTimeout', );
        }
    }
    public function StartMatch()
    {
        if (bUsingArbitration)
        {
            StartArbitrationRegistration();
        }
        else
        {
            Global.StartMatch();
        }
    }
    public function bool MatchIsInProgress()
    {
        return FALSE;
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultPlayerName = "Player"
    GameName = "Game"
    GameInfoClassAliases = ({ShortName = "SP", GameClassName = "SFXGameContent.SFXGameInfoSP"}, 
                            {ShortName = "MP", GameClassName = "SFXGameMPContent.SFXGameType_Horde_Operation"}, 
                            {ShortName = "MPLobby", GameClassName = "SFXGameMPContent.SFXGameInfoMP_Lobby"}, 
                            {ShortName = "MPHordeOnly", GameClassName = "SFXGameMPContent.SFXGameType_Horde"}, 
                            {ShortName = "MPNoEnemies", GameClassName = "SFXGameMPContent.SFXGameInfoMP"}
                           )
    DefaultGameType = "SFXGameContent.SFXGameInfoSP"
    DefaultMapPrefixes = ({
                           Prefix = "EntryMenu", 
                           GameType = "SFXGameContent.SFXGameInfoEntryMenu", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = (), 
                           OverrideCommonPackage = "", 
                           bUsesCommonPackage = FALSE, 
                           bIsMultiplayer = FALSE
                          }, 
                          {
                           Prefix = "BIOG_UIWorld", 
                           GameType = "SFXGame.SFXGame", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources"), 
                           OverrideCommonPackage = "", 
                           bUsesCommonPackage = FALSE, 
                           bIsMultiplayer = FALSE
                          }, 
                          {
                           Prefix = "BioP_MPEngineUnitTest", 
                           GameType = "SFXGameMPContent.SFXGameInfoMP", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources"), 
                           OverrideCommonPackage = "BIOP_MP_COMMON", 
                           bUsesCommonPackage = TRUE, 
                           bIsMultiplayer = TRUE
                          }, 
                          {
                           Prefix = "MP_Playground", 
                           GameType = "SFXGameMPContent.SFXGameInfoMP", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources"), 
                           OverrideCommonPackage = "BIOP_MP_COMMON", 
                           bUsesCommonPackage = TRUE, 
                           bIsMultiplayer = TRUE
                          }, 
                          {
                           Prefix = "BioP_MP", 
                           GameType = "SFXGameMPContent.SFXGameType_Horde_Operation", 
                           AdditionalGameTypes = ("SFXGameContent.SFXGameInfoSP"), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources", "BioGlobalResources.BioGlobalMPResources"), 
                           OverrideCommonPackage = "", 
                           bUsesCommonPackage = TRUE, 
                           bIsMultiplayer = TRUE
                          }, 
                          {
                           Prefix = "Bio", 
                           GameType = "SFXGameContent.SFXGameInfoSP", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources"), 
                           OverrideCommonPackage = "", 
                           bUsesCommonPackage = TRUE, 
                           bIsMultiplayer = FALSE
                          }, 
                          {
                           Prefix = "MPLobby", 
                           GameType = "SFXGameMPContent.SFXGameInfoMP_Lobby", 
                           AdditionalGameTypes = (), 
                           ForcedObjects = ("BioGlobalResources.BioGlobalResources"), 
                           OverrideCommonPackage = "BIOP_MP_COMMON", 
                           bUsesCommonPackage = TRUE, 
                           bIsMultiplayer = TRUE
                          }
                         )
    HUDType = Class'HUD'
    DeathMessageClass = Class'LocalMessage'
    GameMessageClass = Class'GameMessage'
    AccessControlClass = Class'AccessControl'
    BroadcastHandlerClass = Class'BroadcastHandler'
    AutoTestManagerClass = Class'AutoTestManager'
    PlayerControllerClass = Class'PlayerController'
    PlayerReplicationInfoClass = Class'PlayerReplicationInfo'
    GameReplicationInfoClass = Class'GameReplicationInfo'
    GameDifficulty = 1.0
    GameSpeed = 1.0
    MaxSpectators = 2
    MaxSpectatorsAllowed = 32
    MaxPlayers = 4
    MaxPlayersAllowed = 32
    CurrentID = 1
    FearCostFallOff = 0.949999988
    TimeMarginSlack = 1.35000002
    MinTimeMargin = -1.0
    LeaderboardId = -131072
    ArbitratedLeaderboardId = -65536
    TotalNetBandwidth = 32000
    MinDynamicBandwidth = 4000
    MaxDynamicBandwidth = 10000
    bRestartLevel = TRUE
    bPauseable = TRUE
    bDelayedStart = TRUE
    bChangeLevels = TRUE
    Components = ()
}
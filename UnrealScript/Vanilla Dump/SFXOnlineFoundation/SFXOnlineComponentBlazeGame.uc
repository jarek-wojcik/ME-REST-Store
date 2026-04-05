Class SFXOnlineComponentBlazeGame extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentGame, OnlineGameInterface)
    native
    config(Engine);

struct native InviteData 
{
    var array<delegate<OnGameInviteAccepted>> InviteDelegates;
    
    structdefaultproperties
    {
        InviteDelegates = ()
    }
};

var const native noexport Pointer VfTable_IISFXOnlineComponentGame;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var const native noexport Pointer VfTable_Blaze::GameManager::GameManagerAPIListener;
var const native noexport Pointer VfTable_Blaze::GameManager::GameListener;
var UniqueNetId m_InviterId;
var transient Double m_HostMigrationStartTime;
var InviteData InviteCache[4];
var config array<int> ValidHostingNatTypes;
var string m_DLC_Protocol;
var array<delegate<OnEndOnlineGameComplete>> EndOnlineGameCompleteDelegates;
var array<delegate<OnFindOnlineGamesComplete>> FindOnlineGamesCompleteDelegates;
var array<delegate<OnCreateOnlineGameComplete>> CreateOnlineGameCompleteDelegates;
var array<delegate<OnQuickMatchComplete>> QuickMatchCompleteDelegates;
var array<delegate<OnJoinOnlineGameComplete>> JoinOnlineGameCompleteDelegates;
var array<delegate<OnUpdateOnlineGameComplete>> UpdateOnlineGameCompleteDelegates;
var array<delegate<OnDestroyOnlineGameComplete>> DestroyOnlineGameCompleteDelegates;
var array<MPDLCInfo> m_MPDLCInfo;
var array<MPDLCInfo> m_MissingDLCsInvitee;
var array<MPDLCInfo> m_MissingDLCsInviter;
var delegate<OnQuickMatchComplete> __OnQuickMatchComplete__Delegate;
var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;
var native Pointer m_pNetAdapter;
var native Pointer m_MatchMakingJobId;
var native Pointer m_AcceptingInviteJobId;
var const Name m_HostMigrationMsgBoxName;
var const config float m_HostMigrationTimeout;
var const config float m_HostMigrationMessageMinTime;
var const config int m_MatchMakingSessionDurationMs;
var const config int m_MinPlayerCount;
var const config int m_DesiredPlayerCount;
var const stringref srHostMigrationInGame;
var const stringref srHostMigrationInLobby;
var const stringref srInviteLocalPlayerError;
var const stringref srPopupOk;
var int m_MultiplayerTargetVersion;
var const config int m_MultiplayerProtocolVersion;
var int m_ServerMatchMakingRulesVersion;
var SFXOnlineGameSettings GameSettings;
var SFXOnlineGameSearch GameSearch;
var OnlineGameSettings m_PendingGameSettings;
var OnlineGameSettings m_UpdatedGameSettings;
var int m_RunningUpdateRequestCount;
var SFXOnlineEvent_Invite m_DelayedInvite;
var const config bool m_IgnoreBlazeServerDisconnect;
var const config bool m_AssertOnMatchMakingErrors;
var const config bool m_HostMigrationEnabled;
var const config bool m_KickedPlayerAlsoBanned;
var config bool m_HostViabilityEnabled;
var bool bAllowMatchmaking;
var transient bool m_ResolveHostAddressInProgress;
var transient bool m_HostMigrationInProgress;
var transient bool m_HostMigrationCompleted;
var transient bool m_HostMigrationFailed;
var transient bool m_HostMigrationHostAddressResolved;
var transient bool m_HostMigrationEndedFromBlaze;
var bool m_LocalPlayerWasKicked;
var bool m_LeaveGamePending;

public native function bool AcceptGameInvite(byte LocalUserNum, Name SessionName);

public native function AllowMatchmaking(bool bAllow, bool bUpdateServer);

public native function bool CancelFindOnlineGames();

public native function CancelHostMigration();

public native function CancelJoinOnlineGame();

public native function bool CanMigrate();

public event function bool CanShowErrorMessage()
{
    local PlayerController PC;
    local WorldInfo WI;
    
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    PC = WI == None ? None : WI.GetALocalPlayerController();
    return PC != None;
}
public native function bool CanStartMPMatch(OnlineGameSettings NewGameSettings);

public native function CompleteHostMigration(bool bLocalPlayerIsHost, bool bIsInLobby);

public static event function SFXOnlineGameSettings CreateDefaultQuickMatchSettings()
{
    local SFXOnlineGameSettings oSettings;
    
    oSettings = new Class'SFXOnlineGameSettings';
    oSettings.SetPrivate(FALSE);
    oSettings.EnemyType = 4;
    oSettings.Difficulty = SFXOnlineGameDifficulty.SFXONLINE_DIFFICULTY_ANY;
    return oSettings;
}
public native function bool CreateOnlineGame(byte HostingPlayerNum, Name SessionName, OnlineGameSettings NewGameSettings);

public native function bool DestroyOnlineGame(Name SessionName);

public native function bool EndOnlineGame(Name SessionName);

public native function FailHostMigration(string Reason);

public native function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings);

public native function bool ForceCleanUp();

public native function Name GetAPIName();

public native function int GetPlayerCount();

public native function bool GetResolvedConnectString(Name SessionName, out string ConnectInfo);

public event function SFXOnlineGameSettings GetSFXGameSettings()
{
    return GameSettings;
}
public event function GM_OnDisconnect(SFXOnlineEvent disconnectEvent)
{
    if (OnlineSubsystem.GetComponentGameFlow().GM_IsInMultiplayerFlow() && !m_IgnoreBlazeServerDisconnect)
    {
        if (m_HostMigrationInProgress)
        {
            FailHostMigration("Blaze disconnect");
        }
        DestroyOnlineGame('Game');
        ForceCleanUp();
    }
    GameSettings = None;
    GameSearch = None;
}
public native function HideHostMigrationMsgBox();

public native function HostMigrationMsgBoxCallback(bool bAPressed, int Context);

public native function bool IsHostMigrationInProgress();

public native function bool IsInvalidHost();

public native function bool IsLocalPlayer(UniqueNetId PlayerID);

public native function bool IsPlayerInGame(UniqueNetId PlayerID);

public native function bool IsPlaying();

public native function bool IsReadyForConnections();

public event function bool IsTargetVersionRetrieved()
{
    return m_MultiplayerTargetVersion != -1;
}
public native function bool JoinOnlineGame(byte PlayerNum, Name SessionName, const out OnlineGameSearchResult DesiredGame);

public native function bool KickPlayer(UniqueNetId PlayerID);

public native function LeaveGame();

public delegate function OnArbitrationRegistrationComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnCancelFindOnlineGamesComplete(bool bWasSuccessful);

public native function bool OnConnectionError();

public delegate function OnCreateOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnDestroyOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnEndOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnFindOnlineGamesComplete(bool bWasSuccessful);

public delegate function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult);

public native function bool OnHostAddressResolved();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public event function OnInviteAccepted(SFXOnlineEvent oEvent)
{
    local SFXOnlineEvent_Invite oInviteEvent;
    local UniqueNetId invitedUserId;
    local UniqueNetId inviterId;
    local bool invitedInactiveUser;
    local PlayerController PC;
    
    oInviteEvent = SFXOnlineEvent_Invite(oEvent);
    PC = Class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController();
    if (PC == None)
    {
        m_DelayedInvite = oInviteEvent;
        return;
    }
    invitedUserId = SFXOnlineGameSettings(oInviteEvent.SearchResult.GameSettings).invitedUserId;
    invitedInactiveUser = !OnlineSubsystem.GetComponentGameEntryFlow().IsInvitedUserActive(invitedUserId);
    if (invitedInactiveUser)
    {
    }
    inviterId = oInviteEvent.SearchResult.GameSettings.OwningPlayerId;
    if (IsLocalPlayer(inviterId))
    {
        ShowPopup(srInviteLocalPlayerError, TRUE);
    }
    else if (IsPlayerInGame(inviterId) && !invitedInactiveUser)
    {
    }
    else
    {
        m_InviterId = inviterId;
        NotifyGameInviteAcceptedDelegates(oInviteEvent.SearchResult);
    }
}
public delegate function OnJoinOnlineGameComplete(Name SessionName, bool bWasSuccessful);

private final native function OnMPGameStatusChange(SFXOnlineEvent Event);

public delegate function OnQuickMatchComplete(byte Result);

public delegate function OnRegisterPlayerComplete(Name SessionName, UniqueNetId PlayerID, bool bWasSuccessful);

public native function OnRelease();

public delegate function OnStartOnlineGameComplete(Name SessionName, bool bWasSuccessful);

private final native function OnTick(SFXOnlineEvent Event);

public delegate function OnUnregisterPlayerComplete(Name SessionName, UniqueNetId PlayerID, bool bWasSuccessful);

public delegate function OnUpdateOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public native function bool PerformCallRestrictedFunction();

public native function bool QuickMatch(optional OnlineGameSettings quickMatchSettings);

public native function bool RegisterPlayer(Name SessionName, UniqueNetId PlayerID, bool bWasInvited);

public native function SetCallRestrictedFunctionMode(bool bEnable);

public function SetHostViabilityEnabled(bool Enabled)
{
    m_HostViabilityEnabled = Enabled;
}
public event function SetMPDLCInfo(out array<MPDLCInfo> allAvailableDLCs)
{
    m_MPDLCInfo = allAvailableDLCs;
    m_DLC_Protocol = ValidateDLCMasterList();
}
public event function SetMultiplayerTargetVersion(int protocolVersion)
{
    m_MultiplayerTargetVersion = protocolVersion;
}
public native function SetPlatformPresence(bool presencePrivate);

public event function SetServerMatchMakingRulesVersion(int serverRulesVersion)
{
    m_ServerMatchMakingRulesVersion = serverRulesVersion;
}
public native function ShowHostMigrationMsgBox(bool bIsInLobby);

private final native function ShowPopup(stringref bodyStr, bool bShowOkBtn, optional bool bModal = FALSE, optional bool bPauseGameplay = FALSE);

public native function bool StartOnlineGame(Name SessionName);

private final function Tick(SFXOnlineEvent Event)
{
    local PlayerController PC;
    
    if (m_DelayedInvite != None)
    {
        PC = Class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController();
        if (PC != None)
        {
            OnInviteAccepted(m_DelayedInvite);
            m_DelayedInvite = None;
        }
    }
    OnTick(Event);
}
public native function bool UnregisterPlayer(Name SessionName, UniqueNetId PlayerID);

public native function UpdateGameProtocolVersion();

public native function bool UpdateOnlineGame(Name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = FALSE);

public native function string ValidateDLCMasterList();

public function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80]);

public function bool FreeSearchResults(optional OnlineGameSearch Search);

public function bool ReadPlatformSpecificSessionInfo(const out OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80]);

public function AddArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate);

public function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    if (CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate) == -1)
    {
        CreateOnlineGameCompleteDelegates.AddItem(CreateOnlineGameCompleteDelegate);
    }
}
public function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    if (DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate) == -1)
    {
        DestroyOnlineGameCompleteDelegates.AddItem(DestroyOnlineGameCompleteDelegate);
    }
}
public function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    if (EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate) == -1)
    {
        EndOnlineGameCompleteDelegates.AddItem(EndOnlineGameCompleteDelegate);
    }
}
public function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    if (FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate) == -1)
    {
        FindOnlineGamesCompleteDelegates.AddItem(FindOnlineGamesCompleteDelegate);
    }
}
public function AddGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (InviteCache[int(LocalUserNum)].InviteDelegates.Find(GameInviteAcceptedDelegate) == -1)
        {
            InviteCache[int(LocalUserNum)].InviteDelegates.AddItem(GameInviteAcceptedDelegate);
        }
    }
}
public function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    if (JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate) == -1)
    {
        JoinOnlineGameCompleteDelegates.AddItem(JoinOnlineGameCompleteDelegate);
    }
}
public function AddQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate)
{
    if (QuickMatchCompleteDelegates.Find(QuickMatchCompleteDelegate) == -1)
    {
        QuickMatchCompleteDelegates.AddItem(QuickMatchCompleteDelegate);
    }
}
public function AddRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate);

public function AddUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    if (UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate) == -1)
    {
        UpdateOnlineGameCompleteDelegates.AddItem(UpdateOnlineGameCompleteDelegate);
    }
}
public function ClearArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate);

public function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    CreateOnlineGameCompleteDelegates.RemoveItem(CreateOnlineGameCompleteDelegate);
}
public function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    DestroyOnlineGameCompleteDelegates.RemoveItem(DestroyOnlineGameCompleteDelegate);
}
public function ClearEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    EndOnlineGameCompleteDelegates.RemoveItem(EndOnlineGameCompleteDelegate);
}
public function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    FindOnlineGamesCompleteDelegates.RemoveItem(FindOnlineGamesCompleteDelegate);
}
public function ClearGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        InviteCache[int(LocalUserNum)].InviteDelegates.RemoveItem(GameInviteAcceptedDelegate);
    }
}
public function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    JoinOnlineGameCompleteDelegates.RemoveItem(JoinOnlineGameCompleteDelegate);
}
public function ClearQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate)
{
    QuickMatchCompleteDelegates.RemoveItem(QuickMatchCompleteDelegate);
}
public function ClearRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate);

public function ClearUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    UpdateOnlineGameCompleteDelegates.RemoveItem(UpdateOnlineGameCompleteDelegate);
}
public function array<OnlineArbitrationRegistrant> GetArbitratedPlayers(Name SessionName);

public function OnlineGameSearch GetGameSearch()
{
    return GameSearch;
}
public function OnlineGameSettings GetGameSettings(Name SessionName)
{
    return GameSettings;
}
public function bool QueryNonAdvertisedData(int StartAt, int NumberToQuery);

public function bool ReadPlatformSpecificSessionInfoBySessionName(Name SessionName, out byte PlatformSpecificInfo[80]);

public function bool RecalculateSkillRating(Name SessionName, const out array<UniqueNetId> Players);

public function bool RegisterForArbitration(Name SessionName);

public function GetMultiplayer_MissingDLCs(out array<MPDLCInfo> missingDLCs, bool bInvitee)
{
    if (bInvitee)
    {
        missingDLCs = m_MissingDLCsInvitee;
    }
    else
    {
        missingDLCs = m_MissingDLCsInviter;
    }
}
public function bool IsOnLatestMultiplayerVersion()
{
    if (!IsTargetVersionRetrieved())
    {
        return FALSE;
    }
    return m_MultiplayerProtocolVersion >= m_MultiplayerTargetVersion;
}
public function bool WasKickedOutOfGame()
{
    return m_LocalPlayerWasKicked;
}
public function NotifyGameInviteAcceptedDelegates(const out OnlineGameSearchResult InviteResult)
{
    local int UserNum;
    local int i;
    local delegate<OnGameInviteAccepted> del;
    local PlayerController PC;
    
    PC = Class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController();
    if (PC == None)
    {
        return;
    }
    UserNum = LocalPlayer(PC.Player).ControllerId;
    if (UserNum >= 0 && UserNum < 4)
    {
        for (i = 0; i < InviteCache[UserNum].InviteDelegates.Length; i++)
        {
            del = InviteCache[UserNum].InviteDelegates[i];
            if (del != None)
            {
                del(InviteResult);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ValidHostingNatTypes = (0, 1, 4)
    m_HostMigrationMsgBoxName = 'HostMigrationMessageBox'
    m_HostMigrationTimeout = 15.0
    m_HostMigrationMessageMinTime = 3.0
    m_MatchMakingSessionDurationMs = 1800000
    m_MinPlayerCount = 2
    m_DesiredPlayerCount = 4
    srHostMigrationInGame = $678851
    srHostMigrationInLobby = $687620
    srInviteLocalPlayerError = $694204
    srPopupOk = $152938
    m_MultiplayerTargetVersion = -1
    m_MultiplayerProtocolVersion = 1
    m_ServerMatchMakingRulesVersion = -1
    m_HostMigrationEnabled = TRUE
    bAllowMatchmaking = TRUE
    EventSubscriberTable = ({EventCallback = 'GM_OnDisconnect', EventType = SFXOnlineEventType.SFXONLINE_EVENT_PLATFORM_DISCONNECT}, 
                            {EventCallback = 'OnInviteAccepted', EventType = SFXOnlineEventType.SFXONLINE_EVENT_INVITE}, 
                            {EventCallback = 'Tick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}, 
                            {EventCallback = 'OnMPGameStatusChange', EventType = SFXOnlineEventType.SFXONLINE_EVENT_MP_GAME_STATUS_CHANGE}
                           )
}
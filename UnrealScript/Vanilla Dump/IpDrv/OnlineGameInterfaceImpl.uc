Class OnlineGameInterfaceImpl within OnlineSubsystemCommonImpl
    implements(OnlineGameInterface)
    native
    config(Engine);

var array<delegate<OnCreateOnlineGameComplete>> CreateOnlineGameCompleteDelegates;
var array<delegate<OnUpdateOnlineGameComplete>> UpdateOnlineGameCompleteDelegates;
var array<delegate<OnDestroyOnlineGameComplete>> DestroyOnlineGameCompleteDelegates;
var array<delegate<OnJoinOnlineGameComplete>> JoinOnlineGameCompleteDelegates;
var array<delegate<OnStartOnlineGameComplete>> StartOnlineGameCompleteDelegates;
var array<delegate<OnEndOnlineGameComplete>> EndOnlineGameCompleteDelegates;
var array<delegate<OnFindOnlineGamesComplete>> FindOnlineGamesCompleteDelegates;
var array<delegate<OnCancelFindOnlineGamesComplete>> CancelFindOnlineGamesCompleteDelegates;
var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;
var delegate<OnQuickMatchComplete> __OnQuickMatchComplete__Delegate;
var const transient native Pointer LanBeacon;
var const transient native Pointer SessionInfo;
var OnlineSubsystemCommonImpl OwningSubsystem;
var const OnlineGameSettings GameSettings;
var const OnlineGameSearch GameSearch;
var const config int LanAnnouncePort;
var const config int LanGameUniqueId;
var const config int LanPacketPlatformMask;
var float LanQueryTimeLeft;
var config float LanQueryTimeout;
var const byte LanNonce[8];
var const EOnlineGameState CurrentGameState;
var const ELanBeaconState LanBeaconState;

public function bool AcceptGameInvite(byte LocalUserNum, Name SessionName);

public native function bool CancelFindOnlineGames();

public native function bool CreateOnlineGame(byte HostingPlayerNum, Name SessionName, OnlineGameSettings NewGameSettings);

public native function bool DestroyOnlineGame(Name SessionName);

public native function bool EndOnlineGame(Name SessionName);

public native function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings);

public function bool ForceCleanUp();

public native function bool GetResolvedConnectString(Name SessionName, out string ConnectInfo);

public native function bool JoinOnlineGame(byte PlayerNum, Name SessionName, const out OnlineGameSearchResult DesiredGame);

public delegate function OnArbitrationRegistrationComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnCancelFindOnlineGamesComplete(bool bWasSuccessful);

public delegate function OnCreateOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnDestroyOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnEndOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnFindOnlineGamesComplete(bool bWasSuccessful);

public delegate function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult);

public delegate function OnJoinOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnQuickMatchComplete(byte Result);

public delegate function OnRegisterPlayerComplete(Name SessionName, UniqueNetId PlayerID, bool bWasSuccessful);

public delegate function OnStartOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnUnregisterPlayerComplete(Name SessionName, UniqueNetId PlayerID, bool bWasSuccessful);

public delegate function OnUpdateOnlineGameComplete(Name SessionName, bool bWasSuccessful);

public function bool QuickMatch(optional OnlineGameSettings quickMatchSettings);

public function bool RegisterPlayer(Name SessionName, UniqueNetId PlayerID, bool bWasInvited);

public native function bool StartOnlineGame(Name SessionName);

public function bool UnregisterPlayer(Name SessionName, UniqueNetId PlayerID);

public function bool UpdateOnlineGame(Name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = FALSE);

public native function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80]);

public native function bool FreeSearchResults(OnlineGameSearch Search);

public native function bool ReadPlatformSpecificSessionInfo(const out OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80]);

public function AddArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
    if (CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate) == -1)
    {
        CancelFindOnlineGamesCompleteDelegates[CancelFindOnlineGamesCompleteDelegates.Length] = CancelFindOnlineGamesCompleteDelegate;
    }
}
public function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    if (CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate) == -1)
    {
        CreateOnlineGameCompleteDelegates[CreateOnlineGameCompleteDelegates.Length] = CreateOnlineGameCompleteDelegate;
    }
}
public function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    if (DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate) == -1)
    {
        DestroyOnlineGameCompleteDelegates[DestroyOnlineGameCompleteDelegates.Length] = DestroyOnlineGameCompleteDelegate;
    }
}
public function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    if (EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate) == -1)
    {
        EndOnlineGameCompleteDelegates[EndOnlineGameCompleteDelegates.Length] = EndOnlineGameCompleteDelegate;
    }
}
public function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    if (FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate) == -1)
    {
        FindOnlineGamesCompleteDelegates[FindOnlineGamesCompleteDelegates.Length] = FindOnlineGamesCompleteDelegate;
    }
}
public function AddGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate);

public function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    if (JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate) == -1)
    {
        JoinOnlineGameCompleteDelegates[JoinOnlineGameCompleteDelegates.Length] = JoinOnlineGameCompleteDelegate;
    }
}
public function AddQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate);

public function AddRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
    if (StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate) == -1)
    {
        StartOnlineGameCompleteDelegates[StartOnlineGameCompleteDelegates.Length] = StartOnlineGameCompleteDelegate;
    }
}
public function AddUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    if (UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate) == -1)
    {
        UpdateOnlineGameCompleteDelegates[UpdateOnlineGameCompleteDelegates.Length] = UpdateOnlineGameCompleteDelegate;
    }
}
public function ClearArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = CancelFindOnlineGamesCompleteDelegates.Find(CancelFindOnlineGamesCompleteDelegate);
    if (RemoveIndex != -1)
    {
        CancelFindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = CreateOnlineGameCompleteDelegates.Find(CreateOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        CreateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = DestroyOnlineGameCompleteDelegates.Find(DestroyOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        DestroyOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = EndOnlineGameCompleteDelegates.Find(EndOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        EndOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = FindOnlineGamesCompleteDelegates.Find(FindOnlineGamesCompleteDelegate);
    if (RemoveIndex != -1)
    {
        FindOnlineGamesCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate);

public function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = JoinOnlineGameCompleteDelegates.Find(JoinOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        JoinOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate);

public function ClearRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = StartOnlineGameCompleteDelegates.Find(StartOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        StartOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = UpdateOnlineGameCompleteDelegates.Find(UpdateOnlineGameCompleteDelegate);
    if (RemoveIndex != -1)
    {
        UpdateOnlineGameCompleteDelegates.Remove(RemoveIndex, 1);
    }
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


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LanAnnouncePort = 14001
    LanQueryTimeout = 5.0
}
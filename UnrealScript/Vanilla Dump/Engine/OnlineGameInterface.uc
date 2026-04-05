Class OnlineGameInterface extends Interface
    abstract;

var delegate<OnRegisterPlayerComplete> __OnRegisterPlayerComplete__Delegate;
var delegate<OnUpdateOnlineGameComplete> __OnUpdateOnlineGameComplete__Delegate;
var delegate<OnDestroyOnlineGameComplete> __OnDestroyOnlineGameComplete__Delegate;
var delegate<OnFindOnlineGamesComplete> __OnFindOnlineGamesComplete__Delegate;
var delegate<OnCancelFindOnlineGamesComplete> __OnCancelFindOnlineGamesComplete__Delegate;
var delegate<OnJoinOnlineGameComplete> __OnJoinOnlineGameComplete__Delegate;
var delegate<OnCreateOnlineGameComplete> __OnCreateOnlineGameComplete__Delegate;
var delegate<OnUnregisterPlayerComplete> __OnUnregisterPlayerComplete__Delegate;
var delegate<OnStartOnlineGameComplete> __OnStartOnlineGameComplete__Delegate;
var delegate<OnEndOnlineGameComplete> __OnEndOnlineGameComplete__Delegate;
var delegate<OnArbitrationRegistrationComplete> __OnArbitrationRegistrationComplete__Delegate;
var delegate<OnGameInviteAccepted> __OnGameInviteAccepted__Delegate;
var delegate<OnQuickMatchComplete> __OnQuickMatchComplete__Delegate;

public function bool AcceptGameInvite(byte LocalUserNum, Name SessionName);

public function bool CancelFindOnlineGames();

public function bool CreateOnlineGame(byte HostingPlayerNum, Name SessionName, OnlineGameSettings NewGameSettings);

public function bool DestroyOnlineGame(Name SessionName);

public function bool EndOnlineGame(Name SessionName);

public function bool FindOnlineGames(byte SearchingPlayerNum, OnlineGameSearch SearchSettings);

public function bool ForceCleanUp();

public function bool GetResolvedConnectString(Name SessionName, out string ConnectInfo);

public function bool JoinOnlineGame(byte PlayerNum, Name SessionName, const out OnlineGameSearchResult DesiredGame);

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

public function bool StartOnlineGame(Name SessionName);

public function bool UnregisterPlayer(Name SessionName, UniqueNetId PlayerID);

public function bool UpdateOnlineGame(Name SessionName, OnlineGameSettings UpdatedGameSettings, optional bool bShouldRefreshOnlineData = FALSE);

public function bool BindPlatformSpecificSessionToSearch(byte SearchingPlayerNum, OnlineGameSearch SearchSettings, byte PlatformSpecificInfo[80]);

public function bool FreeSearchResults(optional OnlineGameSearch Search);

public function bool ReadPlatformSpecificSessionInfo(const out OnlineGameSearchResult DesiredGame, out byte PlatformSpecificInfo[80]);

public function AddArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function AddCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate);

public function AddCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate);

public function AddDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate);

public function AddEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate);

public function AddFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate);

public function AddGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate);

public function AddJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate);

public function AddQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate);

public function AddRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function AddStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate);

public function AddUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function AddUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate);

public function ClearArbitrationRegistrationCompleteDelegate(delegate<OnArbitrationRegistrationComplete> ArbitrationRegistrationCompleteDelegate);

public function ClearCancelFindOnlineGamesCompleteDelegate(delegate<OnCancelFindOnlineGamesComplete> CancelFindOnlineGamesCompleteDelegate);

public function ClearCreateOnlineGameCompleteDelegate(delegate<OnCreateOnlineGameComplete> CreateOnlineGameCompleteDelegate);

public function ClearDestroyOnlineGameCompleteDelegate(delegate<OnDestroyOnlineGameComplete> DestroyOnlineGameCompleteDelegate);

public function ClearEndOnlineGameCompleteDelegate(delegate<OnEndOnlineGameComplete> EndOnlineGameCompleteDelegate);

public function ClearFindOnlineGamesCompleteDelegate(delegate<OnFindOnlineGamesComplete> FindOnlineGamesCompleteDelegate);

public function ClearGameInviteAcceptedDelegate(byte LocalUserNum, delegate<OnGameInviteAccepted> GameInviteAcceptedDelegate);

public function ClearJoinOnlineGameCompleteDelegate(delegate<OnJoinOnlineGameComplete> JoinOnlineGameCompleteDelegate);

public function ClearQuickMatchCompleteDelegate(delegate<OnQuickMatchComplete> QuickMatchCompleteDelegate);

public function ClearRegisterPlayerCompleteDelegate(delegate<OnRegisterPlayerComplete> RegisterPlayerCompleteDelegate);

public function ClearStartOnlineGameCompleteDelegate(delegate<OnStartOnlineGameComplete> StartOnlineGameCompleteDelegate);

public function ClearUnregisterPlayerCompleteDelegate(delegate<OnUnregisterPlayerComplete> UnregisterPlayerCompleteDelegate);

public function ClearUpdateOnlineGameCompleteDelegate(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate);

public function array<OnlineArbitrationRegistrant> GetArbitratedPlayers(Name SessionName);

public function OnlineGameSearch GetGameSearch();

public function OnlineGameSettings GetGameSettings(Name SessionName);

public function bool QueryNonAdvertisedData(int StartAt, int NumberToQuery);

public function bool ReadPlatformSpecificSessionInfoBySessionName(Name SessionName, out byte PlatformSpecificInfo[80]);

public function bool RecalculateSkillRating(Name SessionName, const out array<UniqueNetId> Players);

public function bool RegisterForArbitration(Name SessionName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
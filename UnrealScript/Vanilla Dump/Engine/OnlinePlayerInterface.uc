Class OnlinePlayerInterface extends Interface
    abstract;

var delegate<OnReadPlayerStorageForNetIdComplete> __OnReadPlayerStorageForNetIdComplete__Delegate;
var delegate<OnLoginCancelled> __OnLoginCancelled__Delegate;
var delegate<OnMutingChange> __OnMutingChange__Delegate;
var delegate<OnFriendsChange> __OnFriendsChange__Delegate;
var delegate<OnLoginFailed> __OnLoginFailed__Delegate;
var delegate<OnLogoutCompleted> __OnLogoutCompleted__Delegate;
var delegate<OnLoginStatusChange> __OnLoginStatusChange__Delegate;
var delegate<OnReadProfileSettingsComplete> __OnReadProfileSettingsComplete__Delegate;
var delegate<OnWriteProfileSettingsComplete> __OnWriteProfileSettingsComplete__Delegate;
var delegate<OnReadPlayerStorageComplete> __OnReadPlayerStorageComplete__Delegate;
var delegate<OnLoginChange> __OnLoginChange__Delegate;
var delegate<OnWritePlayerStorageComplete> __OnWritePlayerStorageComplete__Delegate;
var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
var delegate<OnKeyboardInputComplete> __OnKeyboardInputComplete__Delegate;
var delegate<OnAddFriendByNameComplete> __OnAddFriendByNameComplete__Delegate;
var delegate<OnFriendInviteReceived> __OnFriendInviteReceived__Delegate;
var delegate<OnReceivedGameInvite> __OnReceivedGameInvite__Delegate;
var delegate<OnJoinFriendGameComplete> __OnJoinFriendGameComplete__Delegate;
var delegate<OnFriendMessageReceived> __OnFriendMessageReceived__Delegate;
var delegate<OnUnlockAchievementComplete> __OnUnlockAchievementComplete__Delegate;
var delegate<OnReadAchievementsComplete> __OnReadAchievementsComplete__Delegate;

public function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate);

public function bool AutoLogin();

public function EFeaturePrivilegeLevel CanCommunicate(byte LocalUserNum);

public function EFeaturePrivilegeLevel CanDownloadUserContent(byte LocalUserNum);

public function EFeaturePrivilegeLevel CanPlayOnline(byte LocalUserNum);

public function EFeaturePrivilegeLevel CanPurchaseContent(byte LocalUserNum);

public function EFeaturePrivilegeLevel CanShowPresenceInformation(byte LocalUserNum);

public function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte LocalUserNum);

public function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate);

public function EOnlineEnumerationReadState GetAchievements(byte LocalUserNum, out array<AchievementDetails> Achievements, optional int TitleId = 0);

public function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

public function ELoginStatus GetLoginStatus(byte LocalUserNum);

public function string GetPlayerNickname(byte LocalUserNum);

public function OnlineProfileSettings GetProfileSettings(byte LocalUserNum);

public function bool GetUniquePlayerId(byte LocalUserNum, out UniqueNetId PlayerID);

public function bool IsGuestLogin(byte LocalUserNum);

public function bool IsLocalLogin(byte LocalUserNum);

public function bool IsMuted(byte LocalUserNum, UniqueNetId PlayerID);

public function bool Login(byte LocalUserNum, string LoginName, string Password, optional bool bWantsLocalOnly);

public function bool Logout(byte LocalUserNum);

public delegate function OnAddFriendByNameComplete(bool bWasSuccessful);

public delegate function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message);

public delegate function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message);

public delegate function OnFriendsChange();

public delegate function OnJoinFriendGameComplete(bool bWasSuccessful);

public delegate function OnKeyboardInputComplete(bool bWasSuccessful);

public delegate function OnLoginCancelled();

public delegate function OnLoginChange(byte LocalUserNum);

public delegate function OnLoginFailed(byte LocalUserNum, EOnlineServerConnectionStatus errorCode);

public delegate function OnLoginStatusChange(ELoginStatus NewStatus, UniqueNetId NewId);

public delegate function OnLogoutCompleted(bool bWasSuccessful);

public delegate function OnMutingChange();

public delegate function OnReadAchievementsComplete(int TitleId);

public delegate function OnReadFriendsComplete(bool bWasSuccessful);

public delegate function OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId, bool bWasSuccessful);

public delegate function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnReceivedGameInvite(byte LocalUserNum, string InviterName);

public delegate function OnUnlockAchievementComplete(bool bWasSuccessful);

public delegate function OnWritePlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnWriteProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful);

public function bool ReadAchievements(byte LocalUserNum, optional int TitleId = 0, optional bool bShouldReadText = TRUE, optional bool bShouldReadImages = FALSE);

public function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

public function bool ReadPlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage);

public function bool ReadPlayerStorageForNetId(UniqueNetId NetId, OnlinePlayerStorage PlayerStorage);

public function bool ReadProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

public function SetOnlineStatus(byte LocalUserNum, int StatusId, const out array<LocalizedStringSetting> LocalizedStringSettings, const out array<SettingsProperty> Properties);

public function bool ShowFriendsUI(byte LocalUserNum);

public function bool ShowKeyboardUI(byte LocalUserNum, string TitleText, string DescriptionText, optional bool bIsPassword = FALSE, optional bool bShouldValidate = TRUE, optional string DefaultText, optional int MaxResultLength = 256);

public function bool ShowLoginUI(optional bool bShowOnlineOnly = FALSE);

public function bool UnlockAchievement(byte LocalUserNum, int AchievementId);

public function bool WritePlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage);

public function bool WriteProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

public function bool AcceptFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer);

public function AddAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate);

public function bool AddFriend(byte LocalUserNum, UniqueNetId NewFriend, optional string Message);

public function bool AddFriendByName(byte LocalUserNum, string FriendName, optional string Message);

public function AddFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate);

public function AddFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate);

public function AddFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate);

public function AddJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate);

public function AddKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate);

public function AddLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate);

public function AddLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate);

public function AddLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate);

public function AddLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum);

public function AddLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate);

public function AddMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate);

public function AddReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate);

public function AddReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate);

public function AddReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate);

public function AddReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate);

public function AddReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate);

public function AddUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate);

public function AddWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate);

public function AddWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate);

public function bool AreAnyFriends(byte LocalUserNum, out array<FriendsQuery> Query);

public function ClearAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate);

public function ClearFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate);

public function ClearFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate);

public function ClearFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate);

public function ClearJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate);

public function ClearKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate);

public function ClearLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate);

public function ClearLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate);

public function ClearLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate);

public function ClearLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum);

public function ClearLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate);

public function ClearMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate);

public function ClearReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate);

public function ClearReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate);

public function ClearReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate);

public function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate);

public function ClearReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate);

public function ClearUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate);

public function ClearWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate);

public function ClearWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate);

public function bool DeleteMessage(byte LocalUserNum, int MessageIndex);

public function bool DenyFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer);

public function GetFriendMessages(byte LocalUserNum, out array<OnlineFriendMessage> FriendMessages);

public function string GetKeyboardInputResults(out byte bWasCanceled);

public function OnlinePlayerStorage GetPlayerStorage(byte LocalUserNum);

public function bool IsFriend(byte LocalUserNum, UniqueNetId PlayerID);

public function bool JoinFriendGame(byte LocalUserNum, UniqueNetId Friend);

public function bool RemoveFriend(byte LocalUserNum, UniqueNetId FormerFriend);

public function bool SendGameInviteToFriend(byte LocalUserNum, UniqueNetId Friend, optional string Text);

public function bool SendGameInviteToFriends(byte LocalUserNum, array<UniqueNetId> Friends, optional string Text);

public function bool SendMessageToFriend(byte LocalUserNum, UniqueNetId Friend, string Message);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
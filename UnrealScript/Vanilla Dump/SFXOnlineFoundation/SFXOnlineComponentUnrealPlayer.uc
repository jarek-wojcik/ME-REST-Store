Class SFXOnlineComponentUnrealPlayer extends SFXOnlineComponent
    implements(OnlinePlayerInterface, ISFXOnlineComponent)
    native
    config(Engine);

struct native LoginStatusDelegates 
{
    var array<delegate<OnLoginStatusChange>> Delegates;
    
    structdefaultproperties
    {
        Delegates = ()
    }
};
struct native BioPerUserDelegateLists 
{
    var array<delegate<OnUnlockAchievementComplete>> AchievementDelegates;
    var array<delegate<OnReadAchievementsComplete>> AchievementReadDelegates;
    
    structdefaultproperties
    {
        AchievementDelegates = ()
        AchievementReadDelegates = ()
    }
};
const NumProfiles = 4;
struct native SFXCachedAchievements 
{
    var array<AchievementDetails> Achievements;
    var int PlayerNum;
    var int TitleId;
    var const Surface TempImage;
    var EOnlineEnumerationReadState ReadState;
};
struct native SFXProfileSettingsCache 
{
    var array<delegate<OnReadProfileSettingsComplete>> ReadDelegates;
    var array<delegate<OnWriteProfileSettingsComplete>> WriteDelegates;
    var array<delegate<OnProfileDataChanged>> ProfileDataChangedDelegates;
    var OnlineProfileSettings Profile;
    
    structdefaultproperties
    {
        ReadDelegates = ()
        WriteDelegates = ()
        ProfileDataChangedDelegates = ()
    }
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var SFXProfileSettingsCache ProfileCache[4];
var BioPerUserDelegateLists PerUserDelegates[4];
var LoginStatusDelegates PlayerLoginStatusDelegates[4];
var array<SFXCachedAchievements> CachedAchievementList;
var array<delegate<OnReadPlayerStorageComplete>> LocalPlayerStorageReadDelegates;
var array<delegate<OnWritePlayerStorageComplete>> LocalPlayerStorageWriteDelegates;
var array<delegate<OnReadPlayerStorageForNetIdComplete>> RemotePlayerStorageReadDelegates;
var array<delegate<OnReadFriendsComplete>> ReadFriendsDelegates;
var array<delegate<OnLoginCancelled>> LoginCancelledDelegates;
var array<delegate<OnLoginFailed>> LoginFailedDelegates;
var array<delegate<OnLogoutCompleted>> LogoutCompletedDelegates;
var array<delegate<OnLoginChange>> LoginChangeDelegates;
var config string ProfileDataDirectory;
var config string ProfileDataDirectoryInstalled;
var config string ProfileDataExtension;
var config string LoggedInPlayerName;
var delegate<OnProfileDataChanged> __OnProfileDataChanged__Delegate;
var delegate<OnLoginChange> __OnLoginChange__Delegate;
var delegate<OnLoginCancelled> __OnLoginCancelled__Delegate;
var delegate<OnMutingChange> __OnMutingChange__Delegate;
var delegate<OnFriendsChange> __OnFriendsChange__Delegate;
var delegate<OnLoginFailed> __OnLoginFailed__Delegate;
var delegate<OnLogoutCompleted> __OnLogoutCompleted__Delegate;
var delegate<OnLoginStatusChange> __OnLoginStatusChange__Delegate;
var delegate<OnReadProfileSettingsComplete> __OnReadProfileSettingsComplete__Delegate;
var delegate<OnWriteProfileSettingsComplete> __OnWriteProfileSettingsComplete__Delegate;
var delegate<OnReadPlayerStorageComplete> __OnReadPlayerStorageComplete__Delegate;
var delegate<OnReadPlayerStorageForNetIdComplete> __OnReadPlayerStorageForNetIdComplete__Delegate;
var delegate<OnWritePlayerStorageComplete> __OnWritePlayerStorageComplete__Delegate;
var delegate<OnReadFriendsComplete> __OnReadFriendsComplete__Delegate;
var delegate<OnKeyboardInputComplete> __OnKeyboardInputComplete__Delegate;
var delegate<OnAddFriendByNameComplete> __OnAddFriendByNameComplete__Delegate;
var delegate<OnFriendInviteReceived> __OnFriendInviteReceived__Delegate;
var delegate<OnReceivedGameInvite> __OnReceivedGameInvite__Delegate;
var delegate<OnJoinFriendGameComplete> __OnJoinFriendGameComplete__Delegate;
var delegate<OnFriendMessageReceived> __OnFriendMessageReceived__Delegate;
var delegate<OnReadAchievementsComplete> __OnReadAchievementsComplete__Delegate;
var delegate<OnUnlockAchievementComplete> __OnUnlockAchievementComplete__Delegate;
var OnlinePlayerStorage PlayerStorageCache[4];

public function AddReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate) == -1)
        {
            ReadFriendsDelegates[ReadFriendsDelegates.Length] = ReadFriendsCompleteDelegate;
        }
    }
}
public native function bool AutoLogin();

public final native function CachePlayerNickname();

public native function EFeaturePrivilegeLevel CanCommunicate(byte LocalUserNum);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(byte LocalUserNum);

public native function EFeaturePrivilegeLevel CanPlayOnline(byte LocalUserNum);

public native function EFeaturePrivilegeLevel CanPurchaseContent(byte LocalUserNum);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(byte LocalUserNum);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte LocalUserNum);

private final native function ClearAsyncState(int UserNum);

public native function ClearProfileCaches();

public function ClearReadFriendsCompleteDelegate(byte LocalUserNum, delegate<OnReadFriendsComplete> ReadFriendsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) == 0)
    {
        RemoveIndex = ReadFriendsDelegates.Find(ReadFriendsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            ReadFriendsDelegates.Remove(RemoveIndex, 1);
        }
    }
}
private final event function SFXOnlineJobLoadSettings CreateJobLoadSettings(int Arg)
{
    return Class'SFXOnlineJobLoadSettings'.static.CreateJob(LoadSettingsCallback, Arg);
}
private final event function SFXOnlineJobSaveSettings CreateJobSaveSettings(int Arg)
{
    return Class'SFXOnlineJobSaveSettings'.static.CreateJob(SaveSettingsCallback, Arg);
}
public native function string CreateProfileName();

public native function bool DoesProfileExist();

public native function EOnlineEnumerationReadState GetAchievements(byte LocalUserNum, out array<AchievementDetails> Achievements, optional int TitleId = 0);

public native function Name GetAPIName();

public native function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

public function ELoginStatus GetLoginStatus(byte LocalUserNum)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ELoginStatus ELoginStatus;
    
    ELoginStatus = ELoginStatus.LS_NotLoggedIn;
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentPlatform() != None)
        {
            ELoginStatus = oOnlineSubsystem.GetComponentPlatform().GetLoginStatus(LocalUserNum);
        }
    }
    return ELoginStatus;
}
public native function bool GetOfflinePlayerId(byte LocalUserNum, out UniqueNetId PlayerID);

public native function string GetPlayerNickname(byte LocalUserNum);

public function OnlineProfileSettings GetProfileSettings(byte LocalUserNum)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        return ProfileCache[int(LocalUserNum)].Profile;
    }
    return None;
}
public native function bool GetUniquePlayerId(byte LocalUserNum, out UniqueNetId PlayerID);

public native function bool IsGuestLogin(byte LocalUserNum);

public native function bool IsLocalLogin(byte LocalUserNum);

public function bool IsMuted(byte LocalUserNum, UniqueNetId PlayerID);

private final function LoadSettingsCallback(OnlineJobErrorCode eError, int nJob, const out array<SettingsPair> SettingsPairs, int UserNum)
{
    local bool Success;
    local SettingsPair Setting;
    
    ClearAsyncState(UserNum);
    Success = eError == OnlineJobErrorCode.OJEC_None;
    if (Success)
    {
        PlayerStorageCache[UserNum].SetToDefaults();
        foreach SettingsPairs(Setting, )
        {
            if (!PlayerStorageCache[UserNum].SetProfileSettingValueByName(Name(Setting.Key), Setting.Value))
            {
            }
        }
    }
    TriggerProfileReadDelegate(byte(UserNum), Success);
}
public native function bool Login(byte LocalUserNum, string LoginName, string Password, optional bool bWantsLocalOnly);

public native function bool Logout(byte LocalUserNum);

public delegate function OnAddFriendByNameComplete(bool bWasSuccessful);

public delegate function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message);

public delegate function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message);

public delegate function OnFriendsChange();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnJoinFriendGameComplete(bool bWasSuccessful);

public delegate function OnKeyboardInputComplete(bool bWasSuccessful);

public delegate function OnLoginCancelled();

public delegate function OnLoginChange(byte LocalUserNum);

public delegate function OnLoginFailed(byte LocalUserNum, EOnlineServerConnectionStatus errorCode);

public delegate function OnLoginStatusChange(ELoginStatus NewStatus, UniqueNetId NewId);

public delegate function OnLogoutCompleted(bool bWasSuccessful);

public delegate function OnMutingChange();

public delegate function OnProfileDataChanged();

public delegate function OnReadAchievementsComplete(int TitleId);

public delegate function OnReadFriendsComplete(bool bWasSuccessful);

public delegate function OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnReadPlayerStorageForNetIdComplete(UniqueNetId NetId, bool bWasSuccessful);

public delegate function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnReceivedGameInvite(byte LocalUserNum, string InviterName);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public delegate function OnUnlockAchievementComplete(bool bWasSuccessful);

public delegate function OnWritePlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful);

public delegate function OnWriteProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful);

public native function bool ReadAchievements(byte LocalUserNum, optional int TitleId = 0, optional bool bShouldReadText = TRUE, optional bool bShouldReadImages = FALSE);

public native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

public native function bool ReadPlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage);

public native function bool ReadPlayerStorageForNetId(UniqueNetId NetId, OnlinePlayerStorage PlayerStorage);

public native function bool ReadProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

private final function SaveSettingsCallback(OnlineJobErrorCode eError, int nJob, int UserNum)
{
    local bool Success;
    local delegate<OnWritePlayerStorageComplete> WriteDelegate;
    
    ClearAsyncState(UserNum);
    Success = eError == OnlineJobErrorCode.OJEC_None;
    foreach LocalPlayerStorageWriteDelegates(WriteDelegate, )
    {
        WriteDelegate(byte(UserNum), Success);
    }
}
public native function SetOnlineStatus(byte LocalUserNum, int StatusId, const out array<LocalizedStringSetting> LocalizedStringSettings, const out array<SettingsProperty> Properties);

public function bool ShowFriendsUI(byte LocalUserNum);

public function bool ShowKeyboardUI(byte LocalUserNum, string TitleText, string DescriptionText, optional bool bIsPassword = FALSE, optional bool bShouldValidate = TRUE, optional string DefaultText, optional int MaxResultLength = 256);

public native function bool ShowLoginUI(optional bool bShowOnlineOnly = FALSE);

private final event function TriggerProfileReadDelegate(byte UserNum, bool bWasSuccesful)
{
    local delegate<OnReadPlayerStorageComplete> ReadDelegate;
    
    foreach LocalPlayerStorageReadDelegates(ReadDelegate, )
    {
        ReadDelegate(UserNum, bWasSuccesful);
    }
}
public native function bool UnlockAchievement(byte LocalUserNum, int AchievementId);

public native function bool WritePlayerStorage(byte LocalUserNum, OnlinePlayerStorage PlayerStorage);

public native function bool WriteProfileSettings(byte LocalUserNum, OnlineProfileSettings ProfileSettings);

public function bool AcceptFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer);

public function AddAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate);

public function bool AddFriend(byte LocalUserNum, UniqueNetId NewFriend, optional string Message);

public function bool AddFriendByName(byte LocalUserNum, string FriendName, optional string Message);

public function AddFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate);

public function AddFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate);

public function AddFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate);

public function AddJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate);

public function AddKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate);

public function AddLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
    if (LoginCancelledDelegates.Find(CancelledDelegate) == -1)
    {
        LoginCancelledDelegates.AddItem(CancelledDelegate);
    }
}
public function AddLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
    if (LoginChangeDelegates.Find(LoginDelegate) == -1)
    {
        LoginChangeDelegates.AddItem(LoginDelegate);
    }
}
public function AddLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate)
{
    if (LoginFailedDelegates.Find(LoginDelegate) == -1)
    {
        LoginFailedDelegates.AddItem(LoginDelegate);
    }
}
public function AddLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Find(LoginStatusDelegate) == -1)
        {
            PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.AddItem(LoginStatusDelegate);
        }
    }
}
public function AddLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
    if (LogoutCompletedDelegates.Find(LogoutDelegate) == -1)
    {
        LogoutCompletedDelegates.AddItem(LogoutDelegate);
    }
}
public function AddMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate);

public function AddReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Find(ReadAchievementsCompleteDelegate) == -1)
        {
            PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.AddItem(ReadAchievementsCompleteDelegate);
        }
    }
}
public function AddReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
    if (LocalPlayerStorageReadDelegates.Find(ReadPlayerStorageCompleteDelegate) == -1)
    {
        LocalPlayerStorageReadDelegates.AddItem(ReadPlayerStorageCompleteDelegate);
    }
}
public function AddReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
    if (RemotePlayerStorageReadDelegates.Find(ReadPlayerStorageForNetIdCompleteDelegate) == -1)
    {
        RemotePlayerStorageReadDelegates.AddItem(ReadPlayerStorageForNetIdCompleteDelegate);
    }
}
public function AddReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (ProfileCache[int(LocalUserNum)].ReadDelegates.Find(ReadProfileSettingsCompleteDelegate) == -1)
        {
            ProfileCache[int(LocalUserNum)].ReadDelegates[ProfileCache[int(LocalUserNum)].ReadDelegates.Length] = ReadProfileSettingsCompleteDelegate;
        }
    }
}
public function AddReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate);

public function AddUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Find(UnlockAchievementCompleteDelegate) == -1)
        {
            PerUserDelegates[int(LocalUserNum)].AchievementDelegates[PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Length] = UnlockAchievementCompleteDelegate;
        }
    }
}
public function AddWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    if (LocalPlayerStorageWriteDelegates.Find(WritePlayerStorageCompleteDelegate) == -1)
    {
        LocalPlayerStorageWriteDelegates.AddItem(WritePlayerStorageCompleteDelegate);
    }
}
public function AddWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (ProfileCache[int(LocalUserNum)].WriteDelegates.Find(WriteProfileSettingsCompleteDelegate) == -1)
        {
            ProfileCache[int(LocalUserNum)].WriteDelegates[ProfileCache[int(LocalUserNum)].WriteDelegates.Length] = WriteProfileSettingsCompleteDelegate;
        }
    }
}
public function bool AreAnyFriends(byte LocalUserNum, out array<FriendsQuery> Query);

public function ClearAddFriendByNameCompleteDelegate(byte LocalUserNum, delegate<OnAddFriendByNameComplete> FriendDelegate);

public function ClearFriendInviteReceivedDelegate(byte LocalUserNum, delegate<OnFriendInviteReceived> InviteDelegate);

public function ClearFriendMessageReceivedDelegate(byte LocalUserNum, delegate<OnFriendMessageReceived> MessageDelegate);

public function ClearFriendsChangeDelegate(byte LocalUserNum, delegate<OnFriendsChange> FriendsDelegate);

public function ClearJoinFriendGameCompleteDelegate(delegate<OnJoinFriendGameComplete> JoinFriendGameCompleteDelegate);

public function ClearKeyboardInputDoneDelegate(delegate<OnKeyboardInputComplete> InputDelegate);

public function ClearLoginCancelledDelegate(delegate<OnLoginCancelled> CancelledDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LoginCancelledDelegates.Find(CancelledDelegate);
    if (RemoveIndex != -1)
    {
        LoginCancelledDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearLoginChangeDelegate(delegate<OnLoginChange> LoginDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LoginChangeDelegates.Find(LoginDelegate);
    if (RemoveIndex != -1)
    {
        LoginChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearLoginFailedDelegate(byte LocalUserNum, delegate<OnLoginFailed> LoginDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LoginFailedDelegates.Find(LoginDelegate);
    if (RemoveIndex != -1)
    {
        LoginFailedDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearLoginStatusChangeDelegate(delegate<OnLoginStatusChange> LoginStatusDelegate, byte LocalUserNum)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Find(LoginStatusDelegate);
        if (RemoveIndex != -1)
        {
            PlayerLoginStatusDelegates[int(LocalUserNum)].Delegates.Remove(RemoveIndex, 1);
        }
    }
}
public function ClearLogoutCompletedDelegate(byte LocalUserNum, delegate<OnLogoutCompleted> LogoutDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LogoutCompletedDelegates.Find(LogoutDelegate);
    if (RemoveIndex != -1)
    {
        LogoutCompletedDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearMutingChangeDelegate(delegate<OnMutingChange> MutingDelegate);

public function ClearReadAchievementsCompleteDelegate(byte LocalUserNum, delegate<OnReadAchievementsComplete> ReadAchievementsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Find(ReadAchievementsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            PerUserDelegates[int(LocalUserNum)].AchievementReadDelegates.Remove(RemoveIndex, 1);
        }
    }
}
public function ClearReadPlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LocalPlayerStorageReadDelegates.Find(ReadPlayerStorageCompleteDelegate);
    if (RemoveIndex != -1)
    {
        LocalPlayerStorageReadDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearReadPlayerStorageForNetIdCompleteDelegate(UniqueNetId NetId, delegate<OnReadPlayerStorageForNetIdComplete> ReadPlayerStorageForNetIdCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = RemotePlayerStorageReadDelegates.Find(ReadPlayerStorageForNetIdCompleteDelegate);
    if (RemoveIndex != -1)
    {
        RemotePlayerStorageReadDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearReadProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnReadProfileSettingsComplete> ReadProfileSettingsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = ProfileCache[int(LocalUserNum)].ReadDelegates.Find(ReadProfileSettingsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            ProfileCache[int(LocalUserNum)].ReadDelegates.Remove(RemoveIndex, 1);
        }
    }
}
public function ClearReceivedGameInviteDelegate(byte LocalUserNum, delegate<OnReceivedGameInvite> ReceivedGameInviteDelegate);

public function ClearUnlockAchievementCompleteDelegate(byte LocalUserNum, delegate<OnUnlockAchievementComplete> UnlockAchievementCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Find(UnlockAchievementCompleteDelegate);
        if (RemoveIndex != -1)
        {
            PerUserDelegates[int(LocalUserNum)].AchievementDelegates.Remove(RemoveIndex, 1);
        }
    }
}
public function ClearWritePlayerStorageCompleteDelegate(byte LocalUserNum, delegate<OnWritePlayerStorageComplete> WritePlayerStorageCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LocalPlayerStorageWriteDelegates.Find(WritePlayerStorageCompleteDelegate);
    if (RemoveIndex != -1)
    {
        LocalPlayerStorageWriteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearWriteProfileSettingsCompleteDelegate(byte LocalUserNum, delegate<OnWriteProfileSettingsComplete> WriteProfileSettingsCompleteDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = ProfileCache[int(LocalUserNum)].WriteDelegates.Find(WriteProfileSettingsCompleteDelegate);
        if (RemoveIndex != -1)
        {
            ProfileCache[int(LocalUserNum)].WriteDelegates.Remove(RemoveIndex, 1);
        }
    }
}
public function bool DeleteMessage(byte LocalUserNum, int MessageIndex);

public function bool DenyFriendInvite(byte LocalUserNum, UniqueNetId RequestingPlayer);

public function GetFriendMessages(byte LocalUserNum, out array<OnlineFriendMessage> FriendMessages);

public function string GetKeyboardInputResults(out byte bWasCanceled);

public function OnlinePlayerStorage GetPlayerStorage(byte LocalUserNum)
{
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        return PlayerStorageCache[int(LocalUserNum)];
    }
    return None;
}
public function bool IsFriend(byte LocalUserNum, UniqueNetId PlayerID);

public function bool JoinFriendGame(byte LocalUserNum, UniqueNetId Friend);

public function bool RemoveFriend(byte LocalUserNum, UniqueNetId FormerFriend);

public function bool SendGameInviteToFriend(byte LocalUserNum, UniqueNetId Friend, optional string Text);

public function bool SendGameInviteToFriends(byte LocalUserNum, array<UniqueNetId> Friends, optional string Text);

public function bool SendMessageToFriend(byte LocalUserNum, UniqueNetId Friend, string Message);

public function ClearOnlineProfileCaches()
{
    local int idx;
    
    for (idx = 0; idx < 4; idx++)
    {
        PlayerStorageCache[idx] = None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoggedInPlayerName = "Local Profile"
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}
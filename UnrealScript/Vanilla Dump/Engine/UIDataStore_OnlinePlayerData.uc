Class UIDataStore_OnlinePlayerData extends UIDataStore_Remote
    implements(UIListElementProvider)
    native
    transient
    config(Engine);

var const native noexport Pointer VfTable_IUIListElementProvider;
var string PlayerNick;
var config string ProfileSettingsClassName;
var config string PlayerStorageClassName;
var config string FriendsProviderClassName;
var config string PlayersProviderClassName;
var config string ClanMatesProviderClassName;
var config string FriendMessagesProviderClassName;
var config string AchievementsProviderClassName;
var config string PartyChatProviderClassName;
var Class<OnlineProfileSettings> ProfileSettingsClass;
var Class<OnlinePlayerStorage> PlayerStorageClass;
var Class<UIDataProvider_OnlineFriends> FriendsProviderClass;
var Class<UIDataProvider_OnlinePlayers> PlayersProviderClass;
var Class<UIDataProvider_OnlineClanMates> ClanMatesProviderClass;
var Class<UIDataProvider_OnlineFriendMessages> FriendMessagesProviderClass;
var Class<UIDataProvider_PlayerAchievements> AchievementsProviderClass;
var Class<UIDataProvider_OnlinePartyChatList> PartyChatProviderClass;
var UIDataProvider_OnlineFriends FriendsProvider;
var UIDataProvider_OnlinePlayers PlayersProvider;
var UIDataProvider_OnlineClanMates ClanMatesProvider;
var LocalPlayer Player;
var int NumNewDownloads;
var int NumTotalDownloads;
var UIDataProvider_OnlineProfileSettings ProfileProvider;
var UIDataProvider_OnlinePlayerStorage StorageProvider;
var UIDataProvider_OnlineFriendMessages FriendMessagesProvider;
var UIDataProvider_PlayerAchievements AchievementsProvider;
var UIDataProvider_OnlinePartyChatList PartyChatProvider;

public static event function OnlineProfileSettings GetCachedPlayerProfile(int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local OnlineProfileSettings Result;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            Result = PlayerInterface.GetProfileSettings(byte(ControllerId));
        }
    }
    return Result;
}
public static event function OnlinePlayerStorage GetCachedPlayerStorage(int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local OnlinePlayerStorage Result;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            Result = PlayerInterface.GetPlayerStorage(byte(ControllerId));
        }
    }
    return Result;
}
public function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (int(LocalUserNum) == Player.ControllerId)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None && int(PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
            {
                if (OnlineSub.ContentInterface != None)
                {
                    OnlineSub.ContentInterface.QueryAvailableDownloads(byte(Player.ControllerId));
                }
                PlayerNick = PlayerInterface.GetPlayerNickname(byte(Player.ControllerId));
            }
            else
            {
                PlayerNick = "";
                NumNewDownloads = 0;
                NumTotalDownloads = 0;
            }
        }
        RefreshSubscribers();
    }
}
public event function OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Player = InPlayer;
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
            }
            if (OnlineSub.PlayerInterfaceEx != None)
            {
                OnlineSub.PlayerInterfaceEx.AddProfileDataChangedDelegate(byte(Player.ControllerId), OnPlayerDataChange);
            }
            if (OnlineSub.ContentInterface != None)
            {
                OnlineSub.ContentInterface.AddQueryAvailableDownloadsComplete(byte(Player.ControllerId), OnDownloadableContentQueryDone);
            }
        }
        else if (ProfileProvider != None && ProfileProvider.Profile != None)
        {
            ProfileProvider.Profile.SetToDefaults();
        }
        RegisterDelegates();
        OnLoginChange(byte(Player.ControllerId));
    }
}
public final native function OnSettingProviderChanged(UIDataProvider SourceProvider, optional Name SettingsName);

public event function OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (Player != None)
    {
        ClearDelegates();
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            }
            if (OnlineSub.PlayerInterfaceEx != None)
            {
                OnlineSub.PlayerInterfaceEx.ClearProfileDataChangedDelegate(byte(Player.ControllerId), OnPlayerDataChange);
            }
            if (OnlineSub.ContentInterface != None)
            {
                OnlineSub.ContentInterface.ClearQueryAvailableDownloadsComplete(byte(Player.ControllerId), OnDownloadableContentQueryDone);
            }
        }
    }
}
public event function bool SaveProfileData()
{
    if (ProfileProvider != None)
    {
        return ProfileProvider.SaveStorageData();
    }
    return FALSE;
}
public function ClearDelegates()
{
    FriendsProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    FriendMessagesProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    PlayersProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    ClanMatesProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    ProfileProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    AchievementsProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
    StorageProvider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
}
public function OnDownloadableContentQueryDone(bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.ContentInterface != None)
    {
        if (bWasSuccessful)
        {
            OnlineSub.ContentInterface.GetAvailableDownloadCounts(byte(Player.ControllerId), NumNewDownloads, NumTotalDownloads);
            RefreshSubscribers();
        }
    }
}
public function OnPlayerDataChange()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        if (OnlineSub.PlayerInterface != None)
        {
            PlayerNick = OnlineSub.PlayerInterface.GetPlayerNickname(byte(Player.ControllerId));
            RefreshSubscribers();
        }
    }
}
public function RegisterDelegates()
{
    FriendsProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    FriendMessagesProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    PlayersProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    ClanMatesProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    ProfileProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    AchievementsProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
    StorageProvider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayerNick = "PlayerNickNameHere"
    ProfileSettingsClassName = "SFXGame.SFXProfileSettings"
    PartyChatProviderClassName = "Engine.UIDataProvider_OnlinePartyChatList"
    Tag = 'OnlinePlayerData'
}
Class SFXOnlineComponentPlatformXenon extends SFXOnlineComponent
    implements(ISFXOnlineComponentPlatform)
    native
    config(Engine);

struct native CachedLoginState 
{
    var const UniqueNetId OnlineXuid;
    var const UniqueNetId OfflineXuid;
    var const ELoginStatus LoginStatus;
};
struct native SFXOnlineXenonCustomPlayerListButton 
{
    var string CustomText;
    var SFXOnlineXenonPlayerListButtonType Type;
};
enum SFXOnlineXenonPlayerListButtonType
{
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_TITLECUSTOM,
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_PLAYERREVIEW,
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_GAMEINVITE,
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_MESSAGE,
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_FRIENDREQUEST,
    SFXONLINE_XENON_PLAYERLIST_BUTTON_TYPE_NONE,
};

var const native noexport Pointer VfTable_IISFXOnlineComponentPlatform;
var const CachedLoginState LastLoginState[4];
var native array<Pointer> OverlappedTasks;
var array<OnlineFriend> CachedFriendList;
var const transient native Pointer NotificationHandle;
var const int NumLogins;
var config int MaxNumFriends;
var int LastInputDeviceConnectedMask;
var transient float SigninCountDownCounter;
var float SigninCountDownDelay;
var int NumPartyMembers;
var const bool bIsInSignInUI;
var transient bool bIsCountingDownSigninNotification;
var byte CachedLocalUserNumForAsyncRequest;

public native function bool AddRecentPlayer(UniqueNetId oPlayerId, optional string sDescription);

public native function EFeaturePrivilegeLevel CanCommunicate(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanPlayOnline(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanPurchaseContent(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte eLocalUserNum);

public native function Name GetAPIName();

public native function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

public native function ELoginStatus GetLoginStatus(byte eLocalUserNum);

public native function int GetMinimumAgeForOnlinePlay();

public native function bool GetOfflineXuid(int nUserIndex, out UniqueNetId oPlayerXuid);

public native function bool GetOnlineXuid(int nUserIndex, out UniqueNetId oPlayerXuid);

public event function bool IsPlayerInActiveParty()
{
    return NumPartyMembers > 1;
}
public event function bool IsPlayerInParty()
{
    return NumPartyMembers > 0;
}
public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

public native function SetRichPresence(byte eLocalUserNum, int nPresenceMode, const out array<LocalizedStringSetting> aLocalizedStringSettings, const out array<SettingsProperty> aProperties);

public native function bool ShowAchievementsUI(byte byLocalUserNum);

public native function bool ShowFeedbackUI(byte eLocalUserNum, UniqueNetId oPlayerXuid);

public native function bool ShowFriendsInviteUI(byte eLocalUserNum, UniqueNetId oPlayerXuid);

public native function bool ShowFriendsUI(byte eLocalUserNum);

public native function bool ShowGamerCardUI(byte eLocalUserNum, UniqueNetId oUniqueNetId);

public native function bool ShowInbox();

public native function bool ShowInviteUI(byte LocalUserNum, optional string InviteText);

public native function bool ShowKeyboardUI(byte LocalUserNum, string sTitleText, string sDescriptionText, optional EKeyboardType nKeyboardType = 0, optional bool bShouldValidate = TRUE, optional bool bRouteThroughConsole = FALSE, optional string sDefaultText, optional int nMaxResultLength = 256);

public native function bool ShowLoginUI(optional bool bShowOnlineOnly = FALSE);

public native function bool ShowStoreUI();

public native function bool ShowVoiceCommandTunerUI();

private final native function TickAsyncTasks();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NumLogins = 1
    MaxNumFriends = 100
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}
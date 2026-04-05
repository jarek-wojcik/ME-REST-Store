Class SFXOnlineComponentPlatformPS3 extends SFXOnlineComponent
    implements(ISFXOnlineComponentPlatform)
    native
    config(Engine);

struct native SFXPS3_MinimumAgeData 
{
    var string Country;
    var int MinimumAge;
};
struct native SFXPS3_BootCheckData 
{
    var string DirName;
    var int Type;
    var int Attributes;
    var int hddFreeSizeKB;
    var int sizeKB;
    var int sysSizeKB;
    var int Commerce2Userdata;
};

var const native noexport Pointer VfTable_IISFXOnlineComponentPlatform;
var UniqueNetId mInviterId;
var config array<SFXPS3_MinimumAgeData> MinimumAgeByCountry;
var array<UniqueNetId> PendingRecentPlayers;
var delegate<OnSignInComplete> __OnSignInComplete__Delegate;
var config stringref srInviteFriend;
var int mAttachmentDataId;
var int CachedFriendsListVersion;
var int LastInputDeviceConnectedMask;
var bool mDispatchInviteOnNextTick;
var bool m_bLaunchedSignInUI;

public native function bool AddRecentPlayer(UniqueNetId oPlayerId, optional string sDescription);

public native function EFeaturePrivilegeLevel CanCommunicate(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanPlayOnline(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanPurchaseContent(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(byte eLocalUserNum);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte eLocalUserNum);

private final native function DispatchInviteEvent();

public native function Name GetAPIName();

public native function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

public native function bool GetInviterUniqueNetId(out UniqueNetId InviterUniqueNetId);

public native function ELoginStatus GetLoginStatus(byte eLocalUserNum);

public native function int GetMinimumAgeForOnlinePlay();

public native function bool GetOfflineXuid(int nUserIndex, out UniqueNetId oPlayerXuid);

public native function bool GetOnlineXuid(int nUserIndex, out UniqueNetId oPlayerXuid);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

private final native function OnKeyboardUI(SFXOnlineEvent oEvent);

private final native function OnPlayerSeen(SFXOnlineEvent oEvent);

public native function OnRelease();

public delegate function OnSignInComplete(bool bSignedIn);

private final native function OnTick(SFXOnlineEvent oEvent);

public native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

private final native function RegisterPS3CustomMenuActions();

public native function SetRichPresence(byte eLocalUserNum, int nPresenceMode, const out array<LocalizedStringSetting> aLocalizedStringSettings, const out array<SettingsProperty> aProperties);

public native function bool ShowAchievementsUI(byte byLocalUserNum);

public native function bool ShowFeedbackUI(byte eLocalUserNum, UniqueNetId oPlayerId);

public native function bool ShowFriendsInviteUI(byte eLocalUserNum, UniqueNetId oPlayerXuid);

public native function bool ShowFriendsUI(byte eLocalUserNum);

public native function bool ShowGamerCardUI(byte eLocalUserNum, UniqueNetId oPlayerId);

public native function bool ShowInbox();

public native function bool ShowInviteUI(byte LocalUserNum, optional string InviteText);

public native function bool ShowKeyboardUI(byte LocalUserNum, string sTitleText, string sDescriptionText, optional EKeyboardType nKeyboardType = 0, optional bool bShouldValidate = TRUE, optional bool bRouteThroughConsole = FALSE, optional string sDefaultText, optional int nMaxResultLength = 256);

public native function bool ShowLoginUI(optional bool bShowOnlineOnly = FALSE);

public native function bool ShowLoginUIEx(optional delegate<OnSignInComplete> funcSignInComplete = None);

public native function bool ShowStoreUI();

public native function bool ShowVoiceCommandTunerUI();

public native function StartInviteFlow(int attachmentDataId);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srInviteFriend = $676867
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}, 
                            {EventCallback = 'OnKeyboardUI', EventType = SFXOnlineEventType.SFXONLINE_EVENT_PLATFORM_UI_KEYBOARD}, 
                            {EventCallback = 'OnPlayerSeen', EventType = SFXOnlineEventType.SFXONLINE_EVENT_SEEN_PLAYER}
                           )
}
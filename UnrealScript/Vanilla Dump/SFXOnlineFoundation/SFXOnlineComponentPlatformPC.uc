Class SFXOnlineComponentPlatformPC extends SFXOnlineComponent
    implements(ISFXOnlineComponentPlatform)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponentPlatform;
var array<OnlineFriend> CachedFriendListPC;

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

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

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

public native function bool ShowStoreUI();

public native function bool ShowVoiceCommandTunerUI();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
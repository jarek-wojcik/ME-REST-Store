Class ISFXOnlineComponentPlatform extends ISFXOnlineComponent
    native
    abstract;

enum EKeyboardType
{
    KT_Standard,
    KT_Password,
    KT_Email,
    KT_Code,
};

public native function bool AddRecentPlayer(UniqueNetId oPlayerId, optional string sDescription);

public native function EFeaturePrivilegeLevel CanCommunicate(byte byLocalUserNum);

public native function EFeaturePrivilegeLevel CanDownloadUserContent(byte byLocalUserNum);

public native function EFeaturePrivilegeLevel CanPlayOnline(byte byLocalUserNum);

public native function EFeaturePrivilegeLevel CanPurchaseContent(byte byLocalUserNum);

public native function EFeaturePrivilegeLevel CanShowPresenceInformation(byte byLocalUserNum);

public native function EFeaturePrivilegeLevel CanViewPlayerProfiles(byte byLocalUserNum);

public native function EOnlineEnumerationReadState GetFriendsList(byte LocalUserNum, out array<OnlineFriend> Friends, optional int Count, optional int StartingAt);

public native function ELoginStatus GetLoginStatus(byte byLocalUserNum);

public native function int GetMinimumAgeForOnlinePlay();

public native function bool GetOfflineXuid(int nUserIndex, out UniqueNetId oUserXuid);

public native function bool GetOnlineXuid(int nUserIndex, out UniqueNetId oUserXuid);

public native function bool ReadFriendsList(byte LocalUserNum, optional int Count, optional int StartingAt);

public native function SetRichPresence(byte byLocalUserNum, int nPresenceMode, const out array<LocalizedStringSetting> aLocalizedStringSettings, const out array<SettingsProperty> aProperties);

public native function bool ShowAchievementsUI(byte byLocalUserNum);

public native function bool ShowFeedbackUI(byte byLocalUserNum, UniqueNetId oPlayerId);

public native function bool ShowFriendsInviteUI(byte byLocalUserNum, UniqueNetId oPlayerId);

public native function bool ShowFriendsUI(byte byLocalUserNum);

public native function bool ShowGamerCardUI(byte byLocalUserNum, UniqueNetId oPlayerId);

public native function bool ShowInbox();

public native function bool ShowInviteUI(byte LocalUserNum, optional string InviteText);

public native function bool ShowKeyboardUI(byte byLocalUserNum, string sTitleText, string sDescriptionText, optional EKeyboardType nKeyboardType = 0, optional bool bShouldValidate = TRUE, optional bool bRouteThroughConsole = FALSE, optional string sDefaultText, optional int nMaxResultLength = 256);

public native function bool ShowLoginUI(optional bool bShowOnlineOnly = FALSE);

public native function bool ShowStoreUI();

public native function bool ShowVoiceCommandTunerUI();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
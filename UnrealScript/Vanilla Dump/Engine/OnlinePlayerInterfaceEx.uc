Class OnlinePlayerInterfaceEx extends Interface
    abstract;

var delegate<OnProfileDataChanged> __OnProfileDataChanged__Delegate;
var delegate<OnDeviceSelectionComplete> __OnDeviceSelectionComplete__Delegate;

public function int GetDeviceSelectionResults(byte LocalUserNum, out string DeviceName);

public function bool IsDeviceValid(int DeviceID, optional int SizeNeeded);

public delegate function OnDeviceSelectionComplete(bool bWasSuccessful, bool bWasBlocked);

public delegate function OnProfileDataChanged();

public function bool ShowAchievementsUI(byte LocalUserNum);

public function bool ShowDeviceSelectionUI(byte LocalUserNum, int SizeNeeded, optional bool bForceShowUI, optional bool bManageStorage);

public function bool ShowFeedbackUI(byte LocalUserNum, UniqueNetId PlayerID);

public function bool ShowFriendsInviteUI(byte LocalUserNum, UniqueNetId PlayerID);

public function bool ShowGamerCardUI(byte LocalUserNum, UniqueNetId PlayerID);

public function bool ShowInviteUI(byte LocalUserNum, optional string InviteText);

public function bool UnlockAvatarAward(byte LocalUserNum, int AvatarItemId);

public function AddDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate);

public function AddProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate);

public function ClearDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate);

public function ClearProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate);

public function bool ShowContentMarketplaceUI(byte LocalUserNum, optional int CategoryMask = -1, optional int offerId);

public function bool ShowCustomPlayersUI(byte LocalUserNum, const out array<UniqueNetId> Players, string Title, string Description);

public function bool ShowMembershipMarketplaceUI(byte LocalUserNum);

public function bool ShowMessagesUI(byte LocalUserNum);

public function bool ShowPlayersUI(byte LocalUserNum);

public function bool UnlockGamerPicture(byte LocalUserNum, int PictureId);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
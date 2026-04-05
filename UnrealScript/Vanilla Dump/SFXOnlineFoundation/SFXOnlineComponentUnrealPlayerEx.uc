Class SFXOnlineComponentUnrealPlayerEx extends SFXOnlineComponent
    implements(OnlinePlayerInterfaceEx, ISFXOnlineComponent)
    native;

struct native SFXDeviceIdCache 
{
    var delegate<OnDeviceSelectionComplete> DeviceSelectionMulticast;
    var array<delegate<OnDeviceSelectionComplete>> DeviceSelectionDelegates;
    var int DeviceID;
    
    structdefaultproperties
    {
        DeviceSelectionDelegates = ()
    }
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var SFXDeviceIdCache DeviceCache[4];
var delegate<OnDeviceSelectionComplete> __OnDeviceSelectionComplete__Delegate;
var delegate<OnProfileDataChanged> __OnProfileDataChanged__Delegate;

public native function Name GetAPIName();

public native function int GetDeviceSelectionResults(byte LocalUserNum, out string DeviceName);

public native function bool IsDeviceValid(int DeviceID, optional int SizeNeeded);

public delegate function OnDeviceSelectionComplete(bool bWasSuccessful, bool bWasBlocked);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnProfileDataChanged();

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public function bool ShowAchievementsUI(byte LocalUserNum);

public native function bool ShowDeviceSelectionUI(byte LocalUserNum, int SizeNeeded, optional bool bForceShowUI, optional bool bManageStorage);

public function bool ShowFeedbackUI(byte LocalUserNum, UniqueNetId PlayerID);

public function bool ShowFriendsInviteUI(byte LocalUserNum, UniqueNetId PlayerID)
{
    return OnlineSubsystem.GetComponentPlatform().ShowFriendsInviteUI(LocalUserNum, PlayerID);
}
public function bool ShowGamerCardUI(byte LocalUserNum, UniqueNetId PlayerID);

public function bool ShowInviteUI(byte LocalUserNum, optional string InviteText)
{
    return OnlineSubsystem.GetComponentPlatform().ShowInviteUI(LocalUserNum, InviteText);
}
public native function bool UnlockAvatarAward(byte LocalUserNum, int AvatarItemId);

public function AddDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
    local int AddIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        if (DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Find(DeviceDelegate) == -1)
        {
            AddIndex = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length;
            DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Length + 1;
            DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates[AddIndex] = DeviceDelegate;
        }
    }
}
public function AddProfileDataChangedDelegate(byte LocalUserNum, delegate<OnProfileDataChanged> ProfileDataChangedDelegate);

public function ClearDeviceSelectionDoneDelegate(byte LocalUserNum, delegate<OnDeviceSelectionComplete> DeviceDelegate)
{
    local int RemoveIndex;
    
    if (int(LocalUserNum) >= 0 && int(LocalUserNum) < 4)
    {
        RemoveIndex = DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Find(DeviceDelegate);
        if (RemoveIndex != -1)
        {
            DeviceCache[int(LocalUserNum)].DeviceSelectionDelegates.Remove(RemoveIndex, 1);
        }
    }
}
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
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}
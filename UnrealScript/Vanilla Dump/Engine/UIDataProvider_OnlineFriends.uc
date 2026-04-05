Class UIDataProvider_OnlineFriends extends UIDataProvider_OnlinePlayerDataBase
    implements(UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlineFriend> FriendsList;
var const localized string NickNameCol;
var const localized string PresenceInfoCol;
var const localized string FriendStateCol;
var const localized string bIsOnlineCol;
var const localized string bIsPlayingCol;
var const localized string bIsPlayingThisGameCol;
var const localized string bIsJoinableCol;
var const localized string bHasVoiceSupportCol;
var const localized string bHaveInvitedCol;
var const localized string bHasInvitedYouCol;
var const localized string OfflineText;
var const localized string OnlineText;
var const localized string AwayText;
var const localized string BusyText;

public function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    FriendsList.Length = 0;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None && int(PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
        {
            PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
        }
    }
    NotifyPropertyChanged();
}
public event function OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Super.OnRegister(InPlayer);
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
                PlayerInterface.AddReadFriendsCompleteDelegate(byte(Player.ControllerId), OnFriendsReadComplete);
                PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
            }
        }
    }
}
public event function OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.ClearReadFriendsCompleteDelegate(byte(Player.ControllerId), OnFriendsReadComplete);
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
    }
    Super.OnUnregister();
}
public event function RefreshFriendsList()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.ReadFriendsList(byte(Player.ControllerId));
            }
        }
    }
}
public function OnFriendsReadComplete(bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (bWasSuccessful)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.GetFriendsList(byte(Player.ControllerId), FriendsList);
            }
        }
        NotifyPropertyChanged();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NickNameCol = "Name"
    PresenceInfoCol = "Online Status"
    bIsOnlineCol = "Is Online"
    bIsPlayingCol = "Is Playing"
    bIsPlayingThisGameCol = "Is Playing This Game"
    bIsJoinableCol = "Is Joinable"
    bHasVoiceSupportCol = "Has Voice Support"
    OfflineText = "Offline"
    OnlineText = "Online"
    AwayText = "Away"
    BusyText = "Busy"
}
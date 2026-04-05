Class UIDataProvider_OnlineFriendMessages extends UIDataProvider_OnlinePlayerDataBase
    implements(UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlineFriendMessage> Messages;
var const localized string SendingPlayerNameCol;
var const localized string bIsFriendInviteCol;
var const localized string bWasAcceptedCol;
var const localized string bWasDeniedCol;
var const localized string MessageCol;
var string LastInviteFrom;

public function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
    ReadMessages();
}
public function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
    ReadMessages();
}
public function OnLoginChange(byte LocalUserNum)
{
    if (int(LocalUserNum) == Player.ControllerId)
    {
        ReadMessages();
    }
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
                PlayerInterface.AddFriendMessageReceivedDelegate(byte(Player.ControllerId), OnFriendMessageReceived);
                PlayerInterface.AddFriendInviteReceivedDelegate(byte(Player.ControllerId), OnFriendInviteReceived);
                PlayerInterface.AddReceivedGameInviteDelegate(byte(Player.ControllerId), OnGameInviteReceived);
                ReadMessages();
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
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            PlayerInterface.ClearFriendMessageReceivedDelegate(byte(Player.ControllerId), OnFriendMessageReceived);
            PlayerInterface.ClearFriendInviteReceivedDelegate(byte(Player.ControllerId), OnFriendInviteReceived);
            PlayerInterface.ClearReceivedGameInviteDelegate(byte(Player.ControllerId), OnGameInviteReceived);
        }
    }
    Super.OnUnregister();
}
public function OnGameInviteReceived(byte LocalUserNum, string InviterName)
{
    LastInviteFrom = InviterName;
    ReadMessages();
}
public function ReadMessages()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Messages.Length = 0;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None && int(PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
        {
            PlayerInterface.GetFriendMessages(byte(Player.ControllerId), Messages);
        }
    }
    NotifyPropertyChanged();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SendingPlayerNameCol = "Sender's Name"
    bIsFriendInviteCol = "Friend Invitation"
    bWasAcceptedCol = "Friend Was Accepted"
    bWasDeniedCol = "Friend Was Denied"
    MessageCol = "Message"
}
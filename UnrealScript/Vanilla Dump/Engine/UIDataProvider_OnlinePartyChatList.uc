Class UIDataProvider_OnlinePartyChatList extends UIDataProvider_OnlinePlayerDataBase
    implements(UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var array<OnlinePartyMember> PartyMembersList;
var const localized array<string> NatTypes;
var const localized string NickNameCol;
var const localized string NatTypeCol;
var const localized string IsLocalCol;
var const localized string IsInPartyVoiceCol;
var const localized string IsTalkingCol;
var const localized string IsInGameSessionCol;
var const localized string IsPlayingThisGameCol;

public function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    PartyMembersList.Length = 0;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None && int(PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
        {
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
        }
    }
    Super.OnUnregister();
}
public event function RefreshMembersList()
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
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NatTypes = ("Unknown")
}
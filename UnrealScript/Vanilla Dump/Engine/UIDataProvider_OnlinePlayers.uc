Class UIDataProvider_OnlinePlayers extends UIDataProvider_OnlinePlayerDataBase
    implements(UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;

public event function OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Super.OnRegister(InPlayer);
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (Player != None)
    {
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
            }
        }
    }
}
public function OnPlayersReadComplete()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
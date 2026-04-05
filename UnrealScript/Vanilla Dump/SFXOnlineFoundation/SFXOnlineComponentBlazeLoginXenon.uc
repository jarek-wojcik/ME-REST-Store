Class SFXOnlineComponentBlazeLoginXenon extends SFXOnlineComponentBlazeLogin
    native
    config(Game);

var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;

public native function bool HasInternetConnection();

public delegate function OnExternalUIChange(bool bIsOpening);

public function bool Show1stPartyServiceLoginImp()
{
    local bool Success;
    local SFXOnlineSubsystem oOnlineSubsystem;
    local OnlineSystemInterface SystemInt;
    local ISFXOnlineComponentPlatform CompPlatform;
    
    Success = FALSE;
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        SystemInt = oOnlineSubsystem.SystemInterface;
        CompPlatform = oOnlineSubsystem.GetComponentPlatform();
        if (SystemInt != None && CompPlatform != None)
        {
            SystemInt.AddExternalUIChangeDelegate(XenonLoginResult);
            Success = oOnlineSubsystem.GetComponentPlatform().ShowLoginUI();
            if (!Success)
            {
                SystemInt.ClearExternalUIChangeDelegate(XenonLoginResult);
            }
        }
    }
    return Success;
}
public function XenonLoginResult(bool isOpening)
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    if (!isOpening)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            SystemInt = OnlineSub.SystemInterface;
            if (SystemInt != None)
            {
                SystemInt.ClearExternalUIChangeDelegate(XenonLoginResult);
                On1stPartyServiceLoginResult(IsConnectedTo1stPartyOnlineService());
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
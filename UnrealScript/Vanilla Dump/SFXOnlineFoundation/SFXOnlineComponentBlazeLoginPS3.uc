Class SFXOnlineComponentBlazeLoginPS3 extends SFXOnlineComponentBlazeLogin
    native
    config(Game);

public native function bool GetDefaultBiowareEmailAllowed();

public native function bool HasInternetConnection();

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
            Success = SFXOnlineComponentPlatformPS3(CompPlatform).ShowLoginUIEx(On1stPartyServiceLoginResult);
        }
    }
    return Success;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
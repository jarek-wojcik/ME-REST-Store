Class SFXOnlineJobGaWHTTPRequest extends SFXOnlineJob
    native
    config(Game);

var SFXOnlineHTTPRequest mAuthHTTPRequest;
var SFXOnlineHTTPRequest mSecondHTTPRequest;
var int mBlazeErrorCode;
var bool bKickedOffAuthRequest;
var bool bKickedOffSecondRequest;

public event function AuthenticateHTTP(string token, int tokenType)
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetAuthenticationHTTPRequest(token, tokenType, mAuthHTTPRequest);
    bKickedOffAuthRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mAuthHTTPRequest);
}
public native function AuthenticateHTTPResult();

public event function bool AuthorizationFailed()
{
    if (RunningError == OnlineJobErrorCode.OJEC_AuthorizationRequired)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public native function GetAuthToken();

public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public function OnRelease()
{
    Super.OnRelease();
}
public event function QueueSecondHTTPRequest()
{
}
public event function bool ShouldReschedule()
{
    if (AuthorizationFailed() && GetSchedulingsLeft() > 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function Tick()
{
    TickInternal();
}
public native function TickInternal();

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 1
    JobCategory = OnlineJobCategory.OJC_HTTPSystem
    JobType = OnlineJobType.OJT_GalaxyAtWarHTTPRequest
}
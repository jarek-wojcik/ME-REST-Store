Class SFXOnlineJobGetAuthToken extends SFXOnlineJob
    native
    config(Game);

var delegate<OnAuthTokenRetrieved> __OnAuthTokenRetrieved__Delegate;

public static event function SFXOnlineJobGetAuthToken CreateGetAuthTokenJob(delegate<OnAuthTokenRetrieved> AuthTokenRetrievedDelegate)
{
    local SFXOnlineJobGetAuthToken Job;
    
    Job = new Class'SFXOnlineJobGetAuthToken';
    Job.__OnAuthTokenRetrieved__Delegate = AuthTokenRetrievedDelegate;
    return Job;
}
public delegate function OnAuthTokenRetrieved(string token);

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 3
    JobCategory = OnlineJobCategory.OJC_GetAuthToken
    JobType = OnlineJobType.OJT_GetAuthToken
}
Class SFXOnlineJobGaWHTTPGetRatings extends SFXOnlineJobGaWHTTPRequest
    native
    config(Game);

var delegate<OnGetRatingsComplete> __OnGetRatingsComplete__Delegate;
var config int MaxSecurityRating;
var bool getWarAssets;

public static event function SFXOnlineJobGaWHTTPGetRatings CreateGaWGetRatingsJob(bool includeWarAssets, delegate<OnGetRatingsComplete> RequestCompleteDelegate)
{
    local SFXOnlineJobGaWHTTPGetRatings Job;
    
    Job = new Class'SFXOnlineJobGaWHTTPGetRatings';
    Job.mAuthHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.mSecondHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.__OnGetRatingsComplete__Delegate = RequestCompleteDelegate;
    Job.getWarAssets = includeWarAssets;
    return Job;
}
public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public delegate function OnGetRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

public function OnRelease()
{
    local array<int> updatedSecurityRatings;
    local array<int> updatedWarAssets;
    local int Level;
    
    Super.OnRelease();
    if (RunningError != OnlineJobErrorCode.OJEC_None)
    {
        updatedSecurityRatings.Length = 0;
        updatedWarAssets.Length = 0;
        Level = 0;
        __OnGetRatingsComplete__Delegate(updatedSecurityRatings, updatedWarAssets, Level, mBlazeErrorCode);
    }
}
public event function QueueSecondHTTPRequest()
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetRatingsHTTPRequest(getWarAssets, mSecondHTTPRequest);
    bKickedOffSecondRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mSecondHTTPRequest);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxSecurityRating = 100
}
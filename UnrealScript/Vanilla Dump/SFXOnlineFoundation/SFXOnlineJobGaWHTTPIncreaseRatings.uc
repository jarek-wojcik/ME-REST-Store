Class SFXOnlineJobGaWHTTPIncreaseRatings extends SFXOnlineJobGaWHTTPRequest
    native
    config(Game);

var array<MapEntry> securityRatingIncrease;
var array<MapEntry> warAssetIncrease;
var delegate<OnIncreaseRatingsComplete> __OnIncreaseRatingsComplete__Delegate;
var int defaultRatingIncrease;

public static event function SFXOnlineJobGaWHTTPIncreaseRatings CreateGaWIncreaseRatingsJob(int inDefaultRatingIncrease, array<MapEntry> inSecurityRatingIncrease, array<MapEntry> inWarAssetIncrease, delegate<OnIncreaseRatingsComplete> RequestCompleteDelegate)
{
    local SFXOnlineJobGaWHTTPIncreaseRatings Job;
    
    Job = new Class'SFXOnlineJobGaWHTTPIncreaseRatings';
    Job.mAuthHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.mSecondHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.__OnIncreaseRatingsComplete__Delegate = RequestCompleteDelegate;
    Job.defaultRatingIncrease = inDefaultRatingIncrease;
    Job.securityRatingIncrease = inSecurityRatingIncrease;
    Job.warAssetIncrease = inWarAssetIncrease;
    return Job;
}
public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public delegate function OnIncreaseRatingsComplete(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode);

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
        __OnIncreaseRatingsComplete__Delegate(updatedSecurityRatings, updatedWarAssets, Level, mBlazeErrorCode);
    }
}
public event function QueueSecondHTTPRequest()
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetIncreaseRatingsHTTPRequest(defaultRatingIncrease, securityRatingIncrease, warAssetIncrease, mSecondHTTPRequest);
    bKickedOffSecondRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mSecondHTTPRequest);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
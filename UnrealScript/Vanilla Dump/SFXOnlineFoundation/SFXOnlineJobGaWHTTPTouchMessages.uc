Class SFXOnlineJobGaWHTTPTouchMessages extends SFXOnlineJobGaWHTTPRequest
    native
    config(Game);

var delegate<OnTouchMessagesComplete> __OnTouchMessagesComplete__Delegate;
var int mMsgType;

public static event function SFXOnlineJobGaWHTTPTouchMessages CreateGaWTouchMessagesJob(int msgType, delegate<OnTouchMessagesComplete> RequestCompleteDelegate)
{
    local SFXOnlineJobGaWHTTPTouchMessages Job;
    
    Job = new Class'SFXOnlineJobGaWHTTPTouchMessages';
    Job.mAuthHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.mSecondHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.__OnTouchMessagesComplete__Delegate = RequestCompleteDelegate;
    Job.mMsgType = msgType;
    return Job;
}
public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public function OnRelease()
{
    local int Count;
    
    Super.OnRelease();
    if (RunningError != OnlineJobErrorCode.OJEC_None)
    {
        Count = 0;
        __OnTouchMessagesComplete__Delegate(Count, mBlazeErrorCode);
    }
}
public delegate function OnTouchMessagesComplete(int Count, int errorCode);

public event function QueueSecondHTTPRequest()
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetTouchMessagesHTTPRequest(mMsgType, mSecondHTTPRequest);
    bKickedOffSecondRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mSecondHTTPRequest);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
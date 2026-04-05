Class SFXOnlineJobGaWHTTPGetMessages extends SFXOnlineJobGaWHTTPRequest
    native
    config(Game);

var delegate<OnGetMessagesComplete> __OnGetMessagesComplete__Delegate;
var int mMsgType;

public static event function SFXOnlineJobGaWHTTPGetMessages CreateGaWGetMessagesJob(int msgType, delegate<OnGetMessagesComplete> RequestCompleteDelegate)
{
    local SFXOnlineJobGaWHTTPGetMessages Job;
    
    Job = new Class'SFXOnlineJobGaWHTTPGetMessages';
    Job.mAuthHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.mSecondHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.__OnGetMessagesComplete__Delegate = RequestCompleteDelegate;
    Job.mMsgType = msgType;
    return Job;
}
public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public delegate function OnGetMessagesComplete(array<MessageEntry> Messages, int errorCode);

public function OnRelease()
{
    local array<MessageEntry> Messages;
    
    Super.OnRelease();
    if (RunningError != OnlineJobErrorCode.OJEC_None)
    {
        Messages.Length = 0;
        __OnGetMessagesComplete__Delegate(Messages, mBlazeErrorCode);
    }
}
public event function QueueSecondHTTPRequest()
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetGetMessagesHTTPRequest(mMsgType, mSecondHTTPRequest);
    bKickedOffSecondRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mSecondHTTPRequest);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
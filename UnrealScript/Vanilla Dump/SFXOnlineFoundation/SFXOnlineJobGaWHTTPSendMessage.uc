Class SFXOnlineJobGaWHTTPSendMessage extends SFXOnlineJobGaWHTTPRequest
    native
    config(Game);

var string mSendMsgParam1;
var string mSendMsgParam2;
var string mSendMsgParam3;
var delegate<OnSendMessageComplete> __OnSendMessageComplete__Delegate;
var int mMsgType;

public static event function SFXOnlineJobGaWHTTPSendMessage CreateGaWSendMessageJob(int msgType, string sendMsgParam1, string sendMsgParam2, string sendMsgParam3, delegate<OnSendMessageComplete> RequestCompleteDelegate)
{
    local SFXOnlineJobGaWHTTPSendMessage Job;
    
    Job = new Class'SFXOnlineJobGaWHTTPSendMessage';
    Job.mAuthHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.mSecondHTTPRequest = new Class'SFXOnlineHTTPRequest';
    Job.__OnSendMessageComplete__Delegate = RequestCompleteDelegate;
    Job.mMsgType = msgType;
    Job.mSendMsgParam1 = sendMsgParam1;
    Job.mSendMsgParam2 = sendMsgParam2;
    Job.mSendMsgParam3 = sendMsgParam3;
    return Job;
}
public native function HandleSecondHTTPResult();

public native function JobFailedHandler(OnlineJobErrorCode errorCode);

public function OnRelease()
{
    local int messageId;
    local array<int> messageIds;
    
    Super.OnRelease();
    if (RunningError != OnlineJobErrorCode.OJEC_None)
    {
        messageId = 0;
        messageIds.Length = 0;
        __OnSendMessageComplete__Delegate(messageId, messageIds, mBlazeErrorCode);
    }
}
public delegate function OnSendMessageComplete(int messageId, array<int> messageIds, int errorCode);

public event function QueueSecondHTTPRequest()
{
    local SFXOnlineComponentHTTPManager httpManager;
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetSendMessageHTTPRequest(mMsgType, mSendMsgParam1, mSendMsgParam2, mSendMsgParam3, mSecondHTTPRequest);
    bKickedOffSecondRequest = TRUE;
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    httpManager.QueueRequest(mSecondHTTPRequest);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
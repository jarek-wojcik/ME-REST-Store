Class SFXOnlineComponentHTTPManager extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native
    config(Engine);

enum ECHTTPManagerState
{
    HTTP_MANAGER_STATE_IDLE,
    HTTP_MANAGER_STATE_DOWNLOAD,
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var array<SFXOnlineHTTPRequest> mRequests;
var native Pointer mHttpRef;
var native Pointer mDataResponse;
var native SFXOnlineHTTPRequest mCurrentRequest;
var native int mDataCount;
var config int mRequestTimeout;
var config int mRequestBuffer;
var config int mDebugVerbosity;
var native bool mServiceStarted;
var native ECHTTPManagerState mState;

public native function bool FetchBodyData(SFXOnlineHTTPRequest request);

public native function bool FetchStatus(SFXOnlineHTTPRequest request);

public native function Name GetAPIName();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public function OnTick(SFXOnlineEvent oEvent)
{
    if (mServiceStarted)
    {
        switch (mState)
        {
            case ECHTTPManagerState.HTTP_MANAGER_STATE_IDLE:
                OnIdleTick();
                break;
            case ECHTTPManagerState.HTTP_MANAGER_STATE_DOWNLOAD:
                OnDownloadingTick();
                break;
            default:
        }
    }
}
public native function bool StartRequest(SFXOnlineHTTPRequest request);

public native function StartService();

public function OnDownloadingTick()
{
    local bool isDone;
    
    isDone = ProcessDownload(mCurrentRequest);
    if (isDone)
    {
        mState = ECHTTPManagerState.HTTP_MANAGER_STATE_IDLE;
    }
}
public function OnIdleTick()
{
    local int outstandingRequests;
    local SFXOnlineHTTPRequest request;
    
    outstandingRequests = mRequests.Length;
    if (outstandingRequests > 0)
    {
        request = mRequests[0];
        mRequests.Remove(0, 1);
        if (StartRequest(request))
        {
            mCurrentRequest = request;
            mState = ECHTTPManagerState.HTTP_MANAGER_STATE_DOWNLOAD;
        }
        else
        {
            request.mComplete = TRUE;
            request.mResultSuccess = FALSE;
        }
    }
}
public function bool ProcessDownload(SFXOnlineHTTPRequest request)
{
    if (FetchBodyData(request))
    {
        if (FetchStatus(request))
        {
            request.mInProgress = FALSE;
            return TRUE;
        }
    }
    return FALSE;
}
public function QueueRequest(SFXOnlineHTTPRequest request)
{
    local int oldLength;
    
    oldLength = mRequests.Length;
    mRequests.Length = oldLength + 1;
    mRequests[oldLength] = request;
    request.mInProgress = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    mRequestTimeout = 20
    mRequestBuffer = 8192
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}
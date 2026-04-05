Class SFXOnlineComponentImageManager extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native;

struct native SFXOnlineImageRequest 
{
    var string mImageName;
    var SFXOnlineJobHTTPRequest mJob;
    var Texture2DDynamic mDynamicImage;
    var bool mCompleted;
};

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var array<SFXOnlineImageRequest> mPendingRequests;
var array<SFXOnlineImageRequest> mCompletedRequests;
var string mBaseUrl;
var delegate<OnImageRequestCompleted> __OnImageRequestCompleted__Delegate;
var int mMaxImages;
var int mMaxBytes;

public event function ClearReferences()
{
    mCompletedRequests.Remove(0, mCompletedRequests.Length);
}
public native function Name GetAPIName();

public function SFXOnlineImageRequest GetImage(string ImageName)
{
    local int i;
    
    for (i = 0; i < mPendingRequests.Length; ++i)
    {
        if (ImageName == mPendingRequests[i].mImageName)
        {
            return mPendingRequests[i];
        }
    }
    for (i = 0; i < mCompletedRequests.Length; ++i)
    {
        if (ImageName == mCompletedRequests[i].mImageName)
        {
            return mCompletedRequests[i];
        }
    }
    return StartRequest(ImageName);
}
public delegate function OnImageRequestCompleted(SFXOnlineImageRequest request);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

private final function OnJobComplete(SFXOnlineHTTPRequest request)
{
    local SFXOnlineImageRequest imageRequest;
    
    imageRequest = RemoveRequest(request);
    if (request.mResultSuccess)
    {
        ProcessImage(imageRequest);
    }
    AddCompletedRequest(imageRequest);
    if (mCompletedRequests.Length > 0)
    {
        while (mCompletedRequests.Length > mMaxImages || SumTotalSize() > mMaxBytes)
        {
            mCompletedRequests.Remove(0, 1);
        }
    }
}
public native function OnRelease();

public native function ProcessImage(out SFXOnlineImageRequest imageRequest);

public event function SetBaseURL(string BaseUrl)
{
    mBaseUrl = BaseUrl;
}
public event function SetMaxBytes(int maxBytes)
{
    mMaxBytes = maxBytes;
}
public event function SetMaxImages(int maxImages)
{
    mMaxImages = maxImages;
}
private final function SFXOnlineImageRequest StartRequest(string ImageName)
{
    local SFXOnlineImageRequest request;
    
    request.mImageName = ImageName;
    request.mJob = Class'SFXOnlineJobHTTPRequest'.static.CreateHTTPRequestJob();
    request.mJob.mRequest.mBinary = TRUE;
    request.mJob.mRequest.SetBaseURL(mBaseUrl);
    request.mJob.mRequest.AddSubURL(ImageName);
    request.mJob.__OnJobComplete__Delegate = OnJobComplete;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(request.mJob);
    AddPendingRequest(request);
    return request;
}
public function RequestImage(string ImageName, delegate<OnImageRequestCompleted> CompletedCallback)
{
    local SFXOnlineJobImageRequest Job;
    
    Job = Class'SFXOnlineJobImageRequest'.static.CreateImageRequestJob();
    Job.mRequest.mImageName = ImageName;
    Job.__OnJobComplete__Delegate = CompletedCallback;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
private final function AddCompletedRequest(SFXOnlineImageRequest request)
{
    local int oldLength;
    
    request.mCompleted = TRUE;
    oldLength = mCompletedRequests.Length;
    mCompletedRequests.Length = oldLength + 1;
    mCompletedRequests[oldLength] = request;
}
private final function AddPendingRequest(SFXOnlineImageRequest request)
{
    local int oldLength;
    
    oldLength = mPendingRequests.Length;
    mPendingRequests.Length = oldLength + 1;
    mPendingRequests[oldLength] = request;
}
private final function SFXOnlineImageRequest RemoveRequest(SFXOnlineHTTPRequest request)
{
    local int i;
    local SFXOnlineImageRequest imageToReturn;
    
    for (i = 0; i < mPendingRequests.Length; ++i)
    {
        if (mPendingRequests[i].mJob.mRequest.mURL == request.mURL)
        {
            imageToReturn = mPendingRequests[i];
            mPendingRequests.Remove(i, 1);
            return imageToReturn;
        }
    }
    return imageToReturn;
}
private final function int SumTotalSize()
{
    local int totalSize;
    local int i;
    
    totalSize = 0;
    for (i = 0; i < mCompletedRequests.Length; ++i)
    {
        totalSize += mCompletedRequests[i].mJob.mRequest.mResultSize;
    }
    return totalSize;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    mMaxImages = 5
    mMaxBytes = 1048576
}
Class SFXOnlineJobImageRequest extends SFXOnlineJob
    native
    config(Game);

var SFXOnlineImageRequest mRequest;
var delegate<OnJobComplete> __OnJobComplete__Delegate;

public static event function SFXOnlineJobImageRequest CreateImageRequestJob()
{
    local SFXOnlineJobImageRequest Job;
    
    Job = new Class'SFXOnlineJobImageRequest';
    return Job;
}
public delegate function OnJobComplete(SFXOnlineImageRequest request);

public function Tick()
{
    if (mRequest.mCompleted)
    {
        EndProcessing();
        __OnJobComplete__Delegate(mRequest);
    }
}
public function bool DoExecute()
{
    local SFXOnlineComponentImageManager imageManager;
    local SFXOnlineImageRequest imageRequest;
    
    imageManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentImageManager();
    imageRequest = imageManager.GetImage(mRequest.mImageName);
    if (imageRequest.mCompleted)
    {
        EndProcessing();
        __OnJobComplete__Delegate(imageRequest);
    }
    else
    {
        MoveToBackOfQueue();
    }
    return TRUE;
}
public function MoveToBackOfQueue()
{
    local SFXOnlineJobImageRequest newJob;
    
    newJob = CreateImageRequestJob();
    newJob.mRequest = mRequest;
    newJob.__OnJobComplete__Delegate = OnJobComplete;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(newJob);
    EndProcessing();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    JobCategory = OnlineJobCategory.OJC_ImageSystem
    JobType = OnlineJobType.OJT_HTTPImageRequest
}
Class SFXOnlineJobHTTPRequest extends SFXOnlineJob
    native
    config(Game);

var delegate<OnJobComplete> __OnJobComplete__Delegate;
var SFXOnlineHTTPRequest mRequest;

public static event function SFXOnlineJobHTTPRequest CreateHTTPRequestJob()
{
    local SFXOnlineJobHTTPRequest Job;
    
    Job = new Class'SFXOnlineJobHTTPRequest';
    Job.mRequest = new Class'SFXOnlineHTTPRequest';
    return Job;
}
public delegate function OnJobComplete(SFXOnlineHTTPRequest request);

public function Tick()
{
    if (mRequest.mComplete)
    {
        EndProcessing();
        __OnJobComplete__Delegate(mRequest);
    }
}
public function bool DoExecute()
{
    local SFXOnlineComponentHTTPManager httpManager;
    
    httpManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentHTTPManager();
    mRequest.FillDefaultParameters();
    httpManager.QueueRequest(mRequest);
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    JobCategory = OnlineJobCategory.OJC_HTTPSystem
    JobType = OnlineJobType.OJT_HTTPRequest
}
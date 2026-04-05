Class SFXOnlineComponentJobQueue extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native
    config(Game);

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var array<SFXOnlineJob> PendingJobs;
var array<SFXOnlineJob> ProcessingJobs;
var delegate<JobPredicate> __JobPredicate__Delegate;
var config int JobThrottlesMS[7];
var int ThrottleValuesMS[7];
var int NextJobId;
var config bool SkipJobProcessing;

public event function int AddJob(SFXOnlineJob Job)
{
    Job.SetId(NextJobId);
    PendingJobs.AddItem(Job);
    return NextJobId++;
}
public event function bool CancelJob(int JobId)
{
    local int NumJobs;
    local int JobIdx;
    local SFXOnlineJob Job;
    
    NumJobs = PendingJobs.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = PendingJobs[JobIdx];
        if (Job.GetId() == JobId)
        {
            PendingJobs.Remove(JobIdx, 1);
            Job.Cancel();
            return TRUE;
        }
    }
    NumJobs = ProcessingJobs.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = ProcessingJobs[JobIdx];
        if (Job.GetId() == JobId)
        {
            Job.Cancel();
            return TRUE;
        }
    }
    return FALSE;
}
public event function int CancelJobs(OnlineJobType JobType)
{
    local int CanceledJobs;
    local int NumJobs;
    local int JobIdx;
    local SFXOnlineJob Job;
    local array<SFXOnlineJob> JobsToRemove;
    
    CanceledJobs = 0;
    NumJobs = ProcessingJobs.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = ProcessingJobs[JobIdx];
        if (JobType == OnlineJobType.OJT_AllJobs || int(Job.GetJobType()) == int(JobType))
        {
            JobsToRemove.AddItem(Job);
            ++CanceledJobs;
        }
    }
    NumJobs = JobsToRemove.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = JobsToRemove[JobIdx];
        Job.Cancel();
        ProcessingJobs.RemoveItem(Job);
        Job.OnRelease();
    }
    JobsToRemove.Remove(0, NumJobs);
    NumJobs = PendingJobs.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = PendingJobs[JobIdx];
        if (JobType == OnlineJobType.OJT_AllJobs || int(Job.GetJobType()) == int(JobType))
        {
            JobsToRemove.AddItem(Job);
            ++CanceledJobs;
        }
    }
    NumJobs = JobsToRemove.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = JobsToRemove[JobIdx];
        Job.Cancel();
        PendingJobs.RemoveItem(Job);
        Job.OnRelease();
    }
    return CanceledJobs;
}
public final event function bool CheckForJob(OnlineJobType JobType, optional delegate<JobPredicate> Predicate = None)
{
    return CheckForPendingJob(JobType, Predicate) || CheckForProcessingJob(JobType, Predicate);
}
public final event function bool CheckForPendingJob(OnlineJobType JobType, optional delegate<JobPredicate> Predicate = None)
{
    return CheckForJobInArray(JobType, PendingJobs, Predicate);
}
public final event function bool CheckForProcessingJob(OnlineJobType JobType, optional delegate<JobPredicate> Predicate = None)
{
    return CheckForJobInArray(JobType, ProcessingJobs, Predicate);
}
public native function Name GetAPIName();

public native function SFXOnlineJob GetFirstPendingJob(OnlineJobType JobType);

public delegate function bool JobPredicate(const out SFXOnlineJob Job);

public native function OnInitialize(SFXOnlineSubsystem OnlineSub);

public native function OnRelease();

private final function OnTick(SFXOnlineEvent OnlineEvent)
{
    if (!SkipJobProcessing)
    {
        ProcessJobs(SFXOnlineEvent_Tick(OnlineEvent).DeltaTime);
    }
}
public event function int ProcessJobs(float TimeDelta, optional int JobsToProcess = 1)
{
    local int JobsProcessing;
    local array<SFXOnlineJob> JobsToRemove;
    local int NumJobs;
    local int JobIdx;
    local int JobsStarted;
    local int JobsAlreadyProcessing;
    local SFXOnlineJob Job;
    local int JobCategory;
    
    UpdateTime(int(TimeDelta * float(1000)));
    JobsProcessing = ProcessingJobs.Length;
    if (JobsProcessing > 0)
    {
        NumJobs = ProcessingJobs.Length;
        for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
        {
            Job = ProcessingJobs[JobIdx];
            if (Job.InProgress())
            {
                Job.Tick();
            }
            if (!Job.InProgress())
            {
                JobsToRemove.AddItem(Job);
            }
        }
        NumJobs = JobsToRemove.Length;
        for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
        {
            Job = JobsToRemove[JobIdx];
            ProcessingJobs.RemoveItem(Job);
            if (Job.ShouldReschedule() && !Job.IsCanceled())
            {
                PendingJobs.InsertItem(0, Job);
                continue;
            }
            Job.OnRelease();
        }
        JobsProcessing = ProcessingJobs.Length;
    }
    JobsAlreadyProcessing = JobsProcessing;
    for (JobsStarted = 0; JobsStarted + JobsAlreadyProcessing < JobsToProcess; ++JobsStarted)
    {
        if (PendingJobs.Length == 0)
        {
            break;
        }
        JobsProcessing = ProcessingJobs.Length;
        if (JobsProcessing > 0 && ProcessingJobs[0].IsBlocking())
        {
            break;
        }
        Job = PendingJobs[JobsStarted];
        if (JobsProcessing > 0 && Job.IsBlocking())
        {
            break;
        }
        JobCategory = int(Job.GetJobCategory());
        if (JobCategory < 0 || JobCategory >= 7)
        {
            JobCategory = 0;
        }
        if (float(ThrottleValuesMS[JobCategory]) > 0.0)
        {
            break;
        }
        else
        {
            ThrottleValuesMS[JobCategory] = JobThrottlesMS[JobCategory];
        }
        Job.Execute();
        ProcessingJobs.AddItem(Job);
    }
    if (JobsStarted > 0)
    {
        PendingJobs.Remove(0, JobsStarted);
    }
    return JobsStarted;
}
public native function SetJobThrottle(OnlineJobCategory Category, int valueMS);

private final function UpdateTime(int TimeDeltaMS)
{
    local int CategoryIdx;
    
    for (CategoryIdx = 0; CategoryIdx < 7; ++CategoryIdx)
    {
        ThrottleValuesMS[CategoryIdx] = Max(0, ThrottleValuesMS[CategoryIdx] - TimeDeltaMS);
    }
}
private final function bool CheckForJobInArray(OnlineJobType JobType, const out array<SFXOnlineJob> JobArray, delegate<JobPredicate> Predicate)
{
    local int JobIdx;
    local int NumJobs;
    local SFXOnlineJob Job;
    
    NumJobs = JobArray.Length;
    for (JobIdx = 0; JobIdx < NumJobs; ++JobIdx)
    {
        Job = JobArray[JobIdx];
        if (JobType == OnlineJobType.OJT_AllJobs || int(Job.GetJobType()) == int(JobType))
        {
            return Predicate == None || Predicate(Job);
        }
    }
    return FALSE;
}
public final function SFXOnlineJob GetPendingJob(int JobId)
{
    local int i;
    
    for (i = 0; i < PendingJobs.Length; ++i)
    {
        if (PendingJobs[i].GetId() == JobId)
        {
            return PendingJobs[i];
        }
    }
    return None;
}
public final function SFXOnlineJob GetProcessingJob(int JobId)
{
    local int i;
    
    for (i = 0; i < ProcessingJobs.Length; ++i)
    {
        if (ProcessingJobs[i].GetId() == JobId)
        {
            return ProcessingJobs[i];
        }
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    JobThrottlesMS[0] = 10000
    JobThrottlesMS[1] = 5000
    JobThrottlesMS[2] = 1000
    JobThrottlesMS[3] = 1000
    JobThrottlesMS[4] = 1000
    JobThrottlesMS[5] = 500
    JobThrottlesMS[6] = 1000
    NextJobId = 1
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}
Class SFXOnlineJob
    native
    abstract
    config(Game);

const NOT_SCHEDULED = -1;
enum OnlineJobErrorCode
{
    OJEC_None,
    OJEC_Cancelled,
    OJEC_FailedToStart,
    OJEC_Disconnected,
    OJEC_System,
    OJEC_Timeout,
    OJEC_AuthorizationRequired,
    OJEC_RecordNotFound,
    OJEC_TooManyKeys,
    OJEC_DBError,
};
enum OnlineJobType
{
    OJT_None,
    OJT_SaveSettings,
    OJT_LoadSettings,
    OJT_GameReporting,
    OJT_GetLeaderboardData,
    OJT_GetLeaderboardList,
    OJT_GetStatsGroupList,
    OJT_ImportFriendListToBlaze,
    OJT_SendMessage,
    OJT_FetchAllMessages,
    OJT_PurgeMessages,
    OJT_HTTPRequest,
    OJT_GetAuthToken,
    OJT_GalaxyAtWarHTTPRequest,
    OJT_HTTPImageRequest,
    OJT_AllJobs,
};
enum OnlineJobCategory
{
    OJC_Default,
    OJC_Storage,
    OJC_Leaderboards,
    OJC_FriendList,
    OJC_HTTPSystem,
    OJC_GetAuthToken,
    OJC_ImageSystem,
};

var native array<Pointer> BlazeJobIds;
var int JobId;
var int SchedulingsLeft;
var config int RescheduleCount;
var bool JobIsCanceled;
var bool IsProcessing;
var OnlineJobErrorCode RunningError;
var config OnlineJobCategory JobCategory;
var OnlineJobType JobType;

public final event function Cancel(optional OnlineJobErrorCode WithError = 1)
{
    JobIsCanceled = TRUE;
    EndProcessing(WithError);
    CancelBlazeJobs();
    DeleteBlazeJobs();
}
private final native function CancelBlazeJobs();

private final native function DeleteBlazeJobs();

protected final event function EndProcessing(optional OnlineJobErrorCode WithError = 0)
{
    IsProcessing = FALSE;
    if (WithError == OnlineJobErrorCode.OJEC_None)
    {
        return;
    }
    if (RunningError != OnlineJobErrorCode.OJEC_None && int(RunningError) != int(WithError))
    {
    }
    RunningError = WithError;
}
public final event function int GetId()
{
    return JobId;
}
public final event function OnlineJobType GetJobType()
{
    return JobType;
}
public final event function bool InProgress()
{
    return IsProcessing;
}
public final event function bool IsCanceled()
{
    return JobIsCanceled;
}
public function OnRelease()
{
    DeleteBlazeJobs();
}
public final event function SetId(int NewJobId)
{
    if (JobId != 0)
    {
    }
    JobId = NewJobId;
}
public event function bool ShouldReschedule()
{
    if (GetSchedulingsLeft() == 0)
    {
        return FALSE;
    }
    switch (RunningError)
    {
        case OnlineJobErrorCode.OJEC_FailedToStart:
        case OnlineJobErrorCode.OJEC_Timeout:
        case OnlineJobErrorCode.OJEC_Disconnected:
            return TRUE;
        default:
    }
    return FALSE;
}
public function Tick();

public function bool DoExecute()
{
    return FALSE;
}
public final function Execute()
{
    local bool ExecutionResult;
    
    if (InProgress())
    {
        return;
    }
    if (SchedulingsLeft == 0)
    {
        Cancel();
        return;
    }
    if (SchedulingsLeft == -1)
    {
        SchedulingsLeft = RescheduleCount;
    }
    else
    {
        --SchedulingsLeft;
    }
    RunningError = OnlineJobErrorCode.OJEC_None;
    IsProcessing = TRUE;
    ExecutionResult = DoExecute();
    if (!IsProcessing && ExecutionResult)
    {
    }
    IsProcessing = IsProcessing && ExecutionResult;
}
public final function OnlineJobCategory GetJobCategory()
{
    return JobCategory;
}
protected final function int GetSchedulingsLeft()
{
    return SchedulingsLeft;
}
public function bool IsBlocking()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SchedulingsLeft = -1
}
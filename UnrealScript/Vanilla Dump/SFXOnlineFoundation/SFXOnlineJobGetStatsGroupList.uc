Class SFXOnlineJobGetStatsGroupList extends SFXOnlineJob
    native
    config(Game);

var delegate<OnJobCompletion> __OnJobCompletion__Delegate;

public static event function SFXOnlineJobGetStatsGroupList CreateGetStatsGroupListJob()
{
    local SFXOnlineJobGetStatsGroupList Job;
    
    Job = new Class'SFXOnlineJobGetStatsGroupList';
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    return Job;
}
public native function JobCompleted(byte errorCode);

public delegate function OnJobCompletion(byte errorCode);

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 3
    JobCategory = OnlineJobCategory.OJC_Leaderboards
    JobType = OnlineJobType.OJT_GetStatsGroupList
}
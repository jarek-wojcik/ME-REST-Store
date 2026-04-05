Class SFXOnlineJobImportFriendListToBlaze extends SFXOnlineJob
    native
    config(Game);

var delegate<OnJobCompletion> __OnJobCompletion__Delegate;
var bool bCallPostImportFriendListToBlaze;

public static event function SFXOnlineJobImportFriendListToBlaze CreateImportFriendListToBlazeJob(bool callPostImportFriendListToBlaze)
{
    local SFXOnlineJobImportFriendListToBlaze Job;
    
    Job = new Class'SFXOnlineJobImportFriendListToBlaze';
    Job.bCallPostImportFriendListToBlaze = callPostImportFriendListToBlaze;
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    return Job;
}
public native function JobCompleted(byte errorCode);

public delegate function OnJobCompletion(byte errorCode);

public event function bool ShouldReschedule()
{
    return FALSE;
}
public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 3
    JobCategory = OnlineJobCategory.OJC_FriendList
    JobType = OnlineJobType.OJT_ImportFriendListToBlaze
}
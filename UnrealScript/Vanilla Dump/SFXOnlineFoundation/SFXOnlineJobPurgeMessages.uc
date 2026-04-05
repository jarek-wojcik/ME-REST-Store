Class SFXOnlineJobPurgeMessages extends SFXOnlineJob
    native
    config(Game);

var int MapId;
var bool PurgeAllMessages;

public static event function SFXOnlineJobPurgeMessages CreatePurgeAllMessagesJob()
{
    local SFXOnlineJobPurgeMessages Job;
    
    Job = new Class'SFXOnlineJobPurgeMessages';
    Job.PurgeAllMessages = TRUE;
    return Job;
}
public static event function SFXOnlineJobPurgeMessages CreatePurgeMessagesJob(int InMapId)
{
    local SFXOnlineJobPurgeMessages Job;
    
    Job = new Class'SFXOnlineJobPurgeMessages';
    Job.PurgeAllMessages = FALSE;
    Job.MapId = InMapId;
    return Job;
}
public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 1
    JobCategory = OnlineJobCategory.OJC_Leaderboards
    JobType = OnlineJobType.OJT_PurgeMessages
}
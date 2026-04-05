Class SFXOnlineJobReceiveMessage extends SFXOnlineJob
    native
    config(Game);

var int nMapId;

public static event function SFXOnlineJobReceiveMessage CreateReceiveAllMessagesJob()
{
    local SFXOnlineJobReceiveMessage Job;
    
    Job = new Class'SFXOnlineJobReceiveMessage';
    return Job;
}
public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 1
    JobCategory = OnlineJobCategory.OJC_Leaderboards
    JobType = OnlineJobType.OJT_FetchAllMessages
}
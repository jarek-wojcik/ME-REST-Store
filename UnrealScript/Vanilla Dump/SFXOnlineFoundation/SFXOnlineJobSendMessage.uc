Class SFXOnlineJobSendMessage extends SFXOnlineJob
    native
    config(Game);

var array<string> sendToPersonaNames;
var array<string> sParams;
var SFXOnlineMessageType MessageType;

public static event function SFXOnlineJobSendMessage CreateSendMessageJob(array<string> InSendToPersonaNames, SFXOnlineMessageType InMessageType, optional array<string> Params)
{
    local SFXOnlineJobSendMessage Job;
    
    Job = new Class'SFXOnlineJobSendMessage';
    Job.sendToPersonaNames = InSendToPersonaNames;
    Job.MessageType = InMessageType;
    Job.sParams = Params;
    return Job;
}
public static event function SFXOnlineJobSendMessage CreateSendMessageToAllFriendsJob(SFXOnlineMessageType InMessageType, optional array<string> Params)
{
    local array<string> friendsPersonaNames;
    
    if (!GetFriendsList(friendsPersonaNames))
    {
    }
    return CreateSendMessageJob(friendsPersonaNames, InMessageType, Params);
}
public static native function bool GetFriendsList(out array<string> friendsPersonaNames);

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 1
    JobCategory = OnlineJobCategory.OJC_Leaderboards
    JobType = OnlineJobType.OJT_SendMessage
}
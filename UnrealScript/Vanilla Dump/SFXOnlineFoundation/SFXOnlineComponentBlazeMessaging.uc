Class SFXOnlineComponentBlazeMessaging extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentMessaging)
    native
    config(Game);

struct native unkstructflag BlazeMsgRequest 
{
    var init array<string> Params;
    var native init Pointer pJobId;
    var init SFXOnlineMessageType MessageType;
};

var const native noexport Pointer VfTable_IISFXOnlineComponentMessaging;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var native array<BlazeMsgRequest> mBlazeMsgRequests;
var native Pointer mMessagingAPI;
var config stringref mAchievementMsgStrRef;

private final event function SFXOnlineJobPurgeMessages CreatePurgeAllMessagesJob()
{
    return Class'SFXOnlineJobPurgeMessages'.static.CreatePurgeAllMessagesJob();
}
private final event function SFXOnlineJobPurgeMessages CreatePurgeMessagesJob(int InMapId)
{
    return Class'SFXOnlineJobPurgeMessages'.static.CreatePurgeMessagesJob(InMapId);
}
private final event function SFXOnlineJobReceiveMessage CreateReceiveAllMessagesJob()
{
    return Class'SFXOnlineJobReceiveMessage'.static.CreateReceiveAllMessagesJob();
}
public native function FetchAllMessages();

public native function FetchAllMessagesViaJob();

public native function Name GetAPIName();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public native function PurgeAllMessages();

public native function PurgeAllMessagesViaJob();

public native function SendMessage(array<string> sendToPersonaNames, SFXOnlineMessageType msgType, optional array<string> Params);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    mAchievementMsgStrRef = $680866
}
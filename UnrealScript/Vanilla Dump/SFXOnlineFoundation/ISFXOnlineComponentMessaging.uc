Class ISFXOnlineComponentMessaging extends ISFXOnlineComponent
    native
    abstract;

public native function FetchAllMessages();

public native function FetchAllMessagesViaJob();

public native function PurgeAllMessages();

public native function PurgeAllMessagesViaJob();

public native function SendMessage(array<string> sendToPersonaNames, SFXOnlineMessageType msgType, optional array<string> Params);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
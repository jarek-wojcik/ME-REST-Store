Class SeqEvent_RemoteEvent extends SequenceEvent
    native;

var(SeqEvent_RemoteEvent) array<RemoteEventParameter> Parameters;
var(SeqEvent_RemoteEvent) Name EventName;
var transient bool bStatusIsOk;

public static native function SeqEvent_RemoteEvent FindRemoteEvent(Name fnEventName);

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventName = 'DefaultEvent'
    WhoTriggers = EWhoTriggers.WT_Everyone
}
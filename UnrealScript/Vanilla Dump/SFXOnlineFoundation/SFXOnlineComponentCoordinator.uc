Class SFXOnlineComponentCoordinator
    implements(ISFXOnlineComponent)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var delegate<OnEvent> __OnEvent__Delegate;
var SFXOnlineEventList EventList;
var SFXOnlineEventNotifier EventNotifier;

public final native function bool GetAllPendingEvents(SFXOnlineEventType EventType, out array<SFXOnlineEvent> PendingEvents);

public final native function Name GetAPIName();

public native function SFXOnlineEvent GetEvent(SFXOnlineEventType eEventType, optional int nEventID = -1);

public final native function bool IsAnyEventPending(SFXOnlineEventType EventType);

public native function bool IsEventPending(SFXOnlineEventType eEventType, optional int nEventID = -1);

public native function NotifyEventObject(SFXOnlineEvent oEvent);

public native function NotifyEventType(SFXOnlineEventType eEventType, optional SFXOnlineEventStatus eStatus = 2, optional SFXOnlineEventStatusFinished eOutcome = 0);

public native function NotifyWorkFinishedObject(SFXOnlineEvent oEvent, SFXOnlineEventStatusFinished eStatusFinished);

public native function NotifyWorkFinishedType(SFXOnlineEventType eEventType, SFXOnlineEventStatusFinished eStatusFinished, int nEventID);

public native function NotifyWorkStartedObject(SFXOnlineEvent oEvent, SFXOnlineEventType eEventType, optional int EventId = -1, optional float TimeOut = 0.0);

public native function NotifyWorkStartedType(SFXOnlineEventType eEventType, optional int nEventID = -1, optional float fTimeOut = 0.0);

public delegate function OnEvent(SFXOnlineEvent oEvent);

public final native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public final native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public native function StopWaitingForAllWork(Object oCallbackTarget);

public native function SubscribeToEvent(SFXOnlineEventType eEventType, delegate<OnEvent> fnEventCallback);

public native function UnsubscribeFromAllEvents(Object oCallbackTarget);

public native function UnsubscribeFromEvent(SFXOnlineEventType eEventType, delegate<OnEvent> fnEventCallback);

public native function WaitingForWorkBlocking(SFXOnlineEventType eEventType, optional int nEventID = -1);

public native function WaitingForWorkObject(SFXOnlineEvent oEvent, delegate<OnEvent> fnWorkComplete);

public native function WaitingForWorkSetObject(array<SFXOnlineEvent> aEventObjects, delegate<OnEvent> fnWorkComplete);

public native function WaitingForWorkSetType(array<SFXOnlineEventType> aEventTypes, delegate<OnEvent> fnWorkComplete, optional array<int> aWorkEventIds);

public native function WaitingForWorkType(SFXOnlineEventType eEventType, delegate<OnEvent> fnWorkComplete, optional int nEventID = -1);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
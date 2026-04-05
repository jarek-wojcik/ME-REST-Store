Class SFXOnlineComponent
    native
    abstract;

struct native SFXOnlineSubscriberEventType 
{
    var Name EventCallback;
    var SFXOnlineEventType EventType;
};

var array<SFXOnlineSubscriberEventType> EventSubscriberTable;
var delegate<OnEvent> __OnEvent__Delegate;
var const Name APIName;
var SFXOnlineSubsystem OnlineSubsystem;
var const bool NeedsStateMachine;

public final native function bool GetAllPendingEvents(SFXOnlineEventType eEventType, out array<SFXOnlineEvent> aPendingEvents);

public native function Name GetAPIName();

public final native function SFXOnlineEvent GetEvent(SFXOnlineEventType eEventType, optional int nEventID = -1);

public final native function bool IsAnyEventPending(SFXOnlineEventType eEventType);

public event function bool IsConsole()
{
    return Class'WorldInfo'.static.IsConsoleBuild(0);
}
public final native function bool IsEventPending(SFXOnlineEventType eEventType, optional int nEventID = -1);

public event function bool IsPS3()
{
    return Class'WorldInfo'.static.IsConsoleBuild(2);
}
public event function bool IsXbox360()
{
    return Class'WorldInfo'.static.IsConsoleBuild(1);
}
public final native function NotifyEventObject(SFXOnlineEvent oEvent);

public final native function NotifyEventType(SFXOnlineEventType eEventType, optional SFXOnlineEventStatus eStatus = 2, optional SFXOnlineEventStatusFinished eOutcome = 0);

public final native function NotifyWorkFinishedObject(SFXOnlineEvent oEvent, optional SFXOnlineEventStatusFinished eStatusFinished = 0);

public final native function NotifyWorkFinishedType(SFXOnlineEventType eWork, optional SFXOnlineEventStatusFinished eStatusFinished = 0, optional int nEventID = -1);

public final native function NotifyWorkStartedObject(SFXOnlineEvent oEvent, optional SFXOnlineEventType eEventType = 0, optional float TimeOut = 0.0);

public final native function NotifyWorkStartedType(SFXOnlineEventType eWork, optional int nEventID = -1, optional float fTimeOut = 0.0);

public delegate function OnEvent(SFXOnlineEvent oEvent);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public final native function StopWaitingForAllWork(Object oCallbackTarget);

public final native function SubscribeToEvent(SFXOnlineEventType eEventType, delegate<OnEvent> fnEventCallback);

public final native function UnsubscribeFromAllEvents(Object oCallbackTarget);

public final native function UnsubscribeFromEvent(SFXOnlineEventType oEventType, delegate<OnEvent> fnEventCallback);

public final native function WaitingForWorkObject(SFXOnlineEvent oEvent, delegate<OnEvent> fnWorkComplete);

public final native function WaitingForWorkSetObject(array<SFXOnlineEvent> aOnlineEventSet, delegate<OnEvent> fnWorkComplete);

public final native function WaitingForWorkSetType(array<SFXOnlineEventType> aWorkUnits, delegate<OnEvent> fnWorkComplete);

public final native function WaitingForWorkType(SFXOnlineEventType eWork, delegate<OnEvent> fnWorkComplete, optional int nEventID = -1);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    APIName = 'SFXOnline'
    NeedsStateMachine = TRUE
}
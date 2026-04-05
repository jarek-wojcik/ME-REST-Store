Class SFXOnlineEventNotifier
    native;

struct native SFXOnlineNotifyQueueInfo 
{
    var delegate<OnEvent> EventCallback;
    var SFXOnlineEventType EventType;
};
struct native SFXOnlineEventNotify 
{
    var init array<delegate<OnEvent>> Subscribers;
    var init array<delegate<OnEvent>> Waiters;
    
    structdefaultproperties
    {
        Subscribers = ()
        Waiters = ()
    }
};

var SFXOnlineEventNotify OnlineEventNotifyTable[27];
var array<SFXOnlineNotifyQueueInfo> EventNotifyAddQueue;
var array<SFXOnlineNotifyQueueInfo> EventNotifyRemoveQueue;
var delegate<OnEvent> __OnEvent__Delegate;
var bool bQueuingEnabled;

public native function AddSubscriber(SFXOnlineEventType EventType, delegate<OnEvent> EventCallback);

public native function AddWaiter(SFXOnlineEventType EventType, delegate<OnEvent> EventCallback);

public native function bool IsSubscribed(SFXOnlineEventType EventType, delegate<OnEvent> EventCallback);

public native function NotifyCallbacks(array<delegate<OnEvent>> NotifyArray, SFXOnlineEvent Event);

public native function NotifySubscribers(SFXOnlineEvent Event);

public native function NotifyWaiters(SFXOnlineEvent Event);

public delegate function OnEvent(SFXOnlineEvent Event);

public native function RemoveAllSubscribers(Object CallbackTarget);

public native function RemoveAllWaiters(Object CallbackTarget);

public native function RemoveSubscriber(SFXOnlineEventType EventType, delegate<OnEvent> EventCallback, optional int RemoveIndex = -1);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
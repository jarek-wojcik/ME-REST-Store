Class UIDataStore extends UIDataProvider
    native
    abstract
    transient;

var array<delegate<OnDataStoreValueUpdated>> RefreshSubscriberNotifies;
var delegate<OnDataStoreValueUpdated> __OnDataStoreValueUpdated__Delegate;
var Name Tag;

public final function DataStoreClient GetDataStoreClient()
{
    return Class'UIInteraction'.static.GetDataStoreClient();
}
public function bool NotifyGameSessionEnded();

public native function OnCommit();

public delegate function OnDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public final event function RefreshSubscribers(optional Name PropertyTag, optional bool bInvalidateValues = TRUE, optional UIDataProvider SourceProvider, optional int ArrayIndex = -1)
{
    local int idx;
    local delegate<OnDataStoreValueUpdated> Subscriber;
    local array<delegate<OnDataStoreValueUpdated>> SubscriberArrayCopy;
    
    SubscriberArrayCopy.Length = RefreshSubscriberNotifies.Length;
    for (idx = 0; idx < SubscriberArrayCopy.Length; idx++)
    {
        SubscriberArrayCopy[idx] = RefreshSubscriberNotifies[idx];
    }
    for (idx = 0; idx < SubscriberArrayCopy.Length; idx++)
    {
        Subscriber = SubscriberArrayCopy[idx];
        Subscriber(Self, bInvalidateValues, PropertyTag, SourceProvider, ArrayIndex);
    }
}
public event function Registered(LocalPlayer PlayerOwner);

public event function SubscriberAttached(UIDataStoreSubscriber Subscriber)
{
    local int SubscriberNotifyIndex;
    
    if (Subscriber != None)
    {
        SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
        if (SubscriberNotifyIndex == -1)
        {
            SubscriberNotifyIndex = RefreshSubscriberNotifies.Length;
            RefreshSubscriberNotifies[SubscriberNotifyIndex] = Subscriber.NotifyDataStoreValueUpdated;
        }
    }
}
public event function SubscriberDetached(UIDataStoreSubscriber Subscriber)
{
    local int SubscriberNotifyIndex;
    
    if (Subscriber != None)
    {
        SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
        if (SubscriberNotifyIndex != -1)
        {
            RefreshSubscriberNotifies.Remove(SubscriberNotifyIndex, 1);
        }
    }
}
public event function Unregistered(LocalPlayer PlayerOwner);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
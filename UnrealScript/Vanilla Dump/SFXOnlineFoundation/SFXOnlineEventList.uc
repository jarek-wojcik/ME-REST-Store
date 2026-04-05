Class SFXOnlineEventList
    native;

var init array<SFXOnlineEvent> EventList;

public final native function bool AddEvent(SFXOnlineEvent oEvent);

public final native function int FindEvent(SFXOnlineEvent oEvent);

public final native function bool GetAllPendingEvents(SFXOnlineEventType eEventType, out array<SFXOnlineEvent> PendingEvents);

public final native function SFXOnlineEvent GetEvent(SFXOnlineEvent oEvent);

public final native function SFXOnlineEvent GetEventAtIndex(int nEventIndex);

public final native function SFXOnlineEvent GetNextTimedOutEvent();

public final native function bool RemoveEvent(SFXOnlineEvent oEvent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
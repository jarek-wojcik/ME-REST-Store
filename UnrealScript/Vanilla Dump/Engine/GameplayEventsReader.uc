Class GameplayEventsReader extends GameplayEvents
    native
    config(Game);

var config array<int> EventIDFilter;

public native function int GetPlatform();

public native function float GetSessionDuration();

public native function float GetSessionEnd();

public native function string GetSessionID();

public native function float GetSessionStart();

public native function string GetSessionTimestamp();

public native function int GetTitleID();

public event function bool IsEventFiltered(int EventId)
{
    return EventIDFilter.Find(EventId) != -1;
}
public native function ProcessStream();

protected native function bool SerializeHeader();

public function AddFilter(int EventId)
{
    if (EventIDFilter.Find(EventId) == -1)
    {
        EventIDFilter.AddItem(EventId);
    }
}
public native function CloseStatsFile();

public native function bool OpenStatsFile(string Filename);

public function RemoveFilter(int EventId)
{
    EventIDFilter.RemoveItem(EventId);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
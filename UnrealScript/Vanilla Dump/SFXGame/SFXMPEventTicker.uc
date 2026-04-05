Class SFXMPEventTicker;

var privatewrite transient array<string> Events;

public final function AddTickerEntry(string Text)
{
    Events.AddItem(Text);
}
public final function ClearTicker()
{
    Events.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
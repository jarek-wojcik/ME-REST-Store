Class GFxInteraction extends Interaction
    native
    transient;

var const native noexport Pointer VfTable_FCallbackEventDevice;

public native function NotifyGameSessionEnded();

public native function GFxMovie GetFocusMovie();

public native function bool SetFocusMovie(string MovieName, bool captureInput);

public native function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer);

public native function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
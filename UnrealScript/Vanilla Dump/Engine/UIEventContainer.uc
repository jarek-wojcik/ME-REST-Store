Class UIEventContainer extends Interface
    native
    abstract;

public final native function bool AddSequenceObject(SequenceObject NewObj, optional bool bRecurse);

public final native function GetUIEvents(out array<UIEvent> out_Events, optional Class<UIEvent> LimitClass);

public final native function RemoveSequenceObject(SequenceObject ObjectToRemove);

public final native function RemoveSequenceObjects(array<SequenceObject> ObjectsToRemove);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
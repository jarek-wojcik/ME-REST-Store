Class UISequence extends Sequence
    implements(UIEventContainer)
    native;

var const native noexport Pointer VfTable_IUIEventContainer;
var const transient noimport init array<UIEvent> UIEvents;

public final native function bool AddSequenceObject(SequenceObject NewObj, optional bool bRecurse);

public final native function UIScreenObject GetOwner();

public final native function GetUIEvents(out array<UIEvent> out_Events, optional Class<UIEvent> LimitClass);

public final native function RemoveSequenceObject(SequenceObject ObjectToRemove);

public final native function RemoveSequenceObjects(const out array<SequenceObject> ObjectsToRemove);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
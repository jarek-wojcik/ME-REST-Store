Class UIState extends UIRoot
    implements(UIEventContainer)
    native
    editinlinenew
    abstract;

var const native noexport Pointer VfTable_IUIEventContainer;
var array<InputKeyAction> StateInputActions;
var array<InputKeyAction> DisabledInputActions;
var(UIState) Name MouseCursorName;
var noimport export UIStateSequence StateSequence;
var transient byte PlayerIndexMask;
var const transient byte StackPriority;

public event function bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    return TRUE;
}
public final native function bool AddSequenceObject(SequenceObject NewObj, optional bool bRecurse);

public event function bool DeactivateState(UIScreenObject Target, int PlayerIndex)
{
    return TRUE;
}
public final native function GetUIEvents(out array<UIEvent> out_Events, optional Class<UIEvent> LimitClass);

public final native function bool IsActiveForPlayer(int PlayerIndex);

public event function bool IsStateAllowed(UIScreenObject Target, UIState NewState, int PlayerIndex)
{
    return TRUE;
}
public event function bool IsWidgetClassSupported(Class<UIScreenObject> WidgetClass)
{
    return WidgetClass != None;
}
public event function OnActivate(UIScreenObject Target, int PlayerIndex, bool bPushedState);

public event function OnDeactivate(UIScreenObject Target, int PlayerIndex, bool bPoppedState);

public final native function RemoveSequenceObject(SequenceObject ObjectToRemove);

public final native function RemoveSequenceObjects(const out array<SequenceObject> ObjectsToRemove);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MouseCursorName = 'Arrow'
}
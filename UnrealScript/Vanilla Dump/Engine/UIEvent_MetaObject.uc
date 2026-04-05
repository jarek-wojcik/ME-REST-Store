Class UIEvent_MetaObject extends UIEvent
    native
    placeable
    transient;

var const native noexport Pointer VfTable_FCallbackEventDevice;

public event function bool IsPastingIntoUISequenceAllowed()
{
    return TRUE;
}
public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDeletable = FALSE
}
Class UIEvent_ProcessInput extends UIEvent
    native
    placeable
    transient;

var transient native MultiMap_Mirror ActionMap;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Description = "Executes actions in response to an input event, such as a keypress or mouse movement"
    bShouldRegisterEvent = FALSE
    bPropagateEvent = FALSE
}
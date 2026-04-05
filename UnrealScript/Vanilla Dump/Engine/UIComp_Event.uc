Class UIComp_Event extends UIComponent within UIScreenObject
    native;

var array<DefaultEventSpecification> DefaultEvents;
var array<Name> DisabledEventAliases;
var UISequence EventContainer;
var transient UIEvent_ProcessInput InputProcessor;

public final native function RegisterInputEvents(UIState InputEventOwner, int PlayerIndex);

public final native function UnregisterInputEvents(UIState InputEventOwner, int PlayerIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
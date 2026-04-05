Class UITickableObjectProxy extends UIRoot
    implements(UITickableObject)
    native
    transient;

var const native noexport Pointer VfTable_IUITickableObject;
var delegate<OnScriptTick> __OnScriptTick__Delegate;

public delegate function OnScriptTick(UITickableObjectProxy Sender, float DeltaTime);

public event function ScriptTick(float DeltaTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
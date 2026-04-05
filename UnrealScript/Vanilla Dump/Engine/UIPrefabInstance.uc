Class UIPrefabInstance extends UIObject
    native
    hidedropdown
    config(UI);

var const native Object ArchetypeToInstanceMap;
var const native Object PI_ObjectMap;
var const archetype UIPrefab SourcePrefab;
var const int PrefabInstanceVersion;

public final native function DetachFromSourcePrefab();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    EventProvider = WidgetEventComponent
}
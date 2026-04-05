Class UIPrefab extends UIObject
    native
    hidedropdown
    config(UI);

struct native transient ArchetypeInstancePair 
{
    var transient init float ArchetypeBounds[4];
    var transient init float InstanceBounds[4];
    var transient init UIObject WidgetArchetype;
    var transient init UIObject WidgetInstance;
};

var(Appearance) const UIScreenValue_Extent OriginalWidth;
var(Appearance) const UIScreenValue_Extent OriginalHeight;
var const int PrefabVersion;
var const int InternalPrefabVersion;
var const transient int ModificationCounter;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    OriginalWidth = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentScene, Orientation = EUIOrientation.UIORIENT_Horizontal}
    OriginalHeight = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_PercentScene, Orientation = EUIOrientation.UIORIENT_Vertical}
    EventProvider = WidgetEventComponent
}
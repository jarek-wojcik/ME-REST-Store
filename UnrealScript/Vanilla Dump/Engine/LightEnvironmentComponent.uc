Class LightEnvironmentComponent extends ActorComponent
    native;

var editinline transient export array<PrimitiveComponent> AffectedComponents;
var const editinline transient export LightComponent AffectingDominantLight;
var(LightEnvironmentComponent) const bool bEnabled;
var(LightEnvironmentComponent) bool bForceNonCompositeDynamicLights;

public final native function bool IsEnabled();

public final native function SetEnabled(bool bNewEnabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    ComponentType = EComponentType.COMPONENT_Graphics
}
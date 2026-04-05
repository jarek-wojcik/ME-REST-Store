Class DirectionalLightComponent extends LightComponent
    native
    editinlinenew;

var(Lightmass) LightmassDirectionalLightSettings LightmassSettings;
var(AdvancedLighting) float TraceDistance;
var(DirectionalLightComponent) const float WholeSceneDynamicShadowRadius;

public function OnUpdatePropertyBrightness()
{
    UpdateColorAndBrightness();
}
public function OnUpdatePropertyLightColor()
{
    UpdateColorAndBrightness();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightmassSettings = {LightSourceAngle = 3.0, IndirectLightingScale = 1.0, IndirectLightingSaturation = 1.0, ShadowExponent = 2.0}
    TraceDistance = 100000.0
}
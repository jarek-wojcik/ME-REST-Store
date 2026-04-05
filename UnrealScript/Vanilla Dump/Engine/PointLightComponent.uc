Class PointLightComponent extends LightComponent
    native
    editinlinenew;

var const Matrix CachedParentToWorld;
var(Lightmass) LightmassPointLightSettings LightmassSettings;
var(PointLightComponent) const Vector Translation;
var(PointLightComponent) interp float ShadowRadiusMultiplier;
var(PointLightComponent) interp float Radius;
var(PointLightComponent) interp float FalloffExponent;
var(PointLightComponent) float ShadowFalloffExponent;
var(PointLightComponent) float MinShadowFalloffRadius;
var const editinline export DrawLightRadiusComponent PreviewLightRadius;
var const editinline export DrawLightRadiusComponent PreviewLightSourceRadius;
var transient bool bAllowedInBasePass;

public final native function SetTranslation(Vector NewTranslation);

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
    LightmassSettings = {LightSourceRadius = 100.0, IndirectLightingScale = 1.0, IndirectLightingSaturation = 1.0, ShadowExponent = 2.0}
    ShadowRadiusMultiplier = 1.10000002
    Radius = 1024.0
    FalloffExponent = 2.0
    ShadowFalloffExponent = 2.0
}
Class SpotLightComponent extends PointLightComponent
    native
    editinlinenew;

var(SpotLightComponent) float InnerConeAngle;
var(SpotLightComponent) float OuterConeAngle;
var(LightShafts) float LightShaftConeAngle;
var const editinline export DrawLightConeComponent PreviewInnerCone;
var const editinline export DrawLightConeComponent PreviewOuterCone;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OuterConeAngle = 44.0
    LightShaftConeAngle = 89.0
}
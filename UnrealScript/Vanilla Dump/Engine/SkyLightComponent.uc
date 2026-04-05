Class SkyLightComponent extends LightComponent
    native
    editinlinenew;

var(SkyLightComponent) const float LowerBrightness;
var(SkyLightComponent) const Color LowerColor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LowerColor = {B = 255, G = 255, R = 255, A = 0}
    CastShadows = FALSE
}
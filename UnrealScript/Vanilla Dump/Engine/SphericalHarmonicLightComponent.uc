Class SphericalHarmonicLightComponent extends LightComponent
    native
    editinlinenew;

var(SphericalHarmonicLightComponent) SHVectorRGB WorldSpaceIncidentLighting;
var bool bRenderBeforeModShadows;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CastShadows = FALSE
}
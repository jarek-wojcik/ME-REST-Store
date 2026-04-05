Class FogVolumeSphericalDensityComponent extends FogVolumeDensityComponent
    native
    editinlinenew
    collapsecategories;

var Vector SphereCenter;
var(FogVolumeSphericalDensityComponent) interp float MaxDensity;
var float SphereRadius;
var const editinline export DrawLightRadiusComponent PreviewSphereRadius;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxDensity = 0.00200000009
    SphereRadius = 600.0
}
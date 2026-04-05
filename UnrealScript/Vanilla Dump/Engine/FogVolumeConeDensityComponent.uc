Class FogVolumeConeDensityComponent extends FogVolumeDensityComponent
    native
    editinlinenew
    collapsecategories;

var(FogVolumeConeDensityComponent) interp Vector ConeVertex;
var(FogVolumeConeDensityComponent) interp Vector ConeAxis;
var(FogVolumeConeDensityComponent) interp float MaxDensity;
var(FogVolumeConeDensityComponent) interp float ConeRadius;
var(FogVolumeConeDensityComponent) interp float ConeMaxAngle;
var const editinline export DrawLightConeComponent PreviewCone;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConeAxis = {X = 0.0, Y = 0.0, Z = -1.0}
    MaxDensity = 0.00200000009
    ConeRadius = 600.0
    ConeMaxAngle = 30.0
}
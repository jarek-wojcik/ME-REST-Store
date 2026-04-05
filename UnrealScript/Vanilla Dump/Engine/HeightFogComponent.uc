Class HeightFogComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories;

var const float Height;
var(HeightFogComponent) interp float Density;
var(HeightFogComponent) const interp float LightBrightness;
var(HeightFogComponent) const interp Color LightColor;
var(HeightFogComponent) const interp float ExtinctionDistance;
var(HeightFogComponent) const interp float StartDistance;
var(HeightFogComponent) const bool bEnabled;

public final native function SetEnabled(bool bSetEnabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Density = 0.0000499999987
    LightBrightness = 0.100000001
    LightColor = {B = 255, G = 255, R = 255, A = 0}
    ExtinctionDistance = 100000000.0
    bEnabled = TRUE
}
Class FogVolumeDensityComponent extends ActorComponent
    native
    editinlinenew
    abstract;

var(FogVolumeDensityComponent) array<Actor> FogVolumeActors;
var(FogVolumeDensityComponent) interp LinearColor SimpleLightColor;
var(FogVolumeDensityComponent) interp LinearColor ApproxFogLightColor;
var(FogVolumeDensityComponent) MaterialInterface FogMaterial;
var MaterialInterface DefaultFogVolumeMaterial;
var(FogVolumeDensityComponent) interp float StartDistance;
var(FogVolumeDensityComponent) const bool bEnabled;
var(FogVolumeDensityComponent) bool bAffectsTranslucency;

public final native function SetEnabled(bool bSetEnabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SimpleLightColor = {R = 0.5, G = 0.5, B = 0.699999988, A = 1.0}
    ApproxFogLightColor = {R = 0.5, G = 0.5, B = 0.699999988, A = 1.0}
    DefaultFogVolumeMaterial = Material'EngineMaterials.FogVolumeMaterial'
    bEnabled = TRUE
    bAffectsTranslucency = TRUE
}
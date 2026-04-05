Class SFXLightRig
    native;

var(SFXLightRig) SHVectorRGB LightEnvironment;
var(SFXLightRig) SHVectorRGB NonShadowedLightEnvironment;
var(SFXLightRig) LinearColor KeyLightModifier;
var(SFXLightRig) LinearColor FillLightModifier;
var(SFXLightRig) LinearColor AmbientLightModifier;
var(SFXLightRig) LinearColor TotalShadowIntensity;
var(SFXLightRig) Vector ShadowDirection;

public final native function Init(BioDynamicLightEnvironmentComponent InSourceEnv);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    KeyLightModifier = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
    FillLightModifier = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
    AmbientLightModifier = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
    TotalShadowIntensity = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
}
Class BioLineBloomEffect extends PostProcessEffect
    deprecated;

struct BioFlareParameters 
{
    var(BioFlareParameters) BioFlareColour FlareBase;
    var(BioFlareParameters) BioFlareColour FlareHot;
    var(BioFlareParameters) float FlareTintMultiplier;
    var(BioFlareParameters) float LineLength;
    var(BioFlareParameters) float FalloffParameter;
};
struct BioFlareColour 
{
    var(BioFlareColour) Vector Tint;
    var(BioFlareColour) float IntensityThreshold;
};

var(BioLineBloomEffect) BioFlareParameters BaseFlare;
var(BioLineBloomEffect) BioFlareParameters OverrideFlare;
var(BioLineBloomEffect) float BlurScale;
var(BioLineBloomEffect) int BlurWidth;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BaseFlare = {
                 FlareBase = {
                              Tint = {X = 0.0, Y = 0.0, Z = 0.75}, 
                              IntensityThreshold = 0.899999976
                             }, 
                 FlareHot = {
                             Tint = {X = 1.0, Y = 1.0, Z = 1.0}, 
                             IntensityThreshold = 1.5
                            }, 
                 FlareTintMultiplier = 1.0, 
                 LineLength = 0.25, 
                 FalloffParameter = 0.949999988
                }
    OverrideFlare = {
                     FlareBase = {
                                  Tint = {X = 0.0, Y = 0.0, Z = 0.75}, 
                                  IntensityThreshold = 2.0
                                 }, 
                     FlareHot = {
                                 Tint = {X = 2.0, Y = 2.0, Z = 2.0}, 
                                 IntensityThreshold = 5.0
                                }, 
                     FlareTintMultiplier = 1.0, 
                     LineLength = 0.75, 
                     FalloffParameter = 0.975000024
                    }
    BlurScale = 0.5
    BlurWidth = 3
}
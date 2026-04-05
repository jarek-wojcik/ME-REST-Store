Class UberPostProcessEffect extends DOFBloomMotionBlurEffect
    native;

enum EPostProcessAAType
{
    PostProcessAA_Off,
    PostProcessAA_FXAA0,
    PostProcessAA_FXAA1,
    PostProcessAA_FXAA2,
    PostProcessAA_FXAA3,
    PostProcessAA_FXAA4,
    PostProcessAA_FXAA5,
    PostProcessAA_MLAA,
    PostProcessAA_SFX_FXAA,
};

var(UberPostProcessEffect) Vector SceneShadows;
var(UberPostProcessEffect) Vector SceneHighLights;
var(UberPostProcessEffect) Vector SceneMidTones;
var(UberPostProcessEffect) float SceneDesaturation;
var(PostprocessAntiAliasing) float EdgeDetectionThreshold;
var(UberPostProcessEffect) bool EnableDOF;
var(UberPostProcessEffect) bool EnableBloom;
var(UberPostProcessEffect) bool EnableColorMapping;
var(UberPostProcessEffect) bool EnableMotionBlur;
var(PostprocessAntiAliasing) EPostProcessAAType PostProcessAAType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SceneShadows = {X = 0.0, Y = 0.0, Z = -0.00300000003}
    SceneHighLights = {X = 0.800000012, Y = 0.800000012, Z = 0.800000012}
    SceneMidTones = {X = 1.29999995, Y = 1.29999995, Z = 1.29999995}
    SceneDesaturation = 0.400000006
    EdgeDetectionThreshold = 12.0
}
Class DOFAndBloomEffect extends DOFEffect
    native;

var(DOFAndBloomEffect) float BloomScale;
var(DOFAndBloomEffect) float BloomThreshold;
var(DOFAndBloomEffect) Color BloomTint;
var(DOFAndBloomEffect) float BloomScreenBlendThreshold;
var(DOFAndBloomEffect) float SceneMultiplier;
var(DOFAndBloomEffect) float BlurBloomKernelSize;
var(DOFAndBloomEffect) bool bEnableReferenceDOF;
var(DOFAndBloomEffect) bool bEnableDepthOfFieldHQ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BloomScale = 1.0
    BloomThreshold = 1.0
    BloomTint = {B = 255, G = 255, R = 255, A = 0}
    BloomScreenBlendThreshold = 10.0
    SceneMultiplier = 1.0
    BlurBloomKernelSize = 16.0
    BlurKernelSize = 16.0
}
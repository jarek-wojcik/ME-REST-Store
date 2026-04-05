Class DOFBloomMotionBlurEffect extends DOFAndBloomEffect
    native;

var(DOFBloomMotionBlurEffect) float MaxVelocity;
var(DOFBloomMotionBlurEffect) float MotionBlurAmount;
var(DOFBloomMotionBlurEffect) float CameraRotationThreshold;
var(DOFBloomMotionBlurEffect) float CameraTranslationThreshold;
var(DOFBloomMotionBlurEffect) bool FullMotionBlur;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxVelocity = 1.0
    MotionBlurAmount = 0.5
    CameraRotationThreshold = 90.0
    CameraTranslationThreshold = 10000.0
    FullMotionBlur = TRUE
    bShowInEditor = FALSE
}
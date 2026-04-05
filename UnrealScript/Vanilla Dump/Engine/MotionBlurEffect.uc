Class MotionBlurEffect extends PostProcessEffect
    native;

var(MotionBlurEffect) float MaxVelocity;
var(MotionBlurEffect) float MotionBlurAmount;
var(MotionBlurEffect) float CameraRotationThreshold;
var(MotionBlurEffect) float CameraTranslationThreshold;
var(MotionBlurEffect) bool FullMotionBlur;

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
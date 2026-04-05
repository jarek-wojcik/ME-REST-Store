Class SceneCapture2DHitMaskComponent extends SceneCaptureComponent
    native;

var const transient TextureRenderTarget2D TextureTarget;
var const editinline transient export SkeletalMeshComponent SkeletalMeshComp;
var int RenderSection;
var int ForceLOD;
var float FadingStartTimeAfterHit;
var float FadingPercentage;
var float FadingDurationTime;
var float FadingIntervalTime;

public final native function SetCaptureParameters(const Vector InMaskPosition, const float InMaskRadius, const Vector InStartupPosition);

public final native function SetCaptureTargetTexture(const TextureRenderTarget2D InTextureTarget);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceLOD = -1
    FadingStartTimeAfterHit = 10.0
    FadingPercentage = 0.99000001
    FadingDurationTime = 50.0
    FadingIntervalTime = 3.0
}
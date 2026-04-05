Class SceneCapturePortalComponent extends SceneCaptureComponent
    native;

var(Capture) const TextureRenderTarget2D TextureTarget;
var(Capture) const float ScaleFOV;
var(Capture) const Actor ViewDestination;

public final native function SetCaptureParameters(optional TextureRenderTarget2D NewTextureTarget = TextureTarget, optional float NewScaleFOV = ScaleFOV, optional Actor NewViewDest = ViewDestination);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScaleFOV = 1.0
    FrameRate = 1000.0
    bSkipUpdateIfOwnerOccluded = TRUE
}
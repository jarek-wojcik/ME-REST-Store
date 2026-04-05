Class SceneCaptureReflectComponent extends SceneCaptureComponent
    native;

var(Capture) TextureRenderTarget2D TextureTarget;
var(Capture) float ScaleFOV;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScaleFOV = 1.0
    FrameRate = 1000.0
}
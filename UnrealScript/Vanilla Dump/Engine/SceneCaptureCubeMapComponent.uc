Class SceneCaptureCubeMapComponent extends SceneCaptureComponent
    native;

var const transient native Vector WorldLocation;
var(Capture) TextureRenderTargetCube TextureTarget;
var(Capture) float NearPlane;
var(Capture) float FarPlane;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NearPlane = 20.0
    FarPlane = 500.0
}
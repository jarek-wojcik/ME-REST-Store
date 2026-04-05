Class SceneCapture2DComponent extends SceneCaptureComponent
    native;

var const transient Matrix ViewMatrix;
var const transient Matrix ProjMatrix;
var(Capture) const TextureRenderTarget2D TextureTarget;
var(Capture) const float FieldOfView;
var(Capture) const float NearPlane;
var(Capture) const float FarPlane;
var bool bUpdateMatrices;

public final native function SetCaptureParameters(optional TextureRenderTarget2D NewTextureTarget = TextureTarget, optional float NewFOV = FieldOfView, optional float NewNearPlane = NearPlane, optional float NewFarPlane = FarPlane);

public final native function SetView(Vector NewLocation, Rotator NewRotation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ViewMatrix = {
                  XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                  YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                  ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                  WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
                 }
    ProjMatrix = {
                  XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
                  YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
                  ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
                  WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
                 }
    FieldOfView = 80.0
    NearPlane = 20.0
    FarPlane = 500.0
    bUpdateMatrices = TRUE
}
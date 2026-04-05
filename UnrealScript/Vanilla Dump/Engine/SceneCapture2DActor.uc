Class SceneCapture2DActor extends SceneCaptureActor
    native
    placeable;

var const editinline export DrawFrustumComponent DrawFrustum;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawFrustumComponent Name=DrawFrust0
        FrustumColor = {B = 255, G = 255, R = 255, A = 255}
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SceneCapture2DComponent Name=SceneCapture2DComponent0
    End Object
    DrawFrustum = DrawFrust0
    SceneCapture = SceneCapture2DComponent0
    Components = (SceneCapture2DComponent0, None, DrawFrust0)
}
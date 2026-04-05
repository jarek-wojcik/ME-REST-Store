Class SceneCaptureCubeMapActor extends SceneCaptureActor
    native
    placeable;

var const editinline export StaticMeshComponent StaticMesh;
var transient MaterialInstanceConstant CubeMaterialInst;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SceneCaptureCubeMapComponent Name=SceneCaptureCubeMapComponent0
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        HiddenGame = TRUE
        CastShadow = FALSE
        bAcceptsLights = FALSE
        CollideActors = FALSE
        Scale3D = {X = 0.600000024, Y = 0.600000024, Z = 0.600000024}
    End Object
    StaticMesh = StaticMeshComponent0
    SceneCapture = SceneCaptureCubeMapComponent0
    Components = (SceneCaptureCubeMapComponent0, StaticMeshComponent0)
}
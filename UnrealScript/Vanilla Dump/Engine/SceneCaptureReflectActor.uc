Class SceneCaptureReflectActor extends SceneCaptureActor
    native
    placeable;

var(SceneCaptureReflectActor) const editinline export StaticMeshComponent StaticMesh;
var transient MaterialInstanceConstant ReflectMaterialInst;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SceneCaptureReflectComponent Name=SceneCaptureReflectComponent0
        bSkipUpdateIfTextureUsersOccluded = TRUE
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        HiddenGame = TRUE
        CastShadow = FALSE
        bAcceptsLights = FALSE
        CollideActors = FALSE
        Scale3D = {X = 4.0, Y = 4.0, Z = 4.0}
    End Object
    StaticMesh = StaticMeshComponent0
    SceneCapture = SceneCaptureReflectComponent0
    Components = (None, SceneCaptureReflectComponent0, StaticMeshComponent0)
    Rotation = {Pitch = 16384, Yaw = 0, Roll = 0}
}
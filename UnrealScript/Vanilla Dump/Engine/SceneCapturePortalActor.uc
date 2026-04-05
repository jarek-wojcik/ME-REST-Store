Class SceneCapturePortalActor extends SceneCaptureReflectActor
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SceneCapturePortalComponent Name=SceneCapturePortalComponent0
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent2
        ReplacementPrimitive = None
        HiddenGame = TRUE
        CastShadow = FALSE
        CollideActors = FALSE
        AlwaysLoadOnClient = FALSE
        AlwaysLoadOnServer = FALSE
    End Object
    StaticMesh = StaticMeshComponent2
    SceneCapture = SceneCapturePortalComponent0
    Components = (SceneCapturePortalComponent0, None, StaticMeshComponent2)
    Rotation = {Pitch = 0, Yaw = 0, Roll = 0}
}
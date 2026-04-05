Class StaticMeshActor extends StaticMeshActorBase
    native
    placeable;

var(StaticMeshActor) const editinline editconst export StaticMeshComponent StaticMeshComponent;
var(StaticMeshActor) editinline export AudioComponent oAudioComponent;

public event function PreBeginPlay();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        bAllowApproximateOcclusion = TRUE
        bUsePrecomputedShadows = TRUE
    End Object
    StaticMeshComponent = StaticMeshComponent0
    Components = (StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bPathColliding = TRUE
}
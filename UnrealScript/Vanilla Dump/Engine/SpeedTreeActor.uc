Class SpeedTreeActor extends Actor
    native
    placeable;

var(SpeedTreeActor) const editinline editconst export SpeedTreeComponent SpeedTreeComponent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SpeedTreeComponent Name=SpeedTreeComponent0
        ReplacementPrimitive = None
        bAllowApproximateOcclusion = TRUE
        bForceDirectLightMap = TRUE
    End Object
    SpeedTreeComponent = SpeedTreeComponent0
    Components = (SpeedTreeComponent0)
    CollisionComponent = SpeedTreeComponent0
    bStatic = TRUE
    bNoDelete = TRUE
    bWorldGeometry = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
}
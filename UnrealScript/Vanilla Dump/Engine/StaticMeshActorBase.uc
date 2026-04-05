Class StaticMeshActorBase extends Actor
    native
    abstract;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bStatic = TRUE
    bWorldGeometry = TRUE
    bRouteBeginPlayEvenIfStatic = FALSE
    bGameRelevant = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
}
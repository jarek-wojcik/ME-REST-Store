Class ActorFactorySkeletalMesh extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactorySkeletalMesh) Name AnimSequenceName;
var(ActorFactorySkeletalMesh) SkeletalMesh SkeletalMesh;
var(ActorFactorySkeletalMesh) AnimSet AnimSet;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add SkeletalMesh"
    GameplayActorClass = Class'SkeletalMeshActorSpawnable'
    NewActorClass = Class'SkeletalMeshActor'
    MenuPriority = 12
    AlternateMenuPriority = 11
}
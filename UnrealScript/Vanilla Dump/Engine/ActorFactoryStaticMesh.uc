Class ActorFactoryStaticMesh extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryStaticMesh) Vector DrawScale3D;
var(ActorFactoryStaticMesh) StaticMesh StaticMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    MenuName = "Add StaticMesh"
    NewActorClass = Class'StaticMeshActor'
    MenuPriority = 30
    AlternateMenuPriority = 30
}
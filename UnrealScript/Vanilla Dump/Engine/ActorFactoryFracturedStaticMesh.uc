Class ActorFactoryFracturedStaticMesh extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryFracturedStaticMesh) Vector DrawScale3D;
var(ActorFactoryFracturedStaticMesh) FracturedStaticMesh FracturedStaticMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    MenuName = "Add FracturedStaticMesh"
    NewActorClass = Class'FracturedStaticMeshActor'
    MenuPriority = 35
    AlternateMenuPriority = 35
}
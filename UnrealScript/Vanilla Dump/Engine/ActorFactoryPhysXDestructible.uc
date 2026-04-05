Class ActorFactoryPhysXDestructible extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryPhysXDestructible) Vector DrawScale3D;
var(ActorFactoryPhysXDestructible) PhysXDestructible PhysXDestructible;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    MenuName = "Add PhysXDestructibleActor"
    NewActorClass = Class'PhysXDestructibleActor'
}
Class ActorFactoryApexDestructible extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryApexDestructible) ApexDestructibleAsset DestructibleAsset;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add ApexDestructibleActor"
    NewActorClass = Class'ApexDestructibleActor'
}
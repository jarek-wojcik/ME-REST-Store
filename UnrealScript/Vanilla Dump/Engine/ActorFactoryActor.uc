Class ActorFactoryActor extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryActor) Class<Actor> ActorClass;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ActorClass = Class'Actor'
    bPlaceable = FALSE
}
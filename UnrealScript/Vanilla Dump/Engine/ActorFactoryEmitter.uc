Class ActorFactoryEmitter extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryEmitter) ParticleSystem ParticleSystem;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add Emitter"
    GameplayActorClass = Class'EmitterSpawnable'
    NewActorClass = Class'Emitter'
}
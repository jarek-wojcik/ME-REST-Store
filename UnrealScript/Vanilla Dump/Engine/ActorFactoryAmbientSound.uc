Class ActorFactoryAmbientSound extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryAmbientSound) SoundCue AmbientSoundCue;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add AmbientSound"
    NewActorClass = Class'AmbientSound'
}
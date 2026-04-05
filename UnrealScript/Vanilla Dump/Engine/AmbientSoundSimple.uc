Class AmbientSoundSimple extends AmbientSound
    native
    placeable
    transient;

var(AmbientSoundSimple) editconst SoundNodeAmbient AmbientProperties;
var const export SoundCue SoundCueInstance;
var const export SoundNodeAmbient SoundNodeInstance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SoundNodeAmbient Name=SoundNodeAmbient0
    End Object
    SoundNodeInstance = SoundNodeAmbient0
}
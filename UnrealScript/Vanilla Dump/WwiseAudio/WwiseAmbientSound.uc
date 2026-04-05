Class WwiseAmbientSound extends Keypoint
    native
    placeable;

var(WwiseAmbientSound) WwiseEventPair AudioEvent;
var(Audio) const editinline editconst transient export WwiseAudioComponent AudioComponent;
var(WwiseAmbientSound) bool bAutoPlay;
var transient bool bWasPlaying;
var bool bIsPlaying;

public final native function DrawEmitter();

public final native function HideEmitter();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAutoPlay = TRUE
    Components = (None, None)
    Rotation = {Pitch = -16384, Yaw = 0, Roll = 0}
}
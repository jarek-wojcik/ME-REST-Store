Class AmbientSound extends Keypoint
    native
    placeable
    transient;

var(Audio) const editinline editconst export AudioComponent AudioComponent;
var(AmbientSound) bool bAutoPlay;
var bool bIsPlaying;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAutoPlay = TRUE
    Components = (None, None, None)
}
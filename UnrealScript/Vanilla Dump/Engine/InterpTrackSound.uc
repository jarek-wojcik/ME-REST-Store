Class InterpTrackSound extends InterpTrackVectorBase
    native
    transient
    collapsecategories;

struct native SoundTrackKey 
{
    var float Time;
    var float Volume;
    var float Pitch;
    var(SoundTrackKey) SoundCue Sound;
    
    structdefaultproperties
    {
        Volume = 1.0
        Pitch = 1.0
    }
};

var array<SoundTrackKey> Sounds;
var(InterpTrackSound) bool bContinueSoundOnMatineeEnd;
var(InterpTrackSound) bool bSuppressSubtitles;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstSound'
    TrackTitle = "Sound"
}
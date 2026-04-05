Class MusicTrackDataStructures
    native;

struct native MusicTrackStruct 
{
    var(MusicTrackStruct) SoundCue TheSoundCue;
    var(MusicTrackStruct) float FadeInTime;
    var(MusicTrackStruct) float FadeInVolumeLevel;
    var(MusicTrackStruct) float FadeOutTime;
    var(MusicTrackStruct) float FadeOutVolumeLevel;
    var(MusicTrackStruct) bool bAutoPlay;
    var(MusicTrackStruct) bool bPersistentAcrossLevels;
    
    structdefaultproperties
    {
        FadeInTime = 5.0
        FadeInVolumeLevel = 1.0
        FadeOutTime = 5.0
    }
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
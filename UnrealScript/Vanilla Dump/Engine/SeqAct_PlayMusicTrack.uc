Class SeqAct_PlayMusicTrack extends SequenceAction
    native;

var(SeqAct_PlayMusicTrack) MusicTrackStruct MusicTrack;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MusicTrack = {
                  TheSoundCue = None, 
                  FadeInTime = 5.0, 
                  FadeInVolumeLevel = 1.0, 
                  FadeOutTime = 5.0, 
                  FadeOutVolumeLevel = 0.0, 
                  bAutoPlay = FALSE, 
                  bPersistentAcrossLevels = FALSE
                 }
    VariableLinks = ()
}
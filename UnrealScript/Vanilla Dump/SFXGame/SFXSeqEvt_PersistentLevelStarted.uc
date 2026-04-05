Class SFXSeqEvt_PersistentLevelStarted extends SequenceEvent
    native;

var(SFXSeqEvt_PersistentLevelStarted) bool bFreezeLevelStreaming;
var(SFXSeqEvt_PersistentLevelStarted) bool bKeepLoadMovie;
var(SFXSeqEvt_PersistentLevelStarted) bool bSkipTextureStreaming;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFreezeLevelStreaming = TRUE
    bKeepLoadMovie = TRUE
    bSkipTextureStreaming = TRUE
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ()
}
Class BioEvtSysTrackSubtitles extends SFXGameInterpTrack
    native
    collapsecategories;

struct native BioSubtitleTrackData 
{
    var(BioSubtitleTrackData) int nStrRefID;
    var(BioSubtitleTrackData) float fLength;
    var(BioSubtitleTrackData) bool bShowAtTop;
    var(BioSubtitleTrackData) bool bUseOnlyAsReplyWheelHint;
};

var(BioEvtSysTrackSubtitles) array<BioSubtitleTrackData> m_aSubtitleData;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "Bio Conversation";
}
public static event function string KeyDataArrayName()
{
    return "m_aSubtitleData";
}
public static event function string KeyDataDisplayName()
{
    return "Subtitle Data";
}
public static event function string NewKeyDefaultName()
{
    return "Subtitle";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackSubtitlesInst'
    TrackTitle = "Subtitles"
    bOnePerGroup = TRUE
}
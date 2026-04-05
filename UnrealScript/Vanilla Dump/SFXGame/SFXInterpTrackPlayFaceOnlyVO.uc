Class SFXInterpTrackPlayFaceOnlyVO extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioFOVOTrackData 
{
    var(BioFOVOTrackData) BioConversation pConversation;
    var(BioFOVOTrackData) int nLineStrRef;
    var(BioFOVOTrackData) stringref srActorNameOverride;
    var(BioFOVOTrackData) bool bForceHideSubtitles;
    var(BioFOVOTrackData) bool bPlaySoundOnly;
    var(BioFOVOTrackData) bool bDisableDelayUntilPreload;
    var(BioFOVOTrackData) bool bAllowInConversation;
    var(BioFOVOTrackData) bool bSubtitleHasPriority;
    
    structdefaultproperties
    {
        bSubtitleHasPriority = TRUE
    }
};

var(SFXInterpTrackPlayFaceOnlyVO) array<BioFOVOTrackData> m_aFOVOKeys;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "SFX Cinematics";
}
public static event function string KeyDataArrayName()
{
    return "m_aFOVOKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Play FOVO Data";
}
public static event function string NewKeyDefaultName()
{
    return "PlayFaceOnlyVO";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXInterpTrackPlayFaceOnlyVOInst'
    TrackTitle = "Play FOVO"
}
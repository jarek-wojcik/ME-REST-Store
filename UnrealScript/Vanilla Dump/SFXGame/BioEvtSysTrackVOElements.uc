Class BioEvtSysTrackVOElements extends SFXGameInterpTrack
    native
    collapsecategories;

var(BioEvtSysTrackVOElements) int m_nStrRefID;
var(BioEvtSysTrackVOElements) float m_fJCutOffset;

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
    return "";
}
public static event function string KeyDataDisplayName()
{
    return "VOElements Data";
}
public static event function string NewKeyDefaultName()
{
    return "VOElems";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nStrRefID = -1
    TrackInstClass = Class'BioEvtSysTrackVOElementsInst'
    TrackTitle = "VO Elements"
    bOnePerGroup = TRUE
}
Class BioEvtSysTrackInterrupt extends SFXGameInterpTrack
    native
    collapsecategories;

struct native BioInterruptTrackData 
{
    var(BioInterruptTrackData) bool bShowInterrupt;
};

var(BioEvtSysTrackInterrupt) array<BioInterruptTrackData> m_aInterruptData;

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
    return "m_aInterruptData";
}
public static event function string KeyDataDisplayName()
{
    return "Interrupt Data";
}
public static event function string NewKeyDefaultName()
{
    return "Interrupt";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackInterruptInst'
    TrackTitle = "Interrupt"
    bOnePerGroup = TRUE
}
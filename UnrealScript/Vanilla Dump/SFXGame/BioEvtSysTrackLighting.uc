Class BioEvtSysTrackLighting extends SFXGameActorInterpTrack
    native
    collapsecategories;

var(BioEvtSysTrackLighting) array<BioConvLightingData> m_aLightingKeys;

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
    return "m_aLightingKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Lighting Data";
}
public static event function string NewKeyDefaultName()
{
    return "Lighting";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackLightingInst'
    TrackTitle = "Lighting"
}
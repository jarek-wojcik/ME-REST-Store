Class BioConvNodeTrackDebug extends SFXGameInterpTrack
    native
    collapsecategories;

var(BioConvNodeTrackDebug) array<string> m_aDbgStrings;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "Bio Debug";
}
public static event function string KeyDataArrayName()
{
    return "m_aDbgStrings";
}
public static event function string KeyDataDisplayName()
{
    return "Debug Text";
}
public static event function string NewKeyDefaultName()
{
    return "DebugMsg";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioConvNodeTrackDebugInst'
    TrackTitle = "Bio Debug"
    bOnePerGroup = TRUE
}
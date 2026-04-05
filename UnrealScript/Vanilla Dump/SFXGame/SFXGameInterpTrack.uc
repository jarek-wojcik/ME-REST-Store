Class SFXGameInterpTrack extends BioInterpTrack
    native
    abstract
    collapsecategories;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "";
}
public static event function string KeyDataArrayName()
{
    return "";
}
public static event function string KeyDataDisplayName()
{
    return "";
}
public static event function string NewKeyDefaultName()
{
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInst'
    TrackTitle = "SFXGame Base Track"
}
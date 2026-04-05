Class SFXInterpTrackToggleLightEnvironment extends SFXInterpTrackToggleBase
    native
    collapsecategories;

var transient BioSeqAct_ToggleLightEnv m_LightEnvSeq;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataDisplayName()
{
    return "Toggle Light Env Data";
}
public static event function string NewKeyDefaultName()
{
    return "ToggleLightEnv";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackTitle = "Toggle Light Env"
}
Class SFXInterpTrackForceLightEnvUpdate extends SFXGameInterpTrackCustom
    native
    collapsecategories;

var transient BioSeqAct_ForceLightEnvUpdate m_SeqForceUpdateLight;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "";
}
public static event function string KeyDataDisplayName()
{
    return "Force Update Light Env";
}
public static event function string NewKeyDefaultName()
{
    return "UpDateLightEnv";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Force Update Lighting"
}
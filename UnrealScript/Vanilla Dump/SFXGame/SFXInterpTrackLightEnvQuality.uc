Class SFXInterpTrackLightEnvQuality extends SFXGameInterpTrackCustom
    native
    collapsecategories;

struct native SFXLightEnvTrackData 
{
    var int PlaceHolder;
    var(SFXLightEnvTrackData) EDLEStateType Quality;
};

var(SFXInterpTrackLightEnvQuality) array<SFXLightEnvTrackData> m_aLightEnvKeyData;
var transient BioSeqAct_SetLightEnvQuality m_LightEnvSeq;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aLightEnvKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Light Env Quality Data";
}
public static event function string NewKeyDefaultName()
{
    return "LightEnvQuality";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Light Env Quality"
}
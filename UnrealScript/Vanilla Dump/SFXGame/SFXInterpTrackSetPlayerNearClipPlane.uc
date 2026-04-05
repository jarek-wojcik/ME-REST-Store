Class SFXInterpTrackSetPlayerNearClipPlane extends SFXGameInterpTrackCustom
    native
    collapsecategories;

struct native SFXNearClipTrackData 
{
    var(SFXNearClipTrackData) float m_fValue;
    var(SFXNearClipTrackData) bool m_bUseDefaultValue;
};

var(SFXInterpTrackSetPlayerNearClipPlane) array<SFXNearClipTrackData> m_aNearClipKeyData;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aNearClipKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Near Clip Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "PlayerNearClip";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Player Near Clip"
}
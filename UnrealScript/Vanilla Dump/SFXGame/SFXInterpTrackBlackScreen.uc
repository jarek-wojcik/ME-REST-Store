Class SFXInterpTrackBlackScreen extends SFXGameInterpTrackCustom
    native
    collapsecategories;

struct native SFXBlackScreenTrackData 
{
    var int PlaceHolder;
    var(SFXBlackScreenTrackData) BlackScreenActionSet BlackScreenState;
};

var(SFXInterpTrackBlackScreen) array<SFXBlackScreenTrackData> m_aBlackScreenKeyData;
var transient BioSeqAct_BlackScreen m_BlackScreenSeq;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aBlackScreenKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Black Screen Data";
}
public static event function string NewKeyDefaultName()
{
    return "BlackScreen";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Black Screen"
}
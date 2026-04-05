Class SFXInterpTrackToggleBase extends SFXGameInterpTrackCustom
    native
    abstract
    collapsecategories;

struct native SFXToggleTrackData 
{
    var(SFXToggleTrackData) bool m_bToggle;
    var(SFXToggleTrackData) bool m_bEnable;
};

var(SFXInterpTrackToggleBase) array<SFXToggleTrackData> m_aToggleKeyData;
var(SFXInterpTrackToggleBase) array<BioSeqVar_ObjectFindByTag> m_aTarget;
var transient Actor m_TargetActor;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aToggleKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Toggle Data";
}
public static event function string NewKeyDefaultName()
{
    return "Toggle";
}
public native function SetupToggleSequenceOp(SequenceOp Seq, bool bToggle, bool bEnable);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Toggle Track"
}
Class BioEvtSysTrackSetFacing extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioSetFacingData 
{
    var Name nmStageNode;
    var(BioSetFacingData) float fOrientation;
    var(BioSetFacingData) bool bApplyOrientation;
    var(BioSetFacingData) EDynamicStageNodes eCurrentStageNode;
};
enum EDynamicStageNodes
{
    EDynamicStageNodes_UNSET,
};

var(BioEvtSysTrackSetFacing) array<BioSetFacingData> m_aFacingKeys;

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
    return "m_aFacingKeys";
}
public static event function string KeyDataDisplayName()
{
    return "Facing Data";
}
public static event function string NewKeyDefaultName()
{
    return "Facing";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackSetFacingInst'
    TrackTitle = "Pawn Facing"
}
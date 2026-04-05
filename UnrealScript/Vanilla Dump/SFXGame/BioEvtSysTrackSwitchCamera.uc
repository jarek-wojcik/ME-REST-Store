Class BioEvtSysTrackSwitchCamera extends SFXGameInterpTrack
    native
    collapsecategories;

struct native BioCameraSwitchData 
{
    var Name nmStageSpecificCam;
    var(BioCameraSwitchData) bool bForceCrossingLineOfAction;
    var(BioCameraSwitchData) bool bUseForNextCamera;
};
enum EBioSwitchCamSpecific
{
    SwitchCam_Unset,
};

var(BioEvtSysTrackSwitchCamera) array<BioCameraSwitchData> m_aCameras;

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
    return "m_aCameras";
}
public static event function string KeyDataDisplayName()
{
    return "Camera Data";
}
public static event function string NewKeyDefaultName()
{
    return "Camera";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioEvtSysTrackSwitchCameraInst'
    TrackTitle = "Switch Camera"
    bOnePerGroup = TRUE
}
Class BioEvtSysTrackDOF extends SFXGameInterpTrack
    native
    config(Game)
    collapsecategories;

struct native BioDOFTrackData 
{
    var(BioDOFTrackData) Vector vFocusPosition;
    var(BioDOFTrackData) float fFalloffExponent;
    var(BioDOFTrackData) float fBlurKernelSize;
    var(BioDOFTrackData) float fMaxNearBlurAmount;
    var(BioDOFTrackData) float fMaxFarBlurAmount;
    var(BioDOFTrackData) Color cModulateBlurColor;
    var(BioDOFTrackData) float fFocusInnerRadius;
    var(BioDOFTrackData) float fFocusDistance;
    var(BioDOFTrackData) float fInterpolateSeconds;
    var(BioDOFTrackData) bool bEnableDOF;
    
    structdefaultproperties
    {
        fFalloffExponent = 7.0
        fBlurKernelSize = 1.20000005
        fMaxNearBlurAmount = 1.0
        fMaxFarBlurAmount = 1.0
        cModulateBlurColor = {B = 128, G = 128, R = 128, A = 255}
        fFocusInnerRadius = 600.0
        fFocusDistance = 600.0
    }
};

var(BioEvtSysTrackDOF) array<BioDOFTrackData> m_aDOFData;
var config transient float m_fDOFDefaultBlurKernel;
var config transient float m_fDOFDefaultExponent;
var config transient float m_fDOFDefaultMaxNearBlur;
var config transient float m_fDOFDefaultMaxFarBlur;

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
    return "m_aDOFData";
}
public static event function string KeyDataDisplayName()
{
    return "DOF Data";
}
public static event function string NewKeyDefaultName()
{
    return "DOF";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fDOFDefaultBlurKernel = 2.9000001
    m_fDOFDefaultExponent = 2.0
    m_fDOFDefaultMaxNearBlur = 1.0
    m_fDOFDefaultMaxFarBlur = 0.75
    TrackInstClass = Class'BioEvtSysTrackDOFInst'
    TrackTitle = "Depth of Field"
    bOnePerGroup = TRUE
}
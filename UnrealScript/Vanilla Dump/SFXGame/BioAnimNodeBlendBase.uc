Class BioAnimNodeBlendBase extends AnimNodeBlendBase
    native;

enum EBioAnimBlendDirection
{
    eBioAnimBlend_NOBLEND,
    eBioAnimBlend_BLENDUP,
    eBioAnimBlend_BLENDDOWN,
    eBioAnimBlend_BLENDDIRECT,
};

var float m_fBlendTime;
var float m_fRemainingTime;
var float m_fTotalBlendTime;
var float m_fTargetWeight;
var int m_nLastChild;
var int m_nTargetChild;
var bool m_bIsBlending;
var bool m_bTriggerTimeBlend;
var bool m_bBlendDirect;
var bool m_bShowSlider;

public final native function SetChildAnimTime(AnimNode oChild, float fTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nLastChild = 1
}
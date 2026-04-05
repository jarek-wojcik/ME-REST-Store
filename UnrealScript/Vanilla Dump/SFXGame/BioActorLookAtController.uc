Class BioActorLookAtController extends BioSkelControlAdditiveLookAt
    native;

var transient Matrix m_mControlledRefPose;
var transient native Pointer mc_pDefinition;
var transient Vector LastOrigin;
var transient Actor m_pTargetActor;
var transient int m_nTargetBoneIndex;
var transient float m_fDelayTimer;
var transient int m_nRootAnimBoneIndex;
var transient float m_fPrevAngVelocity;
var transient float m_fLimitZoneAngle;
var transient bool m_bDoAdditive;
var transient bool m_bAnimFirst;
var transient bool m_bResetTargetLocation;
var transient bool m_bDisabling;
var transient bool m_RootAnimBoneLookAtInverted;
var transient bool m_RootAnimBoneUpInverted;
var transient bool m_bTargetReached;
var transient bool m_bRootBoneYawOnly;
var transient bool bHasValidLastOrigin;
var transient bool bTransitioningFromDisabled;
var transient byte m_RootAnimBoneLookAtAxis;
var transient byte m_RootAnimBoneUpAxis;
var transient byte nTransitionType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nRootAnimBoneIndex = -1
    m_fLimitZoneAngle = 2.3499999
    m_bDoAdditive = TRUE
    m_bRootBoneYawOnly = TRUE
}
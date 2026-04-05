Class SFXSkelCtrl_FootPlanting extends SkelControlLimb
    native;

var const transient Vector LockFootLoc;
var const transient Vector LockedFootWorldLoc;
var(SFXSkelCtrl_FootPlanting) Name FootBoneName;
var(SFXSkelCtrl_FootPlanting) Name IKFootBoneName;
var(SFXSkelCtrl_FootPlanting) float FootLockZThreshold;
var(SFXSkelCtrl_FootPlanting) float LockAlphaBlendTime;
var const transient float LockAlphaBlendTimeToGo;
var const transient float LockAlpha;
var const transient float LockAlphaTarget;
var const transient float LastDeltaTime;
var(SFXSkelCtrl_FootPlanting) bool bDoFootLocking;
var const transient bool bLockFoot;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LockAlphaBlendTime = 0.200000003
}
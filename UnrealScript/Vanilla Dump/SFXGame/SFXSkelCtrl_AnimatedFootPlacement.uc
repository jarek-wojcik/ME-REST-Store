Class SFXSkelCtrl_AnimatedFootPlacement extends SkelControl_CCD_IK
    native;

var const transient Vector LockFootLoc;
var const transient Vector LockedFootWorldLoc;
var(SFXSkelCtrl_AnimatedFootPlacement) float LockAlphaBlendTime;
var(SFXSkelCtrl_AnimatedFootPlacement) float HitZOffset;
var const transient float LockAlphaBlendTimeToGo;
var const transient float LockAlpha;
var const transient float LockAlphaTarget;
var const transient float LastDeltaTime;
var const transient bool bLockFoot;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LockAlphaBlendTime = 0.200000003
}
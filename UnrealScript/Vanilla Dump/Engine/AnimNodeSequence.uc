Class AnimNodeSequence extends AnimNode
    native;

enum ERootRotationOption
{
    RRO_Default,
    RRO_Discard,
    RRO_Extract,
};
enum ERootBoneAxis
{
    RBA_Default,
    RBA_Discard,
    RBA_Translate,
};

var(AnimNodeSequence) const Name AnimSeqName;
var(Group) const Name SynchGroupName;
var(AnimNodeSequence) float Rate;
var(AnimNodeSequence) const float CurrentTime;
var const transient float PreviousTime;
var const transient AnimSequence AnimSeq;
var const transient int AnimLinkupIndex;
var(AnimNodeSequence) float NotifyWeightThreshold;
var(Group) float SynchPosOffset;
var(Camera) CameraAnim CameraAnim;
var transient CameraAnimInst ActiveCameraAnimInstance;
var(Camera) float CameraAnimScale;
var(Camera) float CameraAnimPlayRate;
var(AnimNodeSequence) bool bPlaying;
var(AnimNodeSequence) bool bLooping;
var(AnimNodeSequence) bool bCauseActorAnimEnd;
var(AnimNodeSequence) bool bCauseActorAnimPlay;
var(AnimNodeSequence) bool bZeroRootRotation;
var(AnimNodeSequence) bool bZeroRootTranslation;
var(AnimNodeSequence) bool bDisableWarningWhenAnimNotFound;
var bool bHasWeightIgnoreNotifies;
var(AnimNodeSequence) bool bNoNotifies;
var(AnimNodeSequence) bool bForceRefposeWhenNotPlaying;
var bool bIsIssuingNotifies;
var(Group) bool bForceAlwaysSlave;
var(Group) const bool bSynchronize;
var(Group) const bool bReverseSync;
var(Display) bool bShowTimeLineSlider;
var(Camera) bool bLoopCameraAnim;
var(Camera) bool bRandomizeCameraAnimLoopStartTime;
var const bool bEditorOnlyAddRefPoseToAdditiveAnimation;
var(AnimNodeSequence) ERootBoneAxis RootBoneOption[3];
var(AnimNodeSequence) ERootRotationOption RootRotationOption[3];

public native function float FindGroupPosition(float GroupRelativePosition);

public native function float FindGroupRelativePosition(float GroupRelativePosition);

public native function float GetAnimPlaybackLength();

public native function float GetGlobalPlayRate();

public native function float GetGroupRelativePosition();

public native function float GetNormalizedPosition();

public native function float GetTimeLeft();

public native function PlayAnim(optional bool bLoop = FALSE, optional float InRate = 1.0, optional float StartTime = 0.0);

public native function ReplayAnim();

public native function SetAnim(Name Sequence);

public native function SetPosition(float NewTime, bool bFireNotifies);

public native function StopAnim();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Rate = 1.0
    CameraAnimScale = 1.0
    CameraAnimPlayRate = 1.0
    bSynchronize = TRUE
}
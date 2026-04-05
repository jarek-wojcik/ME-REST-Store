Class BioAnimNodeBlend_TurnInPlace extends AnimNodeBlendList
    native;

struct native RotTransitionInfo 
{
    var(RotTransitionInfo) float RotationOffset;
    var(RotTransitionInfo) int ChildIndex;
};

var array<BioAnimNodeAimOffset> OffsetNodes;
var(BioAnimNodeBlend_TurnInPlace) array<RotTransitionInfo> RotTransitions;
var const transient int LastPawnYaw;
var const transient float PawnRotationRate;
var const transient int LastRootBoneYaw;
var(BioAnimNodeBlend_TurnInPlace) const transient int YawOffset;
var const transient float RelativeOffset;
var const transient BioPawn BioPawnOwner;
var const transient BioAnim_TurnInPlace_Rotator TIPRotator;
var(BioAnimNodeBlend_TurnInPlace) float TransitionBlendInTime;
var(BioAnimNodeBlend_TurnInPlace) float TransitionBlendOutTime;
var const int CurrentTransitionIndex;
var(BioAnimNodeBlend_TurnInPlace) float TransitionThresholdAngle;
var float fRotationResetRate;
var(BioAnimNodeBlend_TurnInPlace) float AbortThresholdPercentage;
var(BioAnimNodeBlend_TurnInPlace) float AbortTransitionBlendTime;
var const transient bool bInitialized;
var const transient bool bRootRotInitialized;
var(BioAnimNodeBlend_TurnInPlace) bool bDelayBlendOutToPlayAnim;
var const bool bPlayingTurnTransition;
var bool bTransitioningToIdle;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RotTransitions = ({RotationOffset = 16384.0, ChildIndex = 1}, 
                      {RotationOffset = 32768.0, ChildIndex = 2}, 
                      {RotationOffset = -16384.0, ChildIndex = 3}, 
                      {RotationOffset = -32768.0, ChildIndex = 4}
                     )
    TransitionBlendInTime = 0.150000006
    TransitionBlendOutTime = 0.400000006
    TransitionThresholdAngle = 4096.0
    AbortThresholdPercentage = 0.140000001
    AbortTransitionBlendTime = 0.100000001
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Idle', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Right90', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Right180', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Left90', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Left180', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bSkipTickWhenZeroWeight = TRUE
}
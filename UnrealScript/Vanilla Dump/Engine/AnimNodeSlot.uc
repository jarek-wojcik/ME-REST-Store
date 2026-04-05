Class AnimNodeSlot extends AnimNodeBlendBase
    native;

var array<float> TargetWeight;
var const float PendingBlendOutTime;
var const int CustomChildIndex;
var const int TargetChildIndex;
var const float BlendTimeToGo;
var const transient AnimNodeSynch SynchNode;
var const bool bIsPlayingCustomAnim;
var(AnimNodeSlot) bool bEarlyAnimEndNotify;
var(AnimNodeSlot) bool bSkipBlendWhenNotRendered;
var(AnimNodeSlot) bool bAdditiveAnimationsOverrideSource;

public final native function AddToSynchGroup(Name GroupName);

public final native function AnimNodeSequence GetCustomAnimNodeSeq();

public final native function Name GetPlayedAnimation();

public final native function float PlayCustomAnim(Name AnimName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime);

public final native function bool PlayCustomAnimByDuration(Name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride = TRUE);

public final native function SetActorAnimEndNotification(bool bNewStatus);

public final native function SetCustomAnim(Name AnimName);

public final native function SetRootBoneAxisOption(optional ERootBoneAxis AxisX = 0, optional ERootBoneAxis AxisY = 0, optional ERootBoneAxis AxisZ = 0);

public final native function SetRootBoneRotationOption(optional ERootRotationOption AxisX = 0, optional ERootRotationOption AxisY = 0, optional ERootRotationOption AxisZ = 0);

public final native function StopCustomAnim(float BlendOutTime);

public final function AccelerateBlend(float BlendAmount)
{
    local int i;
    local float BlendDelta;
    
    for (i = 0; i < Children.Length; i++)
    {
        BlendDelta = TargetWeight[i] - Children[i].Weight;
        Children[i].Weight += BlendDelta * BlendAmount;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TargetWeight = (1.0)
    bEarlyAnimEndNotify = TRUE
    bSkipBlendWhenNotRendered = TRUE
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Source', 
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
                 Name = 'Channel 01', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    NodeName = 'SlotName'
}
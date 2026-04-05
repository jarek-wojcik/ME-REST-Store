Class AnimNodePlayCustomAnim extends AnimNodeBlend
    native;

var float CustomPendingBlendOutTime;
var bool bIsPlayingCustomAnim;

public final function AnimNodeSequence GetCustomAnimNodeSeq()
{
    return AnimNodeSequence(Children[1].Anim);
}
public final native function float PlayCustomAnim(Name AnimName, float Rate, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride);

public final native function PlayCustomAnimByDuration(Name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride);

public final function SetActorAnimEndNotification(bool bNewStatus)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Children[1].Anim);
    if (SeqNode != None)
    {
        SeqNode.bCauseActorAnimEnd = bNewStatus;
    }
}
public final function SetCustomAnim(Name AnimName)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(Children[1].Anim);
    if (SeqNode != None)
    {
        SeqNode.SetAnim(AnimName);
    }
}
public final function SetRootBoneAxisOption(optional ERootBoneAxis AxisX = 0, optional ERootBoneAxis AxisY = 0, optional ERootBoneAxis AxisZ = 0)
{
    local AnimNodeSequence AnimSeq;
    
    AnimSeq = GetCustomAnimNodeSeq();
    if (AnimSeq != None)
    {
        AnimSeq.RootBoneOption[0] = AxisX;
        AnimSeq.RootBoneOption[1] = AxisY;
        AnimSeq.RootBoneOption[2] = AxisZ;
    }
}
public final native function StopCustomAnim(float BlendOutTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Normal', 
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
                 Name = 'Custom', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    NodeName = 'CustomAnim'
}
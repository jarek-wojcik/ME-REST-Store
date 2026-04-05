Class AnimNodeCrossfader extends AnimNodeBlend
    native;

var(AnimNodeCrossfader) Name DefaultAnimSeqName;
var const float PendingBlendOutTimeOneShot;
var const bool bDontBlendOutOneShot;

public final native function BlendToLoopingAnim(Name AnimSeqName, optional float BlendInTime, optional float Rate);

public final native function AnimNodeSequence GetActiveChild();

public final native function Name GetAnimName();

public final native function PlayOneShotAnim(Name AnimSeqName, optional float BlendInTime, optional float BlendOutTime, optional bool bDontBlendOut, optional float Rate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
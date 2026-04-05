Class AnimNodeBlendBase extends AnimNode
    native
    abstract;

struct native AnimBlendChild 
{
    var const transient BoneAtom RootMotion;
    var(AnimBlendChild) Name Name;
    var float Weight;
    var const transient float BlendWeight;
    var const transient int bHasRootMotion;
    var export AnimNode Anim;
    var bool bMirrorSkeleton;
    var bool bIsAdditive;
};

var export editfixedsize array<AnimBlendChild> Children;
var bool bFixNumChildren;
var(AnimNodeBlendBase) AlphaBlendType BlendTypeAlpha;

public native function PlayAnim(optional bool bLoop = FALSE, optional float Rate = 1.0, optional float StartTime = 0.0);

public native function ReplayAnim();

public native function StopAnim();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
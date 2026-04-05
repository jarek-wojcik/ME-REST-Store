Class AnimNodeSequenceBlendBase extends AnimNodeSequence
    native
    abstract;

struct native AnimBlendInfo 
{
    var AnimInfo AnimInfo;
    var(AnimBlendInfo) Name AnimName;
    var transient float Weight;
};
struct native AnimInfo 
{
    var const Name AnimSeqName;
    var const transient AnimSequence AnimSeq;
    var const transient int AnimLinkupIndex;
};

var(Animations) export editfixedsize array<AnimBlendInfo> Anims;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Anims = ({
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 1.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }
            )
}
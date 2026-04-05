Class AnimNodeRandom extends AnimNodeBlendList
    native;

struct native RandomAnimInfo 
{
    var(RandomAnimInfo) Vector2D PlayRateRange;
    var(RandomAnimInfo) float Chance;
    var(RandomAnimInfo) float BlendInTime;
    var(RandomAnimInfo) bool bStillFrame;
    var(RandomAnimInfo) byte LoopCountMin;
    var(RandomAnimInfo) byte LoopCountMax;
    var transient byte LoopCount;
    
    structdefaultproperties
    {
        PlayRateRange = {X = 1.0, Y = 1.0}
        Chance = 1.0
        BlendInTime = 0.25
    }
};

var(AnimNodeRandom) editfixedsize array<RandomAnimInfo> RandomInfo;
var transient AnimNodeSequence PlayingSeqNode;
var transient int PendingChildIndex;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PendingChildIndex = -1
    ActiveChildIndex = -1
    bSkipTickWhenZeroWeight = TRUE
}
Class SoundNodeLooping extends SoundNode
    native
    editinlinenew;

var(Looping) float LoopCountMin;
var(Looping) float LoopCountMax;
var(Looping) bool bLoopIndefinitely;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionLoopCount
        Min = 1000000.0
        Max = 1000000.0
    End Object
    LoopCountMin = 1000000.0
    LoopCountMax = 1000000.0
    bLoopIndefinitely = TRUE
}
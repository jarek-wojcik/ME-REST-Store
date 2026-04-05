Class SoundNodeRandom extends SoundNode
    native
    editinlinenew;

var(SoundNodeRandom) editfixedsize array<float> Weights;
var transient array<bool> HasBeenUsed;
var transient int NumRandomUsed;
var(SoundNodeRandom) bool bRandomizeWithoutReplacement;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bRandomizeWithoutReplacement = TRUE
}
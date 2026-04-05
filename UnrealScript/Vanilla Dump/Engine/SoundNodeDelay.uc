Class SoundNodeDelay extends SoundNode
    native
    editinlinenew;

var(Delay) float DelayMin;
var(Delay) float DelayMax;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionDelayDuration
    End Object
}
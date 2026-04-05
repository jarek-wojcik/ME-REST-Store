Class SoundNodeOscillator extends SoundNode
    native
    editinlinenew;

var(Oscillator) float AmplitudeMin;
var(Oscillator) float AmplitudeMax;
var(Oscillator) float FrequencyMin;
var(Oscillator) float FrequencyMax;
var(Oscillator) float OffsetMin;
var(Oscillator) float OffsetMax;
var(Oscillator) float CenterMin;
var(Oscillator) float CenterMax;
var(Oscillator) bool bModulateVolume;
var(Oscillator) bool bModulatePitch;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatUniform Name=DistributionAmplitude
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionCenter
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionFrequency
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionOffset
    End Object
}
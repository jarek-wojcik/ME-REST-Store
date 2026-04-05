Class WwiseEnvironmentSettings
    native;

var(WwiseEnvironmentSettings) string Environment;
var transient int Id;
var(WwiseEnvironmentSettings) float fPrimaryControlValue;
var(WwiseEnvironmentSettings) float fOverrideControlValue;
var(WwiseEnvironmentSettings) WwiseBank ConvolutionReverbSoundBank;
var transient float CurrentEnvironment;
var transient bool bIdResolved;
var(WwiseEnvironmentSettings) bool bOverrideLowerPriorityEnvironments;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fPrimaryControlValue = 1.0
    fOverrideControlValue = 1.0
}
Class ForceFeedbackWaveform
    native
    editinlinenew;

struct native WaveformSample 
{
    var(WaveformSample) float Duration;
    var(WaveformSample) byte LeftAmplitude;
    var(WaveformSample) byte RightAmplitude;
    var(WaveformSample) EWaveformFunction LeftFunction;
    var(WaveformSample) EWaveformFunction RightFunction;
};
enum EWaveformFunction
{
    WF_Constant,
    WF_LinearIncreasing,
    WF_LinearDecreasing,
    WF_Sin0to90,
    WF_Sin90to180,
    WF_Sin0to180,
    WF_Noise,
};

var(ForceFeedbackWaveform) array<WaveformSample> Samples;
var(ForceFeedbackWaveform) bool bIsLooping;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
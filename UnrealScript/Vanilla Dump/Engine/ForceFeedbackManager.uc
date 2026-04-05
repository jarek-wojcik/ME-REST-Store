Class ForceFeedbackManager within PlayerController
    native
    abstract
    transient;

var ForceFeedbackWaveform FFWaveform;
var int CurrentSample;
var float ElapsedTime;
var float ScaleAllWaveformsBy;
var bool bAllowsForceFeedback;
var bool bIsPaused;

public simulated function PauseWaveform(optional bool bPause)
{
    bIsPaused = bPause;
}
public simulated function PlayForceFeedbackWaveform(ForceFeedbackWaveform WaveForm)
{
    if (WaveForm != None && FFWaveform != None && WaveForm.Samples.Length > 0 && WaveForm.Samples[0].Duration < FFWaveform.Samples[0].Duration)
    {
        return;
    }
    CurrentSample = 0;
    ElapsedTime = 0.0;
    bIsPaused = FALSE;
    if (WaveForm != None && WaveForm.Samples.Length > 0 && bAllowsForceFeedback == TRUE)
    {
        FFWaveform = WaveForm;
    }
    else
    {
        FFWaveform = None;
    }
}
public simulated function StopForceFeedbackWaveform(optional ForceFeedbackWaveform WaveForm)
{
    if (WaveForm == None || WaveForm == FFWaveform)
    {
        FFWaveform = None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScaleAllWaveformsBy = 1.0
    bAllowsForceFeedback = TRUE
}
Class SFXRumble_Power extends WaveFormBase;

var float MinDetonationRumbleDistance;
var float MaxDetonationRumbleDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform
        Samples = ({Duration = 0.300000012, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    MinDetonationRumbleDistance = 500.0
    MaxDetonationRumbleDistance = 1500.0
    TheWaveForm = ForceFeedbackWaveform
}
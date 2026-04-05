Class SFXRumble_Explode extends WaveFormBase;

var float MinDetonationRumbleDistance;
var float MaxDetonationRumbleDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform
        Samples = ({Duration = 0.550000012, LeftAmplitude = 90, RightAmplitude = 90, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    MinDetonationRumbleDistance = 500.0
    MaxDetonationRumbleDistance = 1500.0
    TheWaveForm = ForceFeedbackWaveform
}
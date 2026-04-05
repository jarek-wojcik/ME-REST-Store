Class SFXRumble_Power_FireCombo extends SFXRumble_Power;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveform
        Samples = ({Duration = 0.300000012, LeftAmplitude = 200, RightAmplitude = 200, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    MinDetonationRumbleDistance = 800.0
    MaxDetonationRumbleDistance = 2500.0
    TheWaveForm = ForceFeedbackWaveform
}
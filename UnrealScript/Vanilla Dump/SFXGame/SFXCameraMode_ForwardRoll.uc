Class SFXCameraMode_ForwardRoll extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MotionBlurAmount = 0.25
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 10.0, Y = 10.0}
    End Template
    Blur = s_DefaultBlur
    HookOffset = {X = -75.0, Y = 50.0, Z = 25.0}
    Input = s_Input
    bRecenterCamera = TRUE
}
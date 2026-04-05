Class SFXCameraMode_Roll extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MaxVelocity = 0.0
        MotionBlurAmount = 0.0
        FullMotionBlur = FALSE
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 25.0, Y = 20.0}
    End Template
    Blur = s_DefaultBlur
    Input = s_Input
}
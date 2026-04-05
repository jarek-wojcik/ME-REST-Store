Class SFXCameraMode_KroganMelee extends SFXCameraMode_Combat;

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
    Offset = {X = 80.0, Y = -44.0, Z = 35.0}
    HookOffset = {X = -120.0, Y = 10.0, Z = 70.0}
    FOV = 73.7399979
    Input = s_Input
    bRecenterCamera = TRUE
}
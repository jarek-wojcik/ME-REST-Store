Class SFXCameraMode_AdeptPunch extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MotionBlurAmount = 0.25
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 90.0, Y = 90.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 95.0, Y = -38.0, Z = 30.0}
    HookOffset = {X = -120.0, Y = 0.0, Z = 80.0}
    Input = s_Input
}
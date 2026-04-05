Class SFXCameraMode_HipAimCover extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 30.0, Y = 25.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 80.0, Y = -44.0, Z = 35.0}
    HookOffset = {X = -30.0, Y = 0.0, Z = 100.0}
    Input = s_Input
}
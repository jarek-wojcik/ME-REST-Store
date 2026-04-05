Class SFXCameraMode_Atlas extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 20.0, Y = 20.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = -45.0, Y = -7.0, Z = -130.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 0.0}
    HookName = 'God'
    Input = s_Input
}
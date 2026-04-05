Class SFXCameraMode_CoverMeleeRight extends SFXCameraMode_CoverMeleeLeft;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 125.0, Y = -115.0, Z = 20.0}
    HookOffset = {X = -20.0, Y = -50.0, Z = 70.0}
    Input = s_Input
}
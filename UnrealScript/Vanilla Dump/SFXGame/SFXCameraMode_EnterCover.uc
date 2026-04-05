Class SFXCameraMode_EnterCover extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MotionBlurAmount = 0.25
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 135.0, Y = -40.0, Z = 35.0}
    HookOffset = {X = -40.0, Y = -10.0, Z = 45.0}
    FOV = 83.9700012
    Input = s_Input
}
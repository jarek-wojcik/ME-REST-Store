Class SFXCameraMode_LadderUp extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 100.0, Y = -44.0, Z = 35.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 95.0}
    Input = s_Input
}
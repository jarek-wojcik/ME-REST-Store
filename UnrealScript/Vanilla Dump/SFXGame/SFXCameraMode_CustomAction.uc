Class SFXCameraMode_CustomAction extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Input = s_Input
    bRecenterCamera = TRUE
}
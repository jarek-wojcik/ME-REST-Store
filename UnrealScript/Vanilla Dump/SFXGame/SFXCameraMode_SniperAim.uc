Class SFXCameraMode_SniperAim extends SFXCameraMode_TightAim;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioCameraZoom Name=ZoomDataObj
    End Template
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 11.0, Y = 11.0}
        TimeToReachFullSpeed = 1.75
        MaxCameraRotationSpeed = 3.5
    End Template
    ZoomData = ZoomDataObj
    Blur = s_DefaultBlur
    Input = s_Input
    bFirstPerson = TRUE
}
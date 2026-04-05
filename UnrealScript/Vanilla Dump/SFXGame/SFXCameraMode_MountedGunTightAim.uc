Class SFXCameraMode_MountedGunTightAim extends SFXCameraMode_TightAim;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioCameraZoom Name=ZoomDataObj
    End Template
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 20.0, Y = 10.0}
        TimeToReachFullSpeed = 20.2700005
        MaxCameraRotationSpeed = 1.5
    End Template
    ZoomData = ZoomDataObj
    Blur = s_DefaultBlur
    Input = s_Input
}
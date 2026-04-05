Class SFXCameraMode_PistolTightAim extends SFXCameraMode_TightAim;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioCameraZoom Name=ZoomDataObj
    End Template
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    ZoomData = ZoomDataObj
    Blur = s_DefaultBlur
    Offset = {X = 85.0, Y = -32.0, Z = -38.0}
    HookOffset = {X = 0.0, Y = 5.0, Z = 28.0}
    Input = s_Input
}
Class SFXCameraMode_Vehicle extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 35.0, Y = 30.0}
        TimeToReachFullSpeed = 12.2700005
        MaxCameraRotationSpeed = 1.25
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 220.0, Y = -15.0, Z = -165.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 0.0}
    HookName = 'Root'
    RotationSpeedLimit = 32000.0
    Input = s_Input
    bCameraRubberBand = FALSE
}
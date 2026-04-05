Class SFXCameraMode_HitReaction extends SFXCameraMode_Combat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MaxVelocity = 0.800000012
        MotionBlurAmount = 0.850000024
        CameraRotationThreshold = 45.0
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 40.0, Y = 40.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 120.0, Y = -44.0, Z = 15.0}
    Input = s_Input
}
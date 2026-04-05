Class SFXCameraMode_Combat extends SFXCameraMode;

var transient MotionBlurEffect Blur;

public function MakeActive()
{
    local PlayerController PC;
    
    PC = PlayerController(GetViewTargetAsController());
    if (PC != None && PC.IsLocalPlayerController())
    {
        LocalPlayer(PC.Player).BioAddPostProcessEffect(Blur, PC.PlayerCamera, 0);
    }
    Super.MakeActive();
}
public function MakeInactive()
{
    local PlayerController PC;
    
    PC = PlayerController(GetViewTargetAsController());
    if (PC != None && PC.IsLocalPlayerController())
    {
        LocalPlayer(PC.Player).BioRemovePostProcessEffect(Blur);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 80.0, Y = 80.0}
    End Template
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MaxVelocity = 0.800000012
        CameraRotationThreshold = 45.0
    End Object
    Blur = s_DefaultBlur
    Offset = {X = 80.0, Y = -44.0, Z = 15.0}
    HookOffset = {X = -30.0, Y = 0.0, Z = 80.0}
    Input = s_Input
    bIsCameraShakeEnabled = TRUE
    bCameraRubberBand = TRUE
}
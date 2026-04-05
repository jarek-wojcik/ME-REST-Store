Class SFXCameraMode_CoverMeleeLeft extends SFXCameraMode_Combat;

public function Tick(float fTimeDelta)
{
    Super(SFXCameraMode).Tick(fTimeDelta);
    m_pov.FOV = 70.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=MotionBlurEffect Name=s_DefaultBlur
        MotionBlurAmount = 0.150000006
    End Object
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 90.0, Y = 90.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 125.0, Y = 110.0, Z = 20.0}
    HookOffset = {X = -20.0, Y = 80.0, Z = 70.0}
    Input = s_Input
}
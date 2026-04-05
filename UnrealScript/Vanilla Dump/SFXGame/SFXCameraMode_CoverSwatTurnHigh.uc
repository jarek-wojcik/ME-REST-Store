Class SFXCameraMode_CoverSwatTurnHigh extends SFXCameraMode_Combat;

public function Tick(float fTimeDelta)
{
    Super(SFXCameraMode).Tick(fTimeDelta);
    m_pov.FOV = 90.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 90.0, Y = 90.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 130.0, Y = 0.0, Z = 70.0}
    HookOffset = {X = -10.0, Y = 0.0, Z = 120.0}
    Input = s_Input
}
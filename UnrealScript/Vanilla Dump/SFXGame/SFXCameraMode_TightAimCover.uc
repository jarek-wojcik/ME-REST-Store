Class SFXCameraMode_TightAimCover extends SFXCameraMode_Combat;

public function Tick(float TimeDelta)
{
    local Pawn PawnTarget;
    
    Super(SFXCameraMode).Tick(TimeDelta);
    PawnTarget = GetViewTargetAsPawn();
    if (SFXWeapon(PawnTarget.Weapon) != None)
    {
        m_pov.FOV = SFXWeapon(PawnTarget.Weapon).GetZoomFOV();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 30.0, Y = 25.0}
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 135.0, Y = 0.0, Z = 0.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 79.0}
    Input = s_Input
    bAllowSpectate = FALSE
}
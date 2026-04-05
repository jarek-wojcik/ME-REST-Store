Class SFXCameraMode_Spectator extends SFXCameraMode;

public function Initialize()
{
    local Pawn PawnTarget;
    
    Super.Initialize();
    PawnTarget = GetViewTargetAsPawn();
    if (PawnTarget != None)
    {
        m_pov.Rotation = PawnTarget.Rotation;
    }
}
public function Tick(float TimeDelta)
{
    local BioWorldInfo WI;
    
    WI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    m_pov.Rotation = SFXPlayerCamera(WI.GetLocalPlayerController().PlayerCamera).GetRotation();
    m_pov.location = GetCameraLocation();
    m_pov.FOV = FOV;
    WI.SetRenderStateOfPlayerToDefault(0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 90.0, Y = 90.0}
    End Template
    Offset = {X = 135.0, Y = -17.0, Z = 45.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 95.0}
    FOV = 90.0
    Input = s_Input
}
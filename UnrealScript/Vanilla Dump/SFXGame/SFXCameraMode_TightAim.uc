Class SFXCameraMode_TightAim extends SFXCameraMode_Combat;

var transient BioCameraZoom ZoomData;

public event function ModifyPostProcessSettings(out PostProcessSettings PPSettings)
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (SFXWeapon(PC.Pawn.Weapon).AimModes[SFXWeapon(PC.Pawn.Weapon).CurrentAimMode].bScoped)
    {
        if (ZoomData != None && PC.GameModeManager2.IsActive(8) == FALSE)
        {
            ZoomData.ModifyPostProcessSettings(PPSettings);
        }
    }
}
public function Tick(float TimeDelta)
{
    local BioPlayerController PC;
    local Actor Ignored;
    local Vector HitLocation;
    local Vector HitNormal;
    local SFXWeapon Weapon;
    
    PC = BioPlayerController(GetViewTargetAsController());
    m_pov.Rotation = PC.Rotation;
    m_pov.location = GetCameraLocation();
    m_pov.FOV = FOV;
    BioWorldInfo(PC.WorldInfo).SetRenderStateOfPlayerToDefault(0);
    Weapon = SFXWeapon(PC.Pawn.Weapon);
    if (Weapon != None && PC.GameModeManager2.IsActive(8) == FALSE)
    {
        m_pov.FOV = Weapon.GetZoomFOV();
        if (ZoomData != None)
        {
            if (Weapon.AimModes[Weapon.CurrentAimMode].bScoped)
            {
                SFXPlayerCamera(PC.PlayerCamera).GetTrace(Ignored, HitLocation, HitNormal);
                ZoomData.Focus(VSize(m_pov.location - HitLocation), BioWorldInfo(PC.WorldInfo));
                ZoomData.Tick(TimeDelta, m_pov.FOV, 1.0);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraZoom Name=ZoomDataObj
    End Object
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 30.0, Y = 25.0}
    End Template
    ZoomData = ZoomDataObj
    Blur = s_DefaultBlur
    Input = s_Input
    bAllowSpectate = FALSE
}
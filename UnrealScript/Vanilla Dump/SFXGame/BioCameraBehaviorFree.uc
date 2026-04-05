Class BioCameraBehaviorFree extends BioCameraBehavior;

var bool m_bCameraLocked;

public function Initialize()
{
    local Controller C;
    local Vector Loc;
    local Rotator Rot;
    
    Super(SFXCameraMode).Initialize();
    C = GetViewTargetAsController();
    if (C != None)
    {
        C.GetPlayerViewPoint(Loc, Rot);
        m_pov.location = Loc;
        m_pov.Rotation = Rot;
    }
}
public function Tick(float TimeDelta)
{
    local PlayerController PC;
    
    PC = PlayerController(GetViewTargetAsController());
    if (!m_bCameraLocked)
    {
        m_pov.location = PC.location;
        m_pov.Rotation = PC.Rotation;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 60.0, Y = 60.0}
    End Template
    m_pov = {FOV = 60.0}
    Input = s_Input
    bIsCameraShakeEnabled = FALSE
    bCollisionEnabled = FALSE
}
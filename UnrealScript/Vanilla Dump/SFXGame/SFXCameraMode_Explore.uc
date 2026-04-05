Class SFXCameraMode_Explore extends SFXCameraMode;

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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 60.0, Y = 60.0}
    End Template
    Offset = {X = 200.0, Y = 0.0, Z = 40.0}
    HookOffset = {X = 0.0, Y = 0.0, Z = 120.0}
    Input = s_Input
    bIsCameraShakeEnabled = TRUE
}
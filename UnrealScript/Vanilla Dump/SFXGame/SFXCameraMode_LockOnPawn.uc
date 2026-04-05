Class SFXCameraMode_LockOnPawn extends SFXCameraMode_Combat;

public function bool GetActorCameraHook(out Vector OutLocation)
{
    local bool bIsValid;
    local Vector V;
    local Pawn PawnTarget;
    local Rotator R;
    
    PawnTarget = GetViewTargetAsPawn();
    if (BioPawn(PawnTarget) != None)
    {
        bIsValid = TRUE;
        R = PawnTarget.Rotation;
        R.Pitch = 0;
        V = GetCameraHook();
        V += QuatRotateVector(QuatFromRotator(R), HookOffset);
        OutLocation = V;
    }
    return bIsValid;
}
public function Tick(float fTimeDelta)
{
    local Controller C;
    local PlayerController PC;
    local Rotator CurrentRotation;
    local float fPitchDiff;
    
    C = GetViewTargetAsController();
    m_pov.Rotation.Yaw = C.Pawn.Rotation.Yaw;
    if (bRecenterCamera)
    {
        CurrentRotation = Normalize(m_pov.Rotation);
        fPitchDiff = float(CurrentRotation.Pitch);
        if (Abs(fPitchDiff) > 100.0)
        {
            m_pov.Rotation.Pitch = int(float(m_pov.Rotation.Pitch) - fPitchDiff * (fTimeDelta / TimeToRecenter));
        }
    }
    m_pov.location = GetCameraLocation();
    m_pov.FOV = FOV;
    PC = PlayerController(C);
    if (PC != None && LocalPlayer(PC.Player) != None)
    {
        BioWorldInfo(PC.WorldInfo).SetRenderStateOfPlayerToDefault(0);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Input = s_Input
}
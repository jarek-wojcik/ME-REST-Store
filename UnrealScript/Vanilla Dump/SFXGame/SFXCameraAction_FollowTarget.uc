Class SFXCameraAction_FollowTarget extends SFXCameraMode;

var Vector TargetLocation;
var SFXCameraMode UnderneathMode;
var bool ReenableMovement;

public function bool GetActorCameraHook(out Vector OutLocation)
{
    return UnderneathMode.GetActorCameraHook(OutLocation);
}
public function Vector GetCameraLocation()
{
    return UnderneathMode.GetCameraLocation();
}
public function Tick(float TimeDelta)
{
    local SFXPlayerController PC;
    
    PC = SFXPlayerController(GetViewTargetAsController());
    if (PC != None)
    {
        UnderneathMode.Tick(TimeDelta);
        if (PC.m_pActivePOI != None)
        {
            PC.m_pActivePOI.UpdateCamPOV(Self, TimeDelta);
        }
        else
        {
            m_pov.Rotation = UnderneathMode.m_pov.Rotation;
        }
        PC.SetRotation(m_pov.Rotation);
    }
}
public function bool HasLoop(SFXCameraMode CurMode, SFXCameraMode CheckingMode)
{
    if (CurMode == CheckingMode)
    {
        return TRUE;
    }
    else if (SFXCameraAction_FollowTarget(CurMode) != None)
    {
        return HasLoop(SFXCameraAction_FollowTarget(CurMode).UnderneathMode, CheckingMode);
    }
    else if (SFXCameraMode_Interpolate(CurMode) != None)
    {
        return HasLoop(SFXCameraMode_Interpolate(CurMode).From, CheckingMode) || HasLoop(SFXCameraMode_Interpolate(CurMode).To, CheckingMode);
    }
    else
    {
        return FALSE;
    }
}
public function SetUnderneathMode(SFXCameraMode NewUnderneathMode)
{
    if (!HasLoop(NewUnderneathMode, Self))
    {
        UnderneathMode = NewUnderneathMode;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Input = s_Input
}
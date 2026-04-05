Class SFXCameraAction_QuickTurn extends SFXCameraMode_Interpolate;

var int CurrentOffsetApplied;

public function Tick(float TimeDelta)
{
    local float OffsetDelta;
    
    From.Tick(TimeDelta);
    if (From != To)
    {
        To.Tick(TimeDelta);
    }
    m_pov = From.m_pov;
    CurrentTime += TimeDelta;
    if (CurrentTime >= TotalTime)
    {
        bComplete = TRUE;
        CurrentTime = TotalTime;
    }
    OffsetDelta = CurrentTime / TotalTime * float(32767) - float(CurrentOffsetApplied);
    From.m_pov.Rotation.Yaw += int(OffsetDelta);
    CurrentOffsetApplied += int(OffsetDelta);
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    From = FromMode;
    To = ToMode;
    CurrentOffsetApplied = 0;
    bComplete = FALSE;
    CurrentTime = 0.0;
    TotalTime = Time;
    if (TotalTime == float(0))
    {
        TotalTime = 0.00000999999975;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    DefaultTime = 0.699999988
    Input = s_Input
}
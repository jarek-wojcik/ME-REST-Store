Class SFXCameraTransition_FaceTarget extends SFXCameraMode_Interpolate;

var Vector TargetLocation;
var Rotator StartRotation;
var Vector StartLocation;

public function Tick(float TimeDelta)
{
    local float T;
    
    From.Tick(TimeDelta);
    To.Tick(TimeDelta);
    CurrentTime += TimeDelta;
    if (CurrentTime >= TotalTime)
    {
        bComplete = TRUE;
        CurrentTime = TotalTime;
    }
    T = Interpolate(CurrentTime / TotalTime);
    if (From != None && To != None)
    {
        Class'BioInterpolator'.static.InterpolateVector(m_pov.location, 0, StartLocation, To.m_pov.location, T);
        Class'BioInterpolator'.static.InterpolateRotator(m_pov.Rotation, 0, StartRotation, To.m_pov.Rotation, T);
        Class'BioInterpolator'.static.InterpolateFloat(m_pov.FOV, 0, From.m_pov.FOV, To.m_pov.FOV, T);
    }
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    From = FromMode;
    To = ToMode;
    StartRotation = From.m_pov.Rotation;
    StartLocation = From.m_pov.location;
    To.AimAtPoint(TargetLocation);
    GetViewTargetAsController().SetRotation(To.m_pov.Rotation);
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
    HookOffset = {X = 0.0, Y = 0.0, Z = 79.0}
    Input = s_Input
}
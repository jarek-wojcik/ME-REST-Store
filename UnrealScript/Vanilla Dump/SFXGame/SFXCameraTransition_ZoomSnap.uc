Class SFXCameraTransition_ZoomSnap extends SFXCameraMode_Interpolate;

var Vector ZoomSnapTargetLocation;
var Rotator StartRotation;
var Vector StartLocation;

public function Tick(float TimeDelta)
{
    local float T;
    local BioPlayerController PC;
    local SFXModule_AimAssist AimAssist;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (PC != None)
    {
        AimAssist = PC.GetModule(Class'SFXModule_AimAssist');
    }
    From.Tick(TimeDelta);
    To.Tick(TimeDelta);
    CurrentTime += TimeDelta;
    if (CurrentTime >= TotalTime)
    {
        bComplete = TRUE;
        CurrentTime = TotalTime;
    }
    if (PC != None && AimAssist != None)
    {
        To.AimAtPoint(ZoomSnapTargetLocation);
        PC.SetRotation(To.m_pov.Rotation);
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
    To.AimAtPoint(ZoomSnapTargetLocation);
    GetViewTargetAsController().SetRotation(To.m_pov.Rotation);
    bComplete = FALSE;
    CurrentTime = 0.0;
    TotalTime = Time;
    if (TotalTime == float(0))
    {
        TotalTime = 0.00000999999975;
    }
}
public function MakeInactive()
{
    local BioPlayerController PC;
    local SFXModule_AimAssist AimAssist;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (PC != None)
    {
        AimAssist = PC.GetModule(Class'SFXModule_AimAssist');
    }
    if (AimAssist != None)
    {
        AimAssist.LastZoomSnapTarget = None;
        AimAssist.ZoomSnapTarget *= 0.0;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Input = s_Input
}
Class SFXCameraTransition_VanguardSlam extends SFXCameraTransition_Animated;

var InterpCurveFloat FOVCurve;
var InterpCurveFloat MovementCurve;
var transient Vector StartLocation;
var transient Rotator StartRotation;
var transient float StartFOV;
var Actor TargetActor;
var transient float FOVChange;
var float FirstPhaseLength;

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
        Class'BioInterpolator'.static.InterpolateFloatCurve(m_pov.location.X, MovementCurve, StartLocation.X, To.m_pov.location.X, T);
        Class'BioInterpolator'.static.InterpolateFloatCurve(m_pov.location.Y, MovementCurve, StartLocation.Y, To.m_pov.location.Y, T);
        Class'BioInterpolator'.static.InterpolateFloatCurve(m_pov.location.Z, MovementCurve, StartLocation.Z, To.m_pov.location.Z, T);
        Class'BioInterpolator'.static.InterpolateRotator(m_pov.Rotation, 0, StartRotation, To.m_pov.Rotation, T);
        Class'BioInterpolator'.static.InterpolateFloatCurve(m_pov.FOV, FOVCurve, StartFOV, FOVChange, T);
    }
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    From = FromMode;
    To = ToMode;
    StartRotation = From.m_pov.Rotation;
    StartLocation = From.m_pov.location;
    StartFOV = From.m_pov.FOV;
    To.AimAtPoint(TargetActor.location);
    To.m_pov.Rotation.Pitch = StartRotation.Pitch;
    bComplete = FALSE;
    CurrentTime = 0.0;
    TotalTime = Time;
    if (TotalTime == float(0))
    {
        TotalTime = 0.00000999999975;
    }
    MovementCurve.Points[1].InVal = FirstPhaseLength / TotalTime;
    FOVCurve.Points[1].InVal = FirstPhaseLength / TotalTime;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    FOVCurve = {
                Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                          {InVal = 0.433349997, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                          {InVal = 1.0, OutVal = 0.0, ArriveTangent = -4.0, LeaveTangent = -4.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                         ), 
                InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
               }
    MovementCurve = {
                     Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                               {InVal = 0.433349997, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                               {InVal = 1.0, OutVal = 1.0, ArriveTangent = 7.0, LeaveTangent = 7.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                              ), 
                     InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                    }
    FOVChange = 120.0
    DefaultBlendInTime = 0.0
    Input = s_Input
    bCollisionEnabled = FALSE
}
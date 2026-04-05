Class SFXCameraMode_Interpolate extends SFXCameraMode;

var(SFXCameraMode_Interpolate) InterpCurveFloat Curve;
var(SFXCameraMode_Interpolate) Vector AimPoint;
var Rotator RotationOffset;
var Vector LocationOffset;
var(SFXCameraMode_Interpolate) float TotalTime;
var(SFXCameraMode_Interpolate) float CurrentTime;
var(SFXCameraMode_Interpolate) SFXCameraMode From;
var(SFXCameraMode_Interpolate) SFXCameraMode To;
var(SFXCameraMode_Interpolate) float DefaultTime;
var(SFXCameraMode_Interpolate) float AimPointDistance;
var float MinAimPointPreservationDistance;
var(SFXCameraMode_Interpolate) bool bComplete;
var transient bool bDisableAimPointPreservation;
var(SFXCameraMode_Interpolate) EBioInterpolationMethod InterpMethod;

public function bool GetActorCameraHook(out Vector OutLocation)
{
    local float T;
    local Vector FromV;
    local Vector ToV;
    
    T = Interpolate(CurrentTime / TotalTime);
    From.GetActorCameraHook(FromV);
    To.GetActorCameraHook(ToV);
    Class'BioInterpolator'.static.InterpolateVector(OutLocation, InterpMethod, FromV, ToV, T);
    return TRUE;
}
public function Tick(float TimeDelta)
{
    local float T;
    
    CurrentTime += TimeDelta;
    if (CurrentTime >= TotalTime)
    {
        bComplete = TRUE;
        CurrentTime = TotalTime;
    }
    To.Tick(TimeDelta);
    if (From == None)
    {
        return;
    }
    if (!bComplete)
    {
    }
    T = Interpolate(CurrentTime / TotalTime);
    if (From != None && To != None)
    {
        Class'BioInterpolator'.static.InterpolateVector(m_pov.location, InterpMethod, LocationOffset, vect(0.0, 0.0, 0.0), T);
        Class'BioInterpolator'.static.InterpolateRotator(m_pov.Rotation, InterpMethod, RotationOffset, rot(0, 0, 0), T);
        Class'BioInterpolator'.static.InterpolateFloat(m_pov.FOV, InterpMethod, From.m_pov.FOV, To.m_pov.FOV, T);
        Class'BioInterpolator'.static.InterpolateFloat(Input.CameraSensitivity.X, InterpMethod, From.Input.CameraSensitivity.X, To.Input.CameraSensitivity.X, T);
        Class'BioInterpolator'.static.InterpolateFloat(Input.CameraSensitivity.Y, InterpMethod, From.Input.CameraSensitivity.Y, To.Input.CameraSensitivity.Y, T);
        Class'BioInterpolator'.static.InterpolateFloat(Input.MaxCameraRotationSpeed, InterpMethod, From.Input.MaxCameraRotationSpeed, To.Input.MaxCameraRotationSpeed, T);
        Class'BioInterpolator'.static.InterpolateFloat(Input.TimeToReachFullSpeed, InterpMethod, From.Input.TimeToReachFullSpeed, To.Input.TimeToReachFullSpeed, T);
    }
    m_pov.Rotation = To.m_pov.Rotation - m_pov.Rotation;
    m_pov.location = To.m_pov.location - m_pov.location;
}
public function Trace(out Actor HitActor, out Vector HitLocation)
{
    local Vector TraceStart;
    local Vector TraceEnd;
    local Vector ToPC;
    local Vector cameraRot;
    local Vector Extent;
    local Vector HitNormal;
    local TraceHitInfo HitInfo;
    local Pawn PawnTarget;
    local BioPlayerController PC;
    
    PawnTarget = GetViewTargetAsPawn();
    PC = BioPlayerController(GetViewTargetAsController());
    Extent = vect(0.0, 0.0, 0.0);
    TraceStart = PC.PlayerCamera.CameraCache.POV.location;
    ToPC = PawnTarget.location - TraceStart;
    cameraRot = Vector(PC.PlayerCamera.CameraCache.POV.Rotation);
    TraceStart += cameraRot * (ToPC Dot cameraRot);
    TraceEnd = TraceStart + cameraRot * float(10000);
    HitActor = PawnTarget.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, TRUE, Extent, HitInfo, );
}
public function DrawHUD(BioCheatManager M)
{
    M.DrawProfileText("Transition:" @ From.CameraName @ " ---> " @ To.CameraName);
    M.DrawProfileText("Interpolation: " @ CurrentTime @ " / " @ TotalTime);
    M.DrawProfileText("From:");
    From.DrawHUD(M);
    M.DrawProfileText("To:");
    To.DrawHUD(M);
}
public function bool CheckLoop(SFXCameraMode mode, int RecurseLevel)
{
    if (Self == mode)
    {
        return TRUE;
    }
    RecurseLevel -= 1;
    if (RecurseLevel <= 0)
    {
        From = None;
        bComplete = TRUE;
        return FALSE;
    }
    if (From.CheckLoop(Self, RecurseLevel) || To.CheckLoop(Self, RecurseLevel))
    {
        return TRUE;
    }
    return From.CheckLoop(mode, RecurseLevel) || To.CheckLoop(mode, RecurseLevel);
}
public function Rotator GetCurrentShake()
{
    local Rotator shake1;
    local Rotator shake2;
    local Rotator Shake;
    
    if (!bComplete)
    {
        shake1 = From.GetCurrentShake();
    }
    shake2 = To.GetCurrentShake();
    if (From != None && To != None)
    {
        Class'BioInterpolator'.static.InterpolateRotator(Shake, InterpMethod, shake1, shake2, CurrentTime / TotalTime);
    }
    return Shake;
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    local Actor A;
    local Vector V;
    local Controller PC;
    local float AimZDistance;
    
    bComplete = FALSE;
    CurrentTime = 0.0;
    TotalTime = Time;
    if (TotalTime == float(0))
    {
        TotalTime = 0.00000999999975;
    }
    bCameraRubberBand = FromMode.bCameraRubberBand && ToMode.bCameraRubberBand;
    bFirstPerson = FromMode.bFirstPerson && ToMode.bFirstPerson;
    From = FromMode;
    To = ToMode;
    A = None;
    if (PreserveTarget && !bDisableAimPointPreservation)
    {
        Trace(A, V);
    }
    if (A != None)
    {
        AimPointDistance = VSize(V - From.m_pov.location);
        AimZDistance = V.Z - From.m_pov.location.Z;
        if (AimPointDistance < MinAimPointPreservationDistance)
        {
            AimPoint = V + Vector(From.m_pov.Rotation) * (MinAimPointPreservationDistance - AimPointDistance);
        }
        To.AimAtPoint(V);
        To.AimAtPoint(V);
        To.DoCameraCollision(To.m_pov.location, To.m_pov.Rotation, GetViewTargetAsPawn());
        if (To.CollisionDistance > 0.5 || AimPointDistance < MinAimPointPreservationDistance || AimZDistance > AimPointDistance * 0.5)
        {
            To.m_pov.Rotation = From.m_pov.Rotation;
            To.m_pov.location = To.GetCameraLocation();
        }
    }
    else
    {
        To.m_pov.Rotation = From.m_pov.Rotation;
        To.m_pov.location = To.GetCameraLocation();
    }
    PC = GetViewTargetAsController();
    if (PC != None)
    {
        PC.SetRotation(To.m_pov.Rotation);
    }
    RotationOffset = To.m_pov.Rotation - From.m_pov.Rotation;
    LocationOffset = To.m_pov.location - From.m_pov.location;
}
public function float Interpolate(float T)
{
    local float o;
    
    Class'BioInterpolator'.static.InterpolateFloatCurve(o, Curve, 0.0, 1.0, T);
    return FClamp(o, 0.0, 1.0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Curve = {
             Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                       {InVal = 1.0, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                      ), 
             InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
            }
    DefaultTime = 0.5
    MinAimPointPreservationDistance = 500.0
    InterpMethod = EBioInterpolationMethod.BIO_INTERPOLATION_METHOD_QUARTER_SIN
    Input = s_Input
    bAllowSpectate = FALSE
}
Class SFXPlayerCamera extends SFXCameraNativeBase
    transient;

var(SFXPlayerCamera) const InterpCurveFloat CameraRubberBandCurve;
var(SFXPlayerCamera) TPOV CameraDesiredPosition;
var transient Rotator KickBackModifier;
var(SFXPlayerCamera) SFXCameraTransition_FaceTarget FaceTargetTransition;
var(Camera) transient SFXCameraModifier_ScreenShake ScreenShakeModifier;
var transient SFXCameraMode CurrentModalAction;
var float TransitionTimeout;
var transient float LastTransitionTime;
var transient float m_fLastAspectRatio;
var(SFXPlayerCamera) const float CameraRubberBandMaxStretchLength;
var(SFXPlayerCamera) const float CameraRubberBandSpeed;
var(SFXPlayerCamera) float RotationalDecay;
var(SFXPlayerCamera) int MaxTransitionStackDepth;
var export SFXCameraMode FreeCam;
var export SFXCameraMode_Interpolate DefaultTransition;
var transient bool bCurrentTransitionIsModal;
var transient bool bDebugging;
var transient bool m_bLastConstrainAspect;

public function AddScreenShake(ScreenShakeStruct Shake)
{
    if (CameraStyle != 'FreeCam')
    {
        ScreenShakeModifier.AddScreenShake(Shake);
    }
}
public function PostBeginPlay()
{
    Super(Camera).PostBeginPlay();
    ScreenShakeModifier = SFXCameraModifier_ScreenShake(CreateCameraModifier(Class'SFXCameraModifier_ScreenShake'));
}
protected function CameraModifier CreateCameraModifier(Class<CameraModifier> ModifierClass)
{
    local CameraModifier NewMod;
    
    NewMod = new (Outer) ModifierClass;
    NewMod.Init();
    NewMod.AddCameraModifier(Self);
    return NewMod;
}
public function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot)
{
    Super(Camera).ProcessViewRotation(DeltaTime, OutViewRotation, OutDeltaRot);
    if (CurrentCameraMode != None)
    {
        CurrentCameraMode.ProcessViewRotation(DeltaTime, OutViewRotation, OutDeltaRot);
    }
}
public function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local CameraActor CamActor;
    
    if (bDisabled && CameraStyle != 'FreeCam')
    {
        OutVT.POV = CameraCache.POV;
        if (m_fLastAspectRatio >= 0.0)
        {
            OutVT.AspectRatio = m_fLastAspectRatio;
            bConstrainAspectRatio = m_bLastConstrainAspect;
        }
        return;
    }
    ResetHiddenActors();
    CamActor = CameraActor(OutVT.Target);
    if (CamActor != None && CameraStyle != 'FreeCam')
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;
        CurrentCameraMode = None;
        bCurrentTransitionIsModal = FALSE;
    }
    else
    {
        if (CamActor != None && CameraStyle == 'FreeCam')
        {
            OutVT.Target = PCOwner;
        }
        if (WorldInfo.TimeSeconds - LastTransitionTime > TransitionTimeout)
        {
            PickCameraMode(DeltaTime, OutVT);
        }
        UpdateCameraMode(DeltaTime, OutVT);
    }
    ApplyCameraModifiers(DeltaTime, OutVT.POV);
    OutVT.POV.FOV = BioAdjustFOVForViewport(OutVT.POV.FOV, Pawn(OutVT.Target));
    m_bLastConstrainAspect = bConstrainAspectRatio;
    m_fLastAspectRatio = OutVT.AspectRatio;
    if (CamActor != None && CameraStyle == 'FreeCam')
    {
        OutVT.Target = CamActor;
    }
}
public final function Rotator GetBaseRotation()
{
    return PCOwner.Rotation;
}
public function PickCameraMode(float DeltaTime, out TViewTarget OutVT)
{
    local int PreserveTarget;
    local BioPlayerController PC;
    local bool bNoChange;
    local SFXCameraMode NewCameraMode;
    local SFXCameraMode_Interpolate Transition;
    local float TransitionTime;
    
    PC = BioPlayerController(PCOwner);
    if (PC == None)
    {
        return;
    }
    PreserveTarget = 1;
    TransitionTime = Class'SFXCameraMode_Interpolate'.default.DefaultTime;
    Transition = DefaultTransition;
    NewCameraMode = PC.GameModeManager2.GetCameraMode(CurrentCameraMode, PreserveTarget, TransitionTime, Transition);
    if (CurrentModalAction != None)
    {
        SFXCameraAction_FollowTarget(CurrentModalAction).SetUnderneathMode(NewCameraMode);
        NewCameraMode = CurrentModalAction;
    }
    bNoChange = NewCameraMode == CurrentCameraMode || SFXCameraMode_Interpolate(CurrentCameraMode) != None && SFXCameraMode_Interpolate(CurrentCameraMode).To == NewCameraMode;
    if (!bNoChange)
    {
        if (CurrentCameraMode != None && (CurrentCameraMode.CameraName == 'ConversationCam' || CurrentCameraMode.CameraName == 'GalaxyCam'))
        {
            TransitionTime = 0.0;
            PreserveTarget = 0;
        }
        SetBehavior(NewCameraMode, Transition, TransitionTime, bool(PreserveTarget));
        if (CurrentCameraMode != None)
        {
            OutVT.POV = CurrentCameraMode.m_pov;
        }
    }
}
public function SFXCameraMode_Interpolate PlayCameraTransition(SFXCameraMode_Interpolate Transition, float Time, optional SFXCameraMode mode)
{
    local BioPlayerController PC;
    local SFXGameModeManager GMM;
    local SFXGameModeBase GM;
    local SFXCameraMode_Interpolate Instance;
    local int idx;
    
    if (mode != None)
    {
        CurrentModalAction = mode;
        SFXCameraAction_FollowTarget(CurrentModalAction).SetUnderneathMode(CurrentCameraMode);
        Instance = SetBehavior(CurrentModalAction, Transition, Time, FALSE);
    }
    else
    {
        PC = BioPlayerController(Owner);
        GMM = PC.GameModeManager2;
        for (idx = 0; idx < GMM.GameModes.Length; idx++)
        {
            GM = GMM.GameModes[idx];
            if (SFXGameModeDefault(GM) != None)
            {
                SetBehavior(SFXGameModeDefault(GM).CameraSetup.CombatCam, Transition, Time, FALSE);
            }
        }
    }
    bCurrentTransitionIsModal = TRUE;
    return Instance;
}
public function RotateToFace(Vector AimPoint, float Time)
{
    FaceTargetTransition.TargetLocation = AimPoint;
    SetBehavior(CurrentCameraMode, FaceTargetTransition, Time, TRUE);
}
public final function SetBaseRotation(Rotator NewRotation)
{
    if (CurrentCameraMode != None)
    {
        CurrentCameraMode.m_pov.Rotation = NewRotation;
        PCOwner.SetRotation(NewRotation);
    }
}
public function SFXCameraMode_Interpolate SetBehavior(SFXCameraMode mode, SFXCameraMode_Interpolate NewTransitionTemplate, float Time, bool PreserveTarget)
{
    local SFXCameraMode PreviousBehavior;
    local SFXCameraMode_Interpolate NewTransition;
    local BioPlayerController PC;
    
    if (bCurrentTransitionIsModal)
    {
        return None;
    }
    if (mode == None)
    {
        return None;
    }
    PreviousBehavior = CurrentCameraMode;
    mode.ViewTarget = ViewTarget;
    mode.Initialize();
    PC = BioPlayerController(PCOwner);
    if (Time > 0.0 && PreviousBehavior != None)
    {
        NewTransition = new (PC.GetGameModeDefault()) NewTransitionTemplate.Class (NewTransitionTemplate);
        if (NewTransition != None)
        {
            NewTransition.From = None;
            NewTransition.To = None;
            NewTransition.ViewTarget = ViewTarget;
            NewTransition.Initialize();
            NewTransition.InitializeTransition(PreviousBehavior, mode, Time, PreserveTarget);
            if (NewTransition.CheckLoop(None, MaxTransitionStackDepth))
            {
                return None;
            }
            SwitchTo(NewTransition);
            LastTransitionTime = WorldInfo.TimeSeconds;
        }
    }
    else
    {
        SwitchTo(mode);
    }
    return NewTransition;
}
public function Vector SmoothPosition(Vector Start, Vector Target, float TimeDelta)
{
    local float RubberBandTension;
    local float Alpha;
    local float RubberBandRecoveryPct;
    local float Dist;
    local Vector CameraOffset;
    
    CameraOffset = Target - Start;
    Dist = VSize(CameraOffset);
    if (Dist > CameraRubberBandMaxStretchLength)
    {
        return Start + Normal(CameraOffset) * CameraRubberBandMaxStretchLength;
    }
    else
    {
        Dist = FClamp(Dist, 0.0, CameraRubberBandMaxStretchLength);
        RubberBandTension = Dist / CameraRubberBandMaxStretchLength;
        RubberBandRecoveryPct = FClamp(RubberBandTension * TimeDelta * CameraRubberBandSpeed, 0.0, 1.0);
        Class'BioInterpolator'.static.InterpolateFloatCurve(Alpha, CameraRubberBandCurve, 0.0, 1.0, RubberBandRecoveryPct);
        return VLerp(Start, Target, FClamp(Alpha, 0.0, 1.0));
    }
}
public function SwitchTo(SFXCameraMode NewMode)
{
    if (CurrentCameraMode != None)
    {
        CurrentCameraMode.MakeInactive();
    }
    CurrentCameraMode = NewMode;
    if (CurrentCameraMode != None)
    {
        CurrentCameraMode.MakeActive();
    }
    CurrentCameraMode.Tick(0.0);
}
public function UpdateCameraMode(float fDeltaTime, out TViewTarget OutVT)
{
    local SFXCameraMode_Interpolate Transition;
    local BioPawn MyPawn;
    local BioPawn TargetPawn;
    local BioCustomAction MyCustomAction;
    local Rotator RDiff;
    local BioPlayerController PC;
    local float GameTimePassed;
    local float UserTimePassed;
    local bool bForceUpdate;
    
    MyPawn = BioPawn(PCOwner.Pawn);
    if (PCOwner == None || PCOwner.WorldInfo == None || CurrentCameraMode == None)
    {
        return;
    }
    Transition = SFXCameraMode_Interpolate(CurrentCameraMode);
    if (Transition != None && Transition.bComplete)
    {
        bCurrentTransitionIsModal = FALSE;
        SwitchTo(Transition.To);
        Transition = None;
    }
    GameTimePassed = fDeltaTime;
    if (m_bIgnoreSlowMo && WorldInfo.TimeDilation != float(0))
    {
        UserTimePassed = GameTimePassed / WorldInfo.TimeDilation;
        if (CameraStyle == 'FreeCam')
        {
            GameTimePassed = UserTimePassed;
        }
    }
    if (CurrentCameraMode != None)
    {
        CurrentCameraMode.ViewTarget = OutVT;
        TargetPawn = BioPawn(CurrentCameraMode.ViewTarget.Target);
        PC = BioPlayerController(PCOwner);
        bForceUpdate = PC.GameModeManager2.IsActive(9) && PC.Pawn != None && PC.Pawn.IsDead();
        if (PC.GameModeManager2.AllowCameraUpdates() || bForceUpdate)
        {
            CurrentCameraMode.Tick(GameTimePassed);
        }
        else
        {
            CurrentCameraMode.Tick(0.0);
        }
        OutVT.POV = CurrentCameraMode.m_pov;
        if (CurrentCameraMode.bCameraRubberBand && (MyPawn == None || MyPawn.GetCurrentCustomAction(MyCustomAction) == FALSE))
        {
            if (TargetPawn != None && TargetPawn.IsLocallyControlled() == FALSE)
            {
                OutVT.POV.location = SmoothPosition(CameraCache.POV.location, CurrentCameraMode.m_pov.location, fDeltaTime);
            }
            if (Class'SFXGameConfig'.default.bAimAssistEnabled || TargetPawn != None && TargetPawn.IsLocallyControlled() == FALSE)
            {
                RDiff = RLerp(rot(0, 0, 0), Normalize(CurrentCameraMode.m_pov.Rotation - CameraDesiredPosition.Rotation), 1.0 - FClamp(2.71799994 ** (-RotationalDecay * UserTimePassed), 0.0, 1.0), TRUE);
            }
            else
            {
                RDiff = Normalize(CurrentCameraMode.m_pov.Rotation - CameraDesiredPosition.Rotation);
            }
            if (Abs(float(RDiff.Pitch)) + Abs(float(RDiff.Yaw)) > CurrentCameraMode.RotationSpeedLimit * UserTimePassed)
            {
                RDiff *= CurrentCameraMode.RotationSpeedLimit * UserTimePassed / (Abs(float(RDiff.Pitch)) + Abs(float(RDiff.Yaw)));
                RDiff.Roll = 0;
            }
            OutVT.POV.Rotation = CameraDesiredPosition.Rotation + RDiff;
            CameraDesiredPosition.Rotation = OutVT.POV.Rotation;
        }
        else
        {
            CameraDesiredPosition = OutVT.POV;
        }
        OutVT.POV.Rotation += CurrentCameraMode.GetCurrentShake();
        OutVT.POV.Rotation += KickBackModifier;
        OutVT.POV.Rotation = Normalize(OutVT.POV.Rotation);
        AspectRatio = CurrentCameraMode.AspectRatio;
        bConstrainAspectRatio = CurrentCameraMode.bConstrainAspectRatio;
        if (CurrentCameraMode.IsCollisionEnabled())
        {
            TraceCamera(OutVT);
            CurrentCameraMode.CollisionDistance = 0.0;
            CurrentCameraMode.DoCameraCollision(OutVT.POV.location, OutVT.POV.Rotation, OutVT.Target);
        }
    }
    OutVT.POV.Rotation.Yaw = OutVT.POV.Rotation.Yaw %  65536;
    m_aTraceInfo.m_bCollisionDirty = TRUE;
    TraceCamera(OutVT);
    if (CameraStyle == 'FreeCam')
    {
        FreeCam.ViewTarget = ViewTarget;
        FreeCam.Tick(fDeltaTime);
        OutVT.POV = FreeCam.m_pov;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorFree Name=FreeCam0
    End Object
    Begin Object Class=SFXCameraMode_Interpolate Name=DefaultTransition0
    End Object
    Begin Object Class=SFXCameraTransition_FaceTarget Name=FaceTargetTransition0
    End Object
    CameraRubberBandCurve = {
                             Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                                       {InVal = 1.0, OutVal = 1.0, ArriveTangent = 1.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                                      ), 
                             InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                            }
    CameraDesiredPosition = {
                             location = {X = 0.0, Y = 0.0, Z = 0.0}, 
                             Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                             FOV = 90.0
                            }
    FaceTargetTransition = FaceTargetTransition0
    TransitionTimeout = 0.100000001
    m_fLastAspectRatio = -1.0
    CameraRubberBandMaxStretchLength = 50.0
    CameraRubberBandSpeed = 500.0
    RotationalDecay = 25.0
    MaxTransitionStackDepth = 7
    FreeCam = FreeCam0
    DefaultTransition = DefaultTransition0
    DefaultAspectRatio = 1.77777779
}
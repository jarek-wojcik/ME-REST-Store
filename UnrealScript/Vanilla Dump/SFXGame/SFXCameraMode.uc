Class SFXCameraMode
    native
    abstract;

var TViewTarget ViewTarget;
var transient TPOV m_pov;
var(SFXCameraMode) Vector Offset;
var(SFXCameraMode) Vector HookOffset;
var transient Vector LastHookPos;
var Rotator CameraTargetDir;
var(SFXCameraMode) Name HookName;
var(SFXCameraMode) Name CameraName;
var transient Name LastCameraCollisionActor;
var(SFXCameraMode) float FOV;
var(SFXCameraMode) const float AspectRatio;
var(SFXCameraMode) const float TimeToRecenter;
var const float RotationSpeedLimit;
var transient SFXCameraInput Input;
var transient float CollisionDistance;
var float RecenterStrength;
var(SFXCameraMode) bool bIsCameraShakeEnabled;
var(SFXCameraMode) bool bCollisionEnabled;
var(SFXCameraMode) const bool bConstrainAspectRatio;
var(SFXCameraMode) const bool bRecenterCamera;
var(SFXCameraMode) bool bFirstPerson;
var(SFXCameraMode) bool bCameraRubberBand;
var const bool bAllowSpectate;
var(SFXCameraMode) bool bRecenterCameraNew;
var bool bAutoCancelCameraRecentering;
var bool bRecenterCancelled;

public event function AimAtPoint(Vector V)
{
    local Vector PawnToPoint;
    local Vector CameraFromPlayer;
    local Vector CameraOrth;
    local Vector CameraNorm;
    local Vector Intersection;
    local Vector Forward;
    local float Opposite;
    local float Adjascent;
    local float Hypotenuse;
    local float CamNormOffset;
    local float YawDiff;
    local float PitchDiff;
    
    Forward = Vector(m_pov.Rotation);
    PawnToPoint = V - GetViewTargetAsPawn().location;
    CameraFromPlayer = GetCameraLocation() - GetViewTargetAsPawn().location;
    CamNormOffset = CameraFromPlayer Dot Forward;
    CameraNorm = Forward * CamNormOffset;
    CameraOrth = CameraFromPlayer - CameraNorm;
    Adjascent = VSize(CameraOrth);
    Hypotenuse = VSize(PawnToPoint);
    if (Hypotenuse * Hypotenuse - Adjascent * Adjascent < float(0))
    {
        return;
    }
    Opposite = Sqrt(Hypotenuse * Hypotenuse - Adjascent * Adjascent);
    Intersection = CameraOrth + Forward * Opposite;
    YawDiff = float(Rotator(PawnToPoint).Yaw - Rotator(Intersection).Yaw);
    PitchDiff = float(Rotator(PawnToPoint).Pitch - Rotator(Intersection).Pitch);
    m_pov.Rotation.Yaw += int(YawDiff);
    m_pov.Rotation.Pitch += int(PitchDiff);
    m_pov.Rotation.Roll = 0;
    m_pov.location = GetCameraLocation();
}
public final native function Vector CalculateOffsetHook(optional float Distance = 1.0);

public static final native function ComputeClipPlaneRect(float fFov, float fNearClipPlane, out float fWidth, out float fHeight);

public final native function DoCameraCollisionNative(Vector CollisionHook, out Vector V, out Rotator R, Actor A);

public native function bool GetActorCameraHook(out Vector OutLocation);

public final native function Vector GetCameraHook();

public native function Vector GetCameraLocation();

public final event function Controller GetViewTargetAsController()
{
    local Pawn ViewTargetPawn;
    
    ViewTargetPawn = Pawn(ViewTarget.Target);
    if (ViewTargetPawn != None)
    {
        if (ViewTargetPawn.DrivenVehicle != None)
        {
            return ViewTargetPawn.DrivenVehicle.Controller;
        }
        return ViewTargetPawn.Controller;
    }
    return Controller(ViewTarget.Target);
}
public function Initialize()
{
    bRecenterCancelled = FALSE;
}
public event function ModifyPostProcessSettings(out PostProcessSettings PPSettings);

public function Tick(float TimeDelta)
{
    local Controller C;
    local BioPlayerController PC;
    local Rotator R;
    
    C = GetViewTargetAsController();
    if (C != None)
    {
        m_pov.Rotation = C.Rotation;
    }
    else if (ViewTarget.Target != None)
    {
        m_pov.Rotation = ViewTarget.Target.Rotation;
    }
    m_pov.location = GetCameraLocation();
    m_pov.FOV = FOV;
    PC = BioPlayerController(C);
    if (PC != None && LocalPlayer(PC.Player) != None)
    {
        BioWorldInfo(PC.WorldInfo).SetRenderStateOfPlayerToDefault(0);
        if (bRecenterCameraNew && !bRecenterCancelled)
        {
            if (Abs(PC.PlayerInput.RawJoyLookRight) < 0.100000001 && Abs(PC.PlayerInput.RawJoyLookUp) < 0.100000001)
            {
                R = RLerp(m_pov.Rotation, CameraTargetDir, 1.0 - FClamp(2.71799994 ** (-RecenterStrength * TimeDelta), 0.0, 1.0), TRUE);
                PC.SetRotation(R);
            }
            else if (bAutoCancelCameraRecentering)
            {
                bRecenterCancelled = TRUE;
            }
        }
    }
}
public function DrawHUD(BioCheatManager M)
{
    local Pawn PawnTarget;
    local Vector ActorCameraHook;
    
    PawnTarget = GetViewTargetAsPawn();
    M.DrawProfileText("ViewTarget:" @ PawnTarget);
    M.DrawProfileText("Input:" @ Input);
    M.DrawProfileText("Sensitivity:" @ Input.CameraSensitivity.X @ "," @ Input.CameraSensitivity.Y);
    M.DrawProfileText("TimeToReachFullSpeed:" @ Input.TimeToReachFullSpeed);
    M.DrawProfileText("MaxCameraRotationSpeed:" @ Input.MaxCameraRotationSpeed);
    M.DrawProfileText("Follow Hook:" @ HookName @ HookOffset);
    M.DrawProfileText("Last collision with:" @ LastCameraCollisionActor);
    M.Outer.DrawDebugStar(GetCameraHook(), 5.0, 255, 0, 0, FALSE);
    M.Outer.DrawDebugStar(GetCameraLocation(), 5.0, 255, 255, 0, FALSE);
    if (GetActorCameraHook(ActorCameraHook))
    {
        M.Outer.DrawDebugStar(ActorCameraHook, 5.0, 255, 0, 0, FALSE);
        M.Outer.DrawDebugLine(GetCameraHook(), ActorCameraHook, 0, 0, 255, FALSE);
        M.Outer.DrawDebugLine(GetCameraLocation(), ActorCameraHook, 0, 255, 0, FALSE);
    }
}
public function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot)
{
    local Rotator CurrentRotation;
    local float fPitchDiff;
    
    if (bRecenterCamera && !bRecenterCancelled)
    {
        CurrentRotation = Normalize(OutViewRotation);
        fPitchDiff = float(CurrentRotation.Pitch);
        if (Abs(fPitchDiff) > 100.0)
        {
            OutViewRotation.Pitch = int(float(OutViewRotation.Pitch) - fPitchDiff * (DeltaTime / TimeToRecenter));
        }
    }
}
public function bool CheckLoop(SFXCameraMode M, int RecurseLevel)
{
    return FALSE;
}
public function DoCameraCollision(out Vector CamPosition, out Rotator CamRotation, Actor Owner)
{
    local Vector ActorCameraHook;
    
    if (bFirstPerson)
    {
        DoSniperCameraCollision(CamPosition, CamRotation, Owner);
    }
    if (!GetActorCameraHook(ActorCameraHook))
    {
        ActorCameraHook = vect(0.0, 0.0, 0.0);
    }
    DoCameraCollisionNative(ActorCameraHook, CamPosition, CamRotation, Owner);
}
public function DoSniperCameraCollision(out Vector V, out Rotator R, Actor A)
{
    local int idx;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (PC.HiddenActors.Find(PC.Pawn) == -1)
    {
        PC.HiddenActors.AddItem(PC.Pawn);
    }
    for (idx = 0; idx < PC.Pawn.Attached.Length; idx++)
    {
        if (PC.Pawn.Attached[idx] != None)
        {
            if (PC.HiddenActors.Find(PC.Pawn.Attached[idx]) == -1)
            {
                PC.HiddenActors.AddItem(PC.Pawn.Attached[idx]);
            }
        }
    }
}
public function Rotator GetCurrentShake()
{
    local Rotator CurrentShake;
    local Pawn PawnTarget;
    
    PawnTarget = GetViewTargetAsPawn();
    if (bIsCameraShakeEnabled && BioPawn(PawnTarget) != None)
    {
    }
    return CurrentShake;
}
public final function Pawn GetViewTargetAsPawn()
{
    if (ViewTarget.Target != None)
    {
        return Pawn(ViewTarget.Target);
    }
    return None;
}
public function bool IsCollisionEnabled()
{
    return bCollisionEnabled;
}
public function MakeActive();

public function MakeInactive();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraInput Name=s_Input
    End Object
    ViewTarget = {
                  POV = {
                         location = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                         FOV = 90.0
                        }, 
                  Target = None, 
                  Controller = None, 
                  AspectRatio = 0.0, 
                  PRI = None
                 }
    m_pov = {
             location = {X = 0.0, Y = 0.0, Z = 0.0}, 
             Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
             FOV = 90.0
            }
    HookOffset = {X = 0.0, Y = 0.0, Z = 98.0}
    HookName = 'Camera'
    FOV = 70.0
    AspectRatio = 1.77777779
    TimeToRecenter = 0.200000003
    RotationSpeedLimit = 200000.0
    Input = s_Input
    RecenterStrength = 2.0
    bCollisionEnabled = TRUE
    bAllowSpectate = TRUE
}
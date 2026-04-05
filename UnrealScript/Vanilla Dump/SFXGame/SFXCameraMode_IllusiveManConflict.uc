Class SFXCameraMode_IllusiveManConflict extends SFXCameraMode within SFXGameModeIllusiveManConflict;

var ScreenShakeStruct Shake;
var int YawRange;
var int YawCenter;
var float Debug_Speed;
var float AngleMin;
var float AngleMax;
var float MaxSpeed;
var float AccumulatedYaw;
var float AccumulatedPitch;
var float Force;
var float SmoothedSpeed;
var(SFXCameraMode_IllusiveManConflict) float Smoothing;

public function Tick(float DeltaTime)
{
    local int startYaw;
    local int VictoryYaw;
    
    Super.Tick(DeltaTime);
    InitializeFromGameMode();
    startYaw = int(float(YawCenter - YawRange) + float(YawRange) * 2.0 * Outer.DesignerSeq.PushMiniGameStartingPercent);
    if (Outer.Outer.Rotation.Yaw < startYaw)
    {
        Force = FMax(Force - DeltaTime, 0.0);
    }
    UpdateCameraSprings(DeltaTime);
    if (Outer.bPushing && Force <= float(0))
    {
        VictoryYaw = int(float(YawCenter - YawRange) + float(YawRange) * 2.0 * Outer.DesignerSeq.PushMiniGameVictoryPercent);
        if (Outer.Outer.Rotation.Yaw > VictoryYaw)
        {
            Outer.bPushing = FALSE;
        }
    }
    UpdateInput(DeltaTime);
}
public function InitializeFromGameMode()
{
    local Vector ToIM;
    local Vector ToAndy;
    local Rotator Left;
    local Rotator Right;
    
    ToAndy = Outer.AndersonTargetLocation() - Outer.Outer.PlayerCamera.CameraCache.POV.location;
    ToIM = Outer.IllusiveManTargetLocation() - Outer.Outer.PlayerCamera.CameraCache.POV.location;
    ToAndy.Z = 0.0;
    ToAndy = Normal(ToAndy);
    ToIM.Z = 0.0;
    ToIM = Normal(ToIM);
    Left = Rotator(ToIM);
    Right = Rotator(ToAndy);
    if (Right.Yaw < Left.Yaw)
    {
        Left = Rotator(ToAndy);
        Right = Rotator(ToIM);
    }
    YawCenter = int(float((Left.Yaw + Right.Yaw)) * 0.5);
    YawRange = int(Abs(float(Left.Yaw - Right.Yaw)) * 0.5);
}
public function Rotator SmartRLerp(Rotator A, Rotator B, float Alpha)
{
    local Rotator Delta;
    
    A = Normalize(A);
    B = Normalize(B);
    Delta = B - A;
    if (Abs(float(Delta.Yaw) * Alpha) < float(1))
    {
        AccumulatedYaw += float(Delta.Yaw) * Alpha;
    }
    if (Abs(float(Delta.Pitch) * Alpha) < float(1))
    {
        AccumulatedPitch += float(Delta.Pitch) * Alpha;
    }
    if (Abs(AccumulatedYaw) >= float(1))
    {
        A.Yaw += int(AccumulatedYaw);
        AccumulatedYaw = 0.0;
    }
    if (Abs(AccumulatedPitch) >= float(1))
    {
        A.Pitch += int(AccumulatedPitch);
        AccumulatedPitch = 0.0;
    }
    return Normalize(A + Delta * Alpha);
}
public function UpdateCameraSprings(float DeltaTime)
{
    local SFXPlayerController PC;
    local Vector ToAndy;
    local Vector ToIM;
    local Vector CamDir;
    local Vector CamToAndy;
    local Rotator R;
    local float Dot;
    local float Angle;
    local float MaxAngle;
    local float Alpha;
    local float ScaleFactor;
    local float CurrentSpeed;
    
    PC = SFXPlayerController(GetViewTargetAsController());
    ToAndy = Outer.AndersonTargetLocation() - PC.PlayerCamera.CameraCache.POV.location;
    ToIM = Outer.IllusiveManTargetLocation() - PC.PlayerCamera.CameraCache.POV.location;
    CamDir = Vector(PC.PlayerCamera.CameraCache.POV.Rotation);
    CamDir = Normal(CamDir);
    CamToAndy = Outer.AndersonTargetLocation() - (PC.PlayerCamera.CameraCache.POV.location + CamDir * (CamDir Dot ToAndy));
    CamToAndy = Normal(CamToAndy);
    ToAndy.Z = 0.0;
    ToAndy = Normal(ToAndy);
    ToIM.Z = 0.0;
    ToIM = Normal(ToIM);
    CamDir.Z = 0.0;
    CamDir = Normal(CamDir);
    Angle = Abs(Acos(CamDir Dot ToIM));
    MaxAngle = Abs(Acos(ToAndy Dot ToIM));
    if (Outer.bPushing)
    {
        CurrentSpeed = Outer.DesignerSeq.PushSpeed;
    }
    else if (Angle < Outer.DesignerSeq.Threshold)
    {
        CurrentSpeed = Outer.DesignerSeq.MaxStrength;
    }
    else
    {
        Alpha = 1.0 - FClamp((Angle - Outer.DesignerSeq.Threshold) / (MaxAngle - Outer.DesignerSeq.Threshold), 0.0, 1.0);
        CurrentSpeed = Lerp(Outer.DesignerSeq.MinStrength, Outer.DesignerSeq.MaxStrength, Alpha);
    }
    CurrentSpeed = Lerp(SmoothedSpeed, CurrentSpeed, DeltaTime * Smoothing);
    SmoothedSpeed = CurrentSpeed;
    Debug_Speed = CurrentSpeed;
    Alpha = FClamp(CurrentSpeed * DeltaTime * Outer.GetSpringStiffness(), 0.0, 1.0) * 0.5;
    ScaleFactor = Abs(Acos(CamDir Dot ToAndy));
    if (ScaleFactor > 0.00999999978)
    {
        R = SmartRLerp(m_pov.Rotation, Rotator(ToAndy), Alpha / ScaleFactor);
    }
    else
    {
        R = m_pov.Rotation;
    }
    if (float(R.Yaw - YawCenter) > float(YawRange) * 1.5)
    {
        R.Yaw = int(float(YawCenter) + float(YawRange) * 1.5);
    }
    if (float(R.Yaw - YawCenter) < -(float(YawRange) * 1.5))
    {
        R.Yaw = int(float(YawCenter) - float(YawRange) * 1.5);
    }
    Dot = ToIM Dot CamDir;
    if (Dot > Outer.DesignerSeq.CameraShakeMinDot)
    {
        ScaleFactor = 1.0 / (1.0 - Outer.DesignerSeq.CameraShakeMinDot);
        PC.PlayScaledCameraShake(Outer.DesignerSeq.Shake, ScaleFactor * (Dot - Outer.DesignerSeq.CameraShakeMinDot));
    }
    PC.SetRotation(R);
}
public function UpdateInput(float DeltaTime)
{
    local SFXPlayerController PC;
    local Vector ToAndy;
    local Vector ToIM;
    local Vector CamDir;
    local float StickResponse;
    local float Angle;
    local float MaxAngle;
    
    PC = SFXPlayerController(GetViewTargetAsController());
    ToAndy = Normal(Outer.AndersonTargetLocation() - PC.PlayerCamera.CameraCache.POV.location);
    ToIM = Normal(Outer.IllusiveManTargetLocation() - PC.PlayerCamera.CameraCache.POV.location);
    CamDir = Vector(PC.PlayerCamera.CameraCache.POV.Rotation);
    Angle = Abs(Acos(CamDir Dot ToIM));
    MaxAngle = Abs(Acos(ToAndy Dot ToIM));
    if (Force > float(0) || Angle < Outer.DesignerSeq.Threshold)
    {
        Input.CameraSensitivity.X = 0.0;
        Input.CameraSensitivity.Y = 0.0;
    }
    else
    {
        StickResponse = FClamp((Angle - Outer.DesignerSeq.Threshold) / (MaxAngle - Outer.DesignerSeq.Threshold), 0.0, 1.0) * MaxSpeed;
        Input.CameraSensitivity.X = StickResponse;
        Input.CameraSensitivity.Y = StickResponse;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
        TimeToReachFullSpeed = 10.0
        MaxCameraRotationSpeed = 3.0
        MouseClampMax = 50.0
        bClampMouse = TRUE
    End Template
    Shake = {
             RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
             RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
             RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
             LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
             LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             ShakeName = 'None', 
             TimeToGo = 0.0, 
             TimeDuration = 1.0, 
             RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             FOVAmplitude = 2.0, 
             FOVFrequency = 5.0, 
             FOVSinOffset = 0.0, 
             TargetingDampening = 0.0, 
             bOverrideTargetingDampening = FALSE, 
             FOVParam = EShakeParam.ESP_OffsetRandom
            }
    AngleMin = 0.100000001
    AngleMax = 0.200000003
    MaxSpeed = 10.0
    Smoothing = 5.0
    Offset = {X = 90.0, Y = -22.0, Z = 15.0}
    HookOffset = {X = -30.0, Y = 20.0, Z = 80.0}
    FOV = 25.0
    Input = s_Input
    bIsCameraShakeEnabled = TRUE
}
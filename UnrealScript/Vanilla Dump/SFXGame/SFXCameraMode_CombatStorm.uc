Class SFXCameraMode_CombatStorm extends SFXCameraMode_Combat;

var float StickFactor;
var float FullTurnRecenter;

public function Initialize()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (PC != None && PC.Pawn != None && PC.Pawn.IsLocallyControlled())
    {
        CameraTargetDir = PC.Rotation;
    }
    else
    {
        CameraTargetDir = PC.Rotation;
    }
}
public function Tick(float DeltaTime)
{
    SetTarget();
    Super(SFXCameraMode).Tick(DeltaTime);
}
public function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot);

public function SetTarget()
{
    local BioPlayerController PC;
    local BioPlayerInput PInput;
    local int DeltaYaw;
    local Vector MoveStickAdjusted;
    
    PC = BioPlayerController(GetViewTargetAsController());
    if (PC != None && PC.Pawn != None && PC.Pawn.IsLocallyControlled())
    {
        PInput = BioPlayerInput(PC.PlayerInput);
        if (!PC.WorldInfo.IsConsoleBuild())
        {
            bRecenterCameraNew = FALSE;
        }
        else
        {
            bRecenterCameraNew = TRUE;
            Input.CameraSensitivity.X = 0.0;
            Input.CameraSensitivity.Y = 0.0;
        }
        MoveStickAdjusted = PInput.MoveStick;
        MoveStickAdjusted.X = Abs(MoveStickAdjusted.X);
        CameraTargetDir = CameraTargetDir + Rotator(MoveStickAdjusted) * StickFactor;
        RecenterStrength = default.RecenterStrength;
    }
    else
    {
        CameraTargetDir = PC.Rotation;
    }
    DeltaYaw = (CameraTargetDir.Yaw - PC.Rotation.Yaw) %  65536;
    if (DeltaYaw > 32768)
    {
        DeltaYaw -= 65536;
    }
    if (DeltaYaw < -32767)
    {
        DeltaYaw += 65536;
    }
    CameraTargetDir.Yaw = PC.Rotation.Yaw + Clamp(DeltaYaw, -8192, 8192);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
        MaxVelocity = 1.0
        MotionBlurAmount = 0.400000006
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 30.0, Y = 20.0}
    End Template
    StickFactor = 0.0199999996
    FullTurnRecenter = 1.0
    Blur = s_DefaultBlur
    Offset = {X = 135.0, Y = -17.0, Z = 45.0}
    HookOffset = {X = -10.0, Y = 40.0, Z = 90.0}
    FOV = 90.0
    Input = s_Input
    RecenterStrength = 10.0
    bRecenterCameraNew = TRUE
}
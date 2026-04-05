Class SFXGameModeIllusiveManConflict extends SFXGameModeBase within BioPlayerController
    config(Input);

var ScreenShakeStruct PainShake;
var Vector TargetOffset;
var clearcrosslevel SFXSeqAct_BeginIllusiveManConflict DesignerSeq;
var int Difficulty;
var float AccumulatedMovement;
var export SFXCameraMode_IllusiveManConflict CameraMode;
var bool bPushing;

public function Activated()
{
    Super.Activated();
    SetTimer(0.0329999998, TRUE, 'PollInput');
}
public function Deactivated()
{
    Super.Deactivated();
    ClearTimer('PollInput');
    DesignerSeq = None;
}
public exec function FireWeapon()
{
    local SFXWeapon Weapon;
    local Vector StartAimPoint;
    
    Weapon = SFXWeapon(Outer.Pawn.Weapon);
    Weapon.StartFire(Weapon.DefaultFireMode);
    StartAimPoint = (IllusiveManTargetLocation() + AndersonTargetLocation()) * DesignerSeq.PushMiniGameVictoryPercent;
    Outer.SetRotation(Rotator(StartAimPoint - Outer.PlayerCamera.CameraCache.POV.location));
}
public function Vector AndersonTargetLocation()
{
    return Pawn(DesignerSeq.Anderson).Mesh.GetBoneLocation(DesignerSeq.AndersonBoneName) + DesignerSeq.AndersonOffset;
}
public exec function DecreaseDifficulty()
{
    Difficulty = int(FMax(float(Difficulty - 1), 0.0));
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return CameraMode;
}
public function float GetSpringStiffness()
{
    return DesignerSeq.Difficulty[Difficulty];
}
public function Vector IllusiveManTargetLocation()
{
    return Pawn(DesignerSeq.IllusiveMan).Mesh.GetBoneLocation(DesignerSeq.IllusiveManBoneName) + DesignerSeq.IllusiveManOffset;
}
public exec function IncreaseDifficulty()
{
    Difficulty = int(FMin(float(Difficulty + 1), 3.0));
}
public function InitializeMiniGame(SFXSeqAct_BeginIllusiveManConflict Seq)
{
    local Vector StartAimPoint;
    
    DesignerSeq = Seq;
    CameraMode.InitializeFromGameMode();
    Difficulty = Seq.StartingDifficulty;
    StartAimPoint = (IllusiveManTargetLocation() + AndersonTargetLocation()) * 0.5;
    Outer.SetRotation(Rotator(StartAimPoint - Outer.PlayerCamera.CameraCache.POV.location));
}
public function PollInput()
{
    local float Damage;
    local Vector ToIM;
    local SFXPlayerCamera Camera;
    
    if (AccumulatedMovement > 0.100000001)
    {
        AccumulatedMovement = 0.0;
        ToIM = DesignerSeq.IllusiveMan.location - Outer.PlayerCamera.CameraCache.POV.location;
        Damage = DesignerSeq.BaseDamageAmount * Vector(Outer.PlayerCamera.CameraCache.POV.Rotation) Dot Normal(ToIM);
        Outer.Pawn.TakeDamage(Damage, None, Outer.Pawn.location, vect(0.0, 0.0, 0.0), Class'SFXDamageType_IllusiveManConflict');
        SFXPlayerController(Outer).PlayScaledCameraShake(PainShake, 1.0);
    }
    Camera = SFXPlayerCamera(Outer.PlayerCamera);
    if (Camera.m_aTraceInfo.m_oCollVectorActor == DesignerSeq.Anderson)
    {
        FireWeapon();
        bPushing = FALSE;
    }
}
public exec function StartPush()
{
    bPushing = TRUE;
    CameraMode.Force = DesignerSeq.PushInputLockoutTime;
}
public exec function UpdateInput()
{
    AccumulatedMovement += FMax(0.0, Outer.PlayerInput.aMouseX);
    AccumulatedMovement += FMax(0.0, Outer.PlayerInput.RawJoyLookRight);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_IllusiveManConflict Name=Cam01
    End Object
    PainShake = {
                 RotAmplitude = {X = 25.0, Y = 25.0, Z = 10.0}, 
                 RotFrequency = {X = 0.200000003, Y = 0.200000003, Z = 0.200000003}, 
                 RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                 LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 ShakeName = 'IllusiveManPainShake', 
                 TimeToGo = 0.0, 
                 TimeDuration = 0.150000006, 
                 RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 FOVAmplitude = 0.0, 
                 FOVFrequency = 0.0, 
                 FOVSinOffset = 0.0, 
                 TargetingDampening = 0.0, 
                 bOverrideTargetingDampening = FALSE, 
                 FOVParam = EShakeParam.ESP_OffsetRandom
                }
    TargetOffset = {X = 0.0, Y = 0.0, Z = 70.0}
    CameraMode = Cam01
    Bindings = ({
                 Command = "PC_LookX | Repeat UpdateInput", 
                 Name = 'MouseX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_LookY", 
                 Name = 'MouseY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Menu", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Shoot", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowHUD = TRUE
    bShowHealth = FALSE
    bShowWeapon = FALSE
    bAllowRotationUpdate = TRUE
    bAllowCamera = TRUE
    bShowSubtitle = TRUE
    bShowReticles = TRUE
    bAllowPowerWeaponUI = TRUE
}
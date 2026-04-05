Class SFXGameModeVehicle extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModeVehicle) WwiseEvent EnterTightAimSound;
var(SFXGameModeVehicle) WwiseEvent ExitTightAimSound;
var(SFXGameModeVehicle) export SFXCameraMode_Vehicle VehicleCam;
var(SFXGameModeVehicle) export SFXCameraMode_MountedGunTightAim TightAimCam;

public function Initialize()
{
    VehicleCam.Input.m_bUseExplorationSensitivity = TRUE;
    Super.Initialize();
}
public exec function ShowMenu()
{
    Outer.bBoost = 0;
    Outer.bJump = 0;
    Super.ShowMenu();
}
public exec function EnterCommandMenu()
{
    local Vehicle V;
    
    V = Vehicle(Outer.Pawn);
    if (BioPawn(V.Driver).Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterCommandMenu();
}
public exec function EnterPowerWheel()
{
    local Vehicle V;
    
    V = Vehicle(Outer.Pawn);
    if (BioPawn(V.Driver).Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterPowerWheel();
}
public exec function EnterWeaponWheel()
{
    local Vehicle V;
    
    V = Vehicle(Outer.Pawn);
    if (BioPawn(V.Driver).Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterWeaponWheel();
}
public exec function ExitVehicle()
{
    local Vehicle V;
    local SFXVehicle_MountedGun MG;
    
    V = Vehicle(Outer.Pawn);
    MG = SFXVehicle_MountedGun(Outer.Pawn);
    if (V != None)
    {
        if (MG == None || MG.bAllowedToLeave)
        {
            V.DriverLeave(TRUE);
        }
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.150000006;
    PreserveTarget = 1;
    if (Outer.IsZoomed())
    {
        return TightAimCam;
    }
    return VehicleCam;
}
public exec function StopTightAim()
{
    SetTimer(0.100000001, FALSE, 'TurnOffTightAim');
    Outer.PlaySound(ExitTightAimSound, FALSE);
}
public exec function TightAim()
{
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    ClearTimer('TurnOffTightAim');
    BioPlayerInput(Outer.PlayerInput).bWantsToZoom = 1;
    Outer.PlaySound(EnterTightAimSound, FALSE);
    if (AimAssist != None)
    {
        AimAssist.ZoomSnap();
    }
}
public exec function TryReload()
{
    local SFXWeapon Weapon;
    
    Weapon = SFXWeapon(Outer.Pawn.Weapon);
    if (Weapon != None && Weapon.CanReload())
    {
        Weapon.TryReload();
    }
}
public exec function bool TryRoll()
{
    local BioPlayerInput Input;
    local BioPawn oPawn;
    local SFXVehicle_MountedGun MG;
    
    oPawn = BioPawn(Vehicle(Outer.Pawn).Driver);
    MG = SFXVehicle_MountedGun(Outer.Pawn);
    if (Outer.Pawn != None && Outer.IsZoomed() == FALSE && MG != None && MG.bAllowedToLeave == TRUE)
    {
        Input = BioPlayerInput(Outer.PlayerInput);
        if (Input != None)
        {
            if (Input.RawJoyRight > 0.800000012)
            {
                oPawn.StartCustomAction(55);
                Vehicle(Outer.Pawn).DriverLeave(TRUE);
                return TRUE;
            }
            else if (Input.RawJoyRight < -0.800000012)
            {
                oPawn.StartCustomAction(54);
                Vehicle(Outer.Pawn).DriverLeave(TRUE);
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function TurnOffTightAim()
{
    BioPlayerInput(Outer.PlayerInput).bWantsToZoom = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_MountedGunTightAim Name=TightAimCamera1
        Offset = {X = 30.0, Y = 0.0, Z = 0.0}
        HookOffset = {X = 0.0, Y = 0.0, Z = 160.0}
        HookName = 'Root'
        RotationSpeedLimit = 17500.0
        bCameraRubberBand = FALSE
    End Object
    Begin Object Class=SFXCameraMode_Vehicle Name=VehicleCam0
        CameraName = 'VehicleCam'
    End Object
    EnterTightAimSound = WwiseEvent'Wwise_Weapons_S_MinigunTurret.Play_wep_s_minigunturret_zoom_in'
    ExitTightAimSound = WwiseEvent'Wwise_Weapons_S_MinigunTurret.Play_wep_s_minigunturret_zoom_out'
    VehicleCam = VehicleCam0
    TightAimCam = TightAimCamera1
    Bindings = ({
                 Command = "Shared_Shoot", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Aim", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_LookX", 
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
                 Command = "Shared_Action", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_EnterCommandMenu", 
                 Name = 'LeftShift', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowHUD = TRUE
    bShowSelection = TRUE
    bShowDamageIndicators = TRUE
    bShowRadar = TRUE
    bAllowMovement = TRUE
    bAllowCamera = TRUE
    bAllowCameraMods = TRUE
    bAllowPauseMenu = TRUE
    bAllowHints = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bShowReticles = TRUE
    bAllowMessageUI = TRUE
    bNuiSpeechCombat = TRUE
}
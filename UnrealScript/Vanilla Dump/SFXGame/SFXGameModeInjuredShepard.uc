Class SFXGameModeInjuredShepard extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModeInjuredShepard) config float InputDelayTightAimExit;
var(SFXGameModeInjuredShepard) export SFXCameraMode_Combat InjuredCamera;

public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.25;
    PreserveTarget = 0;
    return InjuredCamera;
}
public function ResetSelectionMaterialParams()
{
    if (Outer.m_oPlayerSelection != None)
    {
        Outer.m_oPlayerSelection.SetSelectionIconMaterialParam('Select_ok', 0);
        Outer.m_oPlayerSelection.SetSelectionIconMaterialParam('Select_nodice', 0);
    }
}
public exec function StopTightAim()
{
    SetTimer(InputDelayTightAimExit, FALSE, 'TurnOffTightAim');
}
public exec function TightAim()
{
    local SFXWeapon Weapon;
    
    if (Outer.PlayerInput == None || BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    if (Outer.Pawn != None)
    {
        Weapon = SFXWeapon(Outer.Pawn.Weapon);
        if (Weapon != None && Weapon.GetAmmoCountInMagazine() == 0)
        {
            TryReload();
        }
    }
    ClearTimer('TurnOffTightAim');
    BioPlayerInput(Outer.PlayerInput).bWantsToZoom = 1;
}
public exec function TryReload()
{
    local SFXWeapon Weapon;
    
    if (Outer.PlayerInput == None || BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    if (Outer.Pawn != None)
    {
        Weapon = SFXWeapon(Outer.Pawn.Weapon);
        if (Weapon != None && Weapon.CanReload())
        {
            Weapon.TryReload();
        }
    }
}
public function TurnOffTightAim()
{
    if (Outer.PlayerInput != None)
    {
        BioPlayerInput(Outer.PlayerInput).bWantsToZoom = 0;
    }
}
public exec function bool Used()
{
    if (Outer.m_oPlayerSelection == None || Outer.m_oPlayerSelection.m_oCurrentSelectionTarget == None)
    {
        return FALSE;
    }
    ClearTimer('ResetSelectionMaterialParams');
    SetTimer(0.25, FALSE, 'ResetSelectionMaterialParams');
    if (Outer.TryUse(Outer.m_oPlayerSelection.m_oCurrentSelectionTarget))
    {
        Outer.m_oPlayerSelection.SetSelectionIconMaterialParam('Select_ok', 1);
        return TRUE;
    }
    else
    {
        Outer.m_oPlayerSelection.SetSelectionIconMaterialParam('Select_nodice', 1);
        return FALSE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Combat Name=InjuredCam0
    End Object
    InputDelayTightAimExit = 0.100000001
    InjuredCamera = InjuredCam0
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
                 Command = "Shared_QuickSave", 
                 Name = 'F5', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_QuickLoad", 
                 Name = 'F9', 
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
    bShowHealth = FALSE
    bShowWeapon = FALSE
    bAllowRotationUpdate = TRUE
    bAllowMovement = TRUE
    bAllowCamera = TRUE
    bAllowCameraMods = TRUE
    bAllowSave = TRUE
    bAllowPauseMenu = TRUE
    bAllowHints = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bShowReticles = TRUE
    bPlayVocalizations = TRUE
    bAllowMessageUI = TRUE
    bNuiSpeechGlobal = TRUE
    bNuiSpeechExplore = TRUE
    bNuiSpeechCombat = TRUE
}
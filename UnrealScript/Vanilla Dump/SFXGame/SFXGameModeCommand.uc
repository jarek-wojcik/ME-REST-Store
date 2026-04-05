Class SFXGameModeCommand extends SFXGameModeBase within BioPlayerController
    config(Input);

var bool bCameraEnabled;

public function Activated()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    Super.Activated();
    Outer.SetZoomed(FALSE);
    Outer.WorldInfo.PauseGame(TRUE);
    oGUI.PlayGuiSound('ActivateSquadCommand');
    bCameraEnabled = FALSE;
    oGUI.HideHint(Outer);
}
public function Deactivated()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    Super.Deactivated();
    Outer.WorldInfo.PauseGame(FALSE);
    if (BioPawn(Outer.Pawn) != None && BioPawn(Outer.Pawn).bCombatPawn)
    {
        Outer.ApplyTacticalOrders();
    }
    oGUI.PlayGuiSound('DeactivateSquadCommand');
    oGUI.RestoreHint(Outer);
}
public exec function DisableCamera()
{
    if (bCameraEnabled)
    {
        Outer.IgnoreLookInput(TRUE);
        bCameraEnabled = FALSE;
    }
}
public exec function ShowMenu()
{
    ExitCommandMenu();
    Super.ShowMenu();
}
public exec function EnableCamera()
{
    if (!bCameraEnabled)
    {
        Outer.IgnoreLookInput(FALSE);
        bCameraEnabled = TRUE;
    }
}
public exec function ExitCommandMenu()
{
    Outer.GameModeManager2.DisableMode(5);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bindings = ({
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
                 Command = "PC_CommandToggleCam", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_ExitCommandMenu", 
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
    bShowRadar = TRUE
    bAllowSave = TRUE
    bAllowPauseMenu = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bShowReticles = TRUE
    bAllowMessageUI = TRUE
    bAllowPowerWeaponUI = TRUE
}
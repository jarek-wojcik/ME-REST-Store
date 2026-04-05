Class SFXGameModePowerWheel extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModePowerWheel) config float DisableMoveTime;

public function Activated()
{
    local SFXPRI PRI;
    local SFXGUIInteraction oGUI;
    
    Super.Activated();
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    Outer.SetZoomed(FALSE);
    Outer.WorldInfo.PauseGame(TRUE);
    oGUI.PlayGuiSound('ActivateSquadCommand');
    oGUI.HideHint(Outer);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        PRI = SFXPRI(Outer.PlayerReplicationInfo);
        if (PRI != None)
        {
            if (PRI.StickConfig == EStickConfigOptions.SCO_SouthPaw)
            {
                Outer.GameModeManager2.Helper_SetStaticConsoleBinding('XboxTypeS_LeftX', "Axis aGuiTurn Speed=1.0 EventID=4");
                Outer.GameModeManager2.Helper_SetStaticConsoleBinding('XboxTypeS_LeftY', "Axis aGuiLookUp Speed=1.0 EventID=5");
                Outer.GameModeManager2.Helper_SetStaticConsoleBinding('XboxTypeS_RightX', "Axis aGuiStrafe Speed=1.0 EventID=2");
                Outer.GameModeManager2.Helper_SetStaticConsoleBinding('XboxTypeS_RightY', "Axis aGuiBaseY Speed=-1.0 EventID=3");
            }
        }
    }
}
public function Deactivated()
{
    local SFXPRI PRI;
    local SFXGUIInteraction oGUI;
    
    Super.Deactivated();
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    Outer.WorldInfo.PauseGame(FALSE);
    if (BioPawn(Outer.Pawn).bCombatPawn)
    {
        Outer.ApplyTacticalOrders();
    }
    oGUI.PlayGuiSound('DeactivateSquadCommand');
    oGUI.RestoreHint(Outer);
    if (DisableMoveTime > 0.0 && Outer.IsInCoverState())
    {
        Outer.IgnoreMoveInput(TRUE);
        SetTimer(DisableMoveTime, FALSE, 'EnableMovement');
    }
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        PRI = SFXPRI(Outer.PlayerReplicationInfo);
        if (PRI != None)
        {
            if (PRI.StickConfig == EStickConfigOptions.SCO_SouthPaw)
            {
                Outer.GameModeManager2.Helper_ResetStaticConsoleBindings();
            }
        }
    }
}
public exec function ShowMenu()
{
    ExitPowerWheel();
    Super.ShowMenu();
}
public final function EnableMovement()
{
    Outer.IgnoreMoveInput(FALSE);
}
public exec function ExitPowerWheel()
{
    Outer.GameModeManager2.DisableMode(3);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShowHUD = TRUE
    bShowSelection = TRUE
    bShowRadar = TRUE
    bAllowRotationUpdate = TRUE
    bAllowSave = TRUE
    bAllowPauseMenu = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bShowReticles = TRUE
    bAllowMessageUI = TRUE
    bNuiSpeechCombat = TRUE
    bAllowPowerWeaponUI = TRUE
}
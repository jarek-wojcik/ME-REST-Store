Class SFXGameModeDreamSequence extends SFXGameModeBase within BioPlayerController
    config(Input);

public exec function bool ShowAreaMap()
{
    return FALSE;
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
                }
               )
    bShowSelection = TRUE
    bShowHealth = FALSE
    bShowWeapon = FALSE
    bAllowRotationUpdate = TRUE
    bAllowMovement = TRUE
    bAllowCamera = TRUE
    bAllowCameraMods = TRUE
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
Class SFXGameModeLobby extends SFXGameModeBase within BioPlayerController
    config(Input);

var array<Name> StackedGuis;

public function Deactivated()
{
    if (StackedGuis.Length == 0)
    {
        Super.Deactivated();
    }
}
public function ActivateSpecifier(Name ModeSpecifier)
{
    StackedGuis.AddItem(ModeSpecifier);
}
public function DeactivateSpecifier(Name ModeSpecifier)
{
    StackedGuis.RemoveItem(ModeSpecifier);
}
public exec function MPToggleReady()
{
    if (Class'SFXGUIInteraction'.static.GetInstance().IsInMPLobby())
    {
        Class'SFXGUIInteraction'.static.GetInstance().MPToggleReady(Outer);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bindings = ({
                 Command = "PC_PushToTalk", 
                 Name = 'Tab', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_MPToggleReady", 
                 Name = 'SpaceBar', 
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
    bStopMovement = TRUE
    bAllowSave = TRUE
    bHasMouseAuthority = TRUE
    bMouseVisible = TRUE
    bMergeNotifications = TRUE
    bAllowMessageUI = TRUE
    bRestrictToPrimaryViewport = TRUE
    Priority = EGameModePriority2.ModePriority_Menus
}
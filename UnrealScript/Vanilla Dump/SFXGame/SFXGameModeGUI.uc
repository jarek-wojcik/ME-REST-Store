Class SFXGameModeGUI extends SFXGameModeBase within BioPlayerController
    config(Input);

var array<Name> StackedGuis;
var float DeathTransitionTime;
var(SFXGameModeGUI) export BioCameraBehaviorFlourish DeathCam;
var(SFXGameModeGUI) export SFXCameraTransition_GalaxyMap InstantTransition;

public function Activated()
{
    Super.Activated();
    Class'SFXGUIInteraction'.static.GetInstance().HideHint(Outer);
    PauseTimeDilationEffects();
}
public function Deactivated()
{
    if (StackedGuis.Length == 0)
    {
        Super.Deactivated();
        Class'SFXGUIInteraction'.static.GetInstance().RestoreHint(Outer);
        UnpauseTimeDilationEffects();
    }
}
public function ActivateSpecifier(Name ModeSpecifier)
{
    StackedGuis.AddItem(ModeSpecifier);
}
public exec function ConnectToCerberus()
{
    local BioSFHandler_MainMenu Menu;
    
    Menu = Class'SFXGUIInteraction'.static.GetInstance().GetMainMenuHandler(Outer);
    if (Menu != None)
    {
        Menu.OnMessagingComputerConnectButton();
    }
}
public function DeactivateSpecifier(Name ModeSpecifier)
{
    StackedGuis.RemoveItem(ModeSpecifier);
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    if (Outer.Pawn != None && Outer.Pawn.IsDead())
    {
        TransitionTime = DeathTransitionTime;
        PreserveTarget = 0;
        return DeathCam;
    }
    else
    {
        Transition = InstantTransition;
        TransitionTime = 0.0;
        PreserveTarget = 0;
    }
    return OldCameraMode;
}
public exec function bool HideAreaMap()
{
    local SFXSFHandler_AreaMap oHandler;
    
    oHandler = Class'SFXGUIInteraction'.static.GetInstance().GetAreaMapHandler(Outer);
    if (oHandler != None)
    {
        oHandler.OnBeginClose();
        return TRUE;
    }
    return FALSE;
}
public exec function MPToggleReady()
{
    if (Class'SFXGUIInteraction'.static.GetInstance().IsInMPLobby())
    {
        Class'SFXGUIInteraction'.static.GetInstance().MPToggleReady(Outer);
    }
}
public exec function NextCerberusItem()
{
    local BioSFHandler_MainMenu Menu;
    
    Menu = Class'SFXGUIInteraction'.static.GetInstance().GetMainMenuHandler(Outer);
    if (Menu != None)
    {
        Menu.NextCerberusItem();
    }
}
public exec function PrevCerberusItem()
{
    local BioSFHandler_MainMenu Menu;
    
    Menu = Class'SFXGUIInteraction'.static.GetInstance().GetMainMenuHandler(Outer);
    if (Menu != None)
    {
        Menu.PrevCerberusItem();
    }
}
public exec function SlideshowAdvance(bool bForward)
{
    local SFXSFHandler_Slideshow oHandler;
    
    oHandler = Class'SFXGUIInteraction'.static.GetInstance().GetSlideshowHandler(Outer);
    if (oHandler != None)
    {
        oHandler.TryAdvanceShow(bForward);
    }
}
public exec function SlideshowExit()
{
    local SFXSFHandler_Slideshow oHandler;
    
    oHandler = Class'SFXGUIInteraction'.static.GetInstance().GetSlideshowHandler(Outer);
    if (oHandler != None)
    {
        oHandler.TryExitShow();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorFlourish Name=DeathCam0
        CameraName = 'DeathCam'
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    DeathTransitionTime = 0.5
    DeathCam = DeathCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "Shared_AdvanceSlideshowBackward", 
                 Name = 'Left', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_AdvanceSlideshowForward", 
                 Name = 'Right', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_ExitSlideshow", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
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
    bStopMovement = TRUE
    bAllowSave = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bAllowMessageUI = TRUE
    bRestrictToPrimaryViewport = TRUE
    Priority = EGameModePriority2.ModePriority_Menus
}
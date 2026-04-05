Class SFXGameModeSpectator extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModeSpectator) export SFXCameraMode_Spectator SpectatorCam;

public function Activated()
{
    SetTimer(0.5, TRUE, 'ValidateTarget');
    Super.Activated();
}
public function Deactivated()
{
    ClearTimer('ValidateTarget');
    Super.Deactivated();
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return SpectatorCam;
}
public function ValidateTarget()
{
    local SFXPawn_Player TargetPawn;
    
    TargetPawn = SFXPawn_Player(Outer.PlayerCamera.PendingViewTarget.Target);
    if (TargetPawn == None)
    {
        TargetPawn = SFXPawn_Player(Outer.PlayerCamera.ViewTarget.Target);
    }
    if (TargetPawn == None || TargetPawn.IsDead() || TargetPawn.IsInState('Dying', ) || TargetPawn.IsInState('Downed', ))
    {
        Outer.ViewNextPlayer();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Spectator Name=SpectatorCam0
    End Object
    SpectatorCam = SpectatorCam0
    Bindings = ({
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
                 Command = "ViewNextPlayer true", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewNextPlayer true", 
                 Name = 'MouseScrollUp', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ViewPrevPlayer true", 
                 Name = 'MouseScrollDown', 
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
                 Command = "PC_PushToTalk", 
                 Name = 'Tab', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bAllowRotationUpdate = TRUE
    bAllowCamera = TRUE
    bAllowPauseMenu = TRUE
    bShowSubtitle = TRUE
    bHasMouseAuthority = TRUE
    bMergeNotifications = TRUE
    bShowReticles = TRUE
    bAllowMessageUI = TRUE
}
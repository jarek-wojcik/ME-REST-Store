Class SFXGameModeReplicationDebug extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModeReplicationDebug) export SFXCameraMode_ReplicationDebug ReplicationDebugCam;

public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return ReplicationDebugCam;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_ReplicationDebug Name=ReplicationDebugCam0
    End Object
    ReplicationDebugCam = ReplicationDebugCam0
    Bindings = ({
                 Command = "NextPawn", 
                 Name = 'Right', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PrevPawn", 
                 Name = 'Left', 
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
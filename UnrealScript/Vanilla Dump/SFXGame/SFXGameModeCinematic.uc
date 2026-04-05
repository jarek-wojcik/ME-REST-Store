Class SFXGameModeCinematic extends SFXGameModeBase within BioPlayerController
    config(Input);

public function Activated()
{
    local Actor A;
    local SFXSelectionModule SelMod;
    
    Super.Activated();
    Outer.m_oPlayerSelection.SelectionFlareComp.SetHidden(TRUE);
    foreach BioWorldInfo(Outer.WorldInfo).SelectableActors(A, )
    {
        SelMod = A.GetModule(Class'SFXSelectionModule');
        if (SelMod != None && SelMod.LensFlareComp != None)
        {
            SelMod.LensFlareComp.SetHidden(TRUE);
        }
    }
    RemoveTimeDilationEffects();
}
public function Deactivated()
{
    Super.Deactivated();
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    return None;
}
public exec function SkipCinematic()
{
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (BWI != None && BWI.m_bDisableCinematicSkip == FALSE)
    {
        BWI.m_bCinematicSkip = TRUE;
        BWI.TriggerCinematicSkippedEvent();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bindings = ({
                 Command = "Shared_CineSkip", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_CineSkip", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowSubtitle = TRUE
    bClearPendingFire = TRUE
    bHasMouseAuthority = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bEnforce16x9Subtitles = TRUE
    bRestrictToPrimaryViewport = TRUE
}
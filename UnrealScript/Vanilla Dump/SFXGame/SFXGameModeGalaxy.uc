Class SFXGameModeGalaxy extends SFXGameModeBase within BioPlayerController
    native
    config(Input);

var float DeadZone;
var(SFXGameModeGalaxy) export BioCameraBehaviorGalaxy GalaxyCam;
var(SFXGameModeGalaxy) export SFXCameraTransition_GalaxyMap InstantTransition;

public exec function BuyFuel()
{
    local SFXInventoryManager oInventory;
    
    if (GalaxyCam.m_nCurrentState != 3 || GalaxyCam.m_pSelectedObject != GalaxyCam.m_pDepotObject)
    {
        return;
    }
    oInventory = SFXInventoryManager(Outer.Pawn.InvManager);
    if (CanBuyFuel())
    {
        oInventory.CurrentFuel = FMin(oInventory.CurrentFuel + 25.0, oInventory.GetMaxFuel());
        oInventory.AdjustResource(0, -25, FALSE);
        if (oInventory.CurrentFuel >= oInventory.GetMaxFuel())
        {
            GalaxyCam.m_pAudioComponent.Play(GalaxyCam.Data.AudioData.BuyFuelSound_Full);
        }
        else
        {
            GalaxyCam.m_pAudioComponent.SetWwiseRTPC(GalaxyCam.Data.AudioData.BuyFuelSound_PctFullRTPCName, oInventory.CurrentFuel / oInventory.GetMaxFuel());
        }
    }
    else
    {
        GalaxyCam.m_pAudioComponent.Play(GalaxyCam.Data.AudioData.ErrorSound);
    }
}
public event function bool CanBuyFuel()
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(Outer.Pawn.InvManager);
    return GalaxyCam.m_nCurrentState == 3 && GalaxyCam.m_pSelectedObject == GalaxyCam.m_pDepotObject && (oInventory.CurrentFuel < oInventory.GetMaxFuel() && oInventory.GetResource(0) >= 25);
}
public function bool CanExit()
{
    if (bIsActive && Outer.GameModeManager2.IsInAnInteractiveGalaxyMode())
    {
        return TRUE;
    }
    return FALSE;
}
public function SFXCameraMode HACK_GetCameraMode()
{
    return GalaxyCam;
}
public function Initialize()
{
    GalaxyCam.Input.m_bUseExplorationSensitivity = TRUE;
    Super.Initialize();
}
public final exec function ScanSystem()
{
    GalaxyCam.ScanSystem();
}
public function BeginExitGalaxyMap(bool resize);

public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    Transition = InstantTransition;
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return GalaxyCam;
}
public final function BioSFHandler_GalaxyMap GetGalaxyMap()
{
    return Class'SFXGUIInteraction'.static.GetInstance().GetGalaxyMap(Outer);
}
public final function SetLTriggerLabelVisible(bool bShow, stringref srText)
{
    GalaxyCam.SetLTriggerLabelVisible(bShow, srText);
}
public final function SetRTriggerLabelVisible(bool bShow, stringref srText)
{
    GalaxyCam.SetRTriggerLabelVisible(bShow, srText);
}
public exec function StartFuel()
{
    if (GalaxyCam.m_nCurrentState != 3 || GalaxyCam.m_pSelectedObject != GalaxyCam.m_pDepotObject)
    {
        return;
    }
    if (CanBuyFuel())
    {
        GalaxyCam.m_pAudioComponent.Play(GalaxyCam.Data.AudioData.BuyFuelSound);
    }
}
public exec function StopFuel()
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(Outer.Pawn.InvManager);
    if (GalaxyCam.m_nCurrentState != 3)
    {
        return;
    }
    if (oInventory.CurrentFuel < oInventory.GetMaxFuel())
    {
        GalaxyCam.m_pAudioComponent.Play(GalaxyCam.Data.AudioData.BuyFuelSoundStop);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorGalaxy Name=GalaxyCam0
        CameraName = 'GalaxyCam'
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    DeadZone = 0.100000001
    GalaxyCam = GalaxyCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "PC_GalaxyMouseStrafe", 
                 Name = 'MouseX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_GalaxyMouseMovement", 
                 Name = 'MouseY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_GalaxySystemScan", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowHUD = TRUE
    bAllowCamera = TRUE
    bAllowSave = TRUE
    bAllowHints = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bAllowMessageUI = TRUE
    bRestrictToPrimaryViewport = TRUE
    Priority = EGameModePriority2.ModePriority_Menus
}
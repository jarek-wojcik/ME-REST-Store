Class SFXGameModeBase within BioPlayerController
    native
    abstract
    config(Input);

enum EGameModePriority2
{
    ModePriority_Base,
    ModePriority_CheatMenu,
    ModePriority_Conversation,
    ModePriority_Menus,
    ModePriority_Popup,
};

var transient native MultiMap_Mirror CollectedBindMapping;
var config array<KeyBind> Bindings;
var array<KeyBind> LocalizedBindings;
var int NumReportSkynetMPCustomEventSent;
var(SFXGameModeBase) config float RadarMapDisplayTime;
var bool bBindingsCollected;
var(SFXGameModeBase) bool bIsActive;
var(SFXGameModeBase) const bool bShowHUD;
var(SFXGameModeBase) const bool bShowSelection;
var(SFXGameModeBase) const bool bShowExploreSelection;
var(SFXGameModeBase) const bool bShowDamageIndicators;
var(SFXGameModeBase) const bool bShowRadar;
var(SFXGameModeBase) const bool bShowHealth;
var(SFXGameModeBase) const bool bShowWeapon;
var(SFXGameModeBase) const bool bAllowRotationUpdate;
var(SFXGameModeBase) const bool bAllowMovement;
var(SFXGameModeBase) const bool bStopMovement;
var(SFXGameModeBase) const bool bAllowCamera;
var(SFXGameModeBase) const bool bAllowCameraMods;
var(SFXGameModeBase) const bool bAllowSave;
var(SFXGameModeBase) const bool bAllowPauseMenu;
var(SFXGameModeBase) const bool bAllowHints;
var(SFXGameModeBase) const bool bShowSubtitle;
var(SFXGameModeBase) const bool bClearPendingFire;
var(SFXGameModeBase) const bool bHasMouseAuthority;
var(SFXGameModeBase) bool bMouseVisible;
var(SFXGameModeBase) bool bMergeNotifications;
var(SFXGameModeBase) bool bQueueAndSuppressNotifications;
var(SFXGameModeBase) bool bShowReticles;
var(SFXGameModeBase) bool bPlayVocalizations;
var(SFXGameModeBase) bool bEnforce16x9Subtitles;
var(SFXGameModeBase) bool bAllowMessageUI;
var(SFXGameModeBase) bool bRestrictToPrimaryViewport;
var(SFXGameModeBase) const bool bNuiSpeechGlobal;
var(SFXGameModeBase) const bool bNuiSpeechExplore;
var(SFXGameModeBase) const bool bNuiSpeechCombat;
var(SFXGameModeBase) const bool bAllowPowerWeaponUI;
var(SFXGameModeBase) EGameModePriority2 Priority;

public function Activated()
{
    local SFXWeapon PlayerWeapon;
    
    bIsActive = TRUE;
    if (!bAllowMovement)
    {
        Outer.IgnoreMoveInput(TRUE);
    }
    if (!bAllowRotationUpdate)
    {
        Outer.IgnoreLookInput(TRUE);
    }
    if (bStopMovement && Outer.Pawn != None)
    {
        BioPawn(Outer.Pawn).StopMovement();
    }
    if (bClearPendingFire)
    {
        if (Outer.Pawn.InvManager != None)
        {
            PlayerWeapon = SFXWeapon(Outer.Pawn.Weapon);
            if (PlayerWeapon != None && Outer.Pawn.InvManager.IsPendingFire(PlayerWeapon, int(PlayerWeapon.DefaultFireMode)))
            {
                PlayerWeapon.StopFire(PlayerWeapon.DefaultFireMode);
            }
            Outer.Pawn.InvManager.ClearAllPendingFire(Outer.Pawn.Weapon);
        }
    }
}
public final function ClearTimer(optional Name inTimerFunc = 'Timer', optional Object inObj)
{
    Outer.ClearTimer(inTimerFunc, inObj != None ? inObj : Self);
}
public native function CollectBindings();

public function Deactivated()
{
    bIsActive = FALSE;
    if (!bAllowMovement)
    {
        Outer.IgnoreMoveInput(FALSE);
    }
    if (!bAllowRotationUpdate)
    {
        Outer.IgnoreLookInput(FALSE);
    }
}
public exec function FireWeapon()
{
    if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    Outer.bFire = 1;
}
public event function SFXCameraMode HACK_GetCameraMode();

public event function HidePauseMenu()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (Outer.GameModeManager2.IsActive(9) && oGUI.GetBrowserHandler(Outer) != None)
    {
        oGUI.HideBrowserWheel(None, Outer);
    }
}
public event function Initialize()
{
    CollectBindings();
}
public final function SetTimer(float InRate, optional bool inbLoop, optional Name inTimerFunc = 'Timer', optional Object inObj)
{
    Outer.SetTimer(InRate, inbLoop, inTimerFunc, inObj != None ? inObj : Self);
}
public event function ShowPauseMenu()
{
    ShowMenu();
}
public exec function ShowMenu()
{
    if (bAllowPauseMenu)
    {
        Outer.bWantsToStorm = 0;
        if (Outer.WorldInfo.GRI.IsMultiplayerGame())
        {
            Class'SFXGUIInteraction'.static.GetInstance().ShowMPPauseMenu(Outer, TRUE);
        }
        else
        {
            Class'SFXGUIInteraction'.static.GetInstance().ShowBrowserWheel(Outer);
        }
    }
}
public function ActivateSpecifier(Name ModeSpecifier);

public function DeactivateSpecifier(Name ModeSpecifier);

public exec function EnterCommandMenu()
{
    if (!bAllowPowerWeaponUI)
    {
        return;
    }
    if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    Outer.GameModeManager2.EnableMode(5);
}
public exec function EnterPowerWheel()
{
    if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    if (!bAllowPowerWeaponUI)
    {
        return;
    }
    if (Outer.WorldInfo.GRI.IsMultiplayerGame())
    {
        SFXPlayerController(Outer).PulsePowerDisplay();
    }
    else
    {
        Outer.GameModeManager2.EnableMode(3);
    }
}
public exec function EnterWeaponWheel()
{
    if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled() == FALSE)
    {
        return;
    }
    if (!bAllowPowerWeaponUI)
    {
        return;
    }
    if (Outer.WorldInfo.GRI.IsMultiplayerGame())
    {
        return;
    }
    Outer.GameModeManager2.EnableMode(4);
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return OldCameraMode;
}
public exec function GuiKey(BioGuiEvents Event)
{
    Class'SFXGUIInteraction'.static.GetInstance().HandleInputEvent(Outer.GetPlayerControllerId(), Event);
}
public exec function HoldObjectiveDisplay()
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_Markers oObjectiveMarkers;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oObjectiveMarkers = oGUI.CastGetMovie(Class'SFXGUI_Markers', Outer, oGUI.MovieTag_Markers);
        if (oObjectiveMarkers != None)
        {
            oObjectiveMarkers.BeginOnDemandPulse();
            oObjectiveMarkers.DisplayObjectiveText();
            SetTimer(0.5, TRUE, 'BeginOnDemandPulse', oObjectiveMarkers);
            SetTimer(0.5, TRUE, 'DisplayObjectiveText', oObjectiveMarkers);
        }
    }
}
public exec function LeaveWorld()
{
    local SFXGRI GRI;
    local Sequence GameSeq;
    local array<SequenceObject> AllLeaveEvents;
    local SequenceObject Event;
    
    GRI = SFXGRI(Outer.WorldInfo.GRI);
    if (GRI != None && GRI.InCombat() == FALSE)
    {
        GameSeq = Outer.WorldInfo.GetGameSequence();
        if (GameSeq != None)
        {
            GameSeq.FindSeqObjectsByClass(Class'SFXSeqEvt_LeaveWorld', TRUE, AllLeaveEvents);
            foreach AllLeaveEvents(Event, )
            {
                SequenceEvent(Event).CheckActivate(Outer.Pawn, Outer.Pawn);
            }
        }
    }
}
public function PauseTimeDilationEffects()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGame Game;
    
    if (Outer.Pawn != None)
    {
        Manager = Outer.Pawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.PauseEffectsByType(Class'SFXGameEffect_TimeDilation');
        }
    }
    if (Outer.WorldInfo != None)
    {
        Game = SFXGame(Outer.WorldInfo.Game);
        if (Game != None)
        {
            Game.OnTimeDilationChange(1.0);
        }
    }
}
public exec function PulseObjectiveDisplay()
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_Markers oObjectiveMarkers;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oObjectiveMarkers = oGUI.CastGetMovie(Class'SFXGUI_Markers', Outer, oGUI.MovieTag_Markers);
        if (oObjectiveMarkers != None)
        {
            Outer.GenerateTutorialEvent(18);
            oObjectiveMarkers.BeginOnDemandPulse();
            oObjectiveMarkers.DisplayObjectiveText();
        }
    }
}
public exec function PulseRadarDisplay(float fPulseTime)
{
    local SFXGUIInteraction oGUI;
    local SFXSFHandler_PowerWheel oPowerWheel;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oPowerWheel = oGUI.CastGetMovie(Class'SFXSFHandler_PowerWheel', Outer, oGUI.MovieTag_PowerWheel);
        if (oPowerWheel != None)
        {
            oPowerWheel.PulseRadar(fPulseTime);
        }
    }
}
public function RemoveTimeDilationEffects()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGame Game;
    
    if (Outer.Pawn != None)
    {
        Manager = Outer.Pawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.RemoveEffectsByType(Class'SFXGameEffect_TimeDilation');
        }
    }
    if (Outer.WorldInfo != None)
    {
        Game = SFXGame(Outer.WorldInfo.Game);
        if (Game != None)
        {
            Game.OnTimeDilationChange(1.0);
        }
    }
}
public exec function bool ShowAreaMap()
{
    local SFXGUIInteraction oManager;
    local SFXSFHandler_AreaMap oHandler;
    local bool bGotMap;
    local BioPawn BP;
    
    BP = BioPawn(Outer.Pawn);
    oManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (oManager != None)
    {
        oManager.ShowAreaMap(Outer);
        oHandler = oManager.GetAreaMapHandler(BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController());
        if (oHandler != None)
        {
            bGotMap = oHandler.Initialize(FALSE);
        }
    }
    if (!bGotMap)
    {
        if (BP.CoverAction != ECoverAction.CA_PeekLeft && BP.CoverAction != ECoverAction.CA_PeekRight)
        {
            PulseObjectiveDisplay();
        }
    }
    else
    {
        ClearTimer('TurnObjectiveRadarDisplayOn', Self);
    }
    return bGotMap;
}
public final exec function SquadCommand_Attack()
{
    local bool bCanUseHenchmen;
    local bool bSuccess;
    
    bCanUseHenchmen = SFXGRI(Outer.WorldInfo.GRI).bCanSpawnHenchmen;
    bSuccess = FALSE;
    if (bCanUseHenchmen)
    {
        if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled())
        {
            bSuccess = Outer.QuickCommandAttackTarget();
        }
        Class'SFXGUIInteraction'.static.GetInstance().ForceSquadCommandFeedback(1, 0, bSuccess, Outer);
    }
}
public final exec function SquadCommand_Follow()
{
    local bool bCanUseHenchmen;
    local bool bSuccess;
    
    bCanUseHenchmen = SFXGRI(Outer.WorldInfo.GRI).bCanSpawnHenchmen;
    bSuccess = FALSE;
    if (bCanUseHenchmen)
    {
        if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled())
        {
            bSuccess = Outer.QuickCommandFollowPlayer();
        }
        Class'SFXGUIInteraction'.static.GetInstance().ForceSquadCommandFeedback(3, 0, bSuccess, Outer);
    }
}
public final exec function SquadCommand_Move1()
{
    local bool bCanUseHenchmen;
    local bool bSuccess;
    
    bCanUseHenchmen = SFXGRI(Outer.WorldInfo.GRI).bCanSpawnHenchmen;
    bSuccess = FALSE;
    if (bCanUseHenchmen)
    {
        if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled())
        {
            bSuccess = Outer.QuickCommandMoveTo(1);
        }
        Class'SFXGUIInteraction'.static.GetInstance().ForceSquadCommandFeedback(2, 1, bSuccess, Outer);
    }
}
public final exec function SquadCommand_Move2()
{
    local bool bCanUseHenchmen;
    local bool bSuccess;
    
    bCanUseHenchmen = SFXGRI(Outer.WorldInfo.GRI).bCanSpawnHenchmen;
    bSuccess = FALSE;
    if (bCanUseHenchmen)
    {
        if (BioPlayerInput(Outer.PlayerInput).IsCombatEnabled())
        {
            bSuccess = Outer.QuickCommandMoveTo(2);
        }
        Class'SFXGUIInteraction'.static.GetInstance().ForceSquadCommandFeedback(2, 2, bSuccess, Outer);
    }
}
public exec function StartIngamePropertyEditor()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (Class'Engine'.static.IsShip() || Class'SFXEngine'.static.IsDemoMode())
    {
        return;
    }
    if (Outer.GameModeManager2.IsActive(9) && oGUI.GetBrowserHandler(Outer) != None || Outer.GameModeManager2.IsActive(7) && oGUI.GetConversationHandler(Outer) != None)
    {
        if (Outer.GameModeManager2.IsActive(9))
        {
            oGUI.HideBrowserWheel(None, Outer);
        }
        Outer.GameModeManager2.EnableMode(14);
    }
}
public exec function StopFiringWeapon()
{
    Outer.bFire = 0;
}
public exec function StopObjectiveDisplay()
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_Markers oObjectiveMarkers;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oObjectiveMarkers = oGUI.CastGetMovie(Class'SFXGUI_Markers', Outer, oGUI.MovieTag_Markers);
        if (oObjectiveMarkers != None)
        {
            if (Outer.IsTimerActive('BeginOnDemandPulse', oObjectiveMarkers))
            {
                ClearTimer('BeginOnDemandPulse', oObjectiveMarkers);
                oObjectiveMarkers.FadeOutMarkers();
            }
            if (Outer.IsTimerActive('DisplayObjectiveText', oObjectiveMarkers))
            {
                ClearTimer('DisplayObjectiveText', oObjectiveMarkers);
                oObjectiveMarkers.HideObjectiveText();
            }
        }
    }
}
public exec function ToggleObjectiveRadarDisplay(bool bTurnOn)
{
    local SFXGUIInteraction oGUI;
    local SFXSFHandler_PowerWheel oPowerWheel;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oPowerWheel = oGUI.CastGetMovie(Class'SFXSFHandler_PowerWheel', Outer, oGUI.MovieTag_PowerWheel);
        if (oPowerWheel != None)
        {
            oPowerWheel.m_bObjectiveRadarOn = bTurnOn;
        }
    }
}
public exec function TurnObjectiveRadarDisplayOff()
{
    ToggleObjectiveRadarDisplay(FALSE);
}
public exec function TurnObjectiveRadarDisplayOn()
{
    ToggleObjectiveRadarDisplay(TRUE);
}
public function UnpauseTimeDilationEffects()
{
    local SFXModule_GameEffectManager Manager;
    
    if (Outer.Pawn != None)
    {
        Manager = Outer.Pawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.UnpauseEffectsByType(Class'SFXGameEffect_TimeDilation');
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Bindings = ({
                 Command = "SwapWeaponIfEmpty | FireWeapon | OnRelease StopFiringWeapon", 
                 Name = 'Shared_Shoot', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SwapWeaponIfEmpty | TightAim | OnRelease StopTightAim", 
                 Name = 'Shared_Aim', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Exclusive TryStandingJump | Exclusive Used | OnRelease StormOff | OnHold 0.2 StormOn | Exclusive PressAction | OnTap 0.3 TapAction | OnHold 0.3 HoldAction", 
                 Name = 'Shared_Action', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "TryHolster", 
                 Name = 'Shared_Holster', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "OnTap 0.3 TryMelee | LeaveWorld | OnHold 0.3 TryHeavyMelee", 
                 Name = 'Shared_Melee', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SquadCommand_Attack", 
                 Name = 'Shared_SquadAttack', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SquadCommand_Follow", 
                 Name = 'Shared_SquadFollow', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SquadCommand_Move1", 
                 Name = 'Shared_SquadMove1', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SquadCommand_Move2", 
                 Name = 'Shared_SquadMove2', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ShowMenu", 
                 Name = 'Shared_Menu', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SelectResponse", 
                 Name = 'Shared_ConvSelect', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SkipConversation", 
                 Name = 'Shared_ConvSkip', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "InterruptRenegade", 
                 Name = 'Shared_ConvIntRenegade', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "InterruptParagon", 
                 Name = 'Shared_ConvIntParagon', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SkipCinematic", 
                 Name = 'Shared_CineSkip', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SkipMovie", 
                 Name = 'Shared_MovieSkip', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "StartScanning | OnRelease StopScanning", 
                 Name = 'Shared_GalaxyScan', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ScanSystem", 
                 Name = 'Shared_GalaxySystemScan', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "LaunchProbe", 
                 Name = 'Shared_GalaxyProbe', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PulseRadarDisplay 1.0", 
                 Name = 'Shared_PulseRadarDisplay', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PulseObjectiveDisplay", 
                 Name = 'Shared_PulseObjectiveDisplay', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "TabRight", 
                 Name = 'Shared_GalaxyTabRight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "TabLeft", 
                 Name = 'Shared_GalaxyTabLeft', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ActivatePOI | OnRelease DeactivatePOI", 
                 Name = 'Shared_POI', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ExitAtlas", 
                 Name = 'Shared_ExitAtlas', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ExitVehicle", 
                 Name = 'Shared_ExitMountedGun', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SlideshowAdvance true", 
                 Name = 'Shared_AdvanceSlideshowForward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SlideshowAdvance false", 
                 Name = 'Shared_AdvanceSlideshowBackward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SlideshowExit", 
                 Name = 'Shared_ExitSlideshow', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "TryCoverTurn", 
                 Name = 'Shared_CoverTurn', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "LeaveWorld", 
                 Name = 'Vehicle_Quit', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Toggle bAlternateCamera", 
                 Name = 'Vehicle_Camera', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "CastPower 0", 
                 Name = 'Shared_CastPower0', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "CastPower 1", 
                 Name = 'Shared_CastPower1', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "QuickSave", 
                 Name = 'Shared_QuickSave', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Exclusive ActivatePOI | OnRelease DeactivatePOI | OnTap 0.2 ShowAreaMap | OnHold 0.2 HoldObjectiveDisplay | OnRelease StopObjectiveDisplay ", 
                 Name = 'Shared_ShowMap', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "HideAreaMap", 
                 Name = 'Shared_HideMap', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "MPToggleReady", 
                 Name = 'Shared_MPToggleReady', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aStrafe Speed=-1.0", 
                 Name = 'PC_StrafeLeft', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aStrafe Speed=+1.0", 
                 Name = 'PC_StrafeRight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aBaseY Speed=1.0", 
                 Name = 'PC_MoveForward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aBaseY Speed=-1.0", 
                 Name = 'PC_MoveBackward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Count bXAxis | Axis aMouseX", 
                 Name = 'PC_LookX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Count bYAxis | Axis aMouseY", 
                 Name = 'PC_LookY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "EnterCommandMenu", 
                 Name = 'PC_EnterCommandMenu', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "OnRelease ExitCommandMenu", 
                 Name = 'PC_ExitCommandMenu', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "EnableCamera | OnRelease DisableCamera", 
                 Name = 'PC_CommandToggleCam', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "NextWeapon", 
                 Name = 'PC_NextWeapon', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PrevWeapon", 
                 Name = 'PC_PrevWeapon', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "TrySwapWeapon", 
                 Name = 'PC_SwapWeapon', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "SwapWeaponIfEmpty | TryReload", 
                 Name = 'PC_Reload', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "HighlightDefaultResponse", 
                 Name = 'PC_ConvHilight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 0", 
                 Name = 'PC_HotKey1', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 1", 
                 Name = 'PC_HotKey2', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 2", 
                 Name = 'PC_HotKey3', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 3", 
                 Name = 'PC_HotKey4', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 4", 
                 Name = 'PC_HotKey5', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 5", 
                 Name = 'PC_HotKey6', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 6", 
                 Name = 'PC_HotKey7', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "UseAbility 7", 
                 Name = 'PC_HotKey8', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "QuickLoad", 
                 Name = 'PC_QuickLoad', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aMouseX BIOGUI_EVENT_AXIS_MOUSE_X", 
                 Name = 'PC_GalaxyMouseStrafe', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aMouseY BIOGUI_EVENT_AXIS_MOUSE_Y", 
                 Name = 'PC_GalaxyMouseMovement', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aGuiStrafe Speed=-1.0 EventID=2", 
                 Name = 'PC_GalaxyKeyStrafeLeft', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aGuiStrafe Speed=+1.0 EventID=2", 
                 Name = 'PC_GalaxyKeyStrafeRight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aGuiBaseY Speed=+1.0 EventID=3", 
                 Name = 'PC_GalaxyKeyMoveForward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Axis aGuiBaseY Speed=-1 EventID=3", 
                 Name = 'PC_GalaxyKeyMoveBackward', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Repeat PlanetLeftRight 0.5", 
                 Name = 'PC_GalaxyKeyRotateLeft', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Repeat PlanetLeftRight -0.5", 
                 Name = 'PC_GalaxyKeyRotateRight', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "EnableWalking | OnRelease DisableWalking", 
                 Name = 'Walking', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "VoicePushToTalkStart | OnRelease VoicePushToTalkEnd", 
                 Name = 'PC_PushToTalk', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "BioTalk", 
                 Name = 'PC_Talk', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Quit", 
                 Name = 'F4', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = TRUE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    RadarMapDisplayTime = 1.0
    bShowExploreSelection = TRUE
    bShowHealth = TRUE
    bShowWeapon = TRUE
}
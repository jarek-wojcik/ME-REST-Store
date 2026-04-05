Class BioSFHandler_GalaxyMap extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

struct native SFXUIControlState 
{
    var stringref Text;
    var bool Disabled;
    var ESFXGalaxyMapUIAction Action;
};
enum ESFXGalaxyMapUIAction
{
    GalaxyAction_None,
    GalaxyAction_Exit,
    GalaxyAction_LeavePlanet,
    GalaxyAction_EnterPlanetScan,
    GalaxyAction_LeavePlanetScan,
    GalaxyAction_SystemObjectAction,
    GalaxyAction_PlanetAction,
    GalaxyAction_MassRelayJump,
    GalaxyAction_BuyFuel,
    GalaxyAction_ClusterSelect,
    GalaxyAction_SystemSelect,
    GalaxyAction_MultiLandLand,
};
const PLANETTAG_DISPLAY_GREEN = 1;
const PLANETTAG_DISPLAY_BLUE = 0;

var delegate<OnCallbackEvent> aUIActionCallbacks[12];
var transient string m_sDisplayedFuel;
var transient string m_sDisplayedCash;
var delegate<OnCallbackEvent> __OnCallbackEvent__Delegate;
var SFXUIControlState aActions[12];
var transient SFXUIControlState BackControlState;
var transient SFXUIControlState ActionControlState;
var transient SFXUIControlState AltActionControlState;
var transient SFXUIControlState AltAction2ControlState;
var float m_fScrollValue;
var transient float m_fLeftStickX;
var transient float m_fLeftStickY;
var transient stringref AButtonText;
var transient stringref BButtonText;
var transient stringref XButtonText;
var transient stringref YButtonText;
var transient stringref TitleText;
var transient int m_nDiscoveredPercent;
var transient stringref LTriggerText;
var transient stringref RTriggerText;
var config transient stringref TextTravelMessage;
var config transient stringref TextTravelConfirm;
var config transient stringref TextTravelCancel;
var config transient stringref TextPlanetEventConfirm;
var config transient stringref TextGalaxyTitle;
var config transient stringref TextUnknownObj;
var config transient stringref TextRefueling;
var config transient stringref TextTravel;
var config transient stringref TextLand;
var config transient stringref TextBack;
var config transient stringref TextExit;
var config transient stringref TextScan;
var config transient stringref TextScanStart;
var config transient stringref TextScanClose;
var config transient stringref TextMassRelayJump;
var config transient stringref TextMassRelay;
var config transient stringref TextOrbit;
var config transient stringref TextFuelDepot;
var config transient stringref TextFuel;
var config transient stringref TextProbes;
var config transient stringref TextEmergencyFuel;
var config transient stringref TextLaunchProbe;
var config transient stringref TextCancel;
var config transient stringref TextExploredPercent;
var config transient stringref DescriptionTabText;
var config transient stringref MissionTabText;
var config transient stringref FuelDisplayTextTemplate;
var config transient float FuelAwardDisplayTime;
var transient float m_fRemainingFuelAwardTime;
var transient float m_fFuelAwardStartValue;
var transient float m_fFuelAwardEndValue;
var transient BioCameraBehaviorGalaxy oGalaxyCam;
var transient bool m_bClosingPlanet;
var transient bool m_bClosingScan;
var transient bool m_bWaitingForMsgBox;
var transient bool AButtonEnabled;
var transient bool BButtonEnabled;
var transient bool XButtonEnabled;
var transient bool YButtonEnabled;
var transient bool bLTriggerOn;
var transient bool bRTriggerOn;
var transient bool m_bIsMultiLand;
var transient bool bForceControlUpdate;
var transient bool m_bDisplayingFuelAwardAnim;
var transient bool m_bInitialized;
var bool m_bFullCleanupOnClose;

public final event function AS_DisplayStageFrame(bool bDisplay)
{
    ActionScriptVoid("Main.DisplayStageFrame");
}
public final event function AS_EnterPlanetScan(const string sCallback)
{
    ActionScriptVoid("Main.EnterPlanetScan");
}
public final event function AS_HideAllPlanetTags()
{
    ActionScriptVoid("Main.PlanetTagHolder.HideAllPlanetTags");
}
public final event function AS_HidePlanetPanel()
{
    ActionScriptVoid("Main.HidePlanetPanel");
}
public final event function AS_HidePlanetTag(int nIndex)
{
    ActionScriptVoid("Main.PlanetTagHolder.HidePlanetTag");
}
public final event function AS_HideSystemScan()
{
    ActionScriptVoid("Main.HideSystemScan");
}
public final event function AS_LeavePlanetScan(const string sCallback)
{
    ActionScriptVoid("Main.LeavePlanetScan");
}
public final event function AS_SetActionButton(const string sTitle, const string sCallbackFn, bool bEnabled)
{
    ActionScriptVoid("Main.SetActionButton");
}
public final event function AS_SetAltAction2Button(const string sTitle, const string sCallbackFn, bool bEnabled)
{
    ActionScriptVoid("Main.SetAltAction2Button");
}
public final event function AS_SetAltActionButton(const string sTitle, const string sCallbackFn, bool bEnabled)
{
    ActionScriptVoid("Main.SetAltActionButton");
}
public final event function AS_SetBackButton(const string sTitle, const string sCallbackFn, bool bEnabled)
{
    ActionScriptVoid("Main.SetBackButton");
}
public final event function AS_SetPlanetTagSelection(int nIndex)
{
    ActionScriptVoid("Main.PlanetTagHolder.SetPlanetTagSelection");
}
public final event function AS_SetReaperAlert(float fAlertLevel)
{
    ActionScriptVoid("Main.SetReaperAlert");
}
public final event function AS_ShowPlanetTag(int nIndex)
{
    ActionScriptVoid("Main.PlanetTagHolder.ShowPlanetTag");
}
public final event function AS_ShowSystemScan(const string sText)
{
    ActionScriptVoid("Main.ShowSystemScan");
}
public final event function AS_SystemScanUsed()
{
    ActionScriptVoid("Main.SystemScanUsed");
}
public final event function AS_UpdateFuelRemaining(const string sFuel, const string sCash)
{
    if (!m_bInitialized)
    {
        return;
    }
    ActionScriptVoid("Main.UpdateFuelRemaining");
}
public final event function AS_UpdateSystemSelectors(int nStartIndex, array<Vector2D> aLocations)
{
    ActionScriptVoid("Main.PlanetTagHolder.UpdateSystemSelectors");
}
public event function BuyFuel();

public final event function DisplayPlanetPanel(BioPlanet oPlanet, bool bStartOnMission)
{
    local string sDisplayName;
    local string sText;
    local string sTabTitle;
    local string sImageResource;
    local Texture2D oImage;
    
    if (oPlanet != None)
    {
        sDisplayName = oPlanet.GetPlanetTitleText();
        sText = bStartOnMission ? oPlanet.GetPlanetMissionText() : oPlanet.GetPlanetDescriptionText();
        sTabTitle = UIStrRef(bStartOnMission ? MissionTabText : DescriptionTabText);
        oImage = oPlanet.GetPlanetViewImage();
        sImageResource = oImage != None ? PathName(oImage) : "";
    }
    PlayGuiSound('GalaxyMapDisplayPlanetInfo');
    SetMouseShown(TRUE);
    AS_DisplayPlanetPanel(sDisplayName, sText, sImageResource, sTabTitle);
}
public event function bool HandleInputEvent(BioGuiEvents nEvent, optional float fValue = 1.0)
{
    local SFXGameModeManager Manager;
    local SFXGUIInteraction GuiMan;
    local BioPlayerController PC;
    local SFXGameModeOrbital OrbitalGame;
    local SFXGameModeMultiLand MultiLand;
    local bool bInOrbital;
    local bool bInMultiland;
    
    GuiMan = oPanel.oParentManager;
    if (GuiMan != None)
    {
        PC = BioPlayerController(GetPC());
    }
    if (PC != None)
    {
        Manager = PC.GameModeManager2;
    }
    if (Manager != None)
    {
        OrbitalGame = SFXGameModeOrbital(Manager.HACK_GetOrbitalMode());
        MultiLand = SFXGameModeMultiLand(Manager.HACK_GetMultiLandMode());
        bInOrbital = OrbitalGame != None && OrbitalGame.bIsActive ? TRUE : FALSE;
        bInMultiland = OrbitalGame != None && MultiLand.bIsActive ? TRUE : FALSE;
    }
    switch (nEvent)
    {
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_A_RELEASE:
            if (bInMultiland)
            {
                if (MultiLand.TestLandingCondition())
                {
                    MultiLand.AttemptLand();
                }
                else
                {
                    PlayGuiError();
                }
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_X:
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            if (bInOrbital)
            {
                OrbitalGame.RingReticleLeftRight(fValue);
            }
            else if (bInMultiland)
            {
                MultiLand.RingReticleLeftRight(fValue);
            }
            m_fLeftStickX = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            if (bInOrbital)
            {
                OrbitalGame.RingReticleUpDown(fValue);
            }
            else if (bInMultiland)
            {
                MultiLand.RingReticleUpDown(fValue);
            }
            m_fLeftStickY = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_X:
            if (bInOrbital)
            {
                OrbitalGame.PlanetLeftRight(fValue);
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            m_fScrollValue = fValue;
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(nEvent, fValue);
    }
    return TRUE;
}
public final event function HidePlanetPanel()
{
    AS_HidePlanetPanel();
}
public final event function Initialize()
{
    local bool bShowFuel;
    local float fReaperAlertLevel;
    
    m_bInitialized = TRUE;
    oGalaxyCam.m_bPaused = FALSE;
    bForceControlUpdate = TRUE;
    bShowFuel = FALSE;
    fReaperAlertLevel = 0.0;
    switch (oGalaxyCam.m_nCurrentState)
    {
        case 4:
            if (oGalaxyCam.m_pCameraObject != None)
            {
                oGalaxyCam.m_vLastCameraLocation = oGalaxyCam.m_pCameraObject.location;
            }
            oGalaxyCam.m_bRefreshPlanetUsable = TRUE;
            break;
        case 2:
            bShowFuel = TRUE;
            break;
        case 3:
            bShowFuel = TRUE;
            if (oGalaxyCam.m_pCurrentSystem != None)
            {
                fReaperAlertLevel = oGalaxyCam.m_pCurrentSystem.m_fReaperAlertLevel;
            }
        case 1:
            SetTitleStrings(TextGalaxyTitle, 0);
            break;
        default:
    }
    AS_SetReaperAlert(fReaperAlertLevel);
    if (bShowFuel)
    {
        oGalaxyCam.UpdateFuelAndCashDisplay();
    }
    else
    {
        AS_UpdateFuelRemaining("", "");
    }
    oGalaxyCam.UpdateUITitle();
    oGalaxyCam.m_bRebuildPlanetRingCache = TRUE;
    oGalaxyCam.BuildSelectors();
    oGalaxyCam.UpdateSelectorPositions();
}
public final event function InitializePlanetTags(int nNumTags)
{
    AS_InitializePlanetTags(nNumTags);
}
public delegate function OnCallbackEvent();

public event function OnStart()
{
    m_bInitialized = FALSE;
    bForceControlUpdate = TRUE;
    oGalaxyCam = BioCameraBehaviorGalaxy(BioPlayerController(GetPC()).GameModeManager2.HACK_GetCameraMode(11));
    oGalaxyCam.TriggerEvent('OpenMap');
}
public final event function SelectGalaxyItem()
{
    local BioPlayerController oPC;
    local bool bSelectedObjectWantsTick;
    local SFXGameModeMultiLand MultiLand;
    
    oPC = BioPlayerController(GetPC());
    if (m_bWaitingForMsgBox || oGalaxyCam.m_fZoomTime > 0.0 || !oPC.GameModeManager2.HACK_CanExitGalaxyMode())
    {
        PlayGuiError();
        return;
    }
    if (oGalaxyCam.m_nCurrentState != 4 && oGalaxyCam.m_pSelectedObject == None)
    {
        PlayGuiError();
        return;
    }
    else if (oGalaxyCam.m_pSelectedObject != None)
    {
        bSelectedObjectWantsTick = oGalaxyCam.m_pSelectedObject.bStatic == FALSE && oGalaxyCam.m_pSelectedObject.bTickIsDisabled == FALSE;
        if (!bSelectedObjectWantsTick || oGalaxyCam.m_pSelectedObject.bHidden)
        {
            PlayGuiError();
            return;
        }
    }
    if (oGalaxyCam.ValidLevelTransition(TRUE))
    {
        if (oGalaxyCam.ExecuteTravel())
        {
            TravelPrompt();
        }
        return;
    }
    MultiLand = SFXGameModeMultiLand(BioPlayerController(GetPC()).GameModeManager2.HACK_GetMultiLandMode());
    if (MultiLand == None || !MultiLand.bIsActive || MultiLand.bCanLand)
    {
        if (oGalaxyCam.m_nCurrentState != 4 || !oGalaxyCam.HandleSelectPlanet())
        {
            PlayGuiError();
            return;
        }
    }
    else if (MultiLand != None)
    {
        PlayGuiError();
        return;
    }
    CloseUI();
}
public final event function SetSelectorState(int nIndex, bool bVisible, int nType, int nDisplay, int nPctVisited, stringref srName, const out string sText)
{
    local string sName;
    
    sName = UIStrRef(srName);
    AS_SetSelectorState(nIndex, bVisible, nType, nDisplay, nPctVisited, sName, sText);
}
public final event function SetTitleStrings(stringref srTitle, int nPercentDiscovered)
{
    local string sTitle;
    local string sDisplayText;
    
    if (srTitle == TitleText && m_nDiscoveredPercent == nPercentDiscovered)
    {
        return;
    }
    TitleText = srTitle;
    m_nDiscoveredPercent = nPercentDiscovered;
    if (nPercentDiscovered >= 0)
    {
        SetCustomToken(0, string(nPercentDiscovered));
        sDisplayText = GetUIString(TextExploredPercent, TRUE);
        ClearCustomTokens();
    }
    sTitle = UIStrRef(srTitle);
    AS_SetTitleStrings(sTitle, sDisplayText);
}
public final event function TravelPrompt()
{
    local BioSFHandler_MessageBox mb;
    local BioMessageBoxOptionalParams mbParams;
    
    mb = GetSFXUIController().CreateMessageBox(GetPC());
    if (mb == None)
    {
        return;
    }
    mbParams.srAText = TextTravelConfirm;
    mbParams.srBText = TextTravelCancel;
    mbParams.bNoFade = TRUE;
    mb.SetInputDelegate(TravelConfirm);
    mb.DisplayMessageBox(TextTravelMessage, mbParams);
    m_bWaitingForMsgBox = TRUE;
}
public event function Update(float fDeltaT)
{
    Super.Update(fDeltaT);
    if (m_bDisplayingFuelAwardAnim)
    {
        UpdateFuelAward(fDeltaT);
    }
}
public final function UpdateFuelAndCashDisplay(float fCurrentFuel, float fMaxFuel, int nCredits, bool bDisplayCredits)
{
    local string sFuel;
    local string sCash;
    
    SetCustomToken(0, Class'BioDefine'.static.PrettyFloat(fCurrentFuel, 0));
    SetCustomToken(1, Class'BioDefine'.static.PrettyFloat(fMaxFuel, 0));
    sFuel = GetUIString(FuelDisplayTextTemplate, TRUE);
    ClearCustomTokens();
    if (bDisplayCredits)
    {
        sCash = string(nCredits);
    }
    SetFuelAndCashDisplay(sFuel, sCash);
}
public event function OnClose()
{
    local BioPlayerController oPC;
    
    oPC = BioPlayerController(GetPC());
    if (oPC.GameModeManager2.IsActive(12))
    {
        oPC.GameModeManager2.DisableMode(12);
    }
    if (oPC.GameModeManager2.IsActive(13))
    {
        oPC.GameModeManager2.DisableMode(13);
    }
    if (m_bFullCleanupOnClose)
    {
        oPC.GameModeManager2.DisableMode(11);
        oGalaxyCam.TriggerEvent('CloseMap');
        oGalaxyCam.Cleanup();
        oWorldInfo.PauseGame(FALSE);
    }
    oGalaxyCam = None;
}
public final function AS_ClearControls()
{
    ActionScriptVoid("Main.ClearControls");
}
public final function AS_DisplayPlanetPanel(const string sDisplayName, const string sDescription, const string sImageResource, const string sInfoHeader)
{
    ActionScriptVoid("Main.DisplayPlanetPanel");
}
public final function AS_InitializePlanetTags(int nNumTags)
{
    ActionScriptVoid("Main.PlanetTagHolder.InitializePlanetTags");
}
public final function AS_SetLTriggerLabelVisible(bool bVisible, const string sText)
{
    ActionScriptVoid("Main.SetLTLabelVisible");
}
public final function AS_SetRTriggerLabelVisible(bool bVisible, const string sText)
{
    ActionScriptVoid("Main.SetRTLabelVisible");
}
public final function AS_SetSelectorState(int nIndex, bool bVisible, int nPlanetType, int nPlanetDisplay, int nPctVisited, const string sName, const string sText)
{
    ActionScriptVoid("Main.PlanetTagHolder.SetSelectorState");
}
public final function AS_SetTitleStrings(const string sTitle, const string sDisplayName)
{
    ActionScriptVoid("Main.InitializeGalaxyMap");
}
public final function CloseScan()
{
    local BioPlayerController oPC;
    
    oPC = BioPlayerController(GetPC());
    if (oGalaxyCam.ValidLevelTransition(FALSE))
    {
        PlayGuiSound('GalaxyMapTransitionUpScannerPlanet');
        if (oPC.GameModeManager2.IsActive(12))
        {
            oPC.GameModeManager2.HACK_BeginExitGalaxyMap(TRUE);
        }
        oGalaxyCam.m_bTransitionDown = FALSE;
        oGalaxyCam.SetMapLevel(FALSE);
        if (m_bClosingPlanet)
        {
            oGalaxyCam.ZoomCamera(FALSE, TRUE, TRUE);
        }
        else if (m_bClosingScan)
        {
            oGalaxyCam.ZoomCamera(FALSE, FALSE, FALSE);
        }
    }
    m_bClosingPlanet = FALSE;
    m_bClosingScan = FALSE;
}
public final function CloseUI()
{
    local BioPlayerController oPC;
    
    oPC = BioPlayerController(GetPC());
    if (m_bWaitingForMsgBox || oGalaxyCam.m_fZoomTime > 0.0 || !oPC.GameModeManager2.HACK_CanExitGalaxyMode())
    {
        PlayGuiError();
        return;
    }
    switch (oGalaxyCam.m_nCurrentState)
    {
        case 4:
            if (oGalaxyCam.ValidLevelTransition(FALSE))
            {
                if (oPC.GameModeManager2.IsActive(13))
                {
                    oPC.GameModeManager2.DisableMode(13);
                }
                if (!m_bClosingPlanet)
                {
                    AS_HidePlanetPanel();
                    m_bClosingPlanet = TRUE;
                }
            }
            break;
        case 5:
            if (oGalaxyCam.ValidLevelTransition(FALSE))
            {
                if (!m_bClosingScan && oPC.GameModeManager2.HACK_CanExitGalaxyMode())
                {
                    m_bClosingScan = TRUE;
                    AS_LeavePlanetScan("CloseScan");
                }
            }
            break;
        case 1:
            if (oGalaxyCam.ValidLevelTransition(TRUE))
            {
                if (oGalaxyCam.m_pSelectedCluster != None)
                {
                    oGalaxyCam.m_pSelectedObject = oGalaxyCam.m_pSelectedCluster;
                    oGalaxyCam.ZoomCamera(TRUE, TRUE, TRUE);
                }
                else
                {
                    ExitGalaxyMap(FALSE);
                }
            }
            break;
        default:
            ExitGalaxyMap(FALSE);
            break;
    }
}
public final function ExitGalaxyMap(bool bForcedExit)
{
    local BioPlayerController oPC;
    
    oPC = BioPlayerController(GetPC());
    if (oPC == None && oGalaxyCam == None)
    {
        return;
    }
    if (!bForcedExit)
    {
        if (m_bWaitingForMsgBox || oGalaxyCam.m_fZoomTime > 0.0 || !oPC.GameModeManager2.HACK_CanExitGalaxyMode())
        {
            PlayGuiError();
            return;
        }
    }
    switch (oGalaxyCam.m_nCurrentState)
    {
        case 1:
            SaveGalaxyState(byte(oGalaxyCam.m_nCurrentState));
            if (oGalaxyCam.m_pMassRelayObject != None)
            {
                SaveCurrentGalaxyLocation(oGalaxyCam.m_pMassRelayObject.location);
            }
            break;
        case 4:
            Invoke0("closePlanetPanel");
            SaveGalaxyState(byte(oGalaxyCam.m_nCurrentState));
            if (oGalaxyCam.m_pCrossHairObject != None)
            {
                SaveCurrentGalaxyLocation(oGalaxyCam.m_pCrossHairObject.location);
            }
            break;
        case 5:
            AS_LeavePlanetScan("");
            SaveGalaxyState(byte(oGalaxyCam.m_nCurrentState));
            if (oGalaxyCam.m_pCrossHairObject != None)
            {
                SaveCurrentGalaxyLocation(oGalaxyCam.m_pCrossHairObject.location);
            }
            break;
        case 2:
            if (!bForcedExit && oGalaxyCam.GetRemainingFuel() <= 0.0)
            {
                PlayGuiError();
                return;
            }
            SaveGalaxyState(byte(oGalaxyCam.m_nCurrentState));
            if (oGalaxyCam.m_pCrossHairObject != None)
            {
                SaveCurrentGalaxyLocation(oGalaxyCam.m_pCrossHairObject.location);
            }
            break;
        case 3:
            if (!bForcedExit && oGalaxyCam.m_pCurrentSystem != None && oGalaxyCam.m_pCurrentSystem.m_bReapersChasePlayer)
            {
                PlayGuiError();
                return;
            }
        default:
            SaveGalaxyState(byte(oGalaxyCam.m_nCurrentState));
            if (oGalaxyCam.m_pCrossHairObject != None)
            {
                SaveCurrentGalaxyLocation(oGalaxyCam.m_pCrossHairObject.location);
            }
    }
    Close();
}
public final function ExitPlanet()
{
    m_bClosingPlanet = FALSE;
    CloseUI();
    if (oGalaxyCam.ValidLevelTransition(FALSE))
    {
        oGalaxyCam.ZoomCamera(FALSE, TRUE, TRUE);
    }
}
public final function FuelAwarded(float fInitialFuel, float fFuel)
{
    local BioPlayerController oPC;
    local SFXInventoryManager oInventory;
    
    oPC = BioPlayerController(GetPC());
    oInventory = SFXInventoryManager(BioPawn(oPC.Pawn).InvManager);
    if (oInventory == None)
    {
        return;
    }
    m_bDisplayingFuelAwardAnim = TRUE;
    m_fRemainingFuelAwardTime = FuelAwardDisplayTime;
    m_fFuelAwardStartValue = fInitialFuel;
    m_fFuelAwardEndValue = FMin(fInitialFuel + fFuel, oInventory.GetMaxFuel());
}
public final function OnEscapeAction()
{
    CloseUI();
}
public final function PlanetInfoPanelHidden()
{
    m_bDisplayingFuelAwardAnim = FALSE;
    AS_UpdateFuelRemaining("", "");
    bForceControlUpdate = TRUE;
}
public final function PlanetInfoPanelVisible()
{
    local BioPlanet oPlanet;
    
    oPlanet = oGalaxyCam.GetCurrentPlanet();
    if (oPlanet != None)
    {
        oPlanet.OnDisplayPlanetDetails(Self);
    }
    bForceControlUpdate = TRUE;
}
public final function SaveCurrentGalaxyLocation(Vector vLoc)
{
    oWorldInfo.GetGlobalVariables().SetFloatByName('Current_Galaxy_X', vLoc.X);
    oWorldInfo.GetGlobalVariables().SetFloatByName('Current_Galaxy_Y', vLoc.Y);
}
public final function SaveGalaxyState(EBioGalaxyMapState eState)
{
    oWorldInfo.GetGlobalVariables().SetIntByName('Current_Galaxy_State', int(eState));
}
public final function Scan()
{
    if (oGalaxyCam.m_nCurrentState == 4 && oGalaxyCam.m_bPlanetScanable)
    {
        m_bClosingScan = FALSE;
        m_bClosingPlanet = FALSE;
        PlayGuiSound('GalaxyMapTransitionDownPlanetScanner');
        if (oGalaxyCam.ExecuteTravel())
        {
            TravelPrompt();
        }
    }
}
public final function SetFuelAndCashDisplay(const string sFuel, const string sCash)
{
    if (m_sDisplayedFuel != sFuel || m_sDisplayedCash != sCash)
    {
        m_sDisplayedFuel = sFuel;
        m_sDisplayedCash = sCash;
        AS_UpdateFuelRemaining(sFuel, sCash);
    }
}
public final function SetLTriggerLabel(bool bShow, stringref srText)
{
    if (bShow != bLTriggerOn || LTriggerText != srText)
    {
        AS_SetLTriggerLabelVisible(bShow, UIStrRef(srText));
        bLTriggerOn = bShow;
        LTriggerText = srText;
    }
}
public final function SetRTriggerLabel(bool bShow, stringref srText)
{
    if (bShow != bRTriggerOn || RTriggerText != srText)
    {
        AS_SetRTriggerLabelVisible(bShow, UIStrRef(srText));
        bRTriggerOn = bShow;
        RTriggerText = srText;
    }
}
public final function TravelConfirm(bool bAPressed, int nContext)
{
    m_bWaitingForMsgBox = FALSE;
    oGalaxyCam.m_bPaused = FALSE;
    if (bAPressed && nContext == 0)
    {
        oGalaxyCam.m_nExitMap = 0;
        oGalaxyCam.ZoomCamera(TRUE, TRUE, TRUE);
    }
    else
    {
        oGalaxyCam.m_bRefreshPlanetUsable = TRUE;
    }
    SetMouseShown(FALSE);
}
public final function UpdateFuelAward(float fDeltaT)
{
    local float fFuel;
    local float fPctElapsed;
    local BioPlayerController oPC;
    local SFXInventoryManager oInventory;
    
    oPC = BioPlayerController(GetPC());
    oInventory = SFXInventoryManager(BioPawn(oPC.Pawn).InvManager);
    m_fRemainingFuelAwardTime = FMax(0.0, m_fRemainingFuelAwardTime - fDeltaT);
    fPctElapsed = (FuelAwardDisplayTime - m_fRemainingFuelAwardTime) / FuelAwardDisplayTime;
    fFuel = Lerp(m_fFuelAwardStartValue, m_fFuelAwardEndValue, fPctElapsed);
    UpdateFuelAndCashDisplay(fFuel, oInventory.GetMaxFuel(), 0, FALSE);
    if (m_fRemainingFuelAwardTime <= 0.0)
    {
        m_bDisplayingFuelAwardAnim = FALSE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    aUIActionCallbacks[1] = OnEscapeAction
    aUIActionCallbacks[2] = ExitPlanet
    aUIActionCallbacks[3] = Scan
    aUIActionCallbacks[4] = CloseScan
    aUIActionCallbacks[5] = SelectGalaxyItem
    aUIActionCallbacks[6] = SelectGalaxyItem
    aUIActionCallbacks[7] = SelectGalaxyItem
    aUIActionCallbacks[8] = BuyFuel
    aUIActionCallbacks[9] = SelectGalaxyItem
    aUIActionCallbacks[10] = SelectGalaxyItem
    aUIActionCallbacks[11] = SelectGalaxyItem
    TextTravelMessage = $164578
    TextTravelConfirm = $164579
    TextTravelCancel = $164580
    TextPlanetEventConfirm = $173640
    TextGalaxyTitle = $136216
    TextUnknownObj = $137070
    TextRefueling = $306422
    TextTravel = $136218
    TextLand = $136217
    TextBack = $260949
    TextExit = $136915
    TextScan = $136916
    TextScanStart = $337923
    TextScanClose = $338128
    TextMassRelayJump = $260724
    TextMassRelay = $314183
    TextOrbit = $260735
    TextFuelDepot = $335027
    TextFuel = $330462
    TextProbes = $330463
    TextEmergencyFuel = $330733
    TextLaunchProbe = $339485
    TextCancel = $181674
    TextExploredPercent = $724689
    DescriptionTabText = $126260
    MissionTabText = $341315
    FuelDisplayTextTemplate = $727389
    FuelAwardDisplayTime = 2.0
    AButtonEnabled = TRUE
    BButtonEnabled = TRUE
    XButtonEnabled = TRUE
    YButtonEnabled = TRUE
    m_bFullCleanupOnClose = TRUE
    nHandlerID = 7
    m_bUseThumbstickAsDPad = FALSE
}
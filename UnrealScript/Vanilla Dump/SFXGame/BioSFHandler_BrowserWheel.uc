Class BioSFHandler_BrowserWheel extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

struct native BWPageStruct 
{
    var Name Tag;
    var stringref srLabel;
    var SFXGUIMovie oHandler;
    var MEBrowserWheelSubPages Type;
};

var config array<BWPageStruct> lstPages;
var Vector vInput;
var float fLastRadius;
var config stringref srExitConfirm;
var config stringref srMainMenuConfirm;
var config stringref srConfirm;
var config stringref srCancel;
var export SFXPowerLevelUpHelper m_Helper;

public final function AS_SetArrowPosition(int nDegrees)
{
    ActionScriptVoid("setArrowPosition");
}
public final native function DetermineJournalCodexUpdateStatus();

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            vInput.Y = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_Y:
            BioPlayerController(GetPC()).ConsoleCommand("StartIngamePropertyEditor 1");
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public function OnPanelAdded()
{
    Super.OnPanelAdded();
}
public function OnPanelRemoved()
{
    Super.OnPanelRemoved();
    fLastRadius = 0.0;
}
public final event function ShowSelectedPanel(int nPanel, optional SFXGUIInteraction oManager)
{
    local SFXGUIInteraction oGuiMan;
    local SFXGUIMovie oNewPanel;
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    if (oManager == None)
    {
        oGuiMan = oPanel.oParentManager;
    }
    else
    {
        oGuiMan = oManager;
    }
    if (lstPages.Length - 1 >= nPanel)
    {
        switch (lstPages[nPanel].Type)
        {
            case MEBrowserWheelSubPages.MBW_SP_ReturnToMainMenu:
                oMsgBox = oGuiMan.CreateMessageBox(GetPC());
                oMsgBox.SetInputDelegate(MainMenuConfirm);
                stParams.srAText = srConfirm;
                stParams.srBText = srCancel;
                oMsgBox.DisplayMessageBox(srMainMenuConfirm, stParams);
                break;
            case MEBrowserWheelSubPages.MBW_SP_ExitGame:
                ExitGame();
                break;
            default:
                oNewPanel = GetSFXUIController().OpenMovie(GetPC(), lstPages[nPanel].Tag, TRUE);
                if (oNewPanel != None)
                {
                    if (oPanel != None)
                    {
                        oGuiMan.RemovePanel(oPanel);
                    }
                    oNewPanel.AddExtension(Class'BioSFHandler_SharedIGG');
                    oNewPanel.CloseSound = 'ReturnToBrowser';
                    oNewPanel.SetRequiresUIWorld(TRUE);
                    lstPages[nPanel].oHandler = oNewPanel;
                    if (SFXSFHandler_AreaMap(oNewPanel) != None)
                    {
                        SFXSFHandler_AreaMap(oNewPanel).PauseMenuAdditionalProcessing();
                    }
                    if (oPanel != None)
                    {
                        oPanel.oParentManager.m_eLastBrowserWheelSubPage = byte(nPanel);
                    }
                }
                break;
        }
    }
}
public function Update(float fDeltaT)
{
    local Rotator R;
    local float fRadius;
    local int nDegrees;
    
    if (Abs(vInput.X) > 0.25 || Abs(vInput.Y) > 0.25)
    {
        fRadius = Square(vInput.X) + Square(vInput.Y);
        if (fRadius >= fLastRadius || fRadius > 0.899999976)
        {
            R = Rotator(vInput);
            nDegrees = int(float(R.Yaw) * 0.00549316406);
            if (nDegrees < 0)
            {
                nDegrees += 360;
            }
            AS_SetArrowPosition(nDegrees);
        }
        fLastRadius = fRadius;
    }
    else
    {
        fLastRadius = 0.0;
    }
}
public final function AS_SetButtonAdvanceSwap(bool bMenuAdvanceSwapped)
{
    ActionScriptVoid("SetButtonAdvanceSwap");
}
public final function AS_SetResourceCounts(int nCredits, int nMedigel, int nGrenades)
{
    ActionScriptVoid("SetResourceCounts");
}
public final function CloseBrowser()
{
    GetSFXUIController().HideBrowserWheel(None, GetPC());
}
public final function DetermineSquadUpdateStatus()
{
    local int i;
    local int nSquadSize;
    local bool bAlert;
    local BioPawn oPawn;
    local BioBaseSquad oSquad;
    local BioPlayerSquad oPlayerSquad;
    local bool bCanUseSquadMenu;
    
    oSquad = oWorldInfo.m_playerSquad;
    oPlayerSquad = BioPlayerSquad(oSquad);
    if (oPlayerSquad != None)
    {
        bCanUseSquadMenu = oPlayerSquad.IsFieldingInitialPlayerPawn() == TRUE;
    }
    else
    {
        bCanUseSquadMenu = oWorldInfo.LocalPlayerController.Pawn != None;
    }
    if (!bCanUseSquadMenu)
    {
        oWorldInfo.m_lstBrowserAlerts[2] = 2;
        return;
    }
    bAlert = FALSE;
    if (oSquad != None)
    {
        if (SFXGRI(oWorldInfo.GRI).bCanSpawnHenchmen)
        {
            nSquadSize = oSquad.Members.Length;
            for (i = 0; i < nSquadSize; i++)
            {
                oPawn = BioPawn(oSquad.Members[i]);
                if (oPawn != None)
                {
                    m_Helper.SetPawn(oPawn);
                    if (m_Helper.CanMakePurchase())
                    {
                        bAlert = TRUE;
                        break;
                    }
                }
            }
        }
        else
        {
            oPawn = oSquad.CachedPlayerPawn;
            if (oPawn != None)
            {
                m_Helper.SetPawn(oPawn);
                if (m_Helper.CanMakePurchase())
                {
                    bAlert = TRUE;
                }
            }
        }
    }
    oWorldInfo.m_lstBrowserAlerts[2] = bAlert ? 1 : 0;
}
public function ExitGame();

public final function InitializeBrowser()
{
    local BioPlayerController PC;
    local int i;
    local string sReason;
    local ASParams stParam;
    local array<ASParams> lstParams;
    local SubPageState oSubPageState;
    local bool bAbleToSave;
    local bool bAbleToLoad;
    local int nIndex;
    local BioBrowserStates StateWithOverride;
    
    m_Helper.Initialize(oWorldInfo);
    PC = BioPlayerController(GetPC());
    bAbleToSave = PC != None ? PC.CanSave(sReason) : FALSE;
    if (bAbleToSave == FALSE || !SFXGRI(oWorldInfo.GRI).bCanSave)
    {
        oWorldInfo.m_lstBrowserAlerts[1] = 2;
    }
    else
    {
        oWorldInfo.m_lstBrowserAlerts[1] = 0;
    }
    bAbleToLoad = TRUE;
    if (Class'WorldInfo'.static.IsConsoleBuild(0) && PC != None)
    {
        bAbleToLoad = int(PC.GetLoginStatus()) != 0;
    }
    if (bAbleToLoad)
    {
        oWorldInfo.m_lstBrowserAlerts[3] = 0;
    }
    else
    {
        oWorldInfo.m_lstBrowserAlerts[3] = 2;
    }
    DetermineSquadUpdateStatus();
    if (GetSFXUIController().GetAreaMapData() == None || !SFXGRI(oWorldInfo.GRI).bCanShowMap)
    {
        oWorldInfo.m_lstBrowserAlerts[0] = 2;
    }
    else
    {
        oWorldInfo.m_lstBrowserAlerts[0] = 0;
    }
    if (!SFXGRI(oWorldInfo.GRI).bCanShowJournal)
    {
        oWorldInfo.m_lstBrowserAlerts[4] = 2;
    }
    else
    {
        DetermineJournalCodexUpdateStatus();
    }
    stParam.Type = ASParamTypes.ASParam_Integer;
    stParam.nVar = int(oPanel.oParentManager.m_eLastBrowserWheelSubPage);
    lstParams.AddItem(stParam);
    for (i = 0; i < lstPages.Length; i++)
    {
        stParam.Type = ASParamTypes.ASParam_String;
        stParam.sVar = string(lstPages[i].srLabel);
        lstParams.AddItem(stParam);
        StateWithOverride = oWorldInfo.m_lstBrowserAlerts[int(lstPages[i].Type)];
        for (nIndex = 0; nIndex < oWorldInfo.SubPageStateOverrides.Length; nIndex++)
        {
            oSubPageState = oWorldInfo.SubPageStateOverrides[nIndex];
            if (oSubPageState.Page == MEBrowserWheelSubPages.MBW_SP_Map)
            {
                continue;
            }
            if (int(oSubPageState.Page) == int(lstPages[i].Type))
            {
                if (oSubPageState.Page != MEBrowserWheelSubPages.MBW_SP_Save || bAbleToSave == TRUE)
                {
                    StateWithOverride = oSubPageState.State;
                    continue;
                }
                continue;
            }
        }
        stParam.Type = ASParamTypes.ASParam_Integer;
        stParam.nVar = int(StateWithOverride);
        lstParams.AddItem(stParam);
    }
    if (Class'WorldInfo'.static.IsConsoleBuild(2))
    {
        AS_SetButtonAdvanceSwap(IsEnterMenuButtonAssignmentSwapped());
    }
    oPanel.InvokeMethodArgs("initBrowser", lstParams);
    SetResourceValues();
}
public function MainMenuConfirm(bool bAPressed, int nContext)
{
    local SFXGUIInteraction GUIManager;
    
    GUIManager = oPanel.oParentManager;
    if (bAPressed)
    {
        Class'SFXEngine'.static.GetSFXEngine().LoadMovieManager.SetupNativeLoadingMovie('BrowserWheelToMainMenu');
        GUIManager.HackReloadMainMenu();
    }
}
public final function SelectSegment(int nSegment)
{
    oPanel.oParentManager.InputHandler.AddCooldown(12, 0.5);
    oPanel.oParentManager.InputHandler.AddCooldown(13, 0.5);
    oPanel.oParentManager.InputHandler.AddCooldown(14, 0.5);
    oPanel.oParentManager.InputHandler.AddCooldown(11, 0.5);
    ShowSelectedPanel(nSegment);
}
public function SetResourceValues()
{
    local PlayerController PC;
    local BioPawn oPlayerPawn;
    local SFXInventoryManager oInventory;
    
    PC = GetPC();
    if (PC != None)
    {
        oPlayerPawn = BioPawn(PC.Pawn);
    }
    if (oPlayerPawn == None)
    {
        return;
    }
    oInventory = SFXInventoryManager(oPlayerPawn.InvManager);
    if (oInventory == None)
    {
        return;
    }
    if (SFXGRI(oWorldInfo.GRI).bMultiplayer)
    {
        return;
    }
    AS_SetResourceCounts(oInventory.GetResource(0), oInventory.GetResource(1), oInventory.GetResource(3));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXPowerLevelUpHelper Name=oHelper
    End Object
    lstPages = ({Tag = 'Options', srLabel = $126265, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Options}, 
                {Tag = 'Load', srLabel = $126264, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Load}, 
                {Tag = 'SquadRecord', srLabel = $126257, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_SquadRecord}, 
                {Tag = 'Save', srLabel = $126263, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Save}, 
                {Tag = 'Journal', srLabel = $126261, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Journal}, 
                {Tag = 'Areamap', srLabel = $126262, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Map}, 
                {Tag = 'Manual', srLabel = $387214, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_Manual}, 
                {Tag = 'INVALID', srLabel = $174868, oHandler = None, Type = MEBrowserWheelSubPages.MBW_SP_ReturnToMainMenu}
               )
    srExitConfirm = $176289
    srMainMenuConfirm = $176290
    srConfirm = $153362
    srCancel = $153363
    m_Helper = oHelper
    m_bUseThumbstickAsDPad = FALSE
}
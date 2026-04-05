Class BioSFHandler_ChoiceGUI extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum EChoiceGUIHandlerID
{
    CHOICEHANDLER_NONE,
    CHOICEHANDLER_SELECTED,
    CHOICEHANDLER_EXIT,
    CHOICEHANDLER_UPDATE_IMAGE,
    CHOICEHANDLER_SHOW_CREDITS,
};

var config string m_sResourceCostColorHTML_CanAfford;
var config string m_sResourceCostColorHTML_CantAfford;
var delegate<InputCallback> __InputCallback__Delegate;
var delegate<UpdateCallback> __UpdateCallback__Delegate;
var delegate<UpdateCallbackEx> __UpdateCallbackEx__Delegate;
var SFXGameChoiceGUIData m_ChoiceData;
var int nInputCallbackContext;
var config stringref m_srResourceTextCredits;
var config stringref m_srResourceTextEzo;
var config stringref m_srResourceTextIridium;
var config stringref m_srResourceTextPalladium;
var config stringref m_srResourceTextPlatinum;
var config stringref m_srResourceTextProbes;
var config stringref m_srResourceCostFormat;
var config stringref m_srResourceAvailFormat;
var config int m_nInfoScrollSpeed;
var transient bool m_bStopScroll;

public native function CleanUpDelegateReferences();

public function GameSessionEnded()
{
    CleanUpDelegateReferences();
    Super.GameSessionEnded();
}
public event function int GetResourceCount(int nResource)
{
    local BioPlayerController PC;
    local BioPawn pPawn;
    local EInventoryResourceTypes eResource;
    local int nValue;
    
    nValue = 0;
    if (nResource == -1)
    {
        nResource = int(m_ChoiceData.m_eOptionalPaneResourceType);
    }
    eResource = byte(nResource);
    if (oWorldInfo != None)
    {
        PC = oWorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            pPawn = BioPawn(PC.Pawn);
            if (pPawn != None)
            {
                nValue = SFXInventoryManager(pPawn.InvManager).GetResource(eResource);
            }
        }
    }
    return nValue;
}
public native function string GetResourceText(EInventoryResourceTypes eResource);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            ScrollText(-fValue);
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final native function HideChoiceGUI(optional bool bRemove = FALSE);

public final native function Initialize(SFXGameChoiceGUIData ChoiceData);

public delegate function InputCallback(bool bAPressed, int nContext);

public event function onExIntUpdateOptionValues(int nResource)
{
    local array<ASParams> lstParams;
    local int nResourceCount;
    local EInventoryResourceTypes eResource;
    
    if (nResource == -1)
    {
        nResource = int(m_ChoiceData.m_eOptionalPaneResourceType);
    }
    eResource = byte(nResource);
    nResourceCount = GetResourceCount(nResource);
    lstParams.Length = 1;
    lstParams[0].Type = ASParamTypes.ASParam_String;
    ClearCustomTokens();
    SetCustomToken(0, GetResourceText(eResource));
    SetCustomToken(1, string(nResourceCount));
    lstParams[0].sVar = GetUIString(m_srResourceAvailFormat, TRUE);
    ClearCustomTokens();
    oPanel.InvokeMethodArgs("ChoiceGuiInstance.UpdateInventoryValues", lstParams);
}
public event function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
    if (oPanel.nmTag == 'MissionCompletion')
    {
        PlayGuiSound('MissionCompletionEnter');
    }
    else
    {
        PlayGuiSound('ConsoleEnter');
    }
}
public event function OnPanelRemoved()
{
    if (oPanel.nmTag == 'MissionCompletion')
    {
        PlayGuiSound('MissionCompletionExit');
    }
    else
    {
        PlayGuiSound('ConsoleExit');
    }
    CleanUpDelegateReferences();
    Super.OnPanelRemoved();
}
public native function RefreshChoiceGUI();

public final native function SetInputDelegate(delegate<InputCallback> pDelegate, optional int nContext = 0);

public final native function SetUpdateDelegate(delegate<UpdateCallback> pDelegate);

public native function ShowChoiceGUI();

public delegate function UpdateCallback(float fDeltaT, BioSFHandler_ChoiceGUI oChoiceGUI);

public delegate function UpdateCallbackEx(float fDeltaT, Object oChoiceGUI);

public function ScrollText(float fValue)
{
    local array<ASParams> lstParams;
    local ASParams aParam;
    
    if (Abs(fValue) <= 0.0000999999975)
    {
        if (m_bStopScroll)
        {
            oPanel.InvokeMethod("ChoiceGuiInstance.StopInfoScroll");
            m_bStopScroll = FALSE;
        }
        return;
    }
    aParam.Type = ASParamTypes.ASParam_Float;
    aParam.fVar = fValue * float(m_nInfoScrollSpeed);
    lstParams.AddItem(aParam);
    oPanel.InvokeMethodArgs("ChoiceGuiInstance.ScrollInfoText", lstParams);
    m_bStopScroll = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sResourceCostColorHTML_CanAfford = "<font color='#00FF00'>"
    m_sResourceCostColorHTML_CantAfford = "<font color='#FF0000'>"
    m_srResourceTextCredits = $262489
    m_srResourceTextEzo = $262490
    m_srResourceTextIridium = $262491
    m_srResourceTextPalladium = $262492
    m_srResourceTextPlatinum = $262493
    m_srResourceCostFormat = $349328
    m_srResourceAvailFormat = $349329
    m_nInfoScrollSpeed = 1
    nHandlerID = 38
    bSetGameMode = FALSE
}
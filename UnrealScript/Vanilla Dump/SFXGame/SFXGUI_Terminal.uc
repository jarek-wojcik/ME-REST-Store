Class SFXGUI_Terminal extends SFXGUIMovie
    native
    config(UI);

var array<delegate<OnRequestActionDelegate>> OnRequestActionCallbacks;
var delegate<OnRequestExitCallback> __OnRequestExitCallback__Delegate;
var delegate<OnRequestActionDelegate> __OnRequestActionDelegate__Delegate;
var SFXGUIData_Terminal TerminalData;
var transient bool bIsFinished;
var transient bool bIsAborted;
var transient bool bWasPaused;
var transient bool bIsFlashLoaded;
var transient bool bIsScriptLoaded;

public event function ASAddSelectionTitles(string sTitle, string sDesc, bool bDisabled)
{
    ActionScriptVoid("TerminalStage.AddSelectionTitles");
}
public event function ASSetTitles(string sTitle, string sAText, string sBText)
{
    ActionScriptVoid("TerminalStage.SetTitles");
}
public function Initialize(SFXGUIData_Terminal InitialTerminalGUIData)
{
    TerminalData = InitialTerminalGUIData;
    if (TerminalData == None)
    {
        bIsAborted = TRUE;
        return;
    }
    SetGameMode(TRUE);
    bIsScriptLoaded = TRUE;
    if (bIsFlashLoaded)
    {
        PostInit();
    }
}
public delegate function OnRequestActionDelegate();

public delegate function OnRequestExitCallback();

public event function OnStart()
{
    Super.OnStart();
    SetRequiresUIWorld(TRUE);
    PlayGuiSound('ConsoleEnter');
}
public function PostInit()
{
    local BioGlobalVariableTable PlotStateData;
    local TerminalItemData TermItem;
    local string P1;
    local string P2;
    local string P3;
    
    PlotStateData = oWorldInfo.GetGlobalVariables();
    if (PlotStateData == None)
    {
        bIsAborted = TRUE;
        return;
    }
    P1 = GetUIString(TerminalData.srTerminalTitle);
    P2 = GetUIString(TerminalData.srDefaultAButtonText);
    P3 = GetUIString(TerminalData.srDefaultBButtonText);
    ASSetTitles(P1, P2, P3);
    foreach TerminalData.TerminalItemArray(TermItem, )
    {
        P1 = GetUIString(TermItem.ItemTitle);
        P2 = GetUIString(TermItem.ItemDesc);
        ASAddSelectionTitles(P1, P2, TermItem.PlotUnlockID != 0 && PlotStateData.GetBool(TermItem.PlotUnlockID) == FALSE);
    }
}
public function ShutDown()
{
    if (bIsFinished == FALSE && bIsAborted == FALSE && __OnRequestExitCallback__Delegate != None)
    {
        __OnRequestExitCallback__Delegate();
    }
    __OnRequestExitCallback__Delegate = None;
    ClearActionDelegates();
    SetGameMode(FALSE);
    bIsFinished = TRUE;
    Close();
}
public event function OnClose()
{
    PlayGuiSound('ConsoleExit');
    Super.OnClose();
}
public function AddOnRequestActionDelegate(delegate<OnRequestActionDelegate> fn_OnRequestActionDelegate)
{
    OnRequestActionCallbacks.AddItem(fn_OnRequestActionDelegate);
}
public function ClearActionDelegates()
{
    OnRequestActionCallbacks.Length = 0;
}
public function ExPostLoad()
{
    bIsFlashLoaded = TRUE;
    if (bIsScriptLoaded)
    {
        PostInit();
    }
}
public function ExRequestAction(int nRequest)
{
    local delegate<OnRequestActionDelegate> RequestAction;
    
    if (nRequest > -1 && nRequest < OnRequestActionCallbacks.Length)
    {
        RequestAction = OnRequestActionCallbacks[nRequest];
        RequestAction();
    }
}
public function ExRequestLogoff()
{
    bIsFinished = TRUE;
    if (__OnRequestExitCallback__Delegate != None)
    {
        __OnRequestExitCallback__Delegate();
    }
    else
    {
        ShutDown();
    }
}
public function SetOnRequestExitCallback(delegate<OnRequestExitCallback> fn_OnRequestExitDelegate)
{
    __OnRequestExitCallback__Delegate = fn_OnRequestExitDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bFocusOnStart = TRUE
}
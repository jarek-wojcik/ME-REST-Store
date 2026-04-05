Class SFXGUI_Elevator extends SFXGUIMovie
    native
    config(UI);

var delegate<OnRequestExitDelegate> __OnRequestExitDelegate__Delegate;
var delegate<OnRequestDestinationDelegate> __OnRequestDestinationDelegate__Delegate;
var SFXGUIData_Elevator ElevatorData;
var transient int DefaultDestination;
var transient bool bIsFinished;
var transient bool bIsAborted;
var transient bool bWasPaused;
var transient bool bIsFlashLoaded;
var transient bool bIsScriptLoaded;
var transient bool bDestinationRequested;

public event function ASAddDestination(bool KeepAlive, string Title, string SubTitle, string Desc, string Image, bool Default, bool Able)
{
    ActionScriptVoid("ElevatorStage.AddDestination");
}
public event function ASNativeReady()
{
    ActionScriptVoid("ElevatorStage.NativeReady");
}
public event function ASSetTitles(string sTitle, string sSubtitle, string sAText, string sBText)
{
    ActionScriptVoid("ElevatorStage.SetTitles");
}
public function Initialize(SFXGUIData_Elevator InitialElevatorGUIData, optional int InitialDefaultDestination = -1)
{
    ElevatorData = InitialElevatorGUIData;
    if (ElevatorData == None)
    {
        bIsAborted = TRUE;
        return;
    }
    DefaultDestination = InitialDefaultDestination;
    SetGameMode(TRUE);
    ASNativeReady();
}
public delegate function OnRequestDestinationDelegate(int DestinationID);

public delegate function OnRequestExitDelegate();

public event function OnStart()
{
    Super.OnStart();
    SetRequiresUIWorld(TRUE);
}
public function ShutDown()
{
    if (bIsFinished == FALSE && bIsAborted == FALSE && __OnRequestExitDelegate__Delegate != None)
    {
        __OnRequestExitDelegate__Delegate();
    }
    __OnRequestExitDelegate__Delegate = None;
    SetGameMode(FALSE);
    bIsFinished = TRUE;
    Close();
}
public event function OnClose()
{
    PlayGuiSound('Elevator-ExitGUI');
    Super.OnClose();
}
public function ExExit()
{
    bIsFinished = TRUE;
    if (!bDestinationRequested)
    {
        __OnRequestDestinationDelegate__Delegate(-1);
    }
    if (__OnRequestExitDelegate__Delegate != None)
    {
        __OnRequestExitDelegate__Delegate();
    }
    else
    {
        ShutDown();
    }
}
public function ExGo(int nRequest)
{
    bIsFinished = TRUE;
    if (__OnRequestDestinationDelegate__Delegate != None)
    {
        bDestinationRequested = TRUE;
        __OnRequestDestinationDelegate__Delegate(nRequest);
    }
}
public function ExPullElevatorDestinations()
{
    local BioGlobalVariableTable PlotStateData;
    local ElevatorDestinationData Destination;
    local string P1;
    local string P2;
    local string P3;
    
    PlotStateData = oWorldInfo.GetGlobalVariables();
    if (PlotStateData == None)
    {
        ASAddDestination(FALSE, "", "", "", "", FALSE, FALSE);
        bIsAborted = TRUE;
        return;
    }
    foreach ElevatorData.ElevatorDestinations(Destination, )
    {
        ElevatorData.DestinationTitleString(Self, Destination, P1);
        P2 = GetUIString(Destination.DestSubTitle);
        ElevatorData.DestinationDescString(Self, Destination, P3);
        ASAddDestination(TRUE, P1, P2, P3, Destination.LargeImage, Destination.DestId == DefaultDestination, Destination.PlotUnlockID == 0 || PlotStateData.GetBool(Destination.PlotUnlockID) == TRUE);
    }
    ASAddDestination(FALSE, "", "", "", "", FALSE, FALSE);
}
public function ExPullElevatorTitles()
{
    ASSetTitles(GetUIString(ElevatorData.srElevatorTitle), GetUIString(ElevatorData.srElevatorDescription), GetUIString(ElevatorData.srDefaultAButtonText), GetUIString(ElevatorData.srDefaultBButtonText));
}
public function SetOnRequestDestinationCallback(delegate<OnRequestDestinationDelegate> fn_OnRequestDestinationDelegate)
{
    __OnRequestDestinationDelegate__Delegate = fn_OnRequestDestinationDelegate;
}
public function SetOnRequestExitCallback(delegate<OnRequestExitDelegate> fn_OnRequestExitDelegate)
{
    __OnRequestExitDelegate__Delegate = fn_OnRequestExitDelegate;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultDestination = -1
    m_bFocusOnStart = TRUE
}
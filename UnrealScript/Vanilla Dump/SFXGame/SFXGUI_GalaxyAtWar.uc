Class SFXGUI_GalaxyAtWar extends SFXGUIMovie
    config(UI);

var array<GAWZoneGUIData> GAWRatings;
var delegate<OnFinished> __OnFinished__Delegate;
var delegate<OnSwitchScreens> __OnSwitchScreens__Delegate;
var SFXGAWAssetsHandler GAWAssetHandler;
var config stringref srReadinessPercent;
var config stringref srRatingsError;
var config stringref srOK;
var config stringref srGaWTutorialMessage;
var bool m_bGAWRatingsError;

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            AS_ScrollDetails(fValue);
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public delegate function OnFinished();

public event function OnStart()
{
    Super.OnStart();
    PlayGuiSound('GalaxyAtWarStart');
    SetRequiresUIWorld(TRUE);
    SetGameMode(TRUE, 9);
    SetMouseVisible(TRUE);
    AS_SetPercentagesVisible(FALSE);
    AS_SetLoadingClipVisbile(TRUE);
    GAWAssetHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    GAWAssetHandler.RequestGAWRatings(OnGAWRequestFinished);
    ShowTutorial();
}
public event function OnClose()
{
    SetMouseVisible(FALSE);
    SetGameMode(FALSE, 9);
    Super.OnClose();
}
public function AS_InitializeScreen()
{
    ActionScriptVoid("screen.InitializeScreen");
}
public function AS_ScrollDetails(float fValue)
{
    ActionScriptVoid("screen.ScrollDetails");
}
public function AS_SetLoadingClipVisbile(bool bVisible)
{
    ActionScriptVoid("screen.SetLoadingClipVisible");
}
public function AS_SetPercentagesVisible(bool bVisbile)
{
    ActionScriptVoid("screen.SetMapPercentagesVisible");
}
public function string GetFormattedReadinessPercent(int nReadiness)
{
    local string ResultString;
    
    SetCustomToken(0, string(nReadiness));
    ResultString = GetUIString(srReadinessPercent, TRUE);
    ClearCustomTokens();
    return ResultString;
}
public function array<GAWZoneGUIData> GetGAWRatings()
{
    return GAWRatings;
}
public final function int GetOverallReadiness()
{
    return GAWAssetHandler.GetOverallReadiness();
}
public function GoBack()
{
    PlayGuiSound('GalaxyAtWarFinish');
    Close();
    if (__OnFinished__Delegate != None)
    {
        __OnFinished__Delegate();
    }
}
public function GoToWarAssets()
{
    Close();
    if (__OnSwitchScreens__Delegate != None)
    {
        __OnSwitchScreens__Delegate();
    }
}
public function bool HasGAWRatingsError()
{
    return m_bGAWRatingsError;
}
public function OnGAWRequestFinished(array<GAWZoneGUIData> ZoneData, int Level, int errorCode)
{
    AS_SetLoadingClipVisbile(FALSE);
    m_bGAWRatingsError = errorCode != 0;
    GAWRatings = ZoneData;
    AS_InitializeScreen();
}
private final function OnRatingsErrorFinished(bool bAPressed, int nContext)
{
    Close();
    if (__OnFinished__Delegate != None)
    {
        __OnFinished__Delegate();
    }
}
public delegate function OnSwitchScreens();

public function ShowGAWRatingsRequestError()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    Params.srAText = srOK;
    messageBox.SetInputDelegate(OnRatingsErrorFinished);
    messageBox.DisplayMessageBox(srRatingsError, Params);
}
public function ShowTutorial()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    local SFXEngine Engine;
    
    if (srGaWTutorialMessage == 0)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine.GetPlayerVariable('GaWTutorialDisplayed') != 0)
    {
        return;
    }
    Engine.SetPlayerVariable('GaWTutorialDisplayed', 1);
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    Params.srAText = srOK;
    messageBox.DisplayMessageBox(srGaWTutorialMessage, Params);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srReadinessPercent = $710700
    srRatingsError = $710699
    srOK = $710701
    srGaWTutorialMessage = $727391
    m_bFocusOnStart = TRUE
}
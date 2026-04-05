Class BioSFHandler_GameOver extends SFXGUIMovieLegacyAdapter
    config(UI);

var config stringref GameOverString;
var config stringref BadResumeGameText;
var config stringref AcceptBadResumeGameText;
var bool AbleToLoad;

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.m_bUseThumbstickAsDPad = FALSE;
}
public final function ShowLoadScreen()
{
    if (AbleToLoad)
    {
        AddOnMovieClosedDelegate(OpenLoadScreenOnCloseDelegate);
        Close();
    }
}
public final function AS_DisableLoadButton()
{
    ActionScriptVoid("DisableLoadButton");
}
public final function AS_SetGameOverString(string sText)
{
    ActionScriptVoid("SetGameOverString");
}
public function Callback_GotoMainMenu(bool bAPressed, int Context)
{
    GoToMainMenu();
}
public final function DisplayResumeFailure()
{
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
    messageBox.SetInputDelegate(Callback_GotoMainMenu);
    Params.srAText = AcceptBadResumeGameText;
    Params.bNoFade = TRUE;
    Params.bModal = TRUE;
    messageBox.DisplayMessageBox(BadResumeGameText, Params);
}
public final function GameOverResume_Callback(bool bWasSuccessful)
{
    oPanel.SetInputDisabled(FALSE);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        GetSFXUIController().GetSaveLoadWidget().HideLoadingMessage();
    }
    if (bWasSuccessful)
    {
        GetSFXUIController().HideGameOverGui(GetPC());
    }
    else
    {
        DisplayResumeFailure();
    }
}
public final function GoToMainMenu()
{
    AddOnMovieClosedDelegate(GotoMainMenuOnCloseCallback);
    Close();
}
public final function bool GotoMainMenuOnCloseCallback(SFXGUIMovie oMovie)
{
    GetSFXUIController().HackReloadMainMenu();
    return TRUE;
}
public final function InitializeGameOver()
{
    local string S;
    local BioPlayerController PC;
    
    S = UIStrRef(GameOverString);
    AS_SetGameOverString(S);
    AbleToLoad = TRUE;
    PC = BioPlayerController(GetPC());
    if (Class'WorldInfo'.static.IsConsoleBuild(0) && PC != None)
    {
        AbleToLoad = int(PC.GetLoginStatus()) != 0;
    }
    if (!AbleToLoad)
    {
        AS_DisableLoadButton();
    }
}
public final function LoadLastSave()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        SetInputDisabled(TRUE);
        if (Class'WorldInfo'.static.IsConsoleBuild())
        {
            GetSFXUIController().GetSaveLoadWidget().ShowLoadingMessage();
        }
        Class'SFXEngine'.static.GetSFXEngine().LoadMovieManager.SetupNativeLoadingMovie('GameOverResume');
        PC.ResumeGame(GameOverResume_Callback);
        PlayGuiSound('GameOverResume');
    }
    else
    {
        DisplayResumeFailure();
    }
}
public final function bool OpenLoadScreenOnCloseDelegate(SFXGUIMovie oMovie)
{
    local SFXGUIInteraction GuiMan;
    local SFXSFHandler_Load handler;
    
    GuiMan = GetSFXUIController();
    PlayGuiSound('GameOverLoadScreen');
    handler = GuiMan.CastOpenMovie(Class'SFXSFHandler_Load', GetPC(), GuiMan.MovieTag_Load, FALSE);
    handler.SetRequiresUIWorld(TRUE);
    handler.GuiMode = ESaveGuiMode.SaveGuiMode_GameOver;
    handler.Start(FALSE);
    GuiMan.HideBlackScreen(GetPC(), FALSE);
    StopAnyMusic();
    return TRUE;
}
public final function QuitToMainMenu()
{
    Class'SFXEngine'.static.GetSFXEngine().LoadMovieManager.SetupNativeLoadingMovie('GameOverMainMenu');
    PlayGuiSound('GameOverMainMenu');
    GoToMainMenu();
}
public final function SetGameOverString(stringref messageId)
{
    local string Message;
    
    if (messageId != 0)
    {
        Message = UIStrRef(messageId);
        AS_SetGameOverString(Message);
    }
}
public final function StopAnyMusic()
{
    local BioPlayerController oPC;
    local BioCameraBehaviorGalaxy oGalaxy;
    
    oPC = BioPlayerController(GetPC());
    if (oPC == None)
    {
        return;
    }
    oGalaxy = BioCameraBehaviorGalaxy(oPC.GameModeManager2.HACK_GetCameraMode(11));
    if (oGalaxy != None)
    {
        if (oGalaxy.Data != None && oGalaxy.m_nCurrentState != 0)
        {
            PlayGuiSound('GalaxyMapCriticalMissionFailExitToSaveLoad');
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GameOverString = $157152
    BadResumeGameText = $174514
    AcceptBadResumeGameText = $153007
}
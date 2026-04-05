Class SFXGUI_MainMenu_RTT extends SFXGUIMovieKismet
    native
    config(UI);

enum EMM_GameType
{
    MM_GameType_None,
    MM_GameType_New,
    MM_GameType_Plus,
    MM_GameType_Legacy,
};
struct native MMListSequences 
{
    var string SeqID;
    var string ListID;
    var string FncOnEntry;
    var int SeqStep;
    var stringref Label;
};
struct native MMListEntry 
{
    var string ListID;
    var string FncOnSelect;
    var string FncActiveConditional;
    var string FncNotifyConditional;
    var string KmtOnSelect;
    var stringref Label;
    var bool ShowNotification;
};

var transient Double CheckingDataStartTime;
var transient MMListSequences Cursor_SeqEntry;
var transient MMListSequences Display_SeqEntry;
var config array<MMListEntry> ListEntries;
var config array<MMListSequences> ListSequences;
var transient string Cursor_SeqID;
var transient string m_MPSelectedMapStr;
var delegate<MsgBoxInputCallback> __MsgBoxInputCallback__Delegate;
var Name ExitToMainMenuSound;
var transient int Cursor_SeqStep;
var transient stringref Cursor_Heading;
var transient float TimeSinceLastListUpdate;
var config transient float ListUpdateInterval;
var config float CheckingDataMessageDelay;
var config float CheckingDataMessageMinimum;
var config stringref CheckingDLCMessage;
var config stringref CheckingSaveDataMessage;
var config stringref NoLoginStart;
var config stringref ConfirmNoLoginStart;
var config stringref CancelNoLoginStart;
var config stringref srExitConfirm;
var config stringref srYes;
var config stringref srNo;
var config stringref srOK;
var config stringref srCancel;
var config stringref srConnect;
var config stringref srNoSpaceForCareer;
var config stringref srContinueWithoutSaving;
var config stringref srCancelNewCareer;
var config stringref srDemoNetworkRequired;
var config stringref srViewKinectManual;
var config stringref srViewKinectManual_Ok;
var config stringref srViewKinectManual_Cancel;
var transient bool bHasSaves;
var transient bool bHasNewGamePlusSaves;
var transient bool bCurrentCareerHasSaves;
var transient bool bComputerOpen;
var transient bool bDefaultToFemale;
var transient bool bDelayedNewGameRequested;
var transient bool m_bFemaleSelected;
var transient bool bWaitingForDLC;
var transient bool bWaitingForSaves;
var transient bool bWaitingForDigitalRights;
var transient bool bWaitingToRefreshDigitalRights;
var transient bool bDigitalRightsRefreshActive;
var transient bool bCheckForDLCMessage;
var transient bool bCheckingDataComplete;
var transient bool bCheckingDataMessageVisible;
var transient bool bDisplayingDLCErrorMessage;
var transient bool IsKinectTunerShown;
var transient EMM_GameType GameType;
var(SFXGUI_MainMenu_RTT) byte PendingCommand;

public event function AS_SetEntry(bool bHasHeading, MMListEntry oListEntry, int nListIndex)
{
    ActionScriptVoid("_root.SetListItem");
}
public event function ASClearLists()
{
    ActionScriptVoid("_root.ClearLists");
}
public event function ASRefreshList()
{
    ActionScriptVoid("_root.RefreshList");
}
public event function ASShowPrimaryList()
{
    ActionScriptVoid("_root.ShowPrimaryList");
}
public event function ASShowSubList(int SublistHeading)
{
    ActionScriptVoid("_root.ShowSubList");
}
public event function AsynchGameDataRecieved()
{
    SFXEngine(Class'Engine'.static.GetEngine()).CheckForCorruptCareers();
    EnterSequence("RootSeq");
}
public final native function BeginEnumerateCareers();

private final native function BeginInitDownloadableContent();

public native function bool CallListFnc(Name Fnc);

public final native function bool CanShowShowOnlineStorePC();

public final native function bool CanShowShowOnlineStorePS3();

public final native function bool CanShowShowOnlineStoreXBox();

private final native function ConditionalDisplayDLCError();

public final function Connect()
{
    if (StartConnectingFlow())
    {
        InternalConnect();
    }
}
public native function bool CurrentCareerHasSaves();

private final native function DLCErrorClosed(bool bAPressed, int nContext);

public final native function EndEnumerateCareers(SFXSaveGameCommandEventArgs Args);

public event function EnterSequence(string SeqID)
{
    local MMListSequences SeqEntry;
    
    foreach ListSequences(SeqEntry, )
    {
        if (SeqEntry.SeqID == SeqID && SeqEntry.SeqStep == 0)
        {
            EnterList(SeqEntry);
            TimeSinceLastListUpdate = 0.0;
        }
    }
}
public event function bool HandleInputEvent(BioGuiEvents nEventID, optional float fValue = 1.0)
{
    switch (nEventID)
    {
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_DOWN:
            AS_MenuDown();
            return TRUE;
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_UP:
            AS_MenuUp();
            return TRUE;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_A:
            AS_MenuExecute();
            return TRUE;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_B:
            AS_MenuBack();
            return TRUE;
        default:
    }
    return FALSE;
}
public native function bool HasNewGamePlusSaves();

public native function bool HasSaves();

public final native function bool IsEnumeratingDownloadableContent();

public static final native function bool IsKinectEnabled();

public static final native function bool IsValidKinectSpeechLanguageSetup();

public delegate function MsgBoxInputCallback(bool bAPressed, int Context);

public event function OnLanguageChanged()
{
    local SFXGUIInteraction oMgr;
    
    oMgr = GetSFXUIController();
    oMgr.HackReloadMainMenu();
}
public event function OnStart()
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentGame oOnlineGame;
    local SFXGUIInteraction oMgr;
    local BioSFHandler_MainMenu oMainMenu;
    
    Super.OnStart();
    oMgr = GetSFXUIController();
    if (oMgr != None)
    {
        oMainMenu = oMgr.CastGetMovie(Class'BioSFHandler_MainMenu', GetPC(), oMgr.MovieTag_MainMenu);
        oMainMenu.MenuComputer = Self;
    }
    AS_Initialize();
    BeginInitDownloadableContent();
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oOnlineGame = oOnlineSubsystem.GetComponentGame();
        if (oOnlineGame != None && oOnlineGame.IsPlaying())
        {
            oOnlineGame.LeaveGame();
        }
    }
}
public event function PostAdvance(float tDelta)
{
    if (bDelayedNewGameRequested)
    {
        bDelayedNewGameRequested = FALSE;
        BeginNewGame(m_bFemaleSelected);
    }
}
private final native function RefreshDigitalRightsComplete(int nResult);

public final native function ShowOnlineStore();

public event function StartMultiplayerFlow()
{
    local OnlineSubsystem OnlineSub;
    local ISFXOnlineComponentGameEntryFlow oMultiplayerFlow;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        oMultiplayerFlow = SFXOnlineSubsystem(OnlineSub).GetComponentGameEntryFlow();
        oMultiplayerFlow.ActivateMPLobbyAccessFlow();
    }
}
private final native function bool UpdateCheckingDataMessage(stringref Message, bool bShouldDisplayMessage);

private final native function UpdateCheckingDataState();

public event function OnClose()
{
    Super.OnClose();
}
public final function AS_Initialize()
{
    ActionScriptVoid("_root.Initialize");
}
public final function AS_MenuBack()
{
    ActionScriptVoid("_root.MenuBack");
}
public final function AS_MenuDown()
{
    ActionScriptVoid("_root.MenuDown");
}
public final function AS_MenuExecute()
{
    ActionScriptVoid("_root.MenuExecute");
}
public final function AS_MenuUp()
{
    ActionScriptVoid("_root.MenuUp");
}
public final function AS_SetRepeatingText(string strText)
{
    ActionScriptVoid("_root.SetRepeatingText");
}
public final function BeginNewGame(bool bFemaleSelected)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    if (CheckLogin())
    {
        PC = BioPlayerController(GetPC());
        Engine = SFXEngine(PC.Player.Outer);
        if (Class'WorldInfo'.static.IsConsoleBuild(2))
        {
            Engine.QueueSaveGameCommand(8, , StartNewGameFreeSpaceCallback);
        }
        else
        {
            StartNewGameInternal(bFemaleSelected);
        }
    }
}
public function Callback_NoLoginStart(bool bAPressed, int Context)
{
    local SFXEngine Engine;
    local BioPlayerController PC;
    
    if (bAPressed)
    {
        PC = BioPlayerController(GetPC());
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                Engine.bCanWriteSaveToStorage = FALSE;
                StartNewGameInternal(m_bFemaleSelected);
            }
        }
    }
}
public final function bool CanShowExitGame()
{
    return !Class'WorldInfo'.static.IsConsoleBuild();
}
public final function bool CanShowGameManual()
{
    return TRUE;
}
public final function bool CanShowMultiplayer()
{
    if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
public final function bool CanShowXboxLIVE()
{
    if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
public function CerberusConnectPopupInputCallback(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        Connect();
    }
}
public function bool CheckLogin()
{
    local PlayerController PC;
    local int ControllerId;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;
    local SFXEngine Engine;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams Params;
    
    if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE)
    {
        return TRUE;
    }
    PC = GetPC();
    if (PC != None)
    {
        Engine = SFXEngine(PC.Player.Outer);
        if (Engine != None && Engine.bCanWriteSaveToStorage == FALSE)
        {
            return TRUE;
        }
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInt = OnlineSub.PlayerInterface;
            if (PlayerInt != None && OnlineSub.SystemInterface != None)
            {
                if (int(PlayerInt.GetLoginStatus(byte(ControllerId))) == 0)
                {
                    messageBox = GetSFXUIController().CreateMessageBox(GetPC());
                    messageBox.SetInputDelegate(Callback_NoLoginStart);
                    Params.srAText = ConfirmNoLoginStart;
                    Params.srBText = CancelNoLoginStart;
                    Params.bNoFade = TRUE;
                    messageBox.DisplayMessageBox(NoLoginStart, Params);
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}
public final function CloseComputer()
{
    BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController().CauseEvent('LT_Close');
    bComputerOpen = FALSE;
}
private final function DelayedBeginNewGame(bool bFemaleSelected)
{
    m_bFemaleSelected = bFemaleSelected;
    bDelayedNewGameRequested = TRUE;
}
private final function DisplayInsufficientSpaceMessage(int AdditionalBytesNeeded)
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_MessageBox InsufficientSpaceMessage;
    local BioMessageBoxOptionalParams messageParams;
    local string InsufficientSpaceTextWithSize;
    
    GuiMan = GetSFXUIController();
    if (GuiMan != None)
    {
        InsufficientSpaceMessage = GuiMan.CreateMessageBox(GetPC());
        InsufficientSpaceMessage.SetInputDelegate(InsufficientSpaceCallback);
        messageParams.srAText = srContinueWithoutSaving;
        messageParams.srBText = srCancelNewCareer;
        messageParams.bModal = TRUE;
        messageParams.bNoFade = TRUE;
        SetCustomToken(1, string((AdditionalBytesNeeded + 1023) / 1024));
        InsufficientSpaceTextWithSize = GetTokenisedString(srNoSpaceForCareer);
        ClearCustomTokens();
        InsufficientSpaceMessage.DisplayMessageBoxEx(InsufficientSpaceTextWithSize, messageParams);
    }
}
public function bool EnterExtrasList()
{
    return TRUE;
}
public final function EnterExtrasSequence()
{
    EnterSequence("ExtrasSeq");
}
public function EnterList(MMListSequences SeqEntry)
{
    if (SeqEntry.FncOnEntry != "")
    {
        if (CallListFnc(Name(SeqEntry.FncOnEntry)) == TRUE && SeqEntry.ListID != "")
        {
            Cursor_SeqEntry = SeqEntry;
            Cursor_SeqID = SeqEntry.SeqID;
            Cursor_SeqStep = SeqEntry.SeqStep;
            ShowList(SeqEntry.ListID, SeqEntry.Label);
        }
    }
}
public function bool EnterNewGameList()
{
    GameType = EMM_GameType.MM_GameType_None;
    return PromptToDisplayKinectManual(NewGame_PromptToDisplayKinectManualCompleted);
}
public final function EnterNewGameSequence()
{
    EnterSequence("NewGameSeq");
}
public function bool EnterRootList()
{
    return TRUE;
}
public function bool EnterRootSequence()
{
    if (Cursor_SeqID != "RootSeq")
    {
        EnterSequence("RootSeq");
    }
    return FALSE;
}
public function ExitConfirm(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        oWorldInfo.ConsoleCommand("Exit");
    }
}
public final function ExitGame()
{
    local SFXGUIInteraction oGuiMgr;
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    oGuiMgr = GetSFXUIController();
    oMsgBox = oGuiMgr.CreateMessageBox(GetPC());
    oMsgBox.SetInputDelegate(ExitConfirm);
    stParams.srAText = srYes;
    stParams.srBText = srNo;
    oMsgBox.DisplayMessageBox(srExitConfirm, stParams);
}
private final function InsufficientSpaceCallback(bool bAPressed, int Context)
{
    local SFXEngine Engine;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine != None && bAPressed)
    {
        Engine.bCanWriteSaveToStorage = FALSE;
        StartNewGameInternal(m_bFemaleSelected);
    }
}
public final function InternalConnect()
{
    local BioSFHandler_MainMenu oHandler;
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = GetSFXUIController();
    oHandler = oGuiMgr.CastGetMovie(Class'BioSFHandler_MainMenu', GetPC(), oGuiMgr.MovieTag_MainMenu);
    if (oHandler != None)
    {
        oHandler.CerberusConnect(2);
    }
}
public final function bool IsComputerOpen()
{
    return bComputerOpen;
}
public final function LegacyImport()
{
    local SFXGUIInteraction UIMgr;
    
    UIMgr = GetSFXUIController();
    UIMgr.AddGUIDependency(UIMgr.MovieTag_Load, UIMgr.MovieTag_MainMenu, 2, ReturnFromLoadGui);
    OpenMainMenuSubMovie(UIMgr.MovieTag_Load, TRUE, TRUE);
}
public function bool LegacyReady()
{
    local PlayerController PC;
    local int ControllerId;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;
    
    if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE)
    {
        return TRUE;
    }
    PC = GetPC();
    if (PC != None)
    {
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInt = OnlineSub.PlayerInterface;
            if (PlayerInt != None && OnlineSub.SystemInterface != None && int(PlayerInt.GetLoginStatus(byte(ControllerId))) != 0)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public final function LoadGame()
{
    local SFXGUIInteraction UIMgr;
    
    if (PromptToDisplayKinectManual(LoadGame_PromptToDisplayKinectManualCompleted))
    {
        UIMgr = GetSFXUIController();
        UIMgr.AddGUIDependency(UIMgr.MovieTag_Load, UIMgr.MovieTag_MainMenu, 0, ReturnFromLoadGui);
        OpenMainMenuSubMovie(UIMgr.MovieTag_Load, TRUE, TRUE);
    }
}
public final function LoadGame_PromptToDisplayKinectManualCompleted(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        ShowGameManual(TRUE);
    }
    else
    {
        LoadGame();
    }
}
public final function NewGame_PromptToDisplayKinectManualCompleted(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        ShowGameManual(TRUE);
    }
    else
    {
        EnterSequence("NewGameSeq");
    }
}
public final function NewGameFemale()
{
    m_bFemaleSelected = TRUE;
    DelayedBeginNewGame(TRUE);
}
public final function NewGameMale()
{
    m_bFemaleSelected = FALSE;
    DelayedBeginNewGame(FALSE);
}
public final function NewGamePlus()
{
    local SFXGUIInteraction UIMgr;
    
    UIMgr = GetSFXUIController();
    UIMgr.AddGUIDependency(UIMgr.MovieTag_Load, UIMgr.MovieTag_MainMenu, 1, ReturnFromLoadGui);
    OpenMainMenuSubMovie(UIMgr.MovieTag_Load, TRUE, TRUE);
}
public function NextStep()
{
    StepSeq(1);
}
public final function OpenComputer()
{
    BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController().CauseEvent('LT_Open');
    bComputerOpen = TRUE;
}
public final function SFXGUIMovie OpenMainMenuSubMovie(Name nmMovieTag, optional bool bNewInstance = TRUE, optional bool bStart = TRUE)
{
    local SFXGUIMovie mov;
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = GetSFXUIController();
    mov = oGuiMgr.OpenMovie(GetPC(), nmMovieTag, bStart, FALSE, bNewInstance);
    if (mov != None)
    {
        mov.SetRequiresUIWorld(TRUE);
        mov.CloseSound = ExitToMainMenuSound;
    }
    return mov;
}
public function bool PrevStep()
{
    StepSeq(-1);
    return FALSE;
}
private final function bool PromptToDisplayKinectManual(delegate<MsgBoxInputCallback> aCallback)
{
    local SFXEngine Engine;
    local BioPlayerController PC;
    local SFXProfileSettings ProfSettings;
    local SFXGUIInteraction oGuiMgr;
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    if (!(Class'WorldInfo'.static.IsConsoleBuild(1) && IsKinectEnabled() && IsValidKinectSpeechLanguageSetup()))
    {
        return TRUE;
    }
    PC = BioPlayerController(GetPC());
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine != None)
    {
        ProfSettings = Engine.GetProfileSettings();
    }
    if (ProfSettings != None && ProfSettings.GetHasSeenKinectTutorialPrompt())
    {
        return TRUE;
    }
    else
    {
        oGuiMgr = Class'SFXGUIInteraction'.static.GetInstance();
        oMsgBox = oGuiMgr.CreateMessageBox(GetPC());
        stParams.bModal = TRUE;
        stParams.srAText = srViewKinectManual_Ok;
        stParams.srBText = srViewKinectManual_Cancel;
        oMsgBox.SetInputDelegate(aCallback);
        oMsgBox.DisplayMessageBox(srViewKinectManual, stParams);
        ProfSettings.SetHasSeenKinectTutorialPrompt(TRUE);
        PC.SaveProfile();
        return FALSE;
    }
}
public final function ResumeGame()
{
    local BioPlayerController PC;
    
    if (PromptToDisplayKinectManual(ResumeGame_PromptToDisplayKinectManualCompleted))
    {
        PC = BioPlayerController(GetPC());
        if (PC != None)
        {
            SetInputEnabled(FALSE);
            PC.ResumeGame(ResumeGameCallback);
            if (Class'WorldInfo'.static.IsConsoleBuild())
            {
                GetSFXUIController().GetSaveLoadWidget().ShowLoadingMessage();
            }
        }
    }
}
public final function ResumeGame_PromptToDisplayKinectManualCompleted(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        ShowGameManual(TRUE);
    }
    else
    {
        ResumeGame();
    }
}
public final function ResumeGameCallback(bool bWasSuccessful)
{
    SetInputEnabled(TRUE);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        GetSFXUIController().GetSaveLoadWidget().HideLoadingMessage();
    }
}
public final function ReturnFromLoadGui(optional bool bRescanCareers = FALSE)
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = GetSFXUIController();
    oGuiMgr.ShowMainMenu();
    if (bRescanCareers)
    {
        BeginEnumerateCareers();
    }
}
public final function ReturnFromManualGui(optional bool bRescanCareers = FALSE)
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = GetSFXUIController();
    oGuiMgr.ShowMainMenu();
    if (bRescanCareers)
    {
        BeginEnumerateCareers();
    }
}
public final function ShowAchievements()
{
    local SFXGUI_Accomplishments mov;
    
    mov = SFXGUI_Accomplishments(OpenMainMenuSubMovie(GetSFXUIController().MovieTag_Accomplishments));
    mov.SetFromMainMenu(TRUE);
}
public final function ShowCredits()
{
    local SFXGUI_Credits oCredits;
    
    oCredits = SFXGUI_Credits(OpenMainMenuSubMovie(GetSFXUIController().MovieTag_Credits));
    oCredits.SetFromMainMenu();
}
public final function ShowDemoLoginPopup()
{
    local SFXGUIInteraction oGuiMgr;
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    oGuiMgr = Class'SFXGUIInteraction'.static.GetInstance();
    oMsgBox = oGuiMgr.CreateMessageBox(GetPC());
    stParams.bModal = TRUE;
    stParams.srAText = srOK;
    oMsgBox.SetInputDelegate(ShowDemoLoginPopup_Input);
    oMsgBox.DisplayMessageBox(srDemoNetworkRequired, stParams);
}
public final function ShowDemoLoginPopup_Input(bool bAPressed, int nContext)
{
    Connect();
}
public final function ShowGameManual(optional bool bShowKinectPage = FALSE)
{
    local SFXGUIInteraction UIMgr;
    local SFXGUI_Manual oManual;
    
    UIMgr = GetSFXUIController();
    UIMgr.AddGUIDependency(UIMgr.MovieTag_Manual, UIMgr.MovieTag_MainMenu, 0, ReturnFromManualGui);
    oManual = SFXGUI_Manual(OpenMainMenuSubMovie(GetSFXUIController().MovieTag_Manual, TRUE, FALSE));
    if (oManual != None)
    {
        oManual.SetFromMainMenu();
        if (bShowKinectPage)
        {
            oManual.StartOnKinectChapter();
        }
        oManual.Start();
    }
}
public final function ShowKinectTuner()
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentPlatform CompPlatform;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        CompPlatform = oOnlineSubsystem.GetComponentPlatform();
        if (CompPlatform != None)
        {
            CompPlatform.ShowVoiceCommandTunerUI();
        }
    }
}
public function ShowList(string ListID, optional stringref SublistHeading)
{
    local MMListEntry ListEntry;
    local int ListIdx;
    
    ASClearLists();
    ListIdx = 1;
    foreach ListEntries(ListEntry, )
    {
        if (ListEntry.ListID == ListID)
        {
            if (ListEntry.FncActiveConditional == "" || CallListFnc(Name(ListEntry.FncActiveConditional)) == TRUE)
            {
                ListEntry.ShowNotification = ListEntry.FncNotifyConditional != "" && CallListFnc(Name(ListEntry.FncNotifyConditional));
                AS_SetEntry(Cursor_SeqID != "RootSeq", ListEntry, ListIdx);
                ListIdx++;
            }
        }
    }
    if (Cursor_SeqEntry == Display_SeqEntry)
    {
        ASRefreshList();
    }
    else if (Cursor_SeqID == "RootSeq")
    {
        ASShowPrimaryList();
    }
    else
    {
        ASShowSubList(int(SublistHeading));
    }
    Display_SeqEntry = Cursor_SeqEntry;
}
public final function ShowOptions()
{
    local BioSFHandler_Options oOptions;
    
    oOptions = BioSFHandler_Options(OpenMainMenuSubMovie(GetSFXUIController().MovieTag_Options, TRUE, FALSE));
    oOptions.GuiMode = EOptionsGuiMode.GuiMode_MainMenu;
    oOptions.Start();
}
public final function ShowPendingInvites()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SFXOnlineSubsystem(OnlineSub).GetComponentPlatform().ShowInbox();
    }
}
public final function bool StartConnectingFlow()
{
    local OnlineSubsystem OnlineSub;
    local ISFXOnlineComponentGameEntryFlow oMultiplayerFlow;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        oMultiplayerFlow = SFXOnlineSubsystem(OnlineSub).GetComponentGameEntryFlow();
        if (oMultiplayerFlow != None)
        {
            return oMultiplayerFlow.ActivateConnectFlow();
        }
    }
    return TRUE;
}
private final function StartNewGameFreeSpaceCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess && Args.bTotalFreeBytesSet)
    {
        if (1048576 > Args.TotalFreeBytes)
        {
            DisplayInsufficientSpaceMessage(1048576 - Args.TotalFreeBytes);
        }
        else
        {
            StartNewGameInternal(m_bFemaleSelected);
        }
    }
}
private final function StartNewGameInternal(bool bFemaleSelected)
{
    local SFXEngine Engine;
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine != None)
    {
        Engine.bNewPlayer = FALSE;
        oWorldInfo.RequestStartNewGame(bFemaleSelected);
    }
}
public function StepSeq(int Step)
{
    local MMListSequences SeqEntry;
    
    foreach ListSequences(SeqEntry, )
    {
        if (SeqEntry.SeqID == Cursor_SeqID && SeqEntry.SeqStep == Cursor_SeqStep + Step)
        {
            PlayGuiSound('MainMenu_OnListChange');
            EnterList(SeqEntry);
            return;
        }
    }
    PlayGuiError();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListEntries = ({
                    ListID = "RootList", 
                    FncOnSelect = "ResumeGame", 
                    FncActiveConditional = "CurrentCareerHasSaves", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $134506, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "EnterNewGameSequence", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $344480, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "LoadGame", 
                    FncActiveConditional = "HasSaves", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $156620, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "StartMultiplayerFlow", 
                    FncActiveConditional = "CanShowMultiplayer", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $506692, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "StartMultiplayerFlow", 
                    FncActiveConditional = "CanShowXboxLIVE", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $636336, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "ShowKinectTuner", 
                    FncActiveConditional = "IsKinectEnabled", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $705975, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "ShowOnlineStore", 
                    FncActiveConditional = "CanShowShowOnlineStorePC", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $724571, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "ShowOnlineStore", 
                    FncActiveConditional = "CanShowShowOnlineStoreXBox", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $724572, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "ShowOnlineStore", 
                    FncActiveConditional = "CanShowShowOnlineStorePS3", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $724573, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "EnterExtrasSequence", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $156621, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "RootList", 
                    FncOnSelect = "ExitGame", 
                    FncActiveConditional = "CanShowExitGame", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $176288, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "NewGameList", 
                    FncOnSelect = "NewGameMale", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $134501, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "NewGameList", 
                    FncOnSelect = "NewGameFemale", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $332799, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "NewGameList", 
                    FncOnSelect = "NewGamePlus", 
                    FncActiveConditional = "HasNewGamePlusSaves", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $680645, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "NewGameList", 
                    FncOnSelect = "LegacyImport", 
                    FncActiveConditional = "LegacyReady", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $342053, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "ExtrasList", 
                    FncOnSelect = "ShowAchievements", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $134502, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "ExtrasList", 
                    FncOnSelect = "ShowOptions", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $126265, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "ExtrasList", 
                    FncOnSelect = "ShowCredits", 
                    FncActiveConditional = "", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $134503, 
                    ShowNotification = FALSE
                   }, 
                   {
                    ListID = "ExtrasList", 
                    FncOnSelect = "ShowGameManual", 
                    FncActiveConditional = "CanShowGameManual", 
                    FncNotifyConditional = "", 
                    KmtOnSelect = "", 
                    Label = $387214, 
                    ShowNotification = FALSE
                   }
                  )
    ListSequences = ({SeqID = "RootSeq", ListID = "RootList", FncOnEntry = "EnterRootList", SeqStep = 0, Label = $0}, 
                     {SeqID = "RootSeq", ListID = "", FncOnEntry = "PrevStep", SeqStep = 1, Label = $0}, 
                     {SeqID = "NewGameSeq", ListID = "RootList", FncOnEntry = "EnterRootSequence", SeqStep = -1, Label = $0}, 
                     {SeqID = "NewGameSeq", ListID = "NewGameList", FncOnEntry = "EnterNewGameList", SeqStep = 0, Label = $344480}, 
                     {SeqID = "NewGameSeq", ListID = "", FncOnEntry = "PrevStep", SeqStep = 1, Label = $0}, 
                     {SeqID = "ExtrasSeq", ListID = "RootList", FncOnEntry = "EnterRootSequence", SeqStep = -1, Label = $0}, 
                     {SeqID = "ExtrasSeq", ListID = "ExtrasList", FncOnEntry = "EnterExtrasList", SeqStep = 0, Label = $156621}, 
                     {SeqID = "ExtrasSeq", ListID = "", FncOnEntry = "PrevStep", SeqStep = 1, Label = $0}
                    )
    Cursor_SeqID = "RootSeq"
    ExitToMainMenuSound = 'ReturnToMainMenu'
    ListUpdateInterval = 3.0
    CheckingDataMessageDelay = 0.25
    CheckingDataMessageMinimum = 2.0
    CheckingDLCMessage = $717410
    CheckingSaveDataMessage = $389294
    NoLoginStart = $337346
    ConfirmNoLoginStart = $163219
    CancelNoLoginStart = $163220
    srExitConfirm = $344610
    srYes = $153362
    srNo = $153363
    srOK = $152938
    srCancel = $168246
    srConnect = $584616
    srNoSpaceForCareer = $386067
    srContinueWithoutSaving = $346043
    srCancelNewCareer = $181674
    srDemoNetworkRequired = $701739
    srViewKinectManual = $724793
    srViewKinectManual_Ok = $153362
    srViewKinectManual_Cancel = $153363
}
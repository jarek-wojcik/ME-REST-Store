Class SFXSFHandler_Load extends SFXSFHandler_Save
    native
    config(UI);

enum ELoadGuiMode
{
    LoadGuiMode_Default,
    LoadGuiMode_NGPlus,
    LoadGuiMode_LegacyME2,
};
struct native SaveGUICareerRecord 
{
    var(SaveGUICareerRecord) string CareerName;
    var(SaveGUICareerRecord) string firstName;
    var(SaveGUICareerRecord) string className;
    var(SaveGUICareerRecord) array<SFXSavePair> CareerSaves;
    var(SaveGUICareerRecord) SaveTimeStamp CreationDate;
    var(SaveGUICareerRecord) int DeviceID;
    var(SaveGUICareerRecord) bool bActiveCareer;
    var(SaveGUICareerRecord) EOriginType Origin;
    var(SaveGUICareerRecord) ENotorietyType Notoriety;
};
const LoadOption_DeleteCareer = 8;
const LoadOption_SelectCareer = 7;
const LoadOption_InitializeCareers = 6;
const LoadOption_ChangeStorageDevice = 11;
const LoadOption_QuitToMainMenu = 5;
const LoadOption_DeleteGame = 4;
const LoadOption_LoadGame = 3;
const LoadOption_Initialize = 1;

var(SFXSFHandler_Load) array<SaveGUICareerRecord> CareerList;
var(SFXSFHandler_Load) transient array<SFXSaveDescriptor> CorruptedSaveGames;
var(SFXSFHandler_Load) config transient stringref LoadGameLoseProgressText;
var(SFXSFHandler_Load) config transient stringref ConfirmLoadGameText;
var(SFXSFHandler_Load) config transient stringref CancelLoadGameText;
var(SFXSFHandler_Load) config transient stringref CharNameText;
var(SFXSFHandler_Load) config transient stringref DeleteCareerText;
var(SFXSFHandler_Load) config transient stringref ConfirmDeleteCareerText;
var(SFXSFHandler_Load) config transient stringref CancelDeleteCareerText;
var(SFXSFHandler_Load) config transient stringref CorruptSaveWarningText;
var(SFXSFHandler_Load) config transient stringref ConfirmDeleteCorruptText;
var(SFXSFHandler_Load) config transient stringref CancelDeleteCorruptText;
var(SFXSFHandler_Load) config transient stringref LoadActionText;
var(SFXSFHandler_Load) config transient stringref CareerActionText;
var(SFXSFHandler_Load) config transient stringref SearchingForCareers;
var(SFXSFHandler_Load) config transient stringref srNewGamePlusLoadCareerConfirmation;
var(SFXSFHandler_Load) config transient stringref srSavedRachniiQueen;
var(SFXSFHandler_Load) config transient stringref srKilledRachniiQueen;
var(SFXSFHandler_Load) config transient stringref srAshSurvivedVirimire;
var(SFXSFHandler_Load) config transient stringref srKaidenSurvivedVirimire;
var(SFXSFHandler_Load) config transient stringref srSavedTheCouncil;
var(SFXSFHandler_Load) config transient stringref srSacrificedTheCouncil;
var(SFXSFHandler_Load) config transient stringref srDestroyedMaelonsData;
var(SFXSFHandler_Load) config transient stringref srNotDestroyedMaelonsData;
var(SFXSFHandler_Load) config transient stringref srWrexAlive;
var(SFXSFHandler_Load) config transient stringref srWrexDead;
var(SFXSFHandler_Load) config transient stringref srWrexIgnored;
var(SFXSFHandler_Load) config transient stringref srHeretics_Rewrite;
var(SFXSFHandler_Load) config transient stringref srHeretics_Destroyed;
var(SFXSFHandler_Load) config transient stringref srCollectorBase_Irradiate;
var(SFXSFHandler_Load) config transient stringref srCollectorBase_Destroyed;
var(SFXSFHandler_Load) config transient stringref srNumberSurvivors;
var(SFXSFHandler_Load) config transient stringref srME1_SFXRomanced_Ashley;
var(SFXSFHandler_Load) config transient stringref srME1_SFXRomanced_Kaidan;
var(SFXSFHandler_Load) config transient stringref srME1_SFXRomanced_Liara;
var(SFXSFHandler_Load) config transient stringref srME1_SFXRomanced_NO_ONE;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Tali;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Jack;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Thane;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Jacob;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Garrus;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_Miranda;
var(SFXSFHandler_Load) config transient stringref srME2_SFXRomanced_NO_ONE;
var(SFXSFHandler_Load) transient int CurrentCareerIndex;
var(SFXSFHandler_Load) BioGlobalVariableTable ImportPlotTable;
var BioSFHandler_MessageBox loadingCareerMessageBox;
var(SFXSFHandler_Load) bool bShouldRescanCareers;
var(SFXSFHandler_Load) bool bShowingSearchingCharacterOverlay;
var(SFXSFHandler_Load) ELoadGuiMode LoadMode;

public final event function AS_ScrollDetailsAnalog(float fScroll)
{
    ActionScriptVoid("loadSave.ImportRightPane.scrollDetailsAnalog");
}
public final native function BeginInitializeCareers();

public final native function BeginInitializeLoadList();

public native function Callback_ConfirmDeleteCorruptSaves(bool bAPressed, int Context);

public event function CheckForCorruptSaves()
{
    local SFXGUIInteraction GuiMan;
    local BioMessageBoxOptionalParams Params;
    
    if (CorruptedSaveGames.Length > 0)
    {
        GuiMan = oPanel.oParentManager;
        if (GuiMan == None)
        {
            return;
        }
        Params.srAText = ConfirmDeleteCorruptText;
        Params.srBText = CancelDeleteCorruptText;
        Params.bNoFade = TRUE;
        GuiMan.QueueNamedMessageBox('LoadMessageBox', 3, CorruptSaveWarningText, Params, Callback_ConfirmDeleteCorruptSaves, 0, GetPC());
        bWaitingOnMsgBox = TRUE;
    }
}
public final native function EndInitializeCareers(SFXSaveGameCommandEventArgs Args);

public final native function EndInitializeLoadList(SFXSaveGameCommandEventArgs Args);

public function GameSessionEnded()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.ClearStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
    Super(SFXGUIMovieLegacyAdapter).GameSessionEnded();
}
public final native function string GetNewGamePlusSaveSummary(SFXSaveGame aSave);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            AS_ScrollDetailsAnalog(fValue);
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final event function HideImportSearchOverlay()
{
    if (bShowingSearchingCharacterOverlay)
    {
        bShowingSearchingCharacterOverlay = FALSE;
        loadingCareerMessageBox.Close();
    }
}
public function Initialize()
{
    local SFXEngine Engine;
    local bool bStartInCareerSelection;
    local SFXCareerCacheEntry CareerCacheEntry;
    local SFXGUIInteraction UIMgr;
    local GUIDependency GD;
    
    LoadMode = ELoadGuiMode.LoadGuiMode_Default;
    UIMgr = GetSFXUIController();
    bStartInCareerSelection = TRUE;
    if (UIMgr.RetrieveGUIDependent(UIMgr.MovieTag_Load, GD) == TRUE)
    {
        switch (byte(GD.OptContext))
        {
            case 2:
                InitImportManager();
            case 1:
                LoadMode = byte(GD.OptContext);
                break;
            default:
                break;
        }
        UIMgr.AddGUIDependency(GD.SourceGUI, GD.DependentGUI, GD.OptContext, GD.OnDependency);
        if (GD.DependentGUI == UIMgr.MovieTag_MainMenu)
        {
            GuiMode = ESaveGuiMode.SaveGuiMode_MainMenu;
        }
    }
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (LoadMode == ELoadGuiMode.LoadGuiMode_Default && Engine != None && Engine.TryGetCachedCareer(Engine.GetCurrentSaveDescriptor().Career, CareerCacheEntry))
    {
        bStartInCareerSelection = FALSE;
    }
    SetLoadSave(FALSE, LoadMode == ELoadGuiMode.LoadGuiMode_LegacyME2, LoadMode == ELoadGuiMode.LoadGuiMode_NGPlus, int(GuiMode), int(ScreenLayout), bStartInCareerSelection);
    if (!bStartInCareerSelection)
    {
        InitializeLoadList();
    }
}
public final native function InitImportManager();

public event function OnPanelAdded()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    Super(SFXGUIMovieLegacyAdapter).OnPanelAdded();
    GetSFXUIController().HideMainMenu();
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.AddStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
}
public event function OnPanelRemoved()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInt = OnlineSub.SystemInterface;
        if (SystemInt != None)
        {
            SystemInt.ClearStorageDeviceChangeDelegate(OnStorageDeviceChanged);
        }
    }
    Super(SFXGUIMovieLegacyAdapter).OnPanelRemoved();
}
public event function OnStart()
{
    Super(SFXGUIMovie).OnStart();
    ImportPlotTable = new Class'BioGlobalVariableTable';
}
public final event function ShowImportSearchOverlay()
{
    local BioMessageBoxOptionalParams messageParams;
    
    if (!bShowingSearchingCharacterOverlay)
    {
        bShowingSearchingCharacterOverlay = TRUE;
        loadingCareerMessageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(GetPC());
        loadingCareerMessageBox.DisplayMessageBox(SearchingForCareers, messageParams);
    }
}
public function Callback_ConfirmDeleteCareer(bool bAPressed, int CareerIdx)
{
    local SFXEngine Engine;
    local SFXSaveDescriptor SaveDescriptor;
    
    if (bAPressed)
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Engine != None && CareerIdx >= 0 && CareerIdx < CareerList.Length)
        {
            GetSFXUIController().GetSaveLoadWidget().ShowDeletingMessage(TRUE);
            oPanel.SetInputDisabled(TRUE);
            SaveDescriptor.Career = CareerList[CareerIdx].CareerName;
            Engine.RemoveCachedCareer(CareerList[CareerIdx].CareerName);
            Engine.QueueSaveGameCommand(5, SaveDescriptor, SaveCommandCallback_InitializeCareers);
            bShouldRescanCareers = TRUE;
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public function Callback_ConfirmLoadGame(bool bAPressed, int Context)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    if (bAPressed)
    {
        PC = BioPlayerController(GetPC());
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                switch (LoadMode)
                {
                    case ELoadGuiMode.LoadGuiMode_NGPlus:
                        GetSFXUIController().RevokeGUIDependency(GetSFXUIController().MovieTag_Load);
                        Engine.ImportPlusCharacter(SaveList[Context].SaveGame);
                        BioWorldInfo(PC.WorldInfo).RequestStartPlusGame();
                        break;
                    case ELoadGuiMode.LoadGuiMode_LegacyME2:
                        GetSFXUIController().RevokeGUIDependency(GetSFXUIController().MovieTag_Load);
                        Engine.ImportLegacyCharacter(SaveList[Context].SaveGame);
                        BioWorldInfo(PC.WorldInfo).RequestStartLegacyGame();
                        break;
                    case ELoadGuiMode.LoadGuiMode_Default:
                    default:
                        oPanel.SetInputDisabled(TRUE);
                        if (Class'WorldInfo'.static.IsConsoleBuild())
                        {
                            GetSFXUIController().GetSaveLoadWidget().ShowLoadingMessage();
                        }
                        Engine.QueueSaveGameCommand(1, SaveList[Context].SaveDescriptor, LoadGameCallback);
                        break;
                }
            }
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public final function Callback_ConfirmNGPlusLoadGame(bool bAPressed, int Context)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    if (bAPressed && LoadMode == ELoadGuiMode.LoadGuiMode_NGPlus && CareerList[Context].CareerSaves.Length > 0)
    {
        PC = BioPlayerController(GetPC());
        if (PC != None)
        {
            Engine = SFXEngine(PC.Player.Outer);
            if (Engine != None)
            {
                GetSFXUIController().RevokeGUIDependency(GetSFXUIController().MovieTag_Load);
                Engine.ImportPlusCharacter(CareerList[Context].CareerSaves[0].Save);
                BioWorldInfo(PC.WorldInfo).RequestStartPlusGame();
            }
        }
    }
    bWaitingOnMsgBox = FALSE;
}
public final function DeleteCareer(int nCareerIdx)
{
    local BioMessageBoxOptionalParams Params;
    
    if (nCareerIdx >= 0 && nCareerIdx < CareerList.Length)
    {
        Params.srAText = ConfirmDeleteCareerText;
        Params.srBText = CancelDeleteCareerText;
        Params.bNoFade = TRUE;
        GetSFXUIController().QueueNamedMessageBox('LoadMessageBox', 3, DeleteCareerText, Params, Callback_ConfirmDeleteCareer, nCareerIdx, GetPC());
        bWaitingOnMsgBox = TRUE;
    }
}
public function DeleteGame(int nIndex)
{
    local BioMessageBoxOptionalParams Params;
    
    if (nIndex >= 0 && nIndex < SaveList.Length)
    {
        Params.srAText = ConfirmDeleteGameText;
        Params.srBText = CancelDeleteGameText;
        Params.bNoFade = TRUE;
        GetSFXUIController().QueueNamedMessageBox('LoadMessageBox', 3, DeleteGameText, Params, Callback_ConfirmDelete, nIndex, GetPC());
        bWaitingOnMsgBox = TRUE;
    }
}
public function FillCareerListCallback_InitializeLoadList()
{
    if (CareerList.Length > 0)
    {
        InitializeLoadList(CurrentCareerIndex);
    }
}
public final function string GetPlotSummary(int nSaveIndex)
{
    local PlayerInfoEx PlayerData;
    local PlayerInfoEx CachedGlobalVarPlayerData;
    local SFXSaveGame aSave;
    local string strPlotSummary;
    local bool bRachniiQueenSaved;
    local bool bAshSurvivedVirimire;
    local bool bSavedTheCouncil;
    local bool bSavedMaelonsData;
    local bool bDestroyedMaelonsData;
    local SFXME1Plot_WrexState eWrexState;
    local SFXME2Plot_HereticsState eHereticsState;
    local SFXME2Plot_CollectorBaseState eCollectorBaseState;
    local int nNumberOfSuicideMissionSurviviors;
    local SFXRomanced eME1Romance;
    local SFXRomanced eME2Romance;
    local array<SFXTokenMapping> Tokens;
    local BioGlobalVariableTable GlobalVarTable;
    
    strPlotSummary = "";
    if (SaveList.Length > nSaveIndex)
    {
        GlobalVarTable = oWorldInfo.GetGlobalVariables();
        GlobalVarTable.GetPlayerPlotData(CachedGlobalVarPlayerData);
        aSave = SaveList[nSaveIndex].SaveGame;
        PlayerData.bIsFemale = aSave.PlayerRecord.bIsFemale;
        PlayerData.Origin = aSave.PlayerRecord.Origin;
        PlayerData.Notoriety = aSave.PlayerRecord.Notoriety;
        GlobalVarTable.SetPlayerPlotData(PlayerData);
        ImportPlotTable.SetNewGamePlotStates(SaveList[nSaveIndex].SaveGame, None, PlayerData, FALSE);
        bRachniiQueenSaved = ImportPlotTable.MajorPlot_ME1_RachniiQueenSaved();
        bAshSurvivedVirimire = ImportPlotTable.MajorPlot_ME1_VirmireSurvivor_IsAsh();
        bSavedTheCouncil = ImportPlotTable.MajorPlot_ME1_SavedTheCouncil();
        bSavedMaelonsData = ImportPlotTable.MajorPlot_ME2_SavedMaelonsData();
        bDestroyedMaelonsData = ImportPlotTable.MajorPlot_ME2_DestroyedMaelonsData();
        eWrexState = ImportPlotTable.MajorPlot_ME1_WrexStatus();
        eHereticsState = ImportPlotTable.MajorPlot_ME2_HerteticsStatus();
        eCollectorBaseState = ImportPlotTable.MajorPlot_ME2_CollectorBaseStatus();
        nNumberOfSuicideMissionSurviviors = ImportPlotTable.MajorPlot_ME2_NumberOfSuicideMissionSurvivors();
        eME1Romance = ImportPlotTable.MajorPolt_ME1_Romance();
        eME2Romance = ImportPlotTable.MajorPlot_ME2_Romance();
        strPlotSummary = "<ul>";
        strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(bRachniiQueenSaved == TRUE ? srSavedRachniiQueen : srKilledRachniiQueen) $ "</li>";
        strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(bAshSurvivedVirimire == TRUE ? srAshSurvivedVirimire : srKaidenSurvivedVirimire) $ "</li>";
        strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(bSavedTheCouncil == TRUE ? srSavedTheCouncil : srSacrificedTheCouncil) $ "</li>";
        if (bSavedMaelonsData != bDestroyedMaelonsData)
        {
            strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(bDestroyedMaelonsData == TRUE ? srDestroyedMaelonsData : srNotDestroyedMaelonsData) $ "</li>";
        }
        switch (eWrexState)
        {
            case SFXME1Plot_WrexState.WREX_ALIVE:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srWrexAlive) $ "</li>";
                break;
            case SFXME1Plot_WrexState.WREX_DEAD:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srWrexDead) $ "</li>";
                break;
            case SFXME1Plot_WrexState.WREX_IGNORED:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srWrexIgnored) $ "</li>";
                break;
            default:
        }
        switch (eHereticsState)
        {
            case SFXME2Plot_HereticsState.Heretics_Rewrite:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srHeretics_Rewrite) $ "</li>";
                break;
            case SFXME2Plot_HereticsState.Heretics_Destroyed:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srHeretics_Destroyed) $ "</li>";
                break;
            case SFXME2Plot_HereticsState.Heretics_NotComplete:
                break;
            default:
        }
        switch (eCollectorBaseState)
        {
            case SFXME2Plot_CollectorBaseState.CollectorBase_Irradiate:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srCollectorBase_Irradiate) $ "</li>";
                break;
            case SFXME2Plot_CollectorBaseState.CollectorBase_Destroyed:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srCollectorBase_Destroyed) $ "</li>";
                break;
            default:
        }
        Tokens.Length = 0;
        Tokens.Add(1);
        Tokens[0].TokenId = 0;
        Tokens[0].Data = string(nNumberOfSuicideMissionSurviviors);
        strPlotSummary = strPlotSummary $ "<li>" $ GetTokenizedUIString(srNumberSurvivors, Tokens) $ "</li>";
        switch (eME1Romance)
        {
            case SFXRomanced.SFXRomanced_Ashley:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME1_SFXRomanced_Ashley) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Kaidan:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME1_SFXRomanced_Kaidan) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Liara:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME1_SFXRomanced_Liara) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_NO_ONE:
            default:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME1_SFXRomanced_NO_ONE) $ "</li>";
                break;
        }
        switch (eME2Romance)
        {
            case SFXRomanced.SFXRomanced_Miranda:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Miranda) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Garrus:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Garrus) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Jacob:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Jacob) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Thane:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Thane) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Jack:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Jack) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_Tali:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_Tali) $ "</li>";
                break;
            case SFXRomanced.SFXRomanced_NO_ONE:
            default:
                strPlotSummary = strPlotSummary $ "<li>" $ GetUIString(srME2_SFXRomanced_NO_ONE) $ "</li>";
                break;
        }
        strPlotSummary = strPlotSummary $ "</ul>";
        ImportPlotTable.ClearAllVariables();
        GlobalVarTable.SetPlayerPlotData(CachedGlobalVarPlayerData);
    }
    return strPlotSummary;
}
public function InitializeLoadList(optional int CareerIdx = -1)
{
    CurrentCareerIndex = CareerIdx;
    BeginInitializeLoadList();
}
public final function LaunchNGPlusSaveFromCareer(int nCareerIdx)
{
    local BioMessageBoxOptionalParams Params;
    
    if (nCareerIdx >= 0 && nCareerIdx < CareerList.Length && CareerList[nCareerIdx].CareerSaves.Length > 0)
    {
        Params.srAText = ConfirmLoadGameText;
        Params.srBText = CancelLoadGameText;
        Params.bNoFade = TRUE;
        GetSFXUIController().QueueNamedMessageBoxEx('LaunchNGPlusSaveFromCareer', 3, GetNewGamePlusSaveSummary(CareerList[nCareerIdx].CareerSaves[0].Save), Params, Callback_ConfirmNGPlusLoadGame, nCareerIdx, GetPC());
        bWaitingOnMsgBox = TRUE;
    }
}
public final function LoadGame(int nIndex)
{
    local BioMessageBoxOptionalParams Params;
    
    if (nIndex >= 0 && nIndex < SaveList.Length)
    {
        if (GuiMode == ESaveGuiMode.SaveGuiMode_MainMenu || GuiMode == ESaveGuiMode.SaveGuiMode_GameOver)
        {
            Callback_ConfirmLoadGame(TRUE, nIndex);
        }
        else
        {
            Params.srAText = ConfirmLoadGameText;
            Params.srBText = CancelLoadGameText;
            Params.bNoFade = TRUE;
            GetSFXUIController().QueueNamedMessageBox('LoadMessageBox', 3, LoadGameLoseProgressText, Params, Callback_ConfirmLoadGame, nIndex, GetPC());
            bWaitingOnMsgBox = TRUE;
        }
    }
}
private final function LoadGameCallback(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    if (Class'WorldInfo'.static.IsConsoleBuild())
    {
        GetSFXUIController().GetSaveLoadWidget().HideLoadingMessage();
    }
    if (Args.bSuccess)
    {
        GetSFXUIController().RevokeGUIDependency(GetSFXUIController().MovieTag_Load);
        SFXEngine(Class'Engine'.static.GetEngine()).LoadSaveFromCallback(Args);
    }
}
public function OnStorageDeviceChanged()
{
    local SFXGUIInteraction GuiMan;
    
    GuiMan = GetSFXUIController();
    if (GuiMan != None)
    {
        GuiMan.RemoveNamedMessageBox('LoadMessageBox', GetPC());
        bWaitingOnMsgBox = FALSE;
    }
    oPanel.InvokeMethod("loadSave.InitializeCharacterSelectionScreen");
}
public final function QuitToMainMenu()
{
    local SFXGUIInteraction UIMgr;
    local GUIDependency GD;
    local delegate<SFXGUIInteraction.OnDependencyEvent> OnDependency;
    
    UIMgr = GetSFXUIController();
    if (UIMgr.RetrieveGUIDependent(UIMgr.MovieTag_Load, GD) == TRUE)
    {
        OnDependency = GD.OnDependency;
        OnDependency(bShouldRescanCareers);
        Close(TRUE);
    }
    else
    {
        GetSFXUIController().HackReloadMainMenu();
    }
}
public function ResetGui(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    BeginInitializeLoadList();
}
public function SaveCommandCallback_InitializeCareers(SFXSaveGameCommandEventArgs Args)
{
    oPanel.SetInputDisabled(FALSE);
    BeginInitializeCareers();
}
public final function SelectCareer(int nCareerIdx)
{
    if (nCareerIdx >= 0 && nCareerIdx < CareerList.Length)
    {
        InitializeLoadList(nCareerIdx);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoadGameLoseProgressText = $152355
    ConfirmLoadGameText = $147164
    CancelLoadGameText = $147165
    CharNameText = $170915
    DeleteCareerText = $165655
    ConfirmDeleteCareerText = $147164
    CancelDeleteCareerText = $147165
    CorruptSaveWarningText = $344331
    ConfirmDeleteCorruptText = $147164
    CancelDeleteCorruptText = $147165
    LoadActionText = $166170
    CareerActionText = $163280
    SearchingForCareers = $724258
    srNewGamePlusLoadCareerConfirmation = $724270
    srSavedRachniiQueen = $724054
    srKilledRachniiQueen = $724055
    srAshSurvivedVirimire = $724056
    srKaidenSurvivedVirimire = $724057
    srSavedTheCouncil = $724058
    srSacrificedTheCouncil = $724059
    srDestroyedMaelonsData = $724060
    srNotDestroyedMaelonsData = $724061
    srWrexAlive = $724062
    srWrexDead = $724063
    srWrexIgnored = $724064
    srHeretics_Rewrite = $724065
    srHeretics_Destroyed = $724066
    srCollectorBase_Irradiate = $724067
    srCollectorBase_Destroyed = $724068
    srNumberSurvivors = $724069
    srME1_SFXRomanced_Ashley = $724070
    srME1_SFXRomanced_Kaidan = $724071
    srME1_SFXRomanced_Liara = $724072
    srME1_SFXRomanced_NO_ONE = $724073
    srME2_SFXRomanced_Tali = $724078
    srME2_SFXRomanced_Jack = $724079
    srME2_SFXRomanced_Thane = $724074
    srME2_SFXRomanced_Jacob = $724075
    srME2_SFXRomanced_Garrus = $724077
    srME2_SFXRomanced_Miranda = $724080
    srME2_SFXRomanced_NO_ONE = $724081
}
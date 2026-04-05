Class SFXGUIInteraction extends GFxInteraction
    native
    transient
    config(UI);

struct native GUIDependency 
{
    var delegate<OnDependencyEvent> OnDependency;
    var Name SourceGUI;
    var Name DependentGUI;
    var int OptContext;
};
struct native PlayerGuiData 
{
    var array<BioMessageBoxData> aMessageBoxQueue;
};
struct native SFXStringMap 
{
    var stringref From;
    var stringref To;
};
struct native SFXKeyNameControlToken 
{
    var Name Key;
    var Name token;
};
struct native SFXControlTokenAlias 
{
    var Name From;
    var Name To;
};
struct native SFXSFControlToken 
{
    var string TexturePath;
    var string Resource;
    var string Align;
    var string VAlign;
    var Name token;
    var int Height;
    var int Width;
    var int FontVScale;
    var int VSpace;
    var bool Cook;
    
    structdefaultproperties
    {
        FontVScale = 100
    }
};
struct native SFXFontMap 
{
    var string Locale;
    var string FontExportName;
    var string SubstituteFont;
    var Name FontGFxResource;
    var float ScaleFactor;
    var SFXFontStyle Style;
    
    structdefaultproperties
    {
        ScaleFactor = 1.0
    }
};
enum SFXFontStyle
{
    SFXFONT_Normal,
    SFXFONT_Italic,
    SFXFONT_Bold,
    SFXFONT_BoldItalic,
    SFXFONT_FauxItalic,
    SFXFONT_FauxBold,
    SFXFONT_FauxBoldItalic,
};
struct native SFXSharedAssetMap 
{
    var Name SharedFile;
    var Name GFxResource;
};
struct native SFXGUIMovieData 
{
    var string MovieClass;
    var string GFxResource;
    var string HUDTypeToAutoLoadFor;
    var Name Tag;
    var float CurvePixelError;
    var int ZOrder;
    var bool UseEdgeAA;
    var bool bAutoStart;
    var bool bAutoVisible;
    var bool bSwfDevAutoReopen;
    var EConsoleType Platform;
    var SFMovieStrokeStyle StrokeStyle;
    
    structdefaultproperties
    {
        HUDTypeToAutoLoadFor = "None"
        CurvePixelError = 1.0
        UseEdgeAA = TRUE
        bAutoStart = TRUE
        bAutoVisible = TRUE
        bSwfDevAutoReopen = TRUE
        StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
    }
};

var native Map_Mirror m_PlayerData;
var native Map_Mirror m_UnrealKeyToGfxKeyMap;
var config array<SFXGUIMovieData> MovieLibrary;
var config array<SFXSharedAssetMap> SharedAssetLibrary;
var config array<SFXFontMap> FontMap;
var config array<SFXSFControlToken> ControlTokens;
var array<SFXControlTokenAlias> ControlTokenAliases;
var config array<SFXStringMap> StringMappings;
var array<SFXKeyNameControlToken> SFXKeyNameControlTokens;
var array<GUIDependency> GUIDependencies;
var array<BioSFHandler_MessageBox> m_aHintStack;
var delegate<OnCloseCallback> __OnCloseCallback__Delegate;
var delegate<OnDependencyEvent> __OnDependencyEvent__Delegate;
var Name MovieTag_Reticle;
var Name MovieTag_PowerWheel;
var Name MovieTag_HUD;
var Name MovieTag_Conversation;
var Name MovieTag_BlackScreen;
var Name MovieTag_SkillGameDecryption;
var Name MovieTag_SkillGameBypass;
var Name MovieTag_IntroText;
var Name MovieTag_LoadMovieDefault;
var Name MovieTag_SniperOverlay;
var Name MovieTag_MenuBrowser;
var Name MovieTag_MainMenu;
var Name MovieTag_MissionCompletion;
var Name MovieTag_PRCStore;
var Name MovieTag_Store;
var Name MovieTag_Terminal;
var Name MovieTag_Training;
var Name MovieTag_Elevator;
var Name MovieTag_Mail;
var Name MovieTag_Splash;
var Name MovieTag_GalaxyMap;
var Name MovieTag_ChoiceGUI;
var Name MovieTag_PartySelect;
var Name MovieTag_Personalization;
var Name MovieTag_NewCharacter;
var Name MovieTag_Options;
var Name MovieTag_Journal;
var Name MovieTag_Codex;
var Name MovieTag_Manual;
var Name MovieTag_Accomplishments;
var Name MovieTag_NetworkRegistration;
var Name MovieTag_GameOver;
var Name MovieTag_SquadRecord;
var Name MovieTag_Credits;
var Name MovieTag_DesignerUI;
var Name MovieTag_Specialization;
var Name MovieTag_Save;
var Name MovieTag_Load;
var Name MovieTag_AreaMap;
var Name MovieTag_MessageBox;
var Name MovieTag_QueuedMessageBox;
var Name MovieTag_HintBox;
var Name MovieTag_Slideshow;
var Name MovieTag_Markers;
var Name MovieTag_ObjectiveText;
var Name MovieTag_WeaponSelect;
var Name MovieTag_PlayerCountdown;
var Name MovieTag_GalaxyAtWar;
var Name MovieTag_WarAssets;
var Name MovieTag_OpeningTitles;
var Name MovieTag_SaveIndicatorMessage;
var Name MovieTag_AtlasHUD;
var Name MovieTag_MPEndOfMatch;
var Name MovieTag_MPLobby;
var Name MovieTag_MPAppearance;
var Name MovieTag_MPMatchResults;
var Name MovieTag_MPSelectKit;
var Name MovieTag_Leaderboard;
var Name MovieTag_MPScoretags;
var Name MovieTag_MPPauseMenu;
var Name MovieTag_MPOptions;
var Name MovieTag_MPMatchConsumables;
var Name MovieTag_MPStore;
var Name MovieTag_MPReinforcementsReveal;
var Name MovieTag_MPHUD;
var Name MovieTag_MPNewLobby;
var Name MovieTag_MPLobbyStatusBars;
var Name MovieTag_MPPromotion;
var Name m_nmCurrentVoice;
var Name m_nmCurrentMusic;
var BioSFResources m_oSFResources;
var SFXGUIInputHandler InputHandler;
var editinline export WwiseAudioComponent m_wwiseComponent;
var SFXPawn_Player ImportedTemplatePawn;
var SFXSaveLoadWidgetProxy m_oSavingLoadingDisplayProxy;
var transient SFXAreaMapData m_CurrentAreaMap;
var int m_nMaxHintStackHeight;
var BioSFHandler_MessageBox m_oPreloadedHint;
var config bool ReplaceRegisteredTMWithFullHeightChar;
var bool m_bDesiredMouseVisibility;
var bool bFullGuiSoundLogging;
var bool m_bGameWasPaused;
var bool HACK_IgnoreTurnBlackScreenOffForMP;
var MEBrowserWheelSubPages m_eLastBrowserWheelSubPage;

public final event function AddGUIDependency(Name SourceGUI, Name DependentGUI, optional int OptContext = 0, optional delegate<OnDependencyEvent> OnDependencyEvent = NullDependency)
{
    local GUIDependency GD;
    
    GD.SourceGUI = SourceGUI;
    GD.DependentGUI = DependentGUI;
    GD.OptContext = OptContext;
    GD.OnDependency = OnDependencyEvent;
    GUIDependencies.AddItem(GD);
}
public final native function AddLogEntry(const out string sMessage, const float fTimeToLive, const out Color Clr);

public final event function bool BeginInitCharacterCreation()
{
    local BioWorldInfo oWorldInfo;
    local Pawn P;
    local Pawn ImportedPlaced;
    local Pawn GenderPawnArchetype;
    local SFXEngine Engine;
    local PlayerSaveRecord PlayerRecord;
    local string GenderArchName;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine == None)
    {
        return FALSE;
    }
    if (Engine.PlusImportSaveGame != None)
    {
        Engine.PlusImportSaveGame.GetPlayerRecord(PlayerRecord);
    }
    else if (Engine.LegacyImportSaveGame != None)
    {
        Engine.LegacyImportSaveGame.GetPlayerRecord(PlayerRecord);
    }
    else
    {
        return FALSE;
    }
    foreach oWorldInfo.AllPawns(Class'Pawn', P)
    {
        if (P.Tag == 'Custom_Male_Template')
        {
            ImportedPlaced = P;
            break;
        }
    }
    if (ImportedPlaced == None)
    {
        return FALSE;
    }
    if (PlayerRecord.bIsFemale)
    {
        GenderArchName = SFXGame(oWorldInfo.Game).FCharCreationArchName;
    }
    else
    {
        GenderArchName = SFXGame(oWorldInfo.Game).MCharCreationArchName;
    }
    GenderPawnArchetype = Pawn(Engine.GetSeekFreeObject(GenderArchName, Class'SFXPawn_Player'));
    ImportedTemplatePawn = oWorldInfo.Game.Spawn(Class'SFXPawn_PlayerSoldierNonCombat', None, , ImportedPlaced.location, ImportedPlaced.Rotation, GenderPawnArchetype, TRUE);
    ImportedTemplatePawn.Tag = 'Imported_Custom_Male_Template';
    ImportedTemplatePawn.BioSetDesiredRotation(rot(0, 0, 0), TRUE);
    ImportedTemplatePawn.SetCollision(TRUE, FALSE, TRUE);
    ImportedTemplatePawn.SetHidden(TRUE);
    if (Engine.PlusImportSaveGame != None)
    {
        Engine.PlusImportSaveGame.LoadMorphHead(ImportedTemplatePawn);
    }
    else if (Engine.LegacyImportSaveGame != None)
    {
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}
public event function CancelHint(optional PlayerController oPlayerController)
{
    local BioPlayerController PC;
    local int Index;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    if (m_aHintStack.Length == 0)
    {
        return;
    }
    while (m_aHintStack[Index] == None)
    {
        Index++;
        if (Index >= m_aHintStack.Length)
        {
            return;
        }
    }
    m_aHintStack[Index].HideMessageBox(m_aHintStack[Index] != m_oPreloadedHint);
    m_aHintStack[Index] = None;
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.HintSystem.m_nCurrentlyDisplayedHint = -1;
    }
}
public final native function CancelLeaderActive(PlayerController oPlayerController);

public final native function coerce SFXGUIMovie CastGetMovie(Class<SFXGUIMovie> Type, PlayerController i_pOwningPlayer, Name nmMovieTag);

public final native function coerce SFXGUIMovie CastOpenMovie(Class<SFXGUIMovie> Type, PlayerController i_pOwningPlayer, Name nmMovieTag, optional bool bStart = TRUE, optional bool bStartPaused = FALSE, optional bool bForceNewInstance = FALSE);

private final native function CleanupMessageBoxQueues();

public native function ClearAll();

public native function BioSFHandler_ChoiceGUI CreateChoiceGUI(optional Name nmTag, optional PlayerController oPlayerController, optional bool bForceNewInstance = FALSE);

public native function SFXGUI_Elevator CreateElevatorGUI(optional Name nmTag, optional PlayerController oPlayerController, optional bool bForceNewInstance = FALSE);

public native function BioSFHandler_MessageBox CreateMessageBox(PlayerController oPlayerController);

public event function SFXSFHandler_EANetworking CreateNetworkGUI(Name HandlerId, PlayerController oPlayerController)
{
    local SFXSFHandler_EANetworking oHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oHandler = CastOpenMovie(Class'SFXSFHandler_EANetworking', oPlayerController, HandlerId, TRUE);
    return oHandler;
}
public native function BioSFHandler_MessageBox CreateQueuedMessageBox(PlayerController oPlayerController);

public native function SFXGUI_Store CreateStoreGUI(optional Name nmTag, optional PlayerController oPlayerController, optional bool bForceNewInstance = FALSE);

public native function SFXGUI_Terminal CreateTerminalGUI(optional Name nmTag, optional PlayerController oPlayerController, optional bool bForceNewInstance = FALSE);

public event function DestroyNetworkGUI(Name HandlerId, PlayerController oPlayerController)
{
    local SFXGUIMovie oMovie;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oMovie = GetMovie(oPlayerController, HandlerId);
    if (oMovie != None)
    {
        oMovie.Close(TRUE);
    }
}
public final native function ForceSquadCommandFeedback(SFXDisplayableSquadCommands Command, int MemberIdx, bool bCommandSuccess, PlayerController oPlayerController);

public final native function GetAllMovies(out array<SFXGUIMovie> aOpen, out array<SFXGUIMovie> aTexture);

public final native function BioSFHandler_BrowserWheel GetBrowserHandler(PlayerController oPlayerController);

public final native function SFXSFHandler_HUD GetCachedHudHandler(PlayerController oPlayerController);

public final native function BioSFHandler_DesignerUI GetDUIHandler(PlayerController oPlayerController);

public final native function SFXGUIMovie GetFocusMovieForPlayerController(PlayerController oPlayerController);

public static final native function SFXGUIInteraction GetInstance();

public final native function SFXGUIMovie GetMovie(PlayerController i_pOwningPlayer, Name nmMovieTag);

public final native function GetMovies(PlayerController i_pOwningPlayer, Name nmMovieTag, out array<SFXGUIMovie> aMovies);

public final native function PlayerController GetPlayerControllerFromControllerId(int nControllerId);

public event function SFXSaveLoadWidgetProxy GetSaveLoadWidget()
{
    if (m_oSavingLoadingDisplayProxy == None)
    {
        m_oSavingLoadingDisplayProxy = new (Self) Class'SFXSaveLoadWidgetProxy';
    }
    return m_oSavingLoadingDisplayProxy;
}
public function WorldInfo GetWorldInfo()
{
    return Class'Engine'.static.GetCurrentWorldInfo();
}
public native function HackReloadMainMenu();

public final native function HandleInputEvent(int ControllerId, BioGuiEvents Event, optional float fCooldown = 0.0, optional float fValue = 1.0, optional float fDeadzoneValue = 1.0);

public final event function HideBlackScreen(PlayerController oPlayerController, bool bWithFade, optional float FadeTime)
{
    local BioSFHandler_BlackScreen oBlackScreenHandler;
    
    if (bWithFade == FALSE && HACK_IgnoreTurnBlackScreenOffForMP)
    {
        HACK_IgnoreTurnBlackScreenOffForMP = FALSE;
        return;
    }
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBlackScreenHandler = BioSFHandler_BlackScreen(GetMovie(oPlayerController, MovieTag_BlackScreen));
    if (oBlackScreenHandler != None)
    {
        oBlackScreenHandler.Hide(bWithFade, FadeTime);
    }
}
public final event function HideBrowserWheel(optional SFXGUIMovie oCurrentPanel, optional PlayerController oPlayerController)
{
    local BioPlayerController PC;
    local BioSFHandler_DesignerUI oDUIPanel;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    if (oCurrentPanel != None)
    {
        RemovePanel(oCurrentPanel);
    }
    else
    {
        RemoveMovie(oPlayerController, MovieTag_MenuBrowser);
    }
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(9);
        PC.WorldInfo.PauseGame(m_bGameWasPaused);
    }
    oDUIPanel = CastGetMovie(Class'BioSFHandler_DesignerUI', oPlayerController, MovieTag_DesignerUI);
    if (oDUIPanel != None && oDUIPanel.nElementVisibleCount == 0)
    {
        oDUIPanel.SetVisible(FALSE);
    }
    PlayGuiSound('InGameGuiExit');
}
public final event function HideClimbMantleWidget(PlayerController oPlayerController);

public final event function HideConversationGui(PlayerController oPlayerController)
{
    local BioSFHandler_Conversation oConversationHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oConversationHandler = BioSFHandler_Conversation(GetMovie(oPlayerController, MovieTag_Conversation));
    if (oConversationHandler != None)
    {
        oConversationHandler.SetMovieFocus(FALSE);
        oConversationHandler.SetEnabled(FALSE);
    }
}
public final event function HideCoverWidget(PlayerController oPlayerController);

public event function HideHint(optional PlayerController oPlayerController)
{
    local BioSFHandler_MessageBox oStackHint;
    local int N;
    local int nUsedCount;
    local int nStackTop;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    nUsedCount = 0;
    nStackTop = 0;
    for (N = 0; N < m_aHintStack.Length; ++N)
    {
        oStackHint = m_aHintStack[N];
        if (oStackHint != None)
        {
            ++nUsedCount;
            oStackHint.SetVisible(FALSE);
            if (nUsedCount > m_nMaxHintStackHeight)
            {
                oStackHint.HideMessageBox(oStackHint != m_oPreloadedHint, TRUE);
                m_aHintStack[N] = None;
                continue;
            }
            nStackTop = Max(N, nStackTop);
        }
    }
    m_aHintStack.Length = nStackTop + 1;
    m_aHintStack.Insert(0, 1);
    m_aHintStack[0] = None;
}
public final event function HideMainMenu(optional bool bDestroy = FALSE, optional PlayerController oPlayerController)
{
    local BioSFHandler_MainMenu oHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oHandler = CastGetMovie(Class'BioSFHandler_MainMenu', oPlayerController, MovieTag_MainMenu);
    if (oHandler != None)
    {
        if (bDestroy)
        {
            oHandler.Close(TRUE);
        }
        else
        {
            oHandler.SetEnabled(FALSE);
        }
    }
}
public final native function HideMessageBoxes(optional PlayerController pPlayerController);

public final native function HideQueuedMessageBoxes(optional PlayerController pPlayerController);

public final event function HideSkillGameBypass(PlayerController oPlayerController)
{
    local BioPlayerController PC;
    local BioSkillGame_Bypass_Handler oSkillGamePanel;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oSkillGamePanel = CastGetMovie(Class'BioSkillGame_Bypass_Handler', oPlayerController, MovieTag_SkillGameBypass);
    if (oSkillGamePanel != None)
    {
        RemovePanel(oSkillGamePanel);
        PC = BioPlayerController(oPlayerController);
        if (PC != None)
        {
            PC.GameModeManager2.DisableMode(9);
        }
    }
}
public final event function HideSkillGameDecryption(PlayerController oPlayerController)
{
    local BioPlayerController PC;
    local BioSkillGame_Decryption_Handler oSkillGame;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oSkillGame = CastGetMovie(Class'BioSkillGame_Decryption_Handler', oPlayerController, MovieTag_SkillGameDecryption);
    if (oSkillGame != None)
    {
        oSkillGame.Close(TRUE);
        PC = BioPlayerController(oPlayerController);
        if (PC != None)
        {
            PC.GameModeManager2.DisableMode(9);
        }
        RestoreHint(oPlayerController);
    }
}
public final event function HideSkillGames(PlayerController oPlayerController)
{
    local BioPlayerController PC;
    local BioWorldInfo oBWorldInfo;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oBWorldInfo != None)
    {
        oBWorldInfo.TimerList.KillTimer("HandleSkillGameButtonTimeout");
        oBWorldInfo.TimerList.KillTimer("HandleSkillGameDisplayButton");
    }
    RemoveMovie(oPlayerController, MovieTag_SkillGameDecryption);
    RemoveMovie(oPlayerController, MovieTag_SkillGameBypass);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(9);
        PC.WorldInfo.bPlayersOnly = m_bGameWasPaused;
    }
}
public final event function InterruptActiveSkillGame(PlayerController oPlayerController)
{
    local BioSkillGame_Base_Handler handler;
    local array<Name> skillGameTags;
    local int i;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    skillGameTags[0] = MovieTag_SkillGameDecryption;
    skillGameTags[1] = MovieTag_SkillGameBypass;
    for (i = 0; i < skillGameTags.Length; i++)
    {
        handler = CastGetMovie(Class'BioSkillGame_Base_Handler', oPlayerController, skillGameTags[i]);
        if (handler != None)
        {
            handler.Cancel();
            break;
        }
    }
}
public final event function bool IsCharacterCreationStillBlocking()
{
    if (ImportedTemplatePawn != None)
    {
        ImportedTemplatePawn.UpdateAppearanceAsync();
    }
    return ImportedTemplatePawn != None && ImportedTemplatePawn.HasPendingMorphData();
}
public final native function bool IsControllerStickSouthpaw(PlayerController oPlayerController);

public final native function bool IsControllerTriggerShoulderSwapped(PlayerController oPlayerController);

public final native function bool IsControllerTriggerSouthpaw(PlayerController oPlayerController);

public final native function bool IsEnterMenuButtonAssignmentSwapped();

public final event function bool IsInSplashScreen()
{
    local SFXGUI_SplashScreen oSplashScreen;
    local PlayerController oPlayerController;
    
    oPlayerController = ValidatePlayerController(None);
    oSplashScreen = CastGetMovie(Class'SFXGUI_SplashScreen', oPlayerController, MovieTag_Splash);
    if (oSplashScreen != None && !oSplashScreen.bPressedStart)
    {
        return TRUE;
    }
    return FALSE;
}
public native function NotifyGameSessionEnded();

public native function NotifyLanguageChanged();

public event function NullDependency(optional bool bRescanCareers = FALSE);

public delegate function OnCloseCallback();

public delegate function OnDependencyEvent(optional bool bRescanCareers = FALSE);

public final native function bool OnMovieClosed(SFXGUIMovie i_MovieToClose);

public final native function SFXGUIMovie OpenMovie(PlayerController i_pOwningPlayer, Name nmMovieTag, optional bool bStart = TRUE, optional bool bStartPaused = FALSE, optional bool bForceNewInstance = FALSE);

public final native function PlayGuiMusic(Name nmMusic, optional bool bRestart = FALSE);

public final native function bool PlayGuiSound(Name nmSound);

public final native function PlayGuiVoice(Name nmVoice);

public function PostBeginPlay();

public final native function QueuedMessageBoxCallback(bool bAPressed, int nContext);

public final native function bool QueueNamedMessageBox(Name nmName, int nPriority, stringref srMessage, out BioMessageBoxOptionalParams stParams, delegate<BioSFHandler_MessageBox.InputCallback> pCallback, optional int nContext = 0, optional PlayerController pPlayerController, optional bool persistThroughTravel = FALSE);

public final native function bool QueueNamedMessageBoxEx(Name nmName, int nPriority, string sMessage, out BioMessageBoxOptionalParams stParams, delegate<BioSFHandler_MessageBox.InputCallback> pCallback, optional int nContext = 0, optional PlayerController pPlayerController, optional bool persistThroughTravel = FALSE);

public final native function bool QueueWeaponBox(Name nmName, int nPriority, string sWeaponClass, delegate<BioSFHandler_MessageBox.WeaponChoiceCallback> pCallback);

public final native function RemoveMovie(PlayerController oPlayerController, Name nmMovieTag);

public final native function RemoveMoviesForPlayer(PlayerController oPlayerController);

public final native function RemoveNamedMessageBox(Name nmName, optional PlayerController pPlayerController);

public native function RemovePanel(SFXGUIMovie pMovie);

public final native function ReSortMovies();

public event function RestoreHint(optional PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    if (m_aHintStack.Length > 0)
    {
        if (m_aHintStack[0] != None)
        {
            CancelHint(oPlayerController);
            m_aHintStack[0].HideMessageBox(m_aHintStack[0] != m_oPreloadedHint, TRUE);
            m_aHintStack[0] = None;
        }
        m_aHintStack.Remove(0, 1);
    }
    if (m_aHintStack[0] != None)
    {
        m_aHintStack[0].SetVisible(TRUE);
    }
}
public final event function bool RetrieveGUIDependent(Name SourceGUI, out GUIDependency GD)
{
    local int idx;
    
    for (idx = 0; idx < GUIDependencies.Length; idx++)
    {
        if (GUIDependencies[idx].SourceGUI == SourceGUI)
        {
            GD.SourceGUI = GUIDependencies[idx].SourceGUI;
            GD.DependentGUI = GUIDependencies[idx].DependentGUI;
            GD.OptContext = GUIDependencies[idx].OptContext;
            GD.OnDependency = GUIDependencies[idx].OnDependency;
            GUIDependencies.Remove(idx, 1);
            return TRUE;
        }
    }
    return FALSE;
}
public final event function ReturnToBrowserWheel(optional SFXGUIMovie oCurrentPanel, optional bool bExitImmediately, optional PlayerController oPlayerController)
{
    local SFXGUIMovie oBrowserPanel;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    if (oCurrentPanel != None)
    {
        RemovePanel(oCurrentPanel);
    }
    if (bExitImmediately)
    {
        HideBrowserWheel(None, oPlayerController);
        return;
    }
    oBrowserPanel = OpenMovie(oPlayerController, MovieTag_MenuBrowser, TRUE);
    oBrowserPanel.SetRequiresUIWorld(TRUE);
}
public final event function RevokeGUIDependency(Name SourceGUI)
{
    local int idx;
    
    for (idx = GUIDependencies.Length - 1; idx > -1; idx--)
    {
        if (GUIDependencies[idx].SourceGUI == SourceGUI)
        {
            GUIDependencies.Remove(idx, 1);
        }
    }
}
public final native function SetDesiredMouseCursorVisibility(Object oRequestSource, PlayerController PC, bool bVisible);

public final native function SetMovieGameMode(SFXGUIMovie oMovie, bool bEnable, optional EGameModes eGameMode = 9);

public final native function SetWheelState(MEBrowserWheelSubPages nPage, BioBrowserStates nState);

public final event function ShowBlackScreen(PlayerController oPlayerController, bool bWithFade, optional float FadeTime)
{
    local BioSFHandler_BlackScreen oBlackScreenHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBlackScreenHandler = BioSFHandler_BlackScreen(GetMovie(oPlayerController, MovieTag_BlackScreen));
    if (oBlackScreenHandler != None)
    {
        oBlackScreenHandler.Show(bWithFade, FadeTime);
    }
}
public final event function ShowBrowserWheel(PlayerController oPlayerController)
{
    local BioWorldInfo oBioWorldInfo;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBioWorldInfo = BioWorldInfo(GetWorldInfo());
    if (!oBioWorldInfo.m_bAllowBrowserWheel)
    {
        return;
    }
    if (oBioWorldInfo.m_playerSquad != None)
    {
        CancelLeaderActive(oPlayerController);
    }
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        m_bGameWasPaused = PC.WorldInfo.bPlayersOnly;
        PC.WorldInfo.PauseGame(TRUE);
        PC.GameModeManager2.EnableMode(9);
    }
    ReturnToBrowserWheel(None, FALSE, oPlayerController);
    SetupBackground();
    PlayGuiSound('InGameGuiEnter');
}
public final event function ShowClimbMantleWidget(bool bMantle, PlayerController oPlayerController);

public final event function ShowConversationGui(PlayerController oPlayerController, bool bIsAmbient)
{
    local BioSFHandler_Conversation oConversationHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oConversationHandler = BioSFHandler_Conversation(GetMovie(oPlayerController, MovieTag_Conversation));
    if (oConversationHandler != None)
    {
        oConversationHandler.SetMovieFocus(!bIsAmbient);
        oConversationHandler.SetEnabled(TRUE);
    }
}
public final event function ShowCoverWidget(PlayerController oPlayerController);

public final native function ShowGFxLog(bool bShow);

public event function ShowHint(stringref srText, float fDisplayTime, optional int nIcon = 0, optional SFXHintPosition ePosition = 2, optional bool bCache = FALSE, optional bool bForceVisible = FALSE, optional PlayerController oPlayerController)
{
    local int N;
    local bool bUsePreload;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    CancelHint(oPlayerController);
    if (BioPlayerController(oPlayerController).GameModeManager2.ShouldAllowMessageUI() == FALSE && bForceVisible == FALSE)
    {
        return;
    }
    if (m_aHintStack.Length == 0)
    {
        m_aHintStack[0] = None;
    }
    else if (m_aHintStack[0] != None)
    {
        m_aHintStack[0].HideMessageBox(m_aHintStack[0] != m_oPreloadedHint, TRUE);
        m_aHintStack[0] = None;
    }
    bUsePreload = TRUE;
    for (N = 0; N < m_aHintStack.Length; ++N)
    {
        if (m_aHintStack[N] == m_oPreloadedHint)
        {
            bUsePreload = FALSE;
            break;
        }
    }
    if (bUsePreload)
    {
        m_aHintStack[0] = m_oPreloadedHint;
    }
    if (m_aHintStack[0] == None)
    {
        m_aHintStack[0] = CastOpenMovie(Class'BioSFHandler_MessageBox', oPlayerController, MovieTag_HintBox, TRUE, FALSE, TRUE);
        if (m_oPreloadedHint == None)
        {
            m_oPreloadedHint = m_aHintStack[0];
        }
    }
    if (m_aHintStack[0] == None)
    {
        return;
    }
    if (fDisplayTime > 0.0)
    {
        m_aHintStack[0].m_bForceVisible = bForceVisible;
        m_aHintStack[0].m_fHintTimeRemaining = fDisplayTime;
        m_aHintStack[0].SetUpdateDelegate(UpdateHint);
    }
    m_aHintStack[0].SetVisible(TRUE);
    m_aHintStack[0].DisplayHintMessage(srText, nIcon, ePosition);
}
public final event function BioSFHandler_MainMenu ShowMainMenu(optional PlayerController oPlayerController)
{
    local BioSFHandler_MainMenu oHandler;
    local BioPlayerController PC;
    local bool bWasCreated;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    bWasCreated = FALSE;
    oHandler = CastGetMovie(Class'BioSFHandler_MainMenu', oPlayerController, MovieTag_MainMenu);
    if (oHandler == None)
    {
        oHandler = CastOpenMovie(Class'BioSFHandler_MainMenu', oPlayerController, MovieTag_MainMenu, TRUE);
        bWasCreated = TRUE;
    }
    oHandler.SetEnabled(TRUE);
    if (bWasCreated)
    {
        PC = BioPlayerController(oPlayerController);
        if (PC != None)
        {
            PC.GameModeManager2.EnableMode(9);
        }
    }
    return oHandler;
}
public event function ShowPlatformSpecificHint(stringref srDefaultText, stringref srPS3Text, stringref srPCText, float fDisplayTime, optional SFXHintPosition ePosition = 2, optional bool bCached = FALSE, optional bool bForceVisible = FALSE, optional PlayerController oPlayerController)
{
    local stringref srText;
    local bool bIsPS3;
    local bool bIsPC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    srText = srDefaultText;
    bIsPS3 = Class'WorldInfo'.static.IsConsoleBuild(2);
    bIsPC = !Class'WorldInfo'.static.IsConsoleBuild(0);
    if (bIsPC && srPCText != stringref(0))
    {
        srText = srPCText;
    }
    else if (bIsPS3 && srPS3Text != stringref(0))
    {
        srText = srPS3Text;
    }
    if (srText != stringref(0))
    {
        ShowHint(srText, fDisplayTime, 0, ePosition, bCached, bForceVisible, oPlayerController);
    }
}
public final event function BioSkillGame_Bypass_Handler ShowSkillGameBypass(PlayerController oPlayerController)
{
    local BioSkillGame_Bypass_Handler oPanel;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oPanel = CastOpenMovie(Class'BioSkillGame_Bypass_Handler', oPlayerController, MovieTag_SkillGameBypass, TRUE);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(9);
    }
    return oPanel;
}
public final event function BioSkillGame_Decryption_Handler ShowSkillGameDecryption(PlayerController oPlayerController)
{
    local BioSkillGame_Decryption_Handler oMovie;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    HideHint(oPlayerController);
    oMovie = CastOpenMovie(Class'BioSkillGame_Decryption_Handler', oPlayerController, MovieTag_SkillGameDecryption, TRUE);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(9);
    }
    return oMovie;
}
public final native function StopGuiMusic();

public final native function bool StopGuiSound(Name nmSound);

public final native function StopGuiVoice();

public final native function UpdateNamedMessageBox(Name nmName, stringref srMessage, optional PlayerController pPlayerController);

public final native function UpdateProfileSettings(SFXProfileSettings oSettings);

public final native function PlayerController ValidatePlayerController(PlayerController oPC);

public final function bool BlackScreenFadeFinished(PlayerController oPlayerController)
{
    local bool bVal;
    local BioSFHandler_BlackScreen oBlackScreenHandler;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBlackScreenHandler = BioSFHandler_BlackScreen(GetMovie(oPlayerController, MovieTag_BlackScreen));
    bVal = TRUE;
    if (oBlackScreenHandler != None)
    {
        bVal = !oBlackScreenHandler.IsFading();
    }
    return bVal;
}
public function SFXSFHandler_PRCShop CreatePRCStore(PlayerController oController)
{
    local SFXSFHandler_PRCShop oShop;
    
    oController = ValidatePlayerController(oController);
    oShop = CastOpenMovie(Class'SFXSFHandler_PRCShop', oController, MovieTag_PRCStore, TRUE);
    return oShop;
}
public function DestroyPRCStore(PlayerController oController)
{
    local SFXGUIMovie oMovie;
    
    oController = ValidatePlayerController(oController);
    oMovie = GetMovie(oController, MovieTag_PRCStore);
    if (oMovie != None)
    {
        oMovie.Close(TRUE);
    }
}
public final function BioSFHandler_NewCharacter FinishInitCharacterCreation(array<AnimSet> a_AnimSets, array<Class<SFXCharacterClass>> a_CharacterClasses, SFXMorphFaceFrontEndDataSource a_MaleDataSource, SFXMorphFaceFrontEndDataSource a_FemaleDataSource, const out MorphHeadSaveRecord InDefaultFemaleME2Record, optional PlayerController oPlayerController)
{
    local BioWorldInfo oBioWorldInfo;
    local SFXGUIMovie oPanel;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oBioWorldInfo = BioWorldInfo(GetWorldInfo());
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        oBioWorldInfo.bPlayersOnly = TRUE;
        PC.GameModeManager2.EnableMode(9);
    }
    oPanel = OpenMovie(oPlayerController, MovieTag_NewCharacter, TRUE);
    oPanel.SetRequiresUIWorld(TRUE);
    oBioWorldInfo.m_UIWorld.ResetActors();
    oBioWorldInfo.m_UIWorld.m_oNCHandler = BioSFHandler_NewCharacter(oPanel);
    oBioWorldInfo.m_UIWorld.m_oNCHandler.lstClassAnimSetRefs = a_AnimSets;
    oBioWorldInfo.m_UIWorld.m_oNCHandler.lstCharacterClasses = a_CharacterClasses;
    oBioWorldInfo.m_UIWorld.m_oNCHandler.MaleDataSource = a_MaleDataSource;
    oBioWorldInfo.m_UIWorld.m_oNCHandler.FemaleDataSource = a_FemaleDataSource;
    oBioWorldInfo.m_UIWorld.m_oNCHandler.SetDefaultFemaleME2SaveProperties(InDefaultFemaleME2Record);
    oBioWorldInfo.m_UIWorld.m_oNCHandler.ProcessExternalStates(oBioWorldInfo);
    oBioWorldInfo.m_UIWorld.m_oNCHandler.SpawnPawns();
    oBioWorldInfo.m_UIWorld.m_oNCHandler.UpdateCustomClassList();
    oBioWorldInfo.m_UIWorld.m_oNCHandler.Setup3DModel();
    oBioWorldInfo.m_UIWorld.m_oNCHandler.CalculateCurrentScar();
    oBioWorldInfo.m_UIWorld.FlushPendingCommands();
    oBioWorldInfo.m_UIWorld.m_oNCHandler.SetupSummary();
    return oBioWorldInfo.m_UIWorld.m_oNCHandler;
}
public function SFXAreaMapData GetAreaMapData()
{
    return m_CurrentAreaMap;
}
public final function SFXSFHandler_AreaMap GetAreaMapHandler(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastGetMovie(Class'SFXSFHandler_AreaMap', oPlayerController, MovieTag_AreaMap);
}
public final function BioSFHandler_Conversation GetConversationHandler(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return BioSFHandler_Conversation(GetMovie(oPlayerController, MovieTag_Conversation));
}
public function BioSkillGame_Decryption_Handler GetDecryptionHandler(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastGetMovie(Class'BioSkillGame_Decryption_Handler', oPlayerController, MovieTag_SkillGameDecryption);
}
public final function BioSFHandler_GalaxyMap GetGalaxyMap(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastGetMovie(Class'BioSFHandler_GalaxyMap', oPlayerController, MovieTag_GalaxyMap);
}
public final function BioSFHandler_MainMenu GetMainMenuHandler(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastGetMovie(Class'BioSFHandler_MainMenu', oPlayerController, MovieTag_MainMenu);
}
public final function SFXSFHandler_Slideshow GetSlideshowHandler(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastGetMovie(Class'SFXSFHandler_Slideshow', oPlayerController, MovieTag_Slideshow);
}
public function HideAchievementGui(PlayerController oPlayerController)
{
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_Accomplishments);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(9);
        PC.WorldInfo.bPlayersOnly = m_bGameWasPaused;
    }
}
public function bool HideAreaMap(PlayerController oPlayerController)
{
    local BioPlayerController oController;
    local SFXGUIMovie oPanel;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oController = BioPlayerController(oPlayerController);
    oPanel = GetMovie(oPlayerController, MovieTag_AreaMap);
    if (oPanel != None)
    {
        RemovePanel(oPanel);
    }
    else
    {
        return FALSE;
    }
    oController.WorldInfo.PauseGame(m_bGameWasPaused);
    PlayGuiSound('InGameAreaMapExit');
    return TRUE;
}
public final function HideGameOverGui(PlayerController oPlayerController)
{
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_GameOver);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(9);
        PC.WorldInfo.bPlayersOnly = m_bGameWasPaused;
    }
}
public final function HideMPOptions(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_MPOptions);
}
public final function HideMPPauseMenu(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_MPPauseMenu);
}
public final function HidePartySelect(optional PlayerController oPlayerController)
{
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_PartySelect);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(9);
        PC.WorldInfo.bPlayersOnly = m_bGameWasPaused;
    }
}
public function HidePersonalizationGUI(optional PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_Personalization);
}
public final function HideSniperOverlay(optional PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    RemoveMovie(oPlayerController, MovieTag_SniperOverlay);
}
public function InitializeStartupGuiForPlayer(PlayerController oPlayer, Class<HUD> newHUDType)
{
    local int nMovie;
    
    if (GetWorldInfo().bIsLobbyLevel)
    {
        OpenMovie(oPlayer, MovieTag_HUD, TRUE);
        OpenMovie(oPlayer, MovieTag_BlackScreen, TRUE);
    }
    else
    {
        for (nMovie = 0; nMovie < MovieLibrary.Length; ++nMovie)
        {
            if (ClassIsChildOf(newHUDType, Class<HUD>(FindObject(MovieLibrary[nMovie].HUDTypeToAutoLoadFor, Class'Class'))))
            {
                OpenMovie(oPlayer, MovieLibrary[nMovie].Tag, MovieLibrary[nMovie].bAutoStart);
            }
        }
    }
    m_oPreloadedHint = CastOpenMovie(Class'BioSFHandler_MessageBox', oPlayer, MovieTag_HintBox, TRUE, FALSE, TRUE);
    m_oPreloadedHint.SetVisible(FALSE);
}
public final function bool IsInMPLobby()
{
    local WorldInfo WorldInfo;
    local string DefaultLobbyMap;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo.NetMode != ENetMode.NM_Standalone)
    {
        DefaultLobbyMap = Class'GameEngine'.static.GetDefaultLobbyMap();
        return WorldInfo.GetMapName() == DefaultLobbyMap;
    }
    return FALSE;
}
public final function MPToggleReady(PlayerController oPlayerController)
{
    local SFXPRI PRI;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    PRI = SFXPRI(oPlayerController.PlayerReplicationInfo);
    if (PRI.CanSetReadyInLobby())
    {
        PRI.SetReadyInLobby(!PRI.IsReadyInLobby());
    }
}
public function OnPlayerDeath(PlayerController oPlayerController)
{
    local BioSFHandler_DesignerUI oDUIMovie;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oDUIMovie = CastGetMovie(Class'BioSFHandler_DesignerUI', oPlayerController, MovieTag_DesignerUI);
    HideSkillGames(oPlayerController);
    if (oDUIMovie != None)
    {
        oDUIMovie.ClearAll(TRUE);
        oDUIMovie.ClearAll(FALSE);
        oDUIMovie.Close(TRUE);
    }
}
public final function SFXGUI_Credits PlayCredits(PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    return CastOpenMovie(Class'SFXGUI_Credits', oPlayerController, MovieTag_Credits, TRUE);
}
public final function ReturnToMainMenu(optional PlayerController PC)
{
    HackReloadMainMenu();
}
public function SetAreaMapData(SFXAreaMapData oMapData)
{
    m_CurrentAreaMap = oMapData;
    if (m_CurrentAreaMap != None)
    {
        m_CurrentAreaMap.ReCalculate();
    }
}
public function SetDistanceOnSniperOverlay(int nDistance, optional PlayerController oPlayerController)
{
    local BioSFHandler_SniperOverlay oSniperOverlay;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oSniperOverlay = CastOpenMovie(Class'BioSFHandler_SniperOverlay', oPlayerController, MovieTag_SniperOverlay, TRUE);
    if (oSniperOverlay != None)
    {
        oSniperOverlay.SetDistance(nDistance);
    }
}
public function SetupBackground()
{
    local BioWorldInfo oBioWorldInfo;
    
    oBioWorldInfo = BioWorldInfo(GetWorldInfo());
    oBioWorldInfo.m_UIWorld.TriggerEvent('SetBGShot', oBioWorldInfo);
}
public function ShowAchievementGui(PlayerController oPlayerController)
{
    local SFXGUIMovie oPanel;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oPanel = OpenMovie(oPlayerController, MovieTag_Accomplishments, TRUE);
    oPanel.SetRequiresUIWorld(TRUE);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(9);
        m_bGameWasPaused = PC.WorldInfo.bPlayersOnly;
        PC.WorldInfo.bPlayersOnly = TRUE;
    }
    SetupBackground();
}
public function bool ShowAreaMap(PlayerController oPlayerController)
{
    local SFXGUIMovie oPanel;
    local BioPlayerController oController;
    local SFXAreaMapData oMapData;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oMapData = GetAreaMapData();
    if (oMapData == None)
    {
        return FALSE;
    }
    oPanel = OpenMovie(oPlayerController, MovieTag_AreaMap, TRUE);
    if (oPanel == None)
    {
        return FALSE;
    }
    oController = BioPlayerController(oPlayerController);
    m_bGameWasPaused = oController.WorldInfo.bPlayersOnly;
    oController.WorldInfo.PauseGame(TRUE);
    PlayGuiSound('InGameAreaMapEnter');
    return TRUE;
}
public final function ShowGameOverGui(optional stringref srGameOverString, optional PlayerController oPlayerController)
{
    local BioSFHandler_GameOver oGameOver;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        m_bGameWasPaused = PC.WorldInfo.bPlayersOnly;
        PC.WorldInfo.bPlayersOnly = TRUE;
        PC.GameModeManager2.EnableMode(9);
    }
    oGameOver = CastOpenMovie(Class'BioSFHandler_GameOver', oPlayerController, MovieTag_GameOver, TRUE);
    if (srGameOverString != 0)
    {
        oGameOver.SetGameOverString(srGameOverString);
    }
}
public final function ShowLeaderboard(PlayerController oPlayerController, delegate<SFXGUIMovie.OnMovieClosedDelegate> LeaderboardClosedDelegate)
{
    local SFXGUIMovie oLB;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    if (oPlayerController != None)
    {
        oLB = OpenMovie(oPlayerController, MovieTag_Leaderboard);
        oLB.AddOnMovieClosedDelegate(LeaderboardClosedDelegate);
    }
}
public final function ShowMPOptions(PlayerController oPlayerController, delegate<OnCloseCallback> CloseCallback)
{
    local BioSFHandler_Options OptionsMovie;
    
    PlayGuiSound('MPPauseMenuOptionsStart');
    oPlayerController = ValidatePlayerController(oPlayerController);
    OptionsMovie = CastOpenMovie(Class'BioSFHandler_Options', oPlayerController, MovieTag_MPOptions);
    OptionsMovie.SetRequiresUIWorld(TRUE);
    OptionsMovie.CloseSound = 'MPPauseMenuOptionsFinished';
    OptionsMovie.SetOnCloseCallback(CloseCallback);
}
public final function ShowMPPauseMenu(PlayerController oPlayerController, bool bShouldAnimate)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    OpenMovie(oPlayerController, MovieTag_MPPauseMenu);
}
public final function ShowNewGameOptions(PlayerController oPlayerController, delegate<OnCloseCallback> CloseCallback)
{
    local BioSFHandler_Options oOptions;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oOptions = CastOpenMovie(Class'BioSFHandler_Options', oPlayerController, MovieTag_Options, FALSE);
    oOptions.GuiMode = EOptionsGuiMode.GuiMode_NewGame;
    oOptions.SetOnCloseCallback(CloseCallback);
    oOptions.Start();
}
public final function SFXGUI_TeamSelect ShowPartySelect(optional PlayerController oPlayerController)
{
    local SFXGUI_TeamSelect oPSHandler;
    local BioPlayerController PC;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    PC = BioPlayerController(oPlayerController);
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(9);
    }
    oPSHandler = CastOpenMovie(Class'SFXGUI_TeamSelect', oPlayerController, MovieTag_PartySelect, TRUE);
    oPSHandler.SetRequiresUIWorld(TRUE);
    SetupBackground();
    return oPSHandler;
}
public function ShowPersonalizationGUI(optional PlayerController oPlayerController)
{
    local SFXGUIMovie oMovie;
    
    oPlayerController = ValidatePlayerController(oPlayerController);
    oMovie = OpenMovie(oPlayerController, MovieTag_Personalization, TRUE);
    if (oMovie != None)
    {
        oMovie.SetRequiresUIWorld(TRUE);
    }
}
public final function ShowSniperOverlay(optional PlayerController oPlayerController)
{
    oPlayerController = ValidatePlayerController(oPlayerController);
    OpenMovie(oPlayerController, MovieTag_SniperOverlay, TRUE);
}
public final function UpdateHint(float fDeltaT, BioSFHandler_MessageBox oMsgBox)
{
    if (oMsgBox.GetEnabled())
    {
        oMsgBox.m_fHintTimeRemaining -= fDeltaT;
        if (oMsgBox.m_fHintTimeRemaining <= 0.0)
        {
            oMsgBox.m_fHintTimeRemaining = 0.0;
            CancelHint(oMsgBox.GetPC());
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGUIInputHandler Name=SFXGUIInputHandler0
    End Object
    MovieLibrary = ({
                     MovieClass = "SFXGame.SFXGUI_MPScoretags", 
                     GFxResource = "GUI_SF_MPScoretags.MPScoretags", 
                     HUDTypeToAutoLoadFor = "SFXGameMPContent.SFXHUDMP", 
                     Tag = 'MPScoretags', 
                     CurvePixelError = 1.0, 
                     ZOrder = 6, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Markers", 
                     GFxResource = "GUI_SF_Markers.Markers", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'Markers', 
                     CurvePixelError = 1.0, 
                     ZOrder = 10, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_Reticle", 
                     GFxResource = "GUI_SF_ME2_Reticle.ME2_Reticle", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'Reticle', 
                     CurvePixelError = 1.0, 
                     ZOrder = 20, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCPowerWheel", 
                     GFxResource = "GUI_SF_PC_ME2_PowerWheel.PC_ME2_PowerWheel", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'PowerWheel', 
                     CurvePixelError = 1.0, 
                     ZOrder = 25, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCGalaxyMap", 
                     GFxResource = "GUI_SF_GalaxyMap.GalaxyMap", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'GalaxyMap', 
                     CurvePixelError = 1.0, 
                     ZOrder = 30, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCMainMenu", 
                     GFxResource = "GUI_SF_MainMenu.MainMenu", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MainMenu', 
                     CurvePixelError = 1.0, 
                     ZOrder = 31, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPLobby", 
                     GFxResource = "GUI_SF_MPNewLobby.MPNewLobby", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPNewLobby', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPSelectKit", 
                     GFxResource = "GUI_SF_MPSelectKit.MPSelectKit", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPSelectKit', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPAppearance", 
                     GFxResource = "GUI_SF_MPAppearance.MPAppearance", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPAppearance', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPMatchResults", 
                     GFxResource = "GUI_SF_MPMatchResults.MPMatchResults", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPMatchResults', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Leaderboard", 
                     GFxResource = "GUI_SF_Leaderboard.Leaderboard", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Leaderboard', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_PlayerCountdown", 
                     GFxResource = "GUI_SF_MPPlayerCountdown.MPPlayerCountdown", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'PlayerCountdown', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPMatchConsumables", 
                     GFxResource = "GUI_SF_MPMatchConsumables.MPMatchConsumables", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPMatchConsumables', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPStore", 
                     GFxResource = "GUI_SF_MPStore.MPStore", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPStore', 
                     CurvePixelError = 1.0, 
                     ZOrder = 32, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameContent.SFXGUI_AtlasHUD", 
                     GFxResource = "GUI_SF_HUDatlas.HUDatlas", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'AtlasHUD', 
                     CurvePixelError = 1.0, 
                     ZOrder = 34, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCHUD", 
                     GFxResource = "GUI_SF_ME2_HUD.ME2_HUD", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'HUD', 
                     CurvePixelError = 1.0, 
                     ZOrder = 35, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPHUD", 
                     GFxResource = "GUI_SF_MP_HUD.MP_HUD", 
                     HUDTypeToAutoLoadFor = "SFXGameMPContent.SFXHUDMP", 
                     Tag = 'MPHUD', 
                     CurvePixelError = 1.0, 
                     ZOrder = 36, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCConversation", 
                     GFxResource = "GUI_SF_ConversationWheel.ConversationWheel", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'Conversation', 
                     CurvePixelError = 1.0, 
                     ZOrder = 45, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_BlackScreen", 
                     GFxResource = "GUI_SF_BlackScreen.BlackScreen", 
                     HUDTypeToAutoLoadFor = "SFXGame.BioHUD", 
                     Tag = 'BlackScreen', 
                     CurvePixelError = 1.0, 
                     ZOrder = 50, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_IntroText", 
                     GFxResource = "GUI_SF_IntroText.IntroText", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'IntroText', 
                     CurvePixelError = 1.0, 
                     ZOrder = 90, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_LoadScreen", 
                     GFxResource = "GUI_SF_LoadScreenToolTips.LoadScreenToolTips", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'LoadMovieDefault', 
                     CurvePixelError = 1.0, 
                     ZOrder = 120, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_SniperOverlay", 
                     GFxResource = "GUI_SF_SniperOverlay.SniperOverlay", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'SniperOverlay', 
                     CurvePixelError = 1.0, 
                     ZOrder = 130, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCPauseMenu", 
                     GFxResource = "GUI_SF_MainWheel.MainWheel", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MenuBrowser', 
                     CurvePixelError = 1.0, 
                     ZOrder = 140, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPPauseMenu", 
                     GFxResource = "GUI_SF_MPPauseMenu.MPPauseMenu", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPPauseMenu', 
                     CurvePixelError = 1.0, 
                     ZOrder = 145, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = FALSE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCChoiceGUI", 
                     GFxResource = "GUI_SF_MissionComplete.MissionComplete", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MissionCompletion', 
                     CurvePixelError = 1.0, 
                     ZOrder = 161, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PRCShop", 
                     GFxResource = "GUI_SF_PRCStore.PRCStore", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'PRCStore', 
                     CurvePixelError = 1.0, 
                     ZOrder = 162, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_PCStore", 
                     GFxResource = "GUI_SF_Store.Store", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Store', 
                     CurvePixelError = 1.0, 
                     ZOrder = 163, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Terminal", 
                     GFxResource = "GUI_SF_PersonalTerminal.PersonalTerminal", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Terminal', 
                     CurvePixelError = 1.0, 
                     ZOrder = 164, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Elevator", 
                     GFxResource = "GUI_SF_Elevators.NormandyElevator", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Elevator', 
                     CurvePixelError = 1.0, 
                     ZOrder = 165, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameContent.SFXGUI_Mail", 
                     GFxResource = "GUI_SF_Mail.Mail", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Mail', 
                     CurvePixelError = 1.0, 
                     ZOrder = 166, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameContent.SFXGUI_Training", 
                     GFxResource = "GUI_SF_Training.Training", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Training', 
                     CurvePixelError = 1.0, 
                     ZOrder = 167, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_PCSplashScreen", 
                     GFxResource = "GUI_SF_Splash.Splash", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Splash', 
                     CurvePixelError = 1.0, 
                     ZOrder = 170, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_WeaponSelection", 
                     GFxResource = "GUI_SF_WeaponSelect.WeaponSelect", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'WeaponSelect', 
                     CurvePixelError = 1.0, 
                     ZOrder = 180, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCChoiceGUI", 
                     GFxResource = "GUI_SF_PRCStore.PRCStore", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'ChoiceGUI', 
                     CurvePixelError = 1.0, 
                     ZOrder = 190, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_TeamSelect", 
                     GFxResource = "GUI_SF_TeamSelect.TeamSelect", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'PartySelect', 
                     CurvePixelError = 1.0, 
                     ZOrder = 200, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCPersonalization", 
                     GFxResource = "GUI_SF_Personalization.Personalization", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Personalization', 
                     CurvePixelError = 1.0, 
                     ZOrder = 210, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = FALSE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCNewCharacter", 
                     GFxResource = "GUI_SF_CharacterCreation.CharacterCreation", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'NewCharacter', 
                     CurvePixelError = 1.0, 
                     ZOrder = 220, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCOptions", 
                     GFxResource = "GUI_SF_Options.Options", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Options', 
                     CurvePixelError = 1.0, 
                     ZOrder = 230, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_PCMPOptions", 
                     GFxResource = "GUI_SF_Options.Options", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPOptions', 
                     CurvePixelError = 1.0, 
                     ZOrder = 235, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_JournalCodex", 
                     GFxResource = "GUI_SF_Jourdex.Jourdex", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Journal', 
                     CurvePixelError = 1.0, 
                     ZOrder = 240, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Manual", 
                     GFxResource = "GUI_SF_Jourdex.Jourdex", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Manual', 
                     CurvePixelError = 1.0, 
                     ZOrder = 242, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Accomplishments", 
                     GFxResource = "GUI_SF_Accomplishments.Accomplishments", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Accomplishments', 
                     CurvePixelError = 1.0, 
                     ZOrder = 260, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCEANetworking", 
                     GFxResource = "GUI_SF_NetworkRegistration.NetworkRegistration", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'NetworkRegistration', 
                     CurvePixelError = 1.0, 
                     ZOrder = 270, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_GalaxyAtWar", 
                     GFxResource = "GUI_SF_GalaxyAtWar.GalaxyAtWar", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'galaxyAtWar', 
                     CurvePixelError = 1.0, 
                     ZOrder = 262, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_WarAssets", 
                     GFxResource = "GUI_SF_WarAssets.WarAssets", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'WarAssets', 
                     CurvePixelError = 1.0, 
                     ZOrder = 262, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCGameOver", 
                     GFxResource = "GUI_SF_GameOver.GameOver", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'GameOver', 
                     CurvePixelError = 1.0, 
                     ZOrder = 280, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPEndOfMatch", 
                     GFxResource = "GUI_SF_MPEndOfMatch.MPEndOfMatch", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPEndOfMatch', 
                     CurvePixelError = 1.0, 
                     ZOrder = 281, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_PCSquadRecord", 
                     GFxResource = "GUI_SF_SquadRecord.SquadRecord", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'SquadRecord', 
                     CurvePixelError = 1.0, 
                     ZOrder = 290, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = FALSE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXGUI_Credits", 
                     GFxResource = "GUI_SF_Credits.Credits", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Credits', 
                     CurvePixelError = 1.0, 
                     ZOrder = 300, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCDesignerUI", 
                     GFxResource = "GUI_SF_DesignerUI.DesignerUI", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'DesignerUI', 
                     CurvePixelError = 1.0, 
                     ZOrder = 310, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCSave", 
                     GFxResource = "GUI_SF_LoadSave.LoadSave", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Save', 
                     CurvePixelError = 1.0, 
                     ZOrder = 330, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCLoad", 
                     GFxResource = "GUI_SF_LoadSave.LoadSave", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Load', 
                     CurvePixelError = 1.0, 
                     ZOrder = 340, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCAreaMap", 
                     GFxResource = "GUI_SF_ME2_AreaMap.ME2_AreaMap", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'Areamap', 
                     CurvePixelError = 1.0, 
                     ZOrder = 360, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = FALSE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_MessageBox", 
                     GFxResource = "GUI_SF_MessageBox_Hint.MessageBox_Hint", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'HintBox', 
                     CurvePixelError = 1.0, 
                     ZOrder = 361, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.SFXSFHandler_PCSlideshow", 
                     GFxResource = "GUI_SF_ME2_Slideshow.ME2_Slideshow", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'slideshow', 
                     CurvePixelError = 1.0, 
                     ZOrder = 365, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPPromotion", 
                     GFxResource = "GUI_SF_MPPromotion.MPPromotion", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPPromotion', 
                     CurvePixelError = 1.0, 
                     ZOrder = 366, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPReinforcementsReveal", 
                     GFxResource = "GUI_SF_MPReinforcementsReveal.MPReinforcementsReveal", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPReinforcementsReveal', 
                     CurvePixelError = 1.0, 
                     ZOrder = 367, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameMPContent.SFXGUI_MPLobbyStatusBars", 
                     GFxResource = "GUI_SF_MPLobbyStatusBars.MPLobbyStatusBars", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'MPLobbyStatusBars', 
                     CurvePixelError = 1.0, 
                     ZOrder = 368, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameContent.SFXGUI_OpeningTitles", 
                     GFxResource = "GUI_SF_OpeningTitles.OpeningTitles", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'OpeningTitles', 
                     CurvePixelError = 1.0, 
                     ZOrder = 369, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCMessageBox", 
                     GFxResource = "GUI_SF_MessageBox.MessageBox", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'messageBox', 
                     CurvePixelError = 1.0, 
                     ZOrder = 370, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGame.BioSFHandler_PCMessageBox", 
                     GFxResource = "GUI_SF_MessageBox.MessageBox", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'QueuedMessageBox', 
                     CurvePixelError = 1.0, 
                     ZOrder = 371, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }, 
                    {
                     MovieClass = "SFXGameContent.SFXGUI_SaveIndicatorMessage", 
                     GFxResource = "GUI_SF_SaveIndicatorMessage.SaveIndicatorMessage", 
                     HUDTypeToAutoLoadFor = "None", 
                     Tag = 'SaveIndicatorMessage', 
                     CurvePixelError = 1.0, 
                     ZOrder = 175, 
                     UseEdgeAA = TRUE, 
                     bAutoStart = TRUE, 
                     bAutoVisible = TRUE, 
                     bSwfDevAutoReopen = TRUE, 
                     Platform = EConsoleType.CONSOLE_Any, 
                     StrokeStyle = SFMovieStrokeStyle.SF_MSS_Normal
                    }
                   )
    SharedAssetLibrary = ({SharedFile = 'mainController.gfx', GFxResource = 'GUI_SF_mainController.mainController'}, 
                          {SharedFile = 'PC_SharedAssets.gfx', GFxResource = 'GUI_SF_PC_SharedAssets.PC_SharedAssets'}, 
                          {SharedFile = 'Xbox_ControllerIcons.gfx', GFxResource = 'GUI_SF_Xbox_ControllerIcons.Xbox_ControllerIcons'}, 
                          {SharedFile = 'WeaponSelect.gfx', GFxResource = 'GUI_SF_WeaponSelect.WeaponSelect'}, 
                          {SharedFile = 'SharedDesign.gfx', GFxResource = 'GUI_DesignUI_SharedDesign.SharedDesign'}
                         )
    FontMap = ({
                Locale = "JPN", 
                FontExportName = "BioMass Shared", 
                SubstituteFont = "Biomass+DFGSoGei-W7", 
                FontGFxResource = 'GUI_SF_FontsJPN.gfxfonts', 
                ScaleFactor = 1.0, 
                Style = SFXFontStyle.SFXFONT_Normal
               }, 
               {
                Locale = "JPN", 
                FontExportName = "AeroLight Shared", 
                SubstituteFont = "Myriad Pro+DFGGothicP-W5", 
                FontGFxResource = 'GUI_SF_FontsJPN.gfxfonts', 
                ScaleFactor = 1.0, 
                Style = SFXFontStyle.SFXFONT_Normal
               }, 
               {
                Locale = "*", 
                FontExportName = "BioMass Shared", 
                SubstituteFont = "Biomass+DFGSoGei-W7", 
                FontGFxResource = 'GUI_SF_Fonts.gfxfonts', 
                ScaleFactor = 1.0, 
                Style = SFXFontStyle.SFXFONT_Normal
               }, 
               {
                Locale = "*", 
                FontExportName = "AeroLight Shared", 
                SubstituteFont = "Myriad Pro+DFGGothicP-W5", 
                FontGFxResource = 'GUI_SF_Fonts.gfxfonts', 
                ScaleFactor = 1.0, 
                Style = SFXFontStyle.SFXFONT_Normal
               }
              )
    ControlTokens = ({
                      TexturePath = "BIOA_ControllerIcons_PC.mouse_left", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'Mouse_Btn_L', 
                      Height = 0, 
                      Width = 0, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_ControllerIcons_PC.mouse_right", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'Mouse_Btn_R', 
                      Height = 0, 
                      Width = 0, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "GUI_SF_Credits.Logos.nvidia", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'Logo_NVIDIA_PhysX', 
                      Height = 128, 
                      Width = 256, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "GUI_SF_Credits.Logos.dts", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'Logo_DTS_DigitalEntertainment', 
                      Height = 128, 
                      Width = 256, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "GUI_SF_Credits.Logos.dolby", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'Logo_Dolby', 
                      Height = 128, 
                      Width = 256, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon01", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_01', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon02", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_02', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon03", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_03', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon04", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_04', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon05", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_05', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon06", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_06', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon07", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_07', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon08", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_08', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon09", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_09', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }, 
                     {
                      TexturePath = "BIOA_NumberIcons.NumIcon10", 
                      Resource = "", 
                      Align = "", 
                      VAlign = "bottom", 
                      token = 'AreaMap_Label_10', 
                      Height = 24, 
                      Width = 24, 
                      FontVScale = 100, 
                      VSpace = 0, 
                      Cook = FALSE
                     }
                    )
    ControlTokenAliases = ({From = 'UI_XBoxB_Btn_A', To = 'XBoxB_Btn_A'}, 
                           {From = 'UI_XBoxB_Btn_B', To = 'XBoxB_Btn_B'}, 
                           {From = 'UI_XBoxB_Btn_X', To = 'XBoxB_Btn_X'}, 
                           {From = 'UI_XBoxB_Btn_Y', To = 'XBoxB_Btn_Y'}, 
                           {From = 'UI_XBoxB_Btn_RB', To = 'XBoxB_Btn_RB'}, 
                           {From = 'UI_XBoxB_Btn_RT', To = 'XBoxB_Btn_RT'}, 
                           {From = 'UI_XBoxB_Btn_RS', To = 'XBoxB_Btn_RS'}, 
                           {From = 'UI_XBoxB_Btn_LB', To = 'XBoxB_Btn_LB'}, 
                           {From = 'UI_XBoxB_Btn_LT', To = 'XBoxB_Btn_LT'}, 
                           {From = 'UI_XBoxB_Btn_LS', To = 'XBoxB_Btn_LS'}, 
                           {From = 'UI_XBoxB_Btn_DPadU', To = 'XBoxB_Btn_DPadU'}, 
                           {From = 'UI_XBoxB_Btn_DPadD', To = 'XBoxB_Btn_DPadD'}, 
                           {From = 'UI_XBoxB_Btn_DPadL', To = 'XBoxB_Btn_DPadL'}, 
                           {From = 'UI_XBoxB_Btn_DPadR', To = 'XBoxB_Btn_DPadR'}, 
                           {From = 'UI_XBoxB_Btn_Start', To = 'XBoxB_Btn_Start'}, 
                           {From = 'UI_XBoxB_Btn_Back', To = 'XBoxB_Btn_Back'}, 
                           {From = 'UI_XBoxB_Btn_R3', To = 'XBoxB_Btn_R3'}, 
                           {From = 'UI_XBoxB_Btn_L3', To = 'XBoxB_Btn_L3'}
                          )
    SFXKeyNameControlTokens = ({Key = 'XboxTypeS_A', token = 'XBoxB_Btn_A'}, 
                               {Key = 'XboxTypeS_B', token = 'XBoxB_Btn_B'}, 
                               {Key = 'XboxTypeS_X', token = 'XBoxB_Btn_X'}, 
                               {Key = 'XboxTypeS_Y', token = 'XBoxB_Btn_Y'}, 
                               {Key = 'XboxTypeS_RightShoulder', token = 'XBoxB_Btn_RB'}, 
                               {Key = 'XboxTypeS_RightTrigger', token = 'XBoxB_Btn_RT'}, 
                               {Key = 'XboxTypeS_LeftShoulder', token = 'XBoxB_Btn_LB'}, 
                               {Key = 'XboxTypeS_LeftTrigger', token = 'XBoxB_Btn_LT'}, 
                               {Key = 'Gamepad_LeftStick_Right', token = 'XBoxB_Btn_LSRight'}, 
                               {Key = 'Gamepad_LeftStick_Left', token = 'XBoxB_Btn_LSLeft'}, 
                               {Key = 'Gamepad_LeftStick_Up', token = 'XBoxB_Btn_LSUp'}, 
                               {Key = 'Gamepad_LeftStick_Down', token = 'XBoxB_Btn_LSDown'}, 
                               {Key = 'XboxTypeS_LeftThumbstick', token = 'XBoxB_Btn_L3'}, 
                               {Key = 'Gamepad_RightStick_Right', token = 'XBoxB_Btn_RSRight'}, 
                               {Key = 'Gamepad_RightStick_Left', token = 'XBoxB_Btn_RSLeft'}, 
                               {Key = 'Gamepad_RightStick_Up', token = 'XBoxB_Btn_RSUp'}, 
                               {Key = 'Gamepad_RightStick_Down', token = 'XBoxB_Btn_RSDown'}, 
                               {Key = 'XboxTypeS_RightThumbstick', token = 'XBoxB_Btn_R3'}, 
                               {Key = 'XboxTypeS_DPad_Up', token = 'XBoxB_Btn_DPadU'}, 
                               {Key = 'XboxTypeS_DPad_Down', token = 'XBoxB_Btn_DPadD'}, 
                               {Key = 'XboxTypeS_DPad_Left', token = 'XBoxB_Btn_DPadL'}, 
                               {Key = 'XboxTypeS_DPad_Right', token = 'XBoxB_Btn_DPadR'}, 
                               {Key = 'XboxTypeS_Start', token = 'XXBoxB_Btn_Start'}, 
                               {Key = 'XboxTypeS_Back', token = 'XBoxB_Btn_Back'}, 
                               {Key = 'LeftMouseButton', token = 'Mouse_Btn_L'}, 
                               {Key = 'RightMouseButton', token = 'Mouse_Btn_R'}
                              )
    MovieTag_Reticle = 'Reticle'
    MovieTag_PowerWheel = 'PowerWheel'
    MovieTag_HUD = 'HUD'
    MovieTag_Conversation = 'Conversation'
    MovieTag_BlackScreen = 'BlackScreen'
    MovieTag_SkillGameDecryption = 'SkillGameDecryption'
    MovieTag_SkillGameBypass = 'SkillGameBypass'
    MovieTag_IntroText = 'IntroText'
    MovieTag_LoadMovieDefault = 'LoadMovieDefault'
    MovieTag_SniperOverlay = 'SniperOverlay'
    MovieTag_MenuBrowser = 'MenuBrowser'
    MovieTag_MainMenu = 'MainMenu'
    MovieTag_MissionCompletion = 'MissionCompletion'
    MovieTag_PRCStore = 'PRCStore'
    MovieTag_Store = 'Store'
    MovieTag_Terminal = 'Terminal'
    MovieTag_Training = 'Training'
    MovieTag_Elevator = 'Elevator'
    MovieTag_Mail = 'Mail'
    MovieTag_Splash = 'Splash'
    MovieTag_GalaxyMap = 'GalaxyMap'
    MovieTag_ChoiceGUI = 'ChoiceGUI'
    MovieTag_PartySelect = 'PartySelect'
    MovieTag_Personalization = 'Personalization'
    MovieTag_NewCharacter = 'NewCharacter'
    MovieTag_Options = 'Options'
    MovieTag_Journal = 'Journal'
    MovieTag_Codex = 'Codex'
    MovieTag_Manual = 'Manual'
    MovieTag_Accomplishments = 'Accomplishments'
    MovieTag_NetworkRegistration = 'NetworkRegistration'
    MovieTag_GameOver = 'GameOver'
    MovieTag_SquadRecord = 'SquadRecord'
    MovieTag_Credits = 'Credits'
    MovieTag_DesignerUI = 'DesignerUI'
    MovieTag_Specialization = 'Specialization'
    MovieTag_Save = 'Save'
    MovieTag_Load = 'Load'
    MovieTag_AreaMap = 'Areamap'
    MovieTag_MessageBox = 'messageBox'
    MovieTag_QueuedMessageBox = 'QueuedMessageBox'
    MovieTag_HintBox = 'HintBox'
    MovieTag_Slideshow = 'slideshow'
    MovieTag_Markers = 'Markers'
    MovieTag_ObjectiveText = 'ObjectiveText'
    MovieTag_WeaponSelect = 'WeaponSelect'
    MovieTag_PlayerCountdown = 'PlayerCountdown'
    MovieTag_GalaxyAtWar = 'galaxyAtWar'
    MovieTag_WarAssets = 'WarAssets'
    MovieTag_OpeningTitles = 'OpeningTitles'
    MovieTag_SaveIndicatorMessage = 'SaveIndicatorMessage'
    MovieTag_AtlasHUD = 'AtlasHUD'
    MovieTag_MPEndOfMatch = 'MPEndOfMatch'
    MovieTag_MPLobby = 'MPLobby'
    MovieTag_MPAppearance = 'MPAppearance'
    MovieTag_MPMatchResults = 'MPMatchResults'
    MovieTag_MPSelectKit = 'MPSelectKit'
    MovieTag_Leaderboard = 'Leaderboard'
    MovieTag_MPScoretags = 'MPScoretags'
    MovieTag_MPPauseMenu = 'MPPauseMenu'
    MovieTag_MPOptions = 'MPOptions'
    MovieTag_MPMatchConsumables = 'MPMatchConsumables'
    MovieTag_MPStore = 'MPStore'
    MovieTag_MPReinforcementsReveal = 'MPReinforcementsReveal'
    MovieTag_MPHUD = 'MPHUD'
    MovieTag_MPNewLobby = 'MPNewLobby'
    MovieTag_MPLobbyStatusBars = 'MPLobbyStatusBars'
    MovieTag_MPPromotion = 'MPPromotion'
    m_oSFResources = BioSFResources'BioSFResources.GUI_Sound_Mappings'
    InputHandler = SFXGUIInputHandler0
    m_nMaxHintStackHeight = 2
    m_eLastBrowserWheelSubPage = MEBrowserWheelSubPages.MBW_SP_Save
}
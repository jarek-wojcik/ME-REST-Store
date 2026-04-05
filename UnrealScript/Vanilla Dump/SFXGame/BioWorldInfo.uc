Class BioWorldInfo extends WorldInfo
    native
    config(Game);

struct native EffectsMaterialPriority 
{
    var(EffectsMaterialPriority) Name EffectsMaterial;
    var(EffectsMaterialPriority) int Priority;
};
struct native SubPageState 
{
    var int nPadding;
    var(SubPageState) MEBrowserWheelSubPages Page;
    var(SubPageState) BioBrowserStates State;
};
struct native WorldStreamingState 
{
    var(WorldStreamingState) Name Name;
    var(WorldStreamingState) bool Enabled;
};
struct native PlotStreamingSet 
{
    var(PlotStreamingSet) array<PlotStreamingElement> Elements;
    var(PlotStreamingSet) Name VirtualChunkName;
};
struct native PlotStreamingElement 
{
    var(PlotStreamingElement) Name ChunkName;
    var(PlotStreamingElement) int Conditional;
    var(PlotStreamingElement) bool bFallback;
};
enum BioBrowserStates
{
    BBS_NORMAL,
    BBS_ALERT,
    BBS_DISABLED,
};
enum MEBrowserWheelSubPages
{
    MBW_SP_Map,
    MBW_SP_Save,
    MBW_SP_SquadRecord,
    MBW_SP_Load,
    MBW_SP_Journal,
    MBW_SP_DataPad,
    MBW_SP_Options,
    MBW_SP_ReturnToMainMenu,
    MBW_SP_ExitGame,
    MBW_SP_Manual,
};
enum JournalSortMethods
{
    JSM_Newest,
    JSM_Name,
    JSM_Oldest,
};
enum EPlayerRenderStateSetting
{
    PRSS_NEARCLIP,
};
enum BioLocalVariableObjectType
{
    BIO_LVOT_PLAYER,
    BIO_LVOT_OWNER,
    BIO_LVOT_TARGET,
    BIO_LVOT_BYTAG,
    BIO_LVOT_SPEAKER,
};

var array<SFXSmokeActorBase> SmokeList;
var transient array<BioSeqAct_FaceOnlyVO> m_aCurrentFaceOnlyVOs;
var(BioWorldInfo) string m_sFriendlyName;
var transient string m_sCinematicSkipEvent;
var config transient array<float> m_fLookAtDelays;
var array<Actor> SelectableActors;
var array<Actor> RadarActors;
var array<SFXNav_LadderNode> Ladders;
var(BioWorldInfo) array<PlotStreamingSet> PlotStreaming;
var(BioWorldInfo) array<WorldStreamingState> m_WorldStreamingStates;
var(BioWorldInfo) string m_sDestinationAreaMap;
var(BioWorldInfo) array<int> m_pScannedClusters;
var(BioWorldInfo) array<int> m_pScannedSystems;
var(BioWorldInfo) array<int> m_pScannedPlanets;
var transient array<SubPageState> SubPageStateOverrides;
var(BioWorldInfo) config array<EffectsMaterialPriority> EffectsMaterialPriorities;
var(BioWorldInfo) array<Object> m_AutoPersistentObjects;
var(BioWorldInfo) Vector m_vDestination;
var config Name m_nmPS3RubberMouthAnimName;
var transient BioBaseSquad m_playerSquad;
var BioTimerList TimerList;
var transient BioQuestProgressionMap m_oQuestProgress;
var transient BioDiscoveredCodexMap m_oDiscoveredCodex;
var transient int m_nJournalLastSelectedMission;
var transient int m_nJournalLastSelectedAssignment;
var transient int m_nCodexLastSelectedPrimary;
var transient int m_nCodexLastSelectedSecondary;
var transient BioConversationController m_pConvCondCheckOverride;
var BioPlayerController LocalPlayerController;
var(BioWorldInfo) int m_nRichPresenceContextStringIndex;
var(BioWorldInfo) GFxMovieInfo m_oAreaMap;
var(BioWorldInfo) GFxMovieInfo m_oParentAreaMap;
var config float m_fConversationInterruptDistance;
var config float m_fIdleCameraSpeed;
var config transient float m_fNoSkipBuffer;
var config transient float m_fConvLookAtMaxRange;
var config stringref m_srProfileNotSignedInWarningMsg;
var config transient int m_nAutoBotMPKit;
var config transient int m_nAutoBotLevel;
var config transient int m_nAutoBotEnemyDifficulty;
var config transient float m_fAutoBotAttackPowerPercent;
var config transient float m_fAutoBotDefensePowerPercent;
var privatewrite transient float m_fTimeLevelBecameLive;
var(PlayerSpawning) int ForcedCasualAppearanceID;
var BioInGamePropertyEditor m_oPropertyEditor;
var const config float m_fGameOverPauseTime;
var WwiseEventPairObject m_pEndGameMusicEvent;
var const transient noimport WwiseEnvironmentVolume HighestPriorityAudioEnvVolume;
var transient export BioConversationManager m_pConversationManager;
var transient export BioEventNotifier EventNotifier;
var transient export SFXPlotTreasure m_oTreasure;
var transient export BioSubtitles m_pSubtitles;
var transient export BioPhysicsSounds m_PhysicsSound;
var(BioWorldInfo) const export BioUIWorld m_UIWorld;
var export BioPowerManager m_oPowerManager;
var transient bool m_bJournalShowingMissions;
var transient bool m_bCodexShowingPrimary;
var(BioWorldInfo) bool m_bInvokesHintMessages;
var(BioWorldInfo) bool m_bPlayerRequiresFullHelmet;
var transient bool m_bCinematicSkip;
var transient bool m_bDisableCinematicSkip;
var transient bool m_bForceCinematicDamage;
var bool m_bFlushSFHud;
var config bool m_bDebugCameras;
var config bool m_bPartyMembersImmuneToExternalForce;
var config transient bool m_bAutoBotUseMin1Health;
var privatewrite transient bool m_bLevelIsLive;
var(PlayerSpawning) bool bCombatLevel;
var(PlayerSpawning) bool bCreateAndShowWeapons;
var(PlayerSpawning) bool bUseCasualAppearance;
var transient bool m_bGameWasPaused;
var transient bool bKismetShowHUD;
var(BioWorldInfo) bool m_bAllowBrowserWheel;
var(BioWorldInfo) bool bSupportsPrecomputedLightVolumes;
var transient BioBrowserStates m_lstBrowserAlerts[10];
var transient JournalSortMethods m_nJournalSortMethod;

public final iterator native function AllControllersCloseToSegment(Class<Controller> BaseClass, out Controller C, Vector LineStart, Vector LineEnd, float MaxDistance);

public event function CauseEvent(Name EventName)
{
    if (GetLocalPlayerController() != None)
    {
        GetLocalPlayerController().CauseEvent(EventName);
    }
}
public native function bool CheckConditional(int nConditional, optional int nParam = 0);

public event function bool CheckState(int nState)
{
    local BioGlobalVariableTable gv;
    
    gv = GetGlobalVariables();
    return gv.GetBool(nState);
}
public event function ClearCurrentGame()
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.bGameInProgress = FALSE;
    Engine.bNewPlayer = FALSE;
    Engine.m_DesiredStartPoint = 'None';
    GetGlobalVariables().ClearAllVariables();
    m_oQuestProgress.Clear();
    m_oDiscoveredCodex.Clear();
}
public native function EndAllFOVOs(bool bLowPriorityOnly);

public native function EndFOVO(BioSeqAct_FaceOnlyVO pFOVO);

public native function ExecuteConsequence(int nConsequence, optional int nParam = 0);

public native function ExecuteStateTransition(int nTransition, optional int nParam = 0);

public final native function bool GetAutoBotsEnabled();

public final native function int GetAutoBotsLobbyWaitTime();

public final native function bool GetCurrentStreamingChunkName(out Name nmStreamingChunkName);

public native function string GetDetailedVersionString();

public native function string GetEpicVersionString();

public native function GetGlobalEvents(Class<Object> EventClass, out array<SequenceEvent> aEvents);

public native function BioGlobalVariableTable GetGlobalVariables();

public final native function bool GetGuiInputPermission(byte nEvent);

public native function bool GetLocalBoolVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag, optional int nParam);

public native function float GetLocalFloatVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag, optional int nParam);

public native function int GetLocalIntegerVariable(BioLocalVariableObjectType eObjectType, Name GetFunctionName, optional Name sTag, optional int nParam);

public native function BioPlayerController GetLocalPlayerController();

public final native function float GetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState);

public native function string GetVersionString();

public native function bool HasConditional(int nConditional);

public static final native function bool IsActorHenchman(Actor Actor);

public static final native function bool IsActorPlayer(Actor Actor);

public native function bool IsAmbientOKToStart();

public native function bool IsFOVOPlaying(BioSeqAct_FaceOnlyVO pFOVO, optional bool bAnyFOVO);

public native function bool IsOKToStartFOVO(BioSeqAct_FaceOnlyVO pFOVO);

public final native function MoveToArea(Name sAreaName, Name sNextAreaStartPoint, optional string sArguments);

public native function OnNewGameStartRequest(Name RemoteEvent);

public function PauseGame(bool bPause)
{
    local SFXGRI SFXGRI;
    
    SFXGRI = SFXGRI(GRI);
    if (SFXGRI == None || SFXGRI.bPauseForCommand)
    {
        bPlayersOnly = bPause;
    }
}
public final native function PlayEndGameMusic();

public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    TimerList = new (Outer) Class'BioTimerList';
    if (m_oPropertyEditor != None)
    {
        m_oPropertyEditor.Initialize();
    }
    m_pSubtitles.ClearAllSubtitles();
}
public simulated function PreBeginPlay()
{
    if (bIsUIWorld || bIsMenuLevel || bIsLobbyLevel)
    {
        EmitterPoolClassPath = "";
        DecalManagerClassPath = "";
        FractureManagerClassPath = "";
        ParticleEventManagerClassPath = "";
    }
    Super.PreBeginPlay();
}
public event simulated function ServerTravel(string URL, optional bool bAbsolute, optional bool bShouldSkipGameNotify)
{
    local bool bEnableRestoration;
    local string Options;
    local SFXGRI LocalSFXGRI;
    local SFXHostMigration HostMigration;
    
    HostMigration = Class'SFXHostMigration'.static.GetHostMigration();
    if (HostMigration != None)
    {
        LocalSFXGRI = SFXGRI(GRI);
        Options = Split(URL, "?");
        bEnableRestoration = LocalSFXGRI != None && Class'GameInfo'.static.HasOption(Options, "HostMigration");
        HostMigration.EnableRestoration(bEnableRestoration);
        if (SFXPawn_Player(GetALocalPlayerController().Pawn) != None)
        {
            SFXPawn_Player(GetALocalPlayerController().Pawn).PreClientTravel();
        }
    }
    Super.ServerTravel(URL, bAbsolute, bShouldSkipGameNotify);
}
public final native function SetAutoBotsEnabled(bool bEnabled);

public native function SetFOVOAsPlaying(BioSeqAct_FaceOnlyVO pFOVO);

public native function SetGlobalTlk(bool bMale, optional bool bPurge = TRUE);

public event function SetPlayersControllerId(LocalPlayer Player, int ControllerId)
{
    Player.SetControllerId(ControllerId);
}
public final native function SetRenderStateOfPlayer(EPlayerRenderStateSetting RenderState, float fValue);

public final native function SetRenderStateOfPlayerToDefault(EPlayerRenderStateSetting RenderState);

public final native function SetStreamingState(Name StateName, bool bValue);

public simulated function Tick(float fDeltaT)
{
    if (TimerList != None)
    {
        TimerList.Tick(fDeltaT);
    }
    TickLocal(fDeltaT);
}
private final native function TickLocal(float DeltaTime);

public native function bool TriggerCinematicSkippedEvent();

public function StartMatch()
{
    local BioPawn oPlayer;
    local BioWorldInfo oBWorldInfo;
    local string sStartMapName;
    local string sMapName;
    local int nTemp;
    
    oBWorldInfo = BioWorldInfo(WorldInfo);
    if (oBWorldInfo != None)
    {
        if (oBWorldInfo.m_playerSquad != None)
        {
            oPlayer = oBWorldInfo.m_playerSquad.CachedPlayerPawn;
            if (oPlayer != None)
            {
                sStartMapName = "EntryMenu";
                sMapName = oBWorldInfo.GetURLMap();
                nTemp = Len(sStartMapName);
                sMapName = Mid(sMapName, 0, nTemp);
                if (sMapName != sStartMapName)
                {
                    BioPlayerController(oPlayer.Controller).SetRichPresence();
                }
            }
        }
    }
}
public function AddBrowserWheelStateOverride(SubPageState i_SubStateOverride)
{
    SubPageStateOverrides.AddItem(i_SubStateOverride);
}
public function ClearBrowserWheelStateOverride()
{
    SubPageStateOverrides.Remove(0, SubPageStateOverrides.Length);
}
public function BioConversationManager GetConversationManager()
{
    return m_pConversationManager;
}
public final function MakeLevelLive()
{
    m_bLevelIsLive = TRUE;
    m_fTimeLevelBecameLive = GameTimeSeconds;
}
public final function RequestStartLegacyGame()
{
    RequestStartNewGame(SFXEngine(Class'Engine'.static.GetEngine()).LegacyImportSaveGame.PlayerRecord.bIsFemale, 'None', TRUE, FALSE);
}
public final function RequestStartNewGame(optional bool bFemale, optional Name RemoteEvent, optional bool bLegacySave = FALSE, optional bool bImportSave = FALSE)
{
    local BioPlayerController BPC;
    local SFXGUIInteraction oSFXGUIInteraction;
    local SFXEngine Engine;
    
    if (RemoteEvent == 'None')
    {
        RemoteEvent = 're_StartNewGame';
    }
    BPC = GetLocalPlayerController();
    if (BPC == None)
    {
        return;
    }
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.bGameInProgress = FALSE;
    Engine.ProgressPlayer.bIsFemale = bFemale;
    if (!bLegacySave)
    {
        SFXEngine(Class'Engine'.static.GetEngine()).LegacyImportSaveGame = None;
    }
    if (!bImportSave)
    {
        SFXEngine(Class'Engine'.static.GetEngine()).PlusImportSaveGame = None;
    }
    OnNewGameStartRequest(RemoteEvent);
    oSFXGUIInteraction = Class'SFXGUIInteraction'.static.GetInstance();
    if (oSFXGUIInteraction == None)
    {
        return;
    }
    oSFXGUIInteraction.StopGuiMusic();
    oSFXGUIInteraction.ShowBlackScreen(BPC, FALSE);
}
public final function RequestStartPlusGame()
{
    RequestStartNewGame(SFXEngine(Class'Engine'.static.GetEngine()).PlusImportSaveGame.PlayerRecord.bIsFemale, 'None', FALSE, TRUE);
}
public final function ShowDebugMessage(string Message)
{
    local SFXPlayerController PC;
    
    foreach AllControllers(Class'SFXPlayerController', PC)
    {
        if (PC != None && PC.Pawn != None)
        {
            PC.Pawn.ClientMessage(Message);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioConversationManager Name=defaultConversationManager
    End Object
    Begin Object Class=BioDiscoveredCodexMap Name=BioDiscoveredCodex0
    End Object
    Begin Object Class=BioEventNotifier Name=BEN
    End Object
    Begin Object Class=BioPhysicsSounds Name=oPhysicsSound01
    End Object
    Begin Object Class=BioPowerManager Name=PowerManager
    End Object
    Begin Object Class=BioQuestProgressionMap Name=BioQuestProgress0
    End Object
    Begin Object Class=BioSubtitles Name=oDefaultSubtitles
    End Object
    Begin Object Class=BioUIWorld Name=oUIWorld
        m_CustomLightingData = {
                                KeyLight_Scale_Red = 0.0, 
                                KeyLight_Scale_Green = 0.0, 
                                KeyLight_Scale_Blue = 0.0, 
                                FillLight_Scale_Red = 0.0, 
                                FillLight_Scale_Green = 0.0, 
                                FillLight_Scale_Blue = 0.0, 
                                RimLightColor = {B = 0, G = 0, R = 0, A = 0}, 
                                RimLightYaw = 0.0, 
                                RimLightPitch = 0.0, 
                                BouncedLightingIntensity = 0.0, 
                                bCastShadows = FALSE, 
                                LightingType = EConvLightingType.ConvLighting_Dynamic
                               }
    End Object
    Begin Template Class=PhysicsLODVerticalDestructible Name=PhysicsLODVerticalDestructible0
    End Template
    Begin Template Class=PhysicsLODVerticalEmitter Name=PhysicsLODVerticalEmitter0
    End Template
    Begin Object Class=SFXPlotTreasure Name=oPlotTreasure
    End Object
    Begin Object Class=WwiseEventPairObject Name=EndGameMusicWwiseEventPair
        Play = WwiseEvent'Wwise_Generic_Gameplay_Streaming.Play_mus_death'
        Stop = WwiseEvent'Wwise_Generic_Gameplay_Streaming.Stop_mus_death'
    End Object
    m_fLookAtDelays = (0.5, 
                       0.600000024, 
                       0.699999988, 
                       0.75, 
                       0.800000012, 
                       0.899999976, 
                       1.0, 
                       1.04999995, 
                       1.10000002, 
                       1.14999998
                      )
    EffectsMaterialPriorities = ({EffectsMaterial = 'Masked', Priority = 11}, 
                                 {EffectsMaterial = 'Stasis', Priority = 10}, 
                                 {EffectsMaterial = 'MeltDeath', Priority = 10}, 
                                 {EffectsMaterial = 'Possession', Priority = 9}, 
                                 {EffectsMaterial = 'Stealth', Priority = 9}, 
                                 {EffectsMaterial = 'Stealth_2', Priority = 9}, 
                                 {EffectsMaterial = 'PowerArmor', Priority = 8}, 
                                 {EffectsMaterial = 'Cryo', Priority = 7}, 
                                 {EffectsMaterial = 'Fire', Priority = 5}, 
                                 {EffectsMaterial = 'Fissure', Priority = 5}, 
                                 {EffectsMaterial = 'Biotics', Priority = 4}, 
                                 {EffectsMaterial = 'Adrenaline', Priority = 3}, 
                                 {EffectsMaterial = 'Tech', Priority = 5}, 
                                 {EffectsMaterial = 'Slime', Priority = 1}, 
                                 {EffectsMaterial = 'electric', Priority = 1}
                                )
    m_nmPS3RubberMouthAnimName = 'RubberMouth'
    m_oQuestProgress = BioQuestProgress0
    m_oDiscoveredCodex = BioDiscoveredCodex0
    m_nJournalLastSelectedMission = -1
    m_nJournalLastSelectedAssignment = -1
    m_nCodexLastSelectedPrimary = -1
    m_nCodexLastSelectedSecondary = -1
    m_fConversationInterruptDistance = 999999.0
    m_fIdleCameraSpeed = 1.0
    m_fNoSkipBuffer = 0.699999988
    m_fConvLookAtMaxRange = 500.0
    m_srProfileNotSignedInWarningMsg = $174310
    m_nAutoBotMPKit = -1
    m_nAutoBotLevel = 20
    m_nAutoBotEnemyDifficulty = 2
    m_fAutoBotAttackPowerPercent = 1.0
    m_fAutoBotDefensePowerPercent = 0.100000001
    ForcedCasualAppearanceID = -1
    m_fGameOverPauseTime = 3.0
    m_pEndGameMusicEvent = EndGameMusicWwiseEventPair
    m_pConversationManager = defaultConversationManager
    EventNotifier = BEN
    m_oTreasure = oPlotTreasure
    m_pSubtitles = oDefaultSubtitles
    m_PhysicsSound = oPhysicsSound01
    m_UIWorld = oUIWorld
    m_oPowerManager = PowerManager
    m_bJournalShowingMissions = TRUE
    m_bCodexShowingPrimary = TRUE
    m_bFlushSFHud = TRUE
    m_bPartyMembersImmuneToExternalForce = TRUE
    m_bAutoBotUseMin1Health = TRUE
    bCombatLevel = TRUE
    bCreateAndShowWeapons = TRUE
    bKismetShowHUD = TRUE
    m_bAllowBrowserWheel = TRUE
    DefaultPostProcessSettings = {
                                  Bloom_Scale = 0.200000003, 
                                  DOF_BlurKernelSize = 10.0, 
                                  DOF_MaxNearBlurAmount = 0.100000001, 
                                  DOF_MaxFarBlurAmount = 0.300000012, 
                                  DOF_FocusInnerRadius = 1000.0, 
                                  bEnableDOF = TRUE
                                 }
    EmitterVertical = PhysicsLODVerticalEmitter0
    DestructibleVertical = PhysicsLODVerticalDestructible0
    bNoDefaultInventoryForPlayer = TRUE
}
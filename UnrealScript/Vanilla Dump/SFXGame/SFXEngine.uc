Class SFXEngine extends GameEngine
    implements(BioDynamicLoadInterface)
    native
    transient
    config(Engine);

enum EWaitMessage
{
    EWaitMessage_Generic,
    EWaitMessage_MatchStarted,
    EWaitMessage_MatchEnded,
};
struct native PackageRemapInfo 
{
    var Name PackageName;
    var Name SeekFreePackageName;
};
struct native SeekfreeCommonPackageInfo 
{
    var Name SeekfreeName;
    var Name CommonName;
};
struct native DynamicLoadInfo 
{
    var string ObjectName;
    var array<PlayerController> RemotePlayerWithHandle;
    var Name SeekFreePackageName;
    var transient Object CachedObjectHandle;
    var transient Object LoadedLinkerRoot;
    var transient int ObjectNetID;
    var bool bReplicate;
    var transient bool bNetIDHasBeenSet;
};
struct native unkstructflag SFXCareerCacheEntry 
{
    var init string Career;
    var init string firstName;
    var init stringref className;
    var init int SaveTypes;
    var init EOriginType Origin;
    var init ENotorietyType Notoriety;
};
struct native unkstructflag SFXSaveGameCommandEventArgs 
{
    var init SFXSaveDescriptor Descriptor;
    var init array<SFXCareerDescriptor> Careers;
    var init array<string> CorruptedCareers;
    var init int AdditionalFreeBytesNeeded;
    var init int TotalFreeBytes;
    var init int PreparedSaveSize;
    var init bool bSuccess;
    var init bool bRetry;
    var init bool bPause;
    var init bool bNeedsFreeSpace;
    var init bool bTotalFreeBytesSet;
    var init bool bPreparedSaveSizeSet;
    var init ESFXSaveGameAction Action;
};
struct native unkstructflag SFXCareerDescriptor 
{
    var init string Career;
    var init array<SFXSavePair> Saves;
    var init array<SFXSaveDescriptor> CorruptedSaves;
};
struct native unkstructflag SFXSavePair 
{
    var init SFXSaveDescriptor Descriptor;
    var init SFXSaveGame Save;
};
struct native unkstructflag SFXSaveDescriptor 
{
    var init string Career;
    var init int Index;
    var init ESFXSaveGameType Type;
    
    structdefaultproperties
    {
        Index = -1
    }
};
enum ESFXNetworkErrorStatus
{
    ErrorStatus_NoError,
    ErrorStatus_DisplayingPrompt,
    ErrorStatus_DisplayPromptAfterTravel,
};
enum ESFXSaveGameType
{
    SaveGameType_Manual,
    SaveGameType_Quick,
    SaveGameType_Auto,
    SaveGameType_Chapter,
    SaveGameType_Export,
    SaveGameType_Legend,
};
enum ESFXSaveGameAction
{
    SaveGame_DoNothing,
    SaveGame_Load,
    SaveGame_Save,
    SaveGame_Delete,
    SaveGame_CreateCareer,
    SaveGame_DeleteCareer,
    SaveGame_EnumerateCareers,
    SaveGame_EnumerateSaves,
    SaveGame_QueryFreeSpace,
    SaveGame_PrepareSave,
    SaveGame_DeletePreparedSave,
};
const EncodedSaveDescriptorMultiplier = 1000000;

var transient UniqueNetId m_oInitialPlayerID;
var transient UniqueNetId m_oProfilePlayerID;
var transient Double LoadMapTimeStamp;
var transient QWord LoadMapFrameCounter;
var config transient PlayerInfoEx DefaultPlayer;
var transient PlayerInfoEx ProgressPlayer;
var transient PlayerInfoEx NewPlayer;
var(SFXEngine) GalaxyMapSaveRecord SavedGalaxyMapRecord;
var(SFXEngine) array<Guid> DeadPawnList;
var(SFXEngine) array<Guid> UseModuleList;
var(SFXEngine) array<LevelTreasureSaveRecord> SavedTreasure;
var(SFXEngine) array<KismetBoolSaveRecord> SavedKismetList;
var(SFXEngine) array<HenchmanSaveRecord> HenchmanRecords;
var(SFXEngine) array<DoorSaveRecord> SavedDoorList;
var(SFXEngine) array<PlaceableSaveRecord> SavedPlaceableList;
var(SFXEngine) array<string> CorruptedCareers;
var(SFXEngine) array<SFXCareerCacheEntry> CareerCache;
var(SFXEngine) delegate<OnResumeGameComplete> ResumeGameCompleteDelegate;
var config array<string> MultiDisc1;
var config array<string> MultiDisc2;
var array<ELoadoutWeapons> PlayerLoadoutGroups;
var array<WeaponModSaveRecord> PlayerWeaponMods;
var const config array<DynamicLoadInfo> DynamicLoadMapping;
var const config array<SeekfreeCommonPackageInfo> SeekfreeCommonPackageMap;
var const transient array<PackageRemapInfo> DynamicLoadPackageRemapping;
var transient array<int> AsyncLoadingMapping;
var string sLastNetworkError;
var transient string LoadMapFrom;
var const config array<string> SFXUniqueIDs;
var delegate<SFXSaveCommandCallback> __SFXSaveCommandCallback__Delegate;
var delegate<OnResumeGameComplete> __OnResumeGameComplete__Delegate;
var transient native Object PlayerVariables;
var Name PlayerLoadoutWeapons[6];
var transient Name m_DesiredStartPoint;
var config int GUIMultiDisplayMaxWidth;
var config float GUIMultiDisplayBezelTolerance;
var(SFXEngine) float LastSaveTime;
var(SFXEngine) float LastSecondsPlayed;
var(SFXEngine) int CurrentDeviceID;
var(SFXEngine) int CurrentLoadingTip;
var(SFXEngine) SFXSaveGame CurrentSaveGame;
var(SFXEngine) SFXSaveGame LegacyImportSaveGame;
var(SFXEngine) SFXSaveGame PlusImportSaveGame;
var(SFXEngine) config stringref AutoSaveInsufficientSpaceText;
var(SFXEngine) config stringref QuickSaveInsufficientSpaceText;
var(SFXEngine) config stringref InsufficentSpaceAcknowledgedText;
var transient SFXOnlinePlayerStorage OnlinePlayerStorage;
var transient SFXSaveManagerMP MPSaveManager;
var transient SFXAccomplishmentManager AccomplishmentManager;
var transient SFXTelemetry Telemetry;
var transient SFXHostMigration HostMigration;
var(SFXEngine) transient stringref CorruptCareerWarningText;
var(SFXEngine) transient stringref ConfirmDeleteCorruptText;
var(SFXEngine) transient stringref CancelDeleteCorruptText;
var transient float LastCantContinueTime;
var transient stringref srCantContinueErrorMessage;
var config float LoadingScreenTimeout;
var config float DebugLoadingScreenTimeout;
var float DesiredLoadingScreenTimeout;
var float ActualLoadingScreenTimeout;
var int Player1ControllerID;
var transient SFXAsyncAssetLoader AsyncAssetLoader;
var(SFXEngine) transient export SFXLoadMovieManager LoadMovieManager;
var config bool CopySaveToSkynet;
var config bool GenerateQASaveLibrary;
var config bool bEnableAccomplishmentManager;
var config bool bEnableFastResume;
var(SFXEngine) bool bCanWriteSaveToStorage;
var(SFXEngine) bool bQuickSaveInProgress;
var transient bool bPendingRemountDLC;
var transient bool bPendingSaveProfile;
var transient bool bPendingDisableAutoSave;
var transient bool bFlushInputRequested;
var(SFXEngine) bool bPlayerNeedsLoad;
var(SFXEngine) bool bPlayerLoadPosition;
var(SFXEngine) bool bMPTransitionToEntryMenu;
var transient bool m_bRenderingSuspended;
var transient bool m_bProfileInitialized;
var transient bool bHasProfileCantContinueError;
var transient bool bDisableProfileReconnection;
var transient bool bNewPlayer;
var config transient bool bInitPlayer;
var transient bool bGameInProgress;
var transient bool bUsedSetMission;
var bool bSimulatedNetworkError;
var transient bool LoadMapWithFastResume;
var transient bool DebugTraceBlockingSeekFreeLoad;
var const config bool bUploadFaceCodesToBlaze;
var(SFXEngine) transient byte PendingModeToRemove;
var ESFXNetworkErrorStatus eNetworkErrorStatus;

public native function BioShowDebugMessageBox(string sMessage);

public final native function CacheProfileData(SFXProfileSettings Profile);

public final native function Callback_ConfirmDeleteCorruptCareers(bool bAPressed, int Context);

public final native function CheckForCorruptCareers();

public final native function ClearCurrentSaveDescriptor();

public static final native function ClearNetworkPerfStats();

public final native function ClearSaveCache();

public final native function CloseLoadScreen(bool bDelayStopUntilGameHasRendered);

public final native function CreateCareer(string firstName, stringref srClass, EOriginType Origin, ENotorietyType Notoriety, optional delegate<SFXSaveCommandCallback> Callback);

public final native function CreateCareerInternal(string firstName, string className, EOriginType Origin, ENotorietyType Notoriety, int Year, int Month, int Day, int MSSinceMidnight, optional delegate<SFXSaveCommandCallback> Callback);

public static final native function Guid CreateGUID();

public final native function PlayerInfoEx CurrentPlayerInfo();

public static final native function float CurrentSystemTimeSeconds();

public static final native function bool DoesPackageExist(string PackageName);

public final event function EnableRestorationForHostMigration(bool bEnable)
{
    if (HostMigration != None)
    {
        HostMigration.EnableRestoration(bEnable);
    }
}
public final native function bool FastResumeGame(optional delegate<OnResumeGameComplete> Callback);

public native function bool FindCurrentSaveDevice();

public native function FlushIOHandles();

public final native function ForceGUIUpdate();

public final native function GenerateCareer(string firstName, string className, EOriginType Origin, ENotorietyType Notoriety, int Year, int Month, int Day, int MSSinceMidnight, out string OutCareer, out string OutDisplayName);

public final native function int GetCurrentDevice();

public final native function SFXSaveDescriptor GetCurrentSaveDescriptor();

public final native function float GetCurrentTime();

public native function string GetDisconnectFallbackMap();

public final native function DynamicLoadInfo GetDynamicLoadMappingInfo(string ObjectName);

public final native function DynamicLoadInfo GetDynamicLoadMappingInfoByNetID(int ObjectNetID);

public final event function string GetHostMigrationMapName()
{
    local WorldInfo WI;
    local SFXGRI GRI;
    
    WI = GetCurrentWorldInfo();
    GRI = SFXGRI(WI.GRI);
    if (GRI != None && GRI.IsGameOver())
    {
        return GetDefaultLobbyMap();
    }
    else
    {
        return WI.GetMapName();
    }
}
public final native function int GetLocalPlayerControllerId();

public static final native function GetNetworkPerfStats(out int NumConnection, out int AvrOutBytesPerSecond, out int PeekOutBytesPerSecond, out int AvrPing);

public native function int GetPlayerVariable(Name VariableName);

public final native function float GetPlayTimeSeconds();

public final native function SFXProfileSettings GetProfileSettings();

public native function BioWorldInfo GetRealWorldInfo();

public static final native function int GetSFXUniqueIDFromStr(string Str);

public static final native function string GetStrFromSFXUniqueID(int UniqueId);

public native function HandleLoadingScreenTimeout();

public event function bool HasCantContinueError()
{
    return srCantContinueErrorMessage != 0;
}
public event function bool HasCantContinueProfileError()
{
    return bHasProfileCantContinueError;
}
public native function bool HasCommandlineOption(string Option);

public static final native function bool HasDLC(int ModuleID);

public final native function ImportLegacyCharacter(SFXSaveGame SaveGame);

public final native function ImportPlusCharacter(SFXSaveGame SaveGame);

public final event function InitializeAccomplishmentManager()
{
    if (AccomplishmentManager == None && bEnableAccomplishmentManager)
    {
        AccomplishmentManager = new (Self) Class'SFXAccomplishmentManager';
        AccomplishmentManager.Initialize();
    }
}
public final event function InitializeOnlinePlayerStorage()
{
    if (OnlinePlayerStorage == None)
    {
        OnlinePlayerStorage = new (Self) Class'SFXOnlinePlayerStorage';
    }
}
public final event function InitializePlayerStorage()
{
    if (OnlineSubsystem == None)
    {
        return;
    }
    InitializeMPSaves();
    SFXOnlineComponentUnrealPlayer(OnlineSubsystem.PlayerInterface).ClearOnlineProfileCaches();
    ReadPlayerStorage(ReadPlayerStorageComplete);
}
public final native function bool IsCurrentDeviceValid();

public static event function bool IsDemo()
{
    return FALSE;
}
public static native function bool IsDemoMode();

public native function bool IsInCinematicMode();

public native function bool IsInCombatMode();

public final native function bool IsPerformingSaveAction(ESFXSaveGameAction eAction);

public final event function bool IsReadyToBeHost()
{
    if (HostMigration != None && GetCurrentWorldInfo() != None)
    {
        return HostMigration.HasCompleteAndValidState(SFXGRI(GetCurrentWorldInfo().GRI));
    }
    return FALSE;
}
public final native function bool IsSaving();

public static final native function bool IsSeekFreeObjectSupported(string ObjectName);

public native function bool IsStreamingWhileInGame();

public static final native function LaunchUnreaper();

public native function LaunchUnreaperWithDiscCheck();

public event function LoadingScreenStarted()
{
    SetLoadingScreenTimeout(LoadingScreenTimeout);
}
public event function LoadingScreenTimedOut(optional EWaitMessage WaitMessage = 0)
{
    local BioWorldInfo WI;
    local SFXPlayerController PC;
    
    WI = BioWorldInfo(GetCurrentWorldInfo());
    PC = WI != None ? SFXPlayerController(WI.GetLocalPlayerController()) : None;
    if (PC != None)
    {
        if (PC.LoadingScreenTimedOut(WaitMessage))
        {
            return;
        }
    }
    HandleLoadingScreenTimeout();
    Class'SFXTelemetry'.static.SendBool('TelemetryHook_LoadingScreenTimedOut', FALSE);
}
public final native function LoadPlayer();

public final function LoadPlayerWeapons()
{
    local int idx;
    local LocalPlayer LP;
    
    for (idx = 0; idx < GamePlayers.Length; idx++)
    {
        LP = GamePlayers[idx];
        if (LP != None)
        {
            if (PlusImportSaveGame != None && PlusImportSaveGame.bIsValid)
            {
                PlusImportSaveGame.LoadPlayerWeapons(LP.ControllerId);
                continue;
            }
            if (CurrentSaveGame != None && CurrentSaveGame.bIsValid)
            {
                CurrentSaveGame.LoadPlayerWeapons(LP.ControllerId);
            }
        }
    }
}
public final native function LoadSaveGame(SFXSaveGame SaveGame);

public static final native function Object LoadSeekFreeObjectAsync(string ObjectName, Class<Object> ObjectClass, out EAsyncLoadStatus Status);

public static final native function Object LoadSeekFreeObjectAsyncByNetID(int ObjectNetID, Class<Object> ObjectClass, out EAsyncLoadStatus Status);

public static final native function Object LoadSeekFreeObjectBlocking(string ObjectName, Class<Object> ObjectClass);

public final event function OnBlazeDisconnect()
{
    MPSaveManager.bInitialized = FALSE;
    MPSaveManager.OnlineSave = None;
}
private final function OnOriginClosed()
{
    local BioPlayerController oPC;
    local SFXSaveDescriptor SaveDescriptor;
    local string Reason;
    
    Class'SFXTelemetry'.static.SendVoid('TelemetryHook_OriginClosed');
    oPC = BioWorldInfo(GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC != None && oPC.CanSave(Reason))
    {
        SaveDescriptor.Type = ESFXSaveGameType.SaveGameType_Auto;
        oPC.SaveGameEx(SaveDescriptor, OnSaveGameCompleteAfterOriginShutdown);
    }
    else
    {
        CloseGameAfterOriginShutdown();
    }
}
public delegate function OnResumeGameComplete(bool bWasSuccessful);

public final native function bool ParseCareer(string Career, out string firstName, out string className, out EOriginType Origin, out ENotorietyType Notoriety, out int Year, out int Month, out int Day, optional out int MSSinceMidnight);

public final native function QueryPlayerVariables(out array<Name> VariableNames, optional string SearchText);

public final native function QueueSaveGameCommand(ESFXSaveGameAction Action, optional const SFXSaveDescriptor SaveDescriptor, optional delegate<SFXSaveCommandCallback> Callback);

private final native function QueueSaveGameEx(SFXSaveDescriptor SaveDescriptor, delegate<SFXSaveCommandCallback> Callback);

public final function bool ReadPlayerStorage(delegate<OnlinePlayerInterface.OnReadPlayerStorageComplete> ReadPlayerStorageCompleteDelegate)
{
    local BioPlayerController PC;
    local int ControllerId;
    
    PC = BioWorldInfo(GetCurrentWorldInfo()).GetLocalPlayerController();
    ControllerId = LocalPlayer(PC.Player).ControllerId;
    OnlineSubsystem.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(ControllerId), ReadPlayerStorageCompleteDelegate);
    if (!OnlineSubsystem.PlayerInterface.ReadPlayerStorage(byte(ControllerId), OnlinePlayerStorage))
    {
        return FALSE;
    }
    return TRUE;
}
private final event function RegisterOriginEvents()
{
    local SFXOnlineSubsystem oOnlineSub;
    
    oOnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    if (oOnlineSub != None)
    {
        oOnlineSub.GetComponentOrigin().AddOriginClosedDelegate(OnOriginClosed);
    }
}
public native function ReLaunchExecutable();

public static final native function ReleaseSeekFreeObject(string ObjectName);

public static final native function ReleaseSeekFreeObjectByNetID(int ObjectNetID);

private final native function ReplicateLoadSeekFreeObject(int ObjectIndex);

private final native function ReplicateReleaseSeekFreeObject(int ObjectIndex);

public final native function ResumeRendering();

public final native function ResumeSaveGameCommandExecution();

private final function SaveGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.Descriptor.Type == ESFXSaveGameType.SaveGameType_Quick)
    {
        bQuickSaveInProgress = FALSE;
    }
    if (Args.bSuccess)
    {
        SetCurrentSaveGame(Args.Descriptor);
        bPendingSaveProfile = TRUE;
        UpdateCareerCache(Args.Descriptor, CurrentSaveGame);
    }
    else if (Args.bNeedsFreeSpace)
    {
        HandleNoFreeSpace(Args.Descriptor.Type, Args.AdditionalFreeBytesNeeded);
    }
    else if (Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        if (Abs(LastCantContinueTime - LastSaveTime) < 1.0)
        {
            Args.bRetry = TRUE;
            Args.bPause = HasCantContinueError();
        }
    }
}
public final native function ScanSaveData();

public final native function ScanSaveDataComplete(SFXSaveGameCommandEventArgs Args);

public final native function SendAndResetSkynetFPS(Name TriggerName, Name StateName, Name TierName, Name InChunkName, bool bIsFloor);

public final native function SetBlockOnStreaming();

public final native function SetLanguageForSpeech(string Language, optional bool UpdateProfile = FALSE);

public final native function SetLanguageForText(string Language, optional bool UpdateProfile = FALSE);

public final native function SetLanguageForVO(string Language, optional bool UpdateProfile = FALSE);

public native function SetLoadingScreenTimeout(float inTimeout);

public native function SetPlayerVariable(Name VariableName, int VariableValue);

public native function SetPlayerVariableViaEntitlements();

public native function SetPlotFlagsViaEntitlements(BioGlobalVariableTable InTable);

public final event function SetupInitialMPCharacters()
{
    if (MPSaveManager == None)
    {
        MPSaveManager = new (Self) Class'SFXSaveManagerMP';
        MPSaveManager.SetupInitialMPCharacters();
        MPSaveManager.SetupInitialMPPlayerVariables();
    }
}
public delegate function SFXSaveCommandCallback(SFXSaveGameCommandEventArgs Args);

public final native function ShowLoadScreen(const string LevelName);

public native function SuspendBlazeServerPing(bool suspend);

public final native function SuspendRendering();

public final native function bool TryGetCachedCareer(string Career, out SFXCareerCacheEntry OutEntry);

public final native function UpdateCareerCache(SFXSaveDescriptor SaveDescriptor, SFXSaveGame SaveGame);

public final native function UpdateCurrentDevice(int DeviceID);

public static final native function ValidateNetObjectIndex();

public final native function string ValidCharsFilter(string Sin, bool bFilterAccentedChars);

public function SFXAsyncAssetLoader GetAsyncAssetLoader()
{
    return AsyncAssetLoader;
}
public static final function Object GetSeekFreeObject(string ObjectName, Class<Object> ObjectClass)
{
    return Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(ObjectName, ObjectClass);
}
public function Callback_PlayerLoggedOut(bool bAPressed, int Context)
{
    ReLaunchExecutable();
}
private final function CloseGameAfterOriginShutdown()
{
    local SFXOnlineSubsystem oOnlineSub;
    local SFXOnlineComponentBlazeLoginPC loginComponent;
    
    oOnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    if (oOnlineSub != None)
    {
        loginComponent = oOnlineSub.GetComponentLogin();
        loginComponent.OnOriginClosed();
    }
}
private final function FastResumeGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess)
    {
        SlowResumeGameCallback(Args);
    }
    else if (TravelURL == "")
    {
        QueueSaveGameCommand(1, , SlowResumeGameCallback);
    }
    else
    {
        SlowResumeGameCallback(Args);
    }
}
public static final function Object GetSeekFreeObjectByName(Name ObjectName, Class<Object> ObjectClass)
{
    return Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(string(ObjectName), ObjectClass);
}
public static final function SFXEngine GetSFXEngine()
{
    return SFXEngine(Class'Engine'.static.GetEngine());
}
private final function HandleNoFreeSpace(ESFXSaveGameType Type, int AdditionalFreeBytesNeeded)
{
    local SFXProfileSettings ProfileSettings;
    local BioMessageBoxOptionalParams Params;
    local string InsufficientSpaceTextWithSize;
    local SFXGUIInteraction oGUI;
    local stringref Message;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None && (Type == ESFXSaveGameType.SaveGameType_Auto && Class'WorldInfo'.static.IsConsoleBuild(2) || Type == ESFXSaveGameType.SaveGameType_Quick && Class'WorldInfo'.static.IsConsoleBuild()))
    {
        Params.srAText = InsufficentSpaceAcknowledgedText;
        Params.srBText = $0;
        Params.bModal = TRUE;
        Params.bForcePlayersOnly = TRUE;
        Params.bNoFade = TRUE;
        if (Type == ESFXSaveGameType.SaveGameType_Auto)
        {
            bPendingDisableAutoSave = TRUE;
            ProfileSettings = GetProfileSettings();
            if (ProfileSettings != None)
            {
                ProfileSettings.SetAutoSaveConfigOption(FALSE);
            }
            Message = AutoSaveInsufficientSpaceText;
        }
        else
        {
            Message = QuickSaveInsufficientSpaceText;
        }
        SetCustomToken(1, string((AdditionalFreeBytesNeeded + 1023) / 1024));
        InsufficientSpaceTextWithSize = GetTokenisedString(Message);
        ClearCustomTokens();
        oGUI.QueueNamedMessageBoxEx('SaveFailed', 3, InsufficientSpaceTextWithSize, Params, HandleNoFreeSpaceCallback);
    }
}
private final function HandleNoFreeSpaceCallback(bool bAPressed, int Context);

public static final function bool HasRequiredDLC(const out array<int> ModuleIDs)
{
    local int idx;
    local bool bAllDLCFound;
    
    bAllDLCFound = TRUE;
    for (idx = 0; idx < ModuleIDs.Length; ++idx)
    {
        if (!HasDLC(ModuleIDs[idx]))
        {
            bAllDLCFound = FALSE;
            break;
        }
    }
    return bAllDLCFound;
}
public final function SFXHostMigration InitHostMigration(Class<SFXHostMigration> InstanceClass)
{
    if (HostMigration == None)
    {
        HostMigration = new (Self) InstanceClass;
    }
    return HostMigration;
}
public final function InitializeMPSaves()
{
    if (MPSaveManager == None)
    {
        MPSaveManager = new (Self) Class'SFXSaveManagerMP';
    }
    if (!MPSaveManager.bInitialized)
    {
        MPSaveManager.Initialize();
    }
}
public final function LoadSaveFromCallback(SFXSaveGameCommandEventArgs Args)
{
    if (Args.bSuccess)
    {
        SetCurrentSaveGame(Args.Descriptor);
        bPendingSaveProfile = TRUE;
        LoadSaveGame(Args.Careers[0].Saves[0].Save);
    }
}
private final function OnSaveGameCompleteAfterOriginShutdown(SFXSaveGameCommandEventArgs Args)
{
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC != None)
    {
        oPC.SaveProfile();
    }
    CloseGameAfterOriginShutdown();
}
public final function QueueSaveGameCommandWithLocation(ESFXSaveGameAction Action, optional const SFXSaveDescriptor SaveDescriptor, optional Vector location, optional delegate<SFXSaveCommandCallback> Callback)
{
    QueueSaveGameCommand(Action, SaveDescriptor, Callback);
}
private final function ReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local SFXOnlineSubsystem oOnlineSub;
    
    oOnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    if (MPSaveManager != None && bWasSuccessful)
    {
        MPSaveManager.LoadCharacters();
    }
    if (AccomplishmentManager != None)
    {
        AccomplishmentManager.LoadStorageData(LocalUserNum, bWasSuccessful);
    }
    OnlineSubsystem.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum, ReadPlayerStorageComplete);
    if (oOnlineSub != None)
    {
        oOnlineSub.GetComponentNotification().ReadPlayerStorageCallback(bWasSuccessful);
    }
}
public final function bool RemoveCachedCareer(string Career)
{
    local int Index;
    
    for (Index = 0; Index < CareerCache.Length; ++Index)
    {
        if (CareerCache[Index].Career == Career)
        {
            CareerCache.Remove(Index, 1);
            return TRUE;
        }
    }
    return FALSE;
}
public final function ResumeGame(optional delegate<OnResumeGameComplete> Callback)
{
    local SFXSaveDescriptor Descriptor;
    
    if (TravelURL == "")
    {
        ResumeGameCompleteDelegate = Callback;
        Descriptor = GetCurrentSaveDescriptor();
        QueueSaveGameCommand(1, Descriptor, FastResumeGameCallback);
    }
    else if (Callback != None)
    {
        Callback(FALSE);
    }
}
public final function SaveGameEx(SFXSaveDescriptor SaveDescriptor, optional delegate<SFXSaveCommandCallback> Callback)
{
    if (SaveDescriptor.Type == ESFXSaveGameType.SaveGameType_Quick)
    {
        if (bQuickSaveInProgress)
        {
            return;
        }
        else
        {
            bQuickSaveInProgress = TRUE;
        }
    }
    UploadFaceCodeToBlaze(CurrentSaveGame.PlayerRecord.firstName, CurrentSaveGame.PlayerRecord.faceCode);
    QueueSaveGameEx(SaveDescriptor, Callback);
}
private final function SetCurrentSaveGame(SFXSaveDescriptor Descriptor)
{
    local SFXProfileSettings ProfileSettings;
    local int PreviousEncodedSaveDescriptor;
    local int EncodedSaveDescriptor;
    local int SafeIndex;
    
    ProfileSettings = GetProfileSettings();
    if (ProfileSettings != None)
    {
        SafeIndex = Descriptor.Index == -1 ? 0 : Descriptor.Index;
        EncodedSaveDescriptor = int(Descriptor.Type) * 1000000 + SafeIndex;
        ProfileSettings.SetCurrentCareerName(Descriptor.Career);
        ProfileSettings.GetProfileSettingValueInt(57, PreviousEncodedSaveDescriptor);
        if (PreviousEncodedSaveDescriptor != EncodedSaveDescriptor)
        {
            ProfileSettings.SetProfileSettingValueInt(57, EncodedSaveDescriptor);
        }
    }
}
private final function SlowResumeGameCallback(SFXSaveGameCommandEventArgs Args)
{
    if (ResumeGameCompleteDelegate != None)
    {
        ResumeGameCompleteDelegate(Args.bSuccess);
        ResumeGameCompleteDelegate = None;
    }
    if (Args.bSuccess)
    {
        LoadSaveFromCallback(Args);
    }
}
public final function UploadFaceCodeToBlaze(string firstName, string faceCode)
{
    local SFXOnlineSubsystem OnlineSub;
    
    if (bUploadFaceCodesToBlaze)
    {
        OnlineSub = SFXOnlineSubsystem(OnlineSubsystem);
        if (OnlineSub != None && OnlineSub.GetComponentLogin() != None && OnlineSub.GetComponentLogin().IsSignedIn() && MPSaveManager.bInitialized)
        {
            MPSaveManager.AddNewFaceCode(firstName, faceCode);
            MPSaveManager.SaveRecords();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultPlayer = {
                     firstName = "John", 
                     faceCode = "", 
                     CharacterClass = Class'SFXPawn_PlayerVanguard', 
                     CharacterGUID = {A = 0, B = 0, C = 0, D = 0}, 
                     BonusTalentClass = 'None', 
                     MorphHead = None, 
                     bIsFemale = FALSE, 
                     Origin = EOriginType.OriginType_Earthborn, 
                     Notoriety = ENotorietyType.NotorietyType_Survivor
                    }
    MultiDisc1 = ("BIOG_UIWorld", 
                  "BioP_Global", 
                  "BioP_Global_NC", 
                  "EntryMenu", 
                  "Entry", 
                  "biop_CitHub", 
                  "biop_Nor", 
                  "MPLobby", 
                  "biop_MPCer", 
                  "biop_MPDish", 
                  "biop_MPNov", 
                  "biop_MPRctr", 
                  "biop_MPSlum", 
                  "biop_MPTowr", 
                  "BioP_Char", 
                  "biop_ProEar", 
                  "biop_ProMar", 
                  "biop_KroGar", 
                  "biop_Kro001", 
                  "biop_Cat004", 
                  "biop_End001", 
                  "biop_End002", 
                  "biop_End003"
                 )
    MultiDisc2 = ("BIOG_UIWorld", 
                  "BioP_Global", 
                  "BioP_Global_NC", 
                  "EntryMenu", 
                  "Entry", 
                  "biop_CitHub", 
                  "biop_Nor", 
                  "MPLobby", 
                  "biop_MPCer", 
                  "biop_MPDish", 
                  "biop_MPNov", 
                  "biop_MPRctr", 
                  "biop_MPSlum", 
                  "biop_MPTowr", 
                  "biop_CerMir", 
                  "biop_CitSam", 
                  "biop_CerJcb", 
                  "biop_KroN7a", 
                  "biop_KroN7b", 
                  "biop_KroGru", 
                  "biop_Kro002", 
                  "biop_OmgJck", 
                  "biop_Cat003", 
                  "biop_Gth001", 
                  "biop_GthN7a", 
                  "biop_GthLeg", 
                  "biop_Gth002", 
                  "biop_Cat002", 
                  "biop_SPCer", 
                  "biop_SPDish", 
                  "biop_SPNov", 
                  "biop_SPRctr", 
                  "biop_SPSlum", 
                  "biop_SPTowr"
                 )
    DynamicLoadMapping = ({
                           ObjectName = "SFXGameContent.SFXCharacterClass_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXCharacterClass_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXCharacterClass_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXCharacterClass_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXCharacterClass_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXCharacterClass_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.MaleShepard_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.MaleShepard_AdeptNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.MaleShepard_AdeptInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.MaleShepard_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.MaleShepard_EngineerNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.MaleShepard_EngineerInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_InfiltratorNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_InfiltratorInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_SentinelNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_SentinelInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.MaleShepard_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.MaleShepard_SoldierNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.MaleShepard_SoldierInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_VanguardNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_VanguardInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.UIWorld.MaleShepard_CharCreation", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.FemaleShepard_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.FemaleShepard_AdeptNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Adept.FemaleShepard_AdeptInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Adept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_EngineerNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_EngineerInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Engineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_InfiltratorNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_InfiltratorInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Infiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_SentinelNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_SentinelInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Sentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_SoldierNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_SoldierInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_VanguardNonCombat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_VanguardInjured", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Vanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_Player.Archetypes.UIWorld.FemaleShepard_CharCreation", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXCharacterClass_Soldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.PlaceHolder", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Ashley0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesAshley0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Ashley0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesAshley0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Ashley0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesAshley0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Ashley1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesAshley1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Ashley1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesAshley1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Garrus0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesGarrus0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Garrus0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesGarrus0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Garrus0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesGarrus0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Garrus1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesGarrus1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Garrus1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesGarrus1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Kaidan0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesKaidan0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Kaidan0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesKaidan0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Kaidan0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesKaidan0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Kaidan1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesKaidan1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Kaidan1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesKaidan1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.EDI0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.EDI0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.EDI0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.EDI1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.EDI1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesEDI1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali0_dead", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Tali1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesTali1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Liara0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesLiara0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Liara0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesLiara0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Liara0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesLiara0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Liara1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesLiara1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Liara1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesLiara1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.James0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesJames0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.James0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesJames0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.James0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesJames0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.James1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesJames1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.James1Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesJames1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Prothean0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesProthean0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Prothean0Glow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesProthean0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Henchmen_Images.Prothean0_locked", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXHenchImagesProthean0', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Adept.HumanMale_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Adept_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Engineer.HumanMale_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Engineer_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanMale_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Infiltrator_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Sentinel.HumanMale_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Sentinel_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Soldier_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Vanguard.HumanMale_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_Vanguard_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_SoldierBF3", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanMale_SoldierBF3_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Adept.HumanFemale_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Adept_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Engineer.HumanFemale_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Engineer_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanFemale_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Infiltrator_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Sentinel.HumanFemale_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Sentinel_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Soldier.HumanFemale_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Soldier_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Vanguard.HumanFemale_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_Vanguard_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanFemale_InfiltratorBF3", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'HumanFemale_InfBF3_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Adept.Asari_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Asari_Adept_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Adept.Drell_Adept2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Drell_Adept_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Engineer.Quarian_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Quarian_Engineer_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Engineer.Salarian_Engineer2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Salar_Engineer_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Infiltrator.Salarian_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Salarian_Infiltrator_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Infiltrator.Quarian_Infiltrator2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Quarian_Infiltrator_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Sentinel.Turian_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Turian_Sentinel_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Sentinel.Krogan_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Krogan_Sentinel_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Soldier.Krogan_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Krogan_Soldier_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Soldier.Turian_Soldier2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Turian_Soldier_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Vanguard.Drell_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Drell_Vanguard_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioChar_MPPlayers.Archetypes.Vanguard.Asari_Vanguard2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'Asari_Vanguard_MP', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXTreasureDataLive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXTreasureDataLive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_GrenadeLauncher", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_GrenadeLauncher', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_MissileLauncher", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_MissileLauncher', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_RocketLauncher", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_RocketLauncher', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_TitanMissileLauncher", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_TitanMissileLauncher', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_Cain", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_Cain', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_ParticleBeam", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_ParticleBeam', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_Avalanche", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_Avalanche', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_Flamethrower_Player", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_Flamethrower_Player', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_MiniGun", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_MiniGun', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_Blackstar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_Blackstar', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Heavy_ArcProjector", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Heavy_ArcProjector', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Avenger", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Avenger', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Revenant", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Revenant', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Collector", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Collector', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Geth", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Geth', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Vindicator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Vindicator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Mattock", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Mattock', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Cobra", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Cobra', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Falcon", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Falcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Saber", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Saber', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Argus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Argus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Valkyrie", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Valkyrie', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_AssaultRifle_Reckoning", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_AssaultRifle_Reckoning', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SMG_Shuriken", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SMG_Shuriken', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SMG_Tempest", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SMG_Tempest', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SMG_Locust", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SMG_Locust', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SMG_Hornet", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SMG_Hornet', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SMG_Hurricane", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SMG_Hurricane', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Predator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Predator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Carnifex", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Carnifex', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Phalanx", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Phalanx', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Talon", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Talon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Thor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Thor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Scorpion", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Scorpion', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Ivory", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Ivory', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Pistol_Eagle", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Pistol_Eagle', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Katana", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Katana', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Scimitar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Scimitar', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Claymore", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Claymore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Eviscerator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Eviscerator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Geth", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Geth', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Graal", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Graal', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Disciple", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Disciple', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Striker", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Striker', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Crusader", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Crusader', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_Shotgun_Raider", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_Shotgun_Raider', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Mantis", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Mantis', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Viper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Viper', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Widow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Widow', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Incisor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Incisor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Raptor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Raptor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Javelin", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Javelin', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_BlackWidow", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_BlackWidow', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Indra", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Indra', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeapon_SniperRifle_Valiant", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeapon_SniperRifle_Valiant', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOG_GesturesConfig.RuntimeData", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'GesturesConfig', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_grenade_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_missile_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_avalance_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_cain_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_arcprojector_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_blackstar_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_flamethrower_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_collector_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_spitfire_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_reckoning_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_titan_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.hvy_disinfectiongun_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.targeting-laser_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_avenger_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_vindicator_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_gethpulse_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_mattock_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_revenant_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_collector_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_cobra_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_falcon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_carbine_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_saber_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_valkyrie_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_katana_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_claymore_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_scimitar_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_eviscerator_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_gethplasma_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_graal_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_disciple_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_raider_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_crusader_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_striker_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.smg_shuriken_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.smg_tempest_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.smg_locust_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.smg_hornet_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.smg_hurricane_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_predator_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_carniflex_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_phalanx_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_scorpion_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_talon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_thor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_eagle_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_ivory_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_mantis_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_viper_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_widow_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_incisor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_javelin_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_raptor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_indra_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_valiant_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_blackwidow_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_ammo-capacity_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_heat-sink_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_penetration-mod_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_shredder-mod_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_smg_heat-sink-mod_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_stability-damper_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_tazer-mod_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_ultralight-material_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_barrel-choke_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.MOD_concentration-mod_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_Mods', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_avenger_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_vindicator_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_revenant_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_gethpulse_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_mattock_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_falcon_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_collector_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_cobra_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_carbine_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_saber_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_valkyrie_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_katana_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_scimitar_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_claymore_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_eviscerator_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_gethplasma_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_graal_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_disciple_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_raider_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_crusader_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_striker_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_shuriken_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_tempest_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_locust_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_hornet_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.smg_hurricane_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_predator_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_carniflex_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_phalanx_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_scorpion_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_talon_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_thor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_eagle_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_ivory_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyPistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_mantis_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_viper_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_widow_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_raptor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_javelin_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_incisor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_indra_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_valiant_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_blackwidow_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_grenade_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_avalance_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_cain_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_collector_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_missile_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_spitfire_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_blackstar_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_arcprojector_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_flamethrower_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_reckoning_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_titan_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.hvy_disinfectiongun_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.targeting-laser_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_HeavyWeapons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ArmorPiercingAmmo_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Barrier_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Slam_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Reave_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShredderAmmo_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.WarpAmmo_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Dominate_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.NeuralShock_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Zaeed_Codex_Images.ZaheedInfernoGrenade_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Kasumi_Codex_Images.FlashbangGrenade_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_PowerImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShieldBoost_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.PHelmN7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShieldBoost_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.PHelmN7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_PresidiumB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShieldBoost_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.PHelmN7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsA', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShieldBoost_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.PHelmN7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsB', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.EnergyDrain_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsC', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Fortification_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsC', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ShieldBoost_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsC', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.PHelmN7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXStoreImages_WardsC', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Garrus_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_GarrusImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Grunt_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_GruntImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Jack_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_JackImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Jacob_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_JacobImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Legion_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_LegionImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Miranda_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_MirandaImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Mordin_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_MordinImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Samara_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_SamaraImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Tali_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_TaliImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.Thane_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponImages_ThaneImage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.KroganUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GethUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.JackUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.MordinUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ClassUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.ShieldUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SquadUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.BioticUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_SquadUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.CyberneticUpgradeShepard_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.MediGelUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.HeavyWeaponUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShepardUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NormandyUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.MiniGameDecryptUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.MiniGameHackUpgrade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_OtherUpgrade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.AssaultRifle_Kinetic", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.AssaultRifle_Tungsten", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.AssaultRifle_Targeting", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_sco_c_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.asl_sco_e_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.asl_bar_e_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_stability-damper_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_bar_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ARUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SMG_Microfield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_APistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SMG_Phasic", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_APistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SMG_Heatsink", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_APistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_ultralight-material_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_APistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_smg_heat-sink-mod_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_APistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Biotics_NeuralMask", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_BioticUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Biotics_NeuralMask02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_BioticUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Biotics_HyperAmp", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_BioticUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Prototypes_Grunt", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HenchUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.PrototypesShep_Legion", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HenchUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.HeavyWeapons_MFA", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HvyWeaponUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.HeavyPistol_Pulsar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HPistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.HeavyPistol_Sabot", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HPistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.HeavyPistol_Smartrounds", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HPistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_tazer-mod_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_HPistolUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Microscanner", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_MediGelUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Trauma", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_MediGelUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Harmonics", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_MediGelUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.PrototypesShep_Lattice", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShepardUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.PrototypesShep_Fiberweave", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShepardUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.PrototypesShep_Skeletal", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShepardUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Ablative", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Burstshield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Armor_Nanocrystal", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_ShieldUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Shotgun_Pulsar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Shotgun_Micropulse", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Shotgun_Thermal", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_shredder-mod_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_bar_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.bls_melee_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_barrel-choke_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ShotgunUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SniperRifle_Pulsar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SniperRifle_Tungsten", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.SniperRifle_Scanner", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_sco_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.snp_bar_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_concentration-mod_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_SniperUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.OmniTools_Heuristics", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_TechUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.OmniTools_Hydra", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_TechUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.OmniTools_Multicore", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_TechUpgrades', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_sco_c_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ModLarge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_penetration-mod_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ModLarge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.MOD_ammo-capacity_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ModLarge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.asl_sco_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ModLarge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Weapons.pst_bar_a_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotification_ModLarge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_AssaultRifleForce", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_AssaultRifleStability", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_sco_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_bar_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_body_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.asl_grip_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_AssaultRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_PistolAccuracy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_PistolDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_PistolMagSize", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_PistolStability", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_sco_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.pst_bar_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Pistols', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_ShotgunDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_sco_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_bar_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.bls_melee_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_Shotguns', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SMGAccuracy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SMGDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SMGMagSize", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SMGStability", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SMGs', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_sco_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Weapons.snp_bar_a_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXWeaponMods_SniperRifles', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.AssaultTrooper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Trooper', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Centurion", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Centurion', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Gunner', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Guardian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Guardian', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Nemesis", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Nemesis', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Atlas", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Atlas', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Cannibal", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Cannibal', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Marauder", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Marauder', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Brute", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Brute', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Banshee", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Banshee', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Harvester", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Harvester', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Husk", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Husk', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Reapers.Ravager", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Ravager', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Geth.GethTrooper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_GethTrooper', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Geth.GethRocketTrooper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_GethRocketTrooper', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Geth.GethPyro", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_GethPyro', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Geth.GethHunter", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_GethHunter', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Geth.GethPrime", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_GethPrime', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "Char_Enemies.Archetypes.Cerberus.Phantom", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPawn_Phantom', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Assassination", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Assassination', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Annex_DefendZone_Hack", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Annex_Hack', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Annex_DefendZone_Upload", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Annex_Upload', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Retrieve_PickupObject", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Retrieve', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Retrieve_DropOffLocation", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Retrieve', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Disarm_Enable", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Disarm_Enable', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_Disarm_Disable", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Disarm_Disable', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_SupplyDrop", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_SupplyDrop', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXObjective_ExtractionPoint", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXEngagement_Extraction', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.BioSimpleDlgContainer_Horde", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'BioSimpleDlgContainer_Horde', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AdeptMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AdeptMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AdeptPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AdeptPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AdrenalineRush", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AdrenalineRush', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AIHacking", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AIHacking', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AmmoPower", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AmmoPower', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AndersonPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AndersonPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ArmorPiercingAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ArmorPiercingAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_AshleyPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_AshleyPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_KaiLengSlash", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_KaiLengSlash', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Barrier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Barrier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_BioticCharge", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_BioticCharge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Carnage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Carnage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CerberusGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CerFragGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Cloak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Cloak', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CombatDrone", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CombatDrone', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CombatDroneBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CombatDroneBase', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CombatDroneRocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CombatDroneRocket', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CombatDroneShock", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CombatDroneShock', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CombatDroneZap", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CombatDroneZap', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ConcussiveShot", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ConcussiveShot', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CryoAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CryoAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_CryoBlast", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_CryoBlast', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_DarkChannel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_DarkChannel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Decoy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Decoy', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_DefensiveShield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_DefensiveShield', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Discharge", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Discharge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_DisruptorAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_DisruptorAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_EDIPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_EDIPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_EnergyDrain", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_EnergyDrain', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_EnemyGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_EneFragGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_EngineerMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_EngineerMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_EngineerPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_EngineerPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Fortification", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Fortification', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_FragGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_FragGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GarrusPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GarrusPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GethPrimeDroneRocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GethPrimeDroneRocket', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GethPrimeShieldDrone", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GethPrimeShieldDrone', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GethPrimeTurret", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GethPrimeTurret', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GethShieldBoost", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GethShieldBoost', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_GrenadeBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_GrenadeBase', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_HenchmanPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_HenchmanPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_IncendiaryAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_IncendiaryAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Incinerate", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Incinerate', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_InfernoGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_InfernoGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_InfiltratorMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_InfiltratorMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_InfiltratorPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_InfiltratorPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_JimmyPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_JimmyPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_KaidenPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_KaidenPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_LiaraPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_LiaraPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_LiftGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_LiftGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_StickyGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_StickyGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_BioticGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_BioticGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Marksman", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Marksman', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_MultiProjectile", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_MultiProjectile', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Overload", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Overload', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ProtectorDrone", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ProtectorDrone', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ProtectorDroneBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ProtectorDroneBase', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ProtheanPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ProtheanPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ProximityMine", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ProximityMine', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Pull", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Pull', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Reave", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Reave', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ReaperGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_RprFragGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentinelMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentinelMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentinelPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentinelPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurret", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurret', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurretCryoAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurretCryoAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurretDisruptorAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurretDisruptorAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurretArmorPiercingAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurretArmorPierceAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurretRocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurretRocket', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SentryTurretShock", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SentryTurretShock', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_ShieldDroneBuff", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_ShieldDroneBuff', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Shockwave", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Shockwave', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Singularity", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Singularity', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Slam", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Slam', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SoldierMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SoldierMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_SoldierPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_SoldierPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Stasis", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Stasis', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_TaliPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_TaliPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_TechArmor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_TechArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Throw", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Throw', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_TitanRocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_TitanRocket', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_TitanRocket_Player", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_TitanRocket_Player', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Unity", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Unity', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_VanguardMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_VanguardMeleePassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_VanguardPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_VanguardPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_Warp", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_Warp', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXPowerCustomAction_WarpAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPower_WarpAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_AdrenalineRush", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_AdrenalineRush', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_AIHacking", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_AIHacking', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_AsariPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_AsariPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_AsariMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_AsariMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Barrier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Barrier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_BioticCharge", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_BioticCharge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_BioticGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_BioticGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Carnage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Carnage', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Cloak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Cloak', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_CombatDrone", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_CombatDrone', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_ConcussiveShot", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_ConcussiveShot', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_CryoBlast", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_CryoBlast', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_DarkChannel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_DarkChannel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Decoy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Decoy', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Discharge", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Discharge', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_DrellPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_DrellPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_DrellMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_DrellMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_EnergyDrain", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_EnergyDrain', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_FemQuarPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_FemQuarMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Fortification", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Fortification', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_FragGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_FragGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_GethShieldBoost", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_GethShieldBoost', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HumanPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassiveBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HumanMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Sol', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Adept", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Ade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Engineer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Eng', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Sentinel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Sen', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Vanguard", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Van', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_HmnMPassive_Inf', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Incinerate", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Incinerate', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_InfernoGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_InfernoGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_KroganPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_KroganPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_KroganMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_KroganMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_LiftGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_LiftGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Marksman", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Marksman', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Overload", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Overload', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_PassiveBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_PassiveBase', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_ProximityMine", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_ProximityMine', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Pull", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Pull', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Reave", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Reave', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_MeleePassiveBase", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_MPassiveBase', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_SalarianPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_SalarianPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_SalarianMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_SalarianMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_SentryTurret", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_SentryTurret', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Shockwave", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Shockwave', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Singularity", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Singularity', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Slam", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Slam', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Stasis", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Stasis', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_StickyGrenade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_StickyGrenade', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_TechArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Turian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_TechArmo_Turian', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Krogan", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_TechArmor_Krogan', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Throw", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Throw', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_TurianPassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_TurianPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_TurianMeleePassive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_TurianMPassive', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Warp", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Warp', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Ammo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Shield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Rocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Revive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXPowerCustomActionMP_ConsumableAmmoPower", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXPowerMP_Consumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.01_driven", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.02_bringer_of_war", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.03_mobilizer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.04_world_shaker", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.05_pathfinder", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.06_tunnel_rat", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.07_party_crasher", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.08_hard_target", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.09_saboteur", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.10_arbiter", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.11_last_witness", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.12_executioner", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.13_well_connected", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.14_fact_finder", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.15_liberator", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.16_problem_solver", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.17_patriot", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.18_legend", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.19_shopaholic", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.20_commander", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.21_lost_and_found", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.22_long_service", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.23_insanity", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.24_a_personal_touch", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.25_paramour", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.26_combined_arms", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.27_focused", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.28_recruit", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.29_soldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.30_veteran", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.31_bruiser", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.32_untouchable", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.33_defender", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.34_overload_specialist", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.35_sky_high", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.36_pyromaniac", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.37_eye_of_the_hurricaine", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.38_peekaboo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.39_hijacker", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.40_big_game_hunter", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.41_trainee", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.42_tour_of_duty", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.43_always_prepared", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.44_tourist", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.45_explorer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.46_gunsmith", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.47_half-way_there", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.26_peak_condition", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.49_starbound", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.00_hardcore", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Achievement_Images.OmniBlade_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAchievementImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.BioP_CitHub_IMG", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXSaveLoadImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.BioP_Nor_IMG", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXSaveLoadImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Images_UNC93_I1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXSaveLoadImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_Images.ResearchProjectUpgrade_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXResearchImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GlobalIcons.Notifications.NewTech_256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXResearchImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_SpareAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_SpareAmmo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_ShieldPercentBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_ShieldPercentBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXWeaponGameEffect_DamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_WeaponDamageBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGame.SFXGameEffect_ShieldRegenBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_ShieldRegenBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_MeleeDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MeleeDamageBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_HealthPercentBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_HealthPercentBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PowerBonus_Cooldown", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PowerCooldownBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PowerBonus_Damage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PowerDamageBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGame.SFXGameEffect_MovementSpeedBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MovementSpeedBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGame.SFXGameEffect_WeaponDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_WeaponDamageBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_ConstraintDmgBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_ConstraintDmgBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Cerberus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_UniqueArmorCerberus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Collector", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_UniqueArmorCollector', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Inferno", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_UniqueArmorInferno', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Tank", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_UniqueArmorTank', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Terminus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_UniqueArmorTerminus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_BloodDragon", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_BloodDragon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_UniqueArmor_Reckoning", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_Reckoning', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_AmmoCapacityBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_AmmoCapacityBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ConstraintDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ConstraintDamageBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_HealthBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_HealthBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_MeleeDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_MeleeDamageBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerCooldownBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerCooldownBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_PowerDamageBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldRegenBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_ShieldRegenBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_WeaponDamageBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PartBasedArmor_WeaponDamageBonus_Weak", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_PartBasedArmor', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGameEffect_PassiveMaxAmmoBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MaxAmmoBonus', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGE_MatchConsumables', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_Fonts.gfxfonts", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUI_Fonts', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_FontsJPN.gfxfonts", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUI_FontsJPN', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioDpl_Multiplayer.ProtheanObject", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioDpl_Multiplayer.SupplyDrop", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioDpl_Multiplayer.TechScanner", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioDpl_Multiplayer.ReaperIndocDevice", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Ind_ReaperProto.ReaperProto", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Uti_Computer01.Computer01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Uti_Computer02.Computer02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Ind_EnginePart01.EnginePart01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Ind_Canister02.Canister02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Ind_Beacon02.Beacon02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Cbt_Bomb02.Bomb02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Cake01.Cake01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Fireworks01.Fireworks01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Basket01.Basket01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Heart01.Heart01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Present01.Present01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BioApl_Sea_Pumpkin01.Pumpkin01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPObjectives_Special', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = TRUE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.AdeptHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesAdept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.AdeptHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesAdept', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.EngineerHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesEngineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.EngineerHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesEngineer', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.InfiltratorHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesInfiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.InfiltratorHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesInfiltrator', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.SentinelHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesSentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.SentinelHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesSentinel', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.SoldierHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesSoldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.SoldierHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesSoldier', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.VanguardHumanFemale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesVanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.VanguardHumanMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesVanguard', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Krogan0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Asari0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Salarian0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Drell0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Quarian0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_Turian0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPKitImagesOther2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AddAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AddGalaxy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AddRevive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AddRockets", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AddShield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AmmoCryo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AmmoDisrupt", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AmmoIncendiary", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AmmoPiercing", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.AmmoWarp", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.BoostPower", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.BoostShields", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.BoostSpeed", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.BoostTime", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.Credits", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.DamageAssault", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.DamagePistol", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.DamageShotgun", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.DamageSMG", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.DamageSniper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.EquipAmmo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.EquipGalaxy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.EquipRevive", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.EquipRocket", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.EquipShield", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.Talent", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.XP", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPSupplyCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitAgent", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitAgentMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitBiotic", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitBioticMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitSoldier", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitSoldierMale", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitAsari", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitDrell", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitKrogan", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitQuarian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitSalarian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Cards.KitTurian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_BF_HFM0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Kits.MP_BF_HMM0", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPCardImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptTeamPublic", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptTeamPrivate", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptEmyRandom", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptEmyGeth", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptEmyCerberus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptEmyReapers", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptChallgRandom", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptChallgBrnz", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptChallgSilver", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptChallgGold", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptChallgPlatinum", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapRandom", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapDish", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapSlum", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapTowr", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapRctr", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapRail", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapCer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapNoveria", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapMoon", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapMoon2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapMoon3", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.MatchSettings.OptMapGeth", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMatchSettings', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.StoreItems.Store001", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesStore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.StoreItems.Store002", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesStore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.StoreItems.Store003", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesStore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.StoreItems.Store004", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesStore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.StoreItems.Store005", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesStore', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Alliance", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.AllianceHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Box", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box2Holo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box3", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box3Holo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box4", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box4holo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box5", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.box5holo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.BoxHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Camo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.CamoHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Cerberus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.CerberusHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Geth", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.GethHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Military", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.MilitaryHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.N7", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.N7Holo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Present", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.PresentHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.Reaper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Creates.ReaperHolo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesCrates', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPCer", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPCnfl", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPDefault", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPDish", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPNov", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPrail", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPRctr", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPSlum", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Maps.MPTowr", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPImagesMaps2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-action_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-action_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-action_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.close-quarters-combat_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.close-quarters-combat_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.close-quarters-combat_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.headshot_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.headshot_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.headshot_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assault-rifle_marksman_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assault-rifle_sharpshooter_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assault-rifle_expert_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.sniper-rifle_marksman_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.sniper-rifle_sharpshooter_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.sniper-rifle_expert_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.shotgun_marksman_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.shotgun_sharpshooter_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.shotgun_expert_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.pistol_marksman_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.pistol_sharpshooter_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.pistol_expert_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.smg_marksman_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.smg_sharpshooter_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.smg_expert_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.biotics-mastery_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.biotics-mastery_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.biotics-mastery_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.tech-mastery_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.tech-mastery_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.tech-mastery_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-medic_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-medic_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.combat-medic_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assist_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assist_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.assist_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.cover-grab_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.cover-grab_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.cover-grab_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.survival_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.survival_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.survival_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.challenge_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.challenge_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.challenge_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.extraction_bronze_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.extraction_silver_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.extraction_gold_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.killstreak_1_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.killstreak_2_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.killstreak_3_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.random-map_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_MPImages.Medals.random-faction_256x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXMPMedalImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_Credits.Logos.dts", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUI_A_LegalLogos', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_Credits.Logos.dolby", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUI_A_LegalLogos', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_Credits.Logos.nvidia", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUI_A_LegalLogos', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Asari", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Batarian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Hanar", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Hospital", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Human", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Salarian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Spectre", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Turian", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Volus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_BattleFootage", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_BattleOfArcturus", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_BioticResearchData", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_DestroyedMiniReaper", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_IntactReaperGun", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_IntelligenceArchives", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_LegionIntel1", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_LegionIntel2", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_SamaraMission", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_PrejekPaddlefish", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_Feron", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_AdvancedBioticAmps", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXGUIData_Store_Intel_MedicalUpgrade", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Armor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Credits_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_GMSalvage_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Intel_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Jourdex_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_LevelUp_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_PlotObject_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Store_256x1286", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.NT_Supply_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_Notifications', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.ELV_NorCabin_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.ELV_NorCIC_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.ELV_NorCrew_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.ELV_NorEng_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.ELV_NorCargo_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitDocks_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitCamp_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitCommon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitPurg_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitHosp_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_CitEmb_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXGUIData_ElevatorImages', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMArchon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMBattle_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMBlood_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMCapacitor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMCerberus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMCollector_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMDeath_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMDelumcore_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMGamestop_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMInferno_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMKestrel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMKuwashii_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMMneumonic_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMReckoning_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMRecon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSecuritel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSentry_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPaArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPaLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPaShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPaTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPbArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPbLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPbShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPbTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPcArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPcLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPcShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPcTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPeArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPeLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPeShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPeTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPfArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPfLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPfShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPfTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPgArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPgLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPgShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPgTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPhArms_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPhLegs_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPhShoulders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMSHPhTorso_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMTerminus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.CD_ARMUmbra_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Armor2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_AdamsQuest_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_AlliedDread_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_AlliedFighter_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Book01_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Book02_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Book03_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Book04_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Candy_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Citadel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Eel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_FishFeeder_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Flowers_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Fornax_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_GethFighter_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_JellyFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Kodiak_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_KoiFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_PaddleFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_QuarianLive1_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_SkaldFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_StripeFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_SunFish_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_BonusPower_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Respec_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Whiskey_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Store.STO_Store_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Store', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Codex_images.PDAComputerLogo_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_AI_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Alliance_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Anderson2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Asari_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Ashley_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Banshee_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Batarians_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Biotics_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Brute_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Cannibal_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Cerberus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Chakwas_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Citadel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_CitSpace_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Collectors_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_ContactWar_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Council_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Crucible_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Cyclonic_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Drell_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Earth_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_EDI_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Eezo_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Elcor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_FTL_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Garrus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Geno_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_GenoCure_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Geth_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Grissom_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Hackett1_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Hanar_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Harbinger_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Harvester_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Horizon_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Husk2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_IllusiveMan1_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Indoctination_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Jacob2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_JacobP_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_James_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Joker_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Kaidan_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Keepers_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Kodiak_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Krogan_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Liara_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Marauder_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_MassAccel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_MassRelays2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_MediGel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_MEFields_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Menae_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_MilitaryShips_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Miranda2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Mordin_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Normandy02_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_OmniBlade_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_OmniTool_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Palaven_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Protheans_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Quarians_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_RAlliance_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Rannoch_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Ravager_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Reapers_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_RVariants_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Salarians_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_SamaraP_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Shields_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Shroud_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Silaris_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Sovereign_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_SpaceCombat_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Spectres_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_SurKesh_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Tali_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Thanix_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Thessia_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Thresher_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Tuchanka_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Turians_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Udina_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_VI_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.Codex.CDX_Volus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_Codex_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_MainMenu_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_MissionComputer_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_SquadScreen_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_GeneralHUD_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_HighCover_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_SquadCommand_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_PowerWheel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_WeaponBench_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_PowerUpgrade_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_GalaxyAtWar_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_GameCreation_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_ClassKit_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_InsideReinforcementPack_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_PowersLevel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_HUD1_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_GMGalaxy_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_LowCover_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_MainMenu_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_CharCreation_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_Journal1_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_Enemy_Atlas_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_Help_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_Squad_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_Cover_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_7', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_Combat_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_7', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_Powers_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_7', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_Journal_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_7', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_BasicControls_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_8', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_WeaponLoadout_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_8', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_GenericAction_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_8', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_Lobby_Xbox_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_8', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_BasicControls_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_8', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_WeaponWheel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_9', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Tips_Action_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_9', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_Missions_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_9', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_HUD_Xbox_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_MainMenu_Xbox_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_MainMenu_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_ExplorationCmd_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_ConversationWheel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_SquadOrders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_10', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.KinectSquadOrders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_10', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_PowerWheel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_10', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.Kinect_OptionNarrative_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_10', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.MP_HUD_PS3_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_11', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_GameManual.SP_MainMenu_PS3_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GameManual_11', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Earth_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Mars_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geth01_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geth02_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GethAdmiral_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GethLegion_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.BioP_HorCr1_IMG", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Garrus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geno01_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Geno02_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoRescue_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoBomb_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_GenoGrunt_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat2Thessia_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat3Coup_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Miranda_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Jacob_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Samara_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Grissom_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBDagger_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_4', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGhost_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGiant_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBGlacier_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBReactor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_FBWhite_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_5', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_Cat4Illusive_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_EndEarth_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.ME3_images.LVL_EndCitadel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_NorCIC_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_SF_SaveLoad_Images.Elevators.LVL_NorCargo_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_SaveLoad_6', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AlienFleet_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Allers_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AllianceCruiser_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Artifact_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Asari_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AsariArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AsariCruiser_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AsariNoArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Balak_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Crucible_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_DestinyA_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_DrArcher_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_DrCole_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_DreadVolus_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Fighter_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Frigate_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_GenSherman_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Gerrel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Geth_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_GethPrime_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_GFleet_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Grunt_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_HFleet_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_HumanBiotics_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_HumansArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_HumanScientists_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_HumansNoArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Intel_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Jack_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Kasumi_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_KhaleeSanders_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Kirrahe_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Koris_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Krogan_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_LifePods_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Mikhailovich_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_N7_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_QFleet_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Raan_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Rachni_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_ReaperBaby_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_SalariansArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Salvage_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Samara_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_ShadowShip_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Shiala_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Spectre_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_TuriansArmor_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Voluses_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Wreav_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Wrex_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Xen_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Zaeed_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Khalisa_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AsariSniper_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_Mineral2_512x256", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_AllianceFlotilla_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "gui_codex_images.galaxyAtWar.GM_CerbFighters_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXImages_GAW_3', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Camps", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Camps', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Commons", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Commons', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Docks", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Docks', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Embassy", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Embassy', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Hospital", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Hospital', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Citadel.CitHub_Purgatory", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_CitHub_Purgatory', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Normandy.NorCabin", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NorCabin', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Normandy.NorCargo", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NorCargo', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Normandy.NorCIC", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NorCIC', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Normandy.NorCrew", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NorCrew', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "AreaMaps.Normandy.NorEng", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NorEng', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon01", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon02", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon03", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon04", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon05", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon06", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon07", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon08", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon09", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "BIOA_NumberIcons.NumIcon10", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'AreaMap_NumIcon', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_AFleet_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Allers_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_AllianceCruiser_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Artifact_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Asari_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_AsariArmor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_AsariCruiser_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_AsariNoArmor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Balak_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Cerberus_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_CitSpace_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Crucible_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_DreadVolus_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Fighter_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Frigate_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Gerrel_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_GFleet_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_HFleet_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_HumansArmor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_HumanScientists_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_1', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Intel_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Kasumi_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Krogan_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Liara_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_LifePods_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Raan_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Rachni_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Reapers_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Salvage_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_ShadowShip_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Shiala_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Spectre_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_TuriansArmor_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Voluses_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Xen_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_Zaeed_512", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_WarAssets_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "GUI_Icons.Notifications.GM_BonusPower_256x128", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXNotificationImages_GAW_2', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }, 
                          {
                           ObjectName = "SFXGameContent.SFXAI_AutoBot", 
                           RemotePlayerWithHandle = (), 
                           SeekFreePackageName = 'SFXAutoBots', 
                           CachedObjectHandle = None, 
                           LoadedLinkerRoot = None, 
                           ObjectNetID = 0, 
                           bReplicate = FALSE, 
                           bNetIDHasBeenSet = FALSE
                          }
                         )
    SeekfreeCommonPackageMap = ({SeekfreeName = 'Asari_Adept_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Asari_Vanguard_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Drell_Adept_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Drell_Vanguard_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Adept_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Engineer_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Infiltrator_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_InfBF3_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Sentinel_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Soldier_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanFemale_Vanguard_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Adept_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Engineer_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Infiltrator_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Sentinel_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Soldier_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_SoldierBF3_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'HumanMale_Vanguard_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Krogan_Sentinel_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Krogan_Soldier_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Quarian_Engineer_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Quarian_Infiltrator_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Salarian_Infiltrator_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Salar_Engineer_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Turian_Sentinel_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'Turian_Soldier_MP', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClassMP_Adept', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClassMP_Engineer', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClassMP_Sentinel', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClassMP_Soldier', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClassMP_Vanguard', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Adept_Asari', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Adept_Drell', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Eng_FQuarian', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Eng_Salar', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Infiltrator', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Inf_FQuarian', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Inf_Salar', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Sentinel_Krogan', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Sentinel_Turian', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Soldier_Krogan', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Soldier_Turian', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Vanguard_Asari', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharClassMP_Vanguard_Drell', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXEngagement_Assassination', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXEngagement_Annex_Upload', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXEngagement_Annex_Hack', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXEngagement_Disarm_Disable', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXEngagement_Disarm_Enable', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXPowerMP_Consumables', CommonName = 'BIOP_MP_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Adept', CommonName = 'BIO_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Engineer', CommonName = 'BIO_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Infiltrator', CommonName = 'BIO_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Sentinel', CommonName = 'BIO_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Soldier', CommonName = 'BIO_COMMON'}, 
                                {SeekfreeName = 'SFXCharacterClass_Vanguard', CommonName = 'BIO_COMMON'}
                               )
    SFXUniqueIDs = ("", 
                    "AdeptHumanMale", 
                    "EngineerHumanMale", 
                    "InfiltratorHumanMale", 
                    "SentinelHumanMale", 
                    "SoldierHumanMale", 
                    "VanguardHumanMale", 
                    "SoldierHumanMaleBF3", 
                    "AdeptHumanFemale", 
                    "EngineerHumanFemale", 
                    "InfiltratorHumanFemale", 
                    "SentinelHumanFemale", 
                    "SoldierHumanFemale", 
                    "VanguardHumanFemale", 
                    "InfiltratorHumanFemaleBF3", 
                    "AdeptAsari", 
                    "AdeptDrell", 
                    "EngineerQuarian", 
                    "EngineerSalarian", 
                    "InfiltratorSalarian", 
                    "InfiltratorQuarian", 
                    "SentinelTurian", 
                    "SentinelKrogan", 
                    "SoldierKrogan", 
                    "SoldierTurian", 
                    "VanguardDrell", 
                    "VanguardAsari", 
                    "SFXGameContent.SFXWeapon_Heavy_GrenadeLauncher", 
                    "SFXGameContent.SFXWeapon_Heavy_MissileLauncher", 
                    "SFXGameContent.SFXWeapon_Heavy_RocketLauncher", 
                    "SFXGameContent.SFXWeapon_Heavy_Cain", 
                    "SFXGameContent.SFXWeapon_Heavy_ParticleBeam", 
                    "SFXGameContent.SFXWeapon_Heavy_Avalanche", 
                    "SFXGameContent.SFXWeapon_Heavy_Flamethrower_Player", 
                    "SFXGameContent.SFXWeapon_Heavy_MiniGun", 
                    "SFXGameContent.SFXWeapon_Heavy_Blackstar", 
                    "SFXGameContent.SFXWeapon_Heavy_TitanMissileLauncher", 
                    "SFXGameContent.SFXWeapon_Heavy_ArcProjector", 
                    "SFXGameMPContent.SFXWeapon_Heavy_ConsumableRocketLauncher", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Avenger", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Revenant", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Collector", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Geth", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Vindicator", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Mattock", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Cobra", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Falcon", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Saber", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Argus", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Valkyrie", 
                    "SFXGameContent.SFXWeapon_AssaultRifle_Reckoning", 
                    "SFXGameContent.SFXWeapon_SMG_Shuriken", 
                    "SFXGameContent.SFXWeapon_SMG_Tempest", 
                    "SFXGameContent.SFXWeapon_SMG_Locust", 
                    "SFXGameContent.SFXWeapon_SMG_Hornet", 
                    "SFXGameContent.SFXWeapon_SMG_Hurricane", 
                    "SFXGameContent.SFXWeapon_Pistol_Predator", 
                    "SFXGameContent.SFXWeapon_Pistol_Carnifex", 
                    "SFXGameContent.SFXWeapon_Pistol_Phalanx", 
                    "SFXGameContent.SFXWeapon_Pistol_Talon", 
                    "SFXGameContent.SFXWeapon_Pistol_Thor", 
                    "SFXGameContent.SFXWeapon_Pistol_Scorpion", 
                    "SFXGameContent.SFXWeapon_Pistol_Ivory", 
                    "SFXGameContent.SFXWeapon_Pistol_Eagle", 
                    "SFXGameContent.SFXWeapon_Shotgun_Katana", 
                    "SFXGameContent.SFXWeapon_Shotgun_Scimitar", 
                    "SFXGameContent.SFXWeapon_Shotgun_Claymore", 
                    "SFXGameContent.SFXWeapon_Shotgun_Eviscerator", 
                    "SFXGameContent.SFXWeapon_Shotgun_Geth", 
                    "SFXGameContent.SFXWeapon_Shotgun_Graal", 
                    "SFXGameContent.SFXWeapon_Shotgun_Disciple", 
                    "SFXGameContent.SFXWeapon_Shotgun_Striker", 
                    "SFXGameContent.SFXWeapon_Shotgun_Crusader", 
                    "SFXGameContent.SFXWeapon_Shotgun_Raider", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Mantis", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Viper", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Widow", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Incisor", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Raptor", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Javelin", 
                    "SFXGameContent.SFXWeapon_SniperRifle_BlackWidow", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Indra", 
                    "SFXGameContent.SFXWeapon_SniperRifle_Valiant", 
                    "SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", 
                    "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", 
                    "SFXGameContent.SFXWeaponMod_AssaultRifleForce", 
                    "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", 
                    "SFXGameContent.SFXWeaponMod_AssaultRifleStability", 
                    "SFXGameContent.SFXWeaponMod_PistolAccuracy", 
                    "SFXGameContent.SFXWeaponMod_PistolDamage", 
                    "SFXGameContent.SFXWeaponMod_PistolMagSize", 
                    "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                    "SFXGameContent.SFXWeaponMod_PistolStability", 
                    "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", 
                    "SFXGameContent.SFXWeaponMod_ShotgunDamage", 
                    "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", 
                    "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", 
                    "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                    "SFXGameContent.SFXWeaponMod_SMGAccuracy", 
                    "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", 
                    "SFXGameContent.SFXWeaponMod_SMGDamage", 
                    "SFXGameContent.SFXWeaponMod_SMGMagSize", 
                    "SFXGameContent.SFXWeaponMod_SMGStability", 
                    "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", 
                    "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                    "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                    "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", 
                    "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", 
                    "SFXGameContent.SFXPowerCustomAction_AdeptMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_AdeptPassive", 
                    "SFXGameContent.SFXPowerCustomAction_AdrenalineRush", 
                    "SFXGameContent.SFXPowerCustomAction_AIHacking", 
                    "SFXGameContent.SFXPowerCustomAction_AmmoPower", 
                    "SFXGameContent.SFXPowerCustomAction_AndersonPassive", 
                    "SFXGameContent.SFXPowerCustomAction_ArmorPiercingAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_AshleyPassive", 
                    "SFXGameContent.SFXPowerCustomAction_BansheeShockwave", 
                    "SFXGameContent.SFXPowerCustomAction_Barrier", 
                    "SFXGameContent.SFXPowerCustomAction_BioticCharge", 
                    "SFXGameContent.SFXPowerCustomAction_Carnage", 
                    "SFXGameContent.SFXPowerCustomAction_Cloak", 
                    "SFXGameContent.SFXPowerCustomAction_CombatDrone", 
                    "SFXGameContent.SFXPowerCustomAction_CombatDroneBase", 
                    "SFXGameContent.SFXPowerCustomAction_CombatDroneRocket", 
                    "SFXGameContent.SFXPowerCustomAction_CombatDroneShock", 
                    "SFXGameContent.SFXPowerCustomAction_CombatDroneZap", 
                    "SFXGameContent.SFXPowerCustomAction_ConcussiveShot", 
                    "SFXGameContent.SFXPowerCustomAction_CryoAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_CryoBlast", 
                    "SFXGameContent.SFXPowerCustomAction_DefensiveShield", 
                    "SFXGameContent.SFXPowerCustomAction_Decoy", 
                    "SFXGameContent.SFXPowerCustomAction_Discharge", 
                    "SFXGameContent.SFXPowerCustomAction_DisruptorAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_EDIPassive", 
                    "SFXGameContent.SFXPowerCustomAction_EnergyDrain", 
                    "SFXGameContent.SFXPowerCustomAction_EngineerMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_EngineerPassive", 
                    "SFXGameContent.SFXPowerCustomAction_Fortification", 
                    "SFXGameContent.SFXPowerCustomAction_FragGrenade", 
                    "SFXGameContent.SFXPowerCustomAction_GarrusPassive", 
                    "SFXGameContent.SFXPowerCustomAction_GethPrimeShieldDrone", 
                    "SFXGameContent.SFXPowerCustomAction_GethPrimeTurret", 
                    "SFXGameContent.SFXPowerCustomAction_GethPyroTankExplosion", 
                    "SFXGameContent.SFXPowerCustomAction_GethReaperAttack", 
                    "SFXGameContent.SFXPowerCustomAction_GethShieldBoost", 
                    "SFXGameContent.SFXPowerCustomAction_GrenadeBase", 
                    "SFXGameContent.SFXPowerCustomAction_HenchmanPassive", 
                    "SFXGameContent.SFXPowerCustomAction_IncendiaryAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_Incinerate", 
                    "SFXGameContent.SFXPowerCustomAction_InfernoGrenade", 
                    "SFXGameContent.SFXPowerCustomAction_InfiltratorMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_InfiltratorPassive", 
                    "SFXGameContent.SFXPowerCustomAction_JimmyPassive", 
                    "SFXGameContent.SFXPowerCustomAction_KaidenPassive", 
                    "SFXGameContent.SFXPowerCustomAction_LiaraPassive", 
                    "SFXGameContent.SFXPowerCustomAction_LiftGrenade", 
                    "SFXGameContent.SFXPowerCustomAction_StickyGrenade", 
                    "SFXGameContent.SFXPowerCustomAction_BioticGrenade", 
                    "SFXGameContent.SFXPowerCustomAction_Marksman", 
                    "SFXGameContent.SFXPowerCustomAction_MultiProjectile", 
                    "SFXGameContent.SFXPowerCustomAction_Overload", 
                    "SFXGameContent.SFXPowerCustomAction_ProximityMine", 
                    "SFXGameContent.SFXPowerCustomAction_Pull", 
                    "SFXGameContent.SFXPowerCustomAction_Reave", 
                    "SFXGameContent.SFXPowerCustomAction_SentinelMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_SentinelPassive", 
                    "SFXGameContent.SFXPowerCustomAction_SentryTurret", 
                    "SFXGameContent.SFXPowerCustomAction_SentryTurretCryoAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_SentryTurretDisruptorAmmo", 
                    "SFXGameContent.SFXPowerCustomAction_SentryTurretRocket", 
                    "SFXGameContent.SFXPowerCustomAction_SentryTurretShock", 
                    "SFXGameContent.SFXPowerCustomAction_ShieldDroneBuff", 
                    "SFXGameContent.SFXPowerCustomAction_Shockwave", 
                    "SFXGameContent.SFXPowerCustomAction_Singularity", 
                    "SFXGameContent.SFXPowerCustomAction_Slam", 
                    "SFXGameContent.SFXPowerCustomAction_SoldierMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_SoldierPassive", 
                    "SFXGameContent.SFXPowerCustomAction_Stasis", 
                    "SFXGameContent.SFXPowerCustomAction_TaliPassive", 
                    "SFXGameContent.SFXPowerCustomAction_TechArmor", 
                    "SFXGameContent.SFXPowerCustomAction_Throw", 
                    "SFXGameContent.SFXPowerCustomAction_TitanRocket", 
                    "SFXGameContent.SFXPowerCustomAction_TitanRocket_Player", 
                    "SFXGameContent.SFXPowerCustomAction_Unity", 
                    "SFXGameContent.SFXPowerCustomAction_VanguardMeleePassive", 
                    "SFXGameContent.SFXPowerCustomAction_VanguardPassive", 
                    "SFXGameContent.SFXPowerCustomAction_Warp", 
                    "SFXGameContent.SFXPowerCustomAction_WarpAmmo", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_AdrenalineRush", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_AIHacking", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_AsariPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_AsariMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Barrier", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_BioticCharge", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_BioticGrenade", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Carnage", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Cloak", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_CombatDrone", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_ConcussiveShot", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_CryoBlast", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_DarkChannel", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Decoy", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Discharge", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_DrellPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_DrellMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_EnergyDrain", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_FemQuarianMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Fortification", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_FragGrenade", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_GethShieldBoost", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassiveBase", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Soldier", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Adept", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Engineer", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Sentinel", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Vanguard", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_HumanMeleePassive_Infiltrator", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Incinerate", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_InfernoGrenade", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_KroganPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_KroganMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_LiftGrenade", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Marksman", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Overload", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_ProximityMine", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Pull", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Reave", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_SalarianPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_SalarianMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_SentryTurret", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Shockwave", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Singularity", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Slam", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Stasis", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_StickyGrenade", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Turian", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_TechArmor_Krogan", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Throw", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_TurianPassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_TurianMeleePassive", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Warp", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Consumable", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Ammo", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Shield", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Rocket", 
                    "SFXGameMPContent.SFXPowerCustomActionMP_Consumable_Revive", 
                    "SFXGameContent.SFXGameEffect_PowerCombo_Biotic", 
                    "SFXGameContent.SFXGameEffect_PowerCombo_Electric", 
                    "SFXGameContent.SFXGameEffect_PowerCombo_Cryo", 
                    "SFXGameContent.SFXGameEffect_PowerCombo_Fire", 
                    "DisarmEnable", 
                    "DisarmDisable", 
                    "ExtractionPoint", 
                    "AnnexZoneHack", 
                    "AnnexZoneUpload", 
                    "AssassinationObjective", 
                    "RetrievePickup", 
                    "RetrieveDropOff", 
                    "SupplyDrop", 
                    "SFXOperation_ObjectiveData_SupplyCrate_Variation1", 
                    "SFXOperation_ObjectiveData_Retrieve_Variation1", 
                    "SFXOperation_ObjectiveData_AnnexHack_Variation1", 
                    "SFXOperation_ObjectiveData_AnnexHack_Variation2", 
                    "SFXOperation_ObjectiveData_AnnexUpload_Variation1", 
                    "SFXOperation_ObjectiveData_AnnexUpload_Variation2", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation1", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation2", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation3", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation4", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation5", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation6", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation7", 
                    "SFXOperation_ObjectiveData_DisarmEnable_Variation8", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation1", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation2", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation3", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation4", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation5", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation6", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation7", 
                    "SFXOperation_ObjectiveData_DisarmDisable_Variation8", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_ArmorPiercing", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Cryo", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Disruptor", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Incendiary", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_AmmoPower_Warp", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonus", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_ShieldBonus", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_SpeedBonus", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_AssaultRifle", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Pistol", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_Shotgun", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SMG", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_WeaponDamageBonus_SniperRifle", 
                    "SFXGameMPContent.SFXGameEffect_MatchConsumable_PowerBonusDamage", 
                    "MatchConsumable_ActiveXPBonusMultiplierIndex", 
                    "PROEAR", 
                    "PROMAR", 
                    "KROGAR", 
                    "KRO001", 
                    "KRO002", 
                    "KROGRU", 
                    "GTH001", 
                    "GTH002", 
                    "GTHLEG", 
                    "CAT003", 
                    "CAT002", 
                    "CAT004", 
                    "CERMIR", 
                    "CITSAM", 
                    "OMGJCK", 
                    "CERJCB", 
                    "END001", 
                    "END002", 
                    "STORE", 
                    "ENDGAMEMAX", 
                    "FINDSALVAGE", 
                    "IMPORT", 
                    "INSANITY", 
                    "WEAPONMOD", 
                    "ROMANCE", 
                    "POWERCOMBO", 
                    "MAXPOWER", 
                    "KILLA", 
                    "KILLB", 
                    "KILLC", 
                    "MELEE", 
                    "ESCAPEREAPER", 
                    "MAXSECURITY", 
                    "OVERLOADSHIELDS", 
                    "ENEMIESFLYING", 
                    "ENEMIESONFIRE", 
                    "BRUTECHARGE", 
                    "GUARDIANMAILSLOT", 
                    "HIJACKATLAS", 
                    "HARVESTER", 
                    "CREATECHAR", 
                    "PLAYALLMAPS", 
                    "PREPARED", 
                    "MISSIONSA", 
                    "MISSIONSB", 
                    "WEAPONMAXED", 
                    "HIGHLEVEL", 
                    "MAXLEVEL", 
                    "NEWGAME", 
                    "ALLMAPSGOLD", 
                    "SALVAGECOUNT", 
                    "LEVELCOUNT", 
                    "MPLEVELCOUNT", 
                    "KILLCOUNT", 
                    "MELEEKILLCOUNT", 
                    "OVERLOADCOUNT", 
                    "FLYINGCOUNT", 
                    "ONFIRECOUNT", 
                    "COMBOCOUNT", 
                    "GUARDIANHEADKILLCOUNT", 
                    "SPPLAYEDMAPS", 
                    "SPMAPSCOUNT", 
                    "MPPLAYEDMAPS", 
                    "MPMAPSCOUNT", 
                    "SPPLAYEDMAPSINSANE", 
                    "SPMAPSINSANECOUNT", 
                    "MPPLAYEDMAPSGOLD", 
                    "MPMAPSGOLDCOUNT", 
                    "ARMORCOUNT", 
                    "WEAPONLEVEL", 
                    "POWERLEVEL", 
                    "AVATAROMNIBLADE", 
                    "biop_mptowr", 
                    "biop_mpcer", 
                    "biop_mpnov", 
                    "biop_mpslum", 
                    "biop_mprctr", 
                    "biop_mpdish", 
                    "MPCapacity_Ammo", 
                    "MPCapacity_Revive", 
                    "MPCapacity_Rocket", 
                    "MPCapacity_Shield", 
                    "MPRespec", 
                    "MPCredits"
                   )
    GUIMultiDisplayMaxWidth = 5
    GUIMultiDisplayBezelTolerance = 0.0500000007
    CorruptCareerWarningText = $349279
    ConfirmDeleteCorruptText = $147164
    CancelDeleteCorruptText = $147165
    LoadingScreenTimeout = 160.0
    DebugLoadingScreenTimeout = 180.0
    ActualLoadingScreenTimeout = -1.0
    bEnableAccomplishmentManager = TRUE
    bEnableFastResume = TRUE
    bCanWriteSaveToStorage = TRUE
    bUploadFaceCodesToBlaze = TRUE
}
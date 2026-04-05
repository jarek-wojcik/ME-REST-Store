Class SFXGRI extends GameReplicationInfo
    native
    config(Game);

var delegate<GenericTimerCallback> __GenericTimerCallback__Delegate;
var const Class<SFXDifficultyHandler> DifficultyHandlerClass;
var Class<SFXVocalizationManager> VocManagerClass;
var SFXObjectPool ObjectPool;
var SFXPreAsyncWorkTicker PreAsyncWorker;
var SFXDuringAsyncWorkTicker DuringAsyncWorker;
var SFXGameConfig gameconfig;
var config float StormStamina;
var config float StormRegen;
var config float StormStaminaNonCombat;
var config float StormRegenNonCombat;
var config float HackCrouchCoverOffset;
var SFXVocalizationManager VocManager;
var transient SFXMarkerModuleManager MarkerModuleManager;
var(SFXGRI) SFXDifficultyHandler DifficultyHandler;
var SFXWaveCoordinator WaveCoordinator;
var config float WaveDelay;
var export RvrClientEffectManager m_pClientEffectManager;
var export RvrClientEffectPool m_pClientEffectPool;
var bool bCanSpawnHenchmen;
var bool bPlayerCanChangeSquad;
var bool bPauseForCommand;
var bool bAllowTimeDilation;
var bool bAlwaysInCombat;
var bool bMultiplayer;
var bool bIsMultiplayerCharacter;
var bool bCanShowMap;
var bool bCanShowCodex;
var bool bCanShowJournal;
var bool bCanSave;
var transient bool bInCombat;
var transient bool bForceCombat;
var bool EnableDamage;
var bool bForceOperationWave;

public event simulated function ClearAllMarkerActors()
{
    MarkerModuleManager.ClearAllMarkerActors();
}
public event simulated function Destroyed()
{
    local SFXMarkerModuleManager OldMarkerManager;
    
    Super.Destroyed();
    OldMarkerManager = MarkerModuleManager;
    MarkerModuleManager = None;
    OldMarkerManager.Destroyed();
}
public final native function DestroyLoadMovieAudio();

public delegate function GenericTimerCallback();

public final event simulated function bool GetPlayerLevel(int ControllerId, out int PlayerLevel)
{
    local BioPlayerController PC;
    local LocalPlayer LP;
    
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        LP = LocalPlayer(PC.Player);
        if (LP != None && LP.ControllerId == ControllerId && PC.Pawn != None)
        {
            PlayerLevel = SFXPawn_PlayerParty(PC.Pawn).CharacterLevel;
            return TRUE;
        }
    }
    return FALSE;
}
public final event simulated function bool InCombat()
{
    return bInCombat || bForceCombat || bAlwaysInCombat;
}
public simulated function PostBeginPlay()
{
    local BioRemoteLogger GLogger;
    
    Super.PostBeginPlay();
    if (WorldInfo.bIsUIWorld == FALSE)
    {
        if (DifficultyHandler == None)
        {
            DifficultyHandler = new (Self) DifficultyHandlerClass;
        }
        if (VocManager == None && VocManagerClass != None)
        {
            VocManager = Spawn(VocManagerClass);
        }
        if (ObjectPool == None)
        {
            ObjectPool = Spawn(Class'SFXObjectPool');
        }
        if (PreAsyncWorker == None)
        {
            PreAsyncWorker = Spawn(Class'SFXPreAsyncWorkTicker', Self);
        }
        if (DuringAsyncWorker == None)
        {
            DuringAsyncWorker = Spawn(Class'SFXDuringAsyncWorkTicker', Self);
        }
        if (MarkerModuleManager == None)
        {
            MarkerModuleManager = new (Self) Class'SFXMarkerModuleManager';
        }
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            if (IsMultiplayerGame())
            {
                GLogger.SetFlag(256, TRUE);
            }
            else
            {
                GLogger.SetFlag(256, FALSE);
            }
        }
    }
}
public event simulated function TriggerVocalizationEvent(byte VocalizationID, BioPawn instigatedBy, optional BioPawn Recipient, optional float Delay, optional float fChanceToPlayModifier = 1.0, optional bool bReplicated = FALSE)
{
    VocManager.TriggerVocalizationEvent(VocalizationID, instigatedBy, Recipient, None, Delay, fChanceToPlayModifier, bReplicated);
}
public function CopyProperties(SFXGRI OldGRI);

public simulated function bool ModifyDamage(out float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<SFXDamageType> DamageType, Actor injured, Controller instigatedBy, out DamageCalculationAlgorithm DamageCalc, optional Actor DamageCauser)
{
    local BioWorldInfo Info;
    local BioPlayerController PC;
    
    if (!EnableDamage)
    {
        return FALSE;
    }
    Info = BioWorldInfo(WorldInfo);
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        if (PC.GameModeManager2.IsActive(8) && Info != None && Info.m_bForceCinematicDamage == FALSE)
        {
            return FALSE;
        }
        if (PC.GameModeManager2.IsActive(7))
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function AddSquadMedal(int Medal, optional int ReplaceMedal = -1);

public final simulated function bool ClearGenericTimer(delegate<GenericTimerCallback> Callback)
{
    if (__GenericTimerCallback__Delegate == None)
    {
        return TRUE;
    }
    if (__GenericTimerCallback__Delegate == Callback)
    {
        ClearTimer('GenericTimer');
        __GenericTimerCallback__Delegate = None;
        return TRUE;
    }
    return FALSE;
}
public function CreateWaveCoordinator(Class<SFXWaveCoordinator> WaveCoordinatorClass)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (WaveCoordinator == None)
        {
            WaveCoordinator = Spawn(WaveCoordinatorClass, Self);
        }
    }
}
public final simulated function GenericTimer()
{
    local delegate<GenericTimerCallback> Callback;
    
    Callback = GenericTimerCallback;
    __GenericTimerCallback__Delegate = None;
    if (Callback != None)
    {
        Callback();
    }
}
public simulated function int GetEnemyWaveTypeID();

public simulated function SFXMPEventTicker GetEventTicker()
{
    return None;
}
public simulated function SFXScoreManager GetScoreManager()
{
    return None;
}
public simulated function float GetTeamScore();

public function bool HasSquadMedal(int Medal)
{
    return FALSE;
}
public simulated function bool IsGameOver()
{
    return FALSE;
}
public simulated function bool IsJoinInProgress()
{
    return FALSE;
}
public simulated function bool IsOperationWave()
{
    return FALSE;
}
public simulated function Pawn NextLivingPlayer()
{
    return GetALocalPlayerController().Pawn;
}
public simulated function int NumLivingPlayers()
{
    local int nRemaining;
    local SFXPlayerController C;
    
    nRemaining = 0;
    foreach WorldInfo.AllControllers(Class'SFXPlayerController', C)
    {
        if (!C.IsDead() && C.Pawn != None)
        {
            nRemaining++;
        }
    }
    return nRemaining;
}
public simulated function int NumPlayersInGame()
{
    local int NumPlayers;
    local int idx;
    
    for (idx = 0; idx < PRIArray.Length; idx++)
    {
        if (PRIArray[idx].bBot == FALSE)
        {
            NumPlayers++;
        }
    }
    return NumPlayers;
}
public simulated function OnMissionComplete();

public final simulated function PlayTransientSound(WwiseBaseSoundObject InWwiseEvent, Vector SoundLocation, optional array<string> RTPCName, optional array<float> RTPCValue)
{
    local WwiseAudioComponent Component;
    local int i;
    
    Component = ObjectPool.GetWwiseAudioComponent();
    if (Component != None)
    {
        Component.SetLocation(SoundLocation);
        if (RTPCName.Length > 0)
        {
            if (RTPCValue.Length == RTPCName.Length)
            {
                for (i = 0; i < RTPCName.Length; i++)
                {
                    Component.SetWwiseRTPC(RTPCName[i], RTPCValue[i]);
                }
            }
        }
        Component.Play(InWwiseEvent);
    }
}
public simulated function bool RandomFactionChosen();

public simulated function bool RandomMapChosen();

public final simulated function bool SetGenericTimer(float InRate, delegate<GenericTimerCallback> Callback)
{
    if (__GenericTimerCallback__Delegate != None)
    {
        return FALSE;
    }
    __GenericTimerCallback__Delegate = Callback;
    SetTimer(InRate, FALSE, 'GenericTimer', );
    return TRUE;
}
public function SetMatchMinuteCounter(int MatchTime);


replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        WaveCoordinator, bInCombat, bForceCombat;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=RvrClientEffectManager Name=CEManager
    End Object
    Begin Object Class=RvrClientEffectPool Name=CEPool
    End Object
    Begin Object Class=SFXGameConfig Name=GameConfigBase
    End Object
    DifficultyHandlerClass = Class'SFXDifficultyHandler'
    gameconfig = GameConfigBase
    StormStamina = 10000.0
    StormRegen = 10000.0
    StormStaminaNonCombat = 6.5
    StormRegenNonCombat = 0.375
    WaveDelay = 8.0
    m_pClientEffectManager = CEManager
    m_pClientEffectPool = CEPool
    bCanSpawnHenchmen = TRUE
    bPlayerCanChangeSquad = TRUE
    bPauseForCommand = TRUE
    bAllowTimeDilation = TRUE
    bCanShowMap = TRUE
    bCanShowCodex = TRUE
    bCanShowJournal = TRUE
    bCanSave = TRUE
    EnableDamage = TRUE
}
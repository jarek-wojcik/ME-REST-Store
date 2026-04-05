Class SFXGame extends GameInfo
    native
    config(Game);

struct native ReputationThreshold 
{
    var int PlotStateID;
    var int Threshold;
};
struct native DecayedCover 
{
    var CoverSlotMarker CoverMarker;
    var int ExtraCoverCost;
};
struct native ScaledFloat 
{
    var array<SFXGameEffect> Bonuses;
    var(ScaledFloat) float X;
    var(ScaledFloat) float Y;
    var(ScaledFloat) int MaxLevel;
    var(ScaledFloat) int Level;
    var float Value;
    var float StaticBonus;
    
    structdefaultproperties
    {
        MaxLevel = 100
        StaticBonus = 1.0
    }
};
struct native TimeDilationStruct 
{
    var InterpCurveFloat Curve;
    var Name Identifier;
    var float TotalTime;
    var float Time;
};
enum ECharacterClass
{
    ClassType_Invalid,
    ClassType_Soldier,
    ClassType_Adept,
    ClassType_Infiltrator,
    ClassType_Engineer,
    ClassType_Vanguard,
    ClassType_Sentinel,
};
const MUSIC_PLOT_STATE_INDEX = 10251;

var const native Map_Mirror DecayedCoverMap;
var array<SFXTeamInfo> Teams;
var string MaleActorType;
var string FemaleActorType;
var(SFXGame) biodynamicload string TreasureClassName;
var(SFXGame) config array<string> NewGamePlusPlayerVariables;
var array<TimeDilationStruct> TimeDilationCurves;
var biodynamicload string MAdeptArchName;
var biodynamicload string MEngineerArchName;
var biodynamicload string MInfiltratorArchName;
var biodynamicload string MSentinelArchName;
var biodynamicload string MSoldierArchName;
var biodynamicload string MVanguardArchName;
var biodynamicload string MAdeptNCArchName;
var biodynamicload string MEngineerNCArchName;
var biodynamicload string MInfiltratorNCArchName;
var biodynamicload string MSentinelNCArchName;
var biodynamicload string MSoldierNCArchName;
var biodynamicload string MVanguardNCArchName;
var biodynamicload string MAdeptInjuredArchName;
var biodynamicload string MEngineerInjuredArchName;
var biodynamicload string MInfiltratorInjuredArchName;
var biodynamicload string MSentinelInjuredArchName;
var biodynamicload string MSoldierInjuredArchName;
var biodynamicload string MVanguardInjuredArchName;
var biodynamicload string MCharCreationArchName;
var biodynamicload string FAdeptArchName;
var biodynamicload string FEngineerArchName;
var biodynamicload string FInfiltratorArchName;
var biodynamicload string FSentinelArchName;
var biodynamicload string FSoldierArchName;
var biodynamicload string FVanguardArchName;
var biodynamicload string FAdeptNCArchName;
var biodynamicload string FEngineerNCArchName;
var biodynamicload string FInfiltratorNCArchName;
var biodynamicload string FSentinelNCArchName;
var biodynamicload string FSoldierNCArchName;
var biodynamicload string FVanguardNCArchName;
var biodynamicload string FAdeptInjuredArchName;
var biodynamicload string FEngineerInjuredArchName;
var biodynamicload string FInfiltratorInjuredArchName;
var biodynamicload string FSentinelInjuredArchName;
var biodynamicload string FSoldierInjuredArchName;
var biodynamicload string FVanguardInjuredArchName;
var biodynamicload string FCharCreationArchName;
var const array<DecayedCover> DecayedCoverList;
var config array<ReputationThreshold> ReputationThresholds;
var array<delegate<OnJoinInProgress>> JoinInProgressDelegates;
var delegate<OnJoinInProgress> __OnJoinInProgress__Delegate;
var BioBaseSquad PlayerSquad;
var stringref srGameOverString;
var config float fAutoUnlitDownsizeThreshold;
var(SFXGame) SFXTreasureData TREASURE;
var float TimeDilationOverride;
var WwiseEvent StartSlowEvent;
var WwiseEvent StopSlowEvent;
var float AdjacentDecayMult;
var int DecayRecoveryPerSecond;
var float DecayRecoveryIntervalRemaining;
var transient int CurrentSmokeCount;
var float MaxSmokeCount;
var transient int CurrentSwarmerCount;
var transient int CurrentCannibalCount;
var transient float LastEnemyGrenadeTimestamp;
var transient SFXAIPerceptionManager PerceptionManager;
var config bool bEnableLowDetailProxySilhouettes;
var config bool bAutoUnlitDownsizeInCombat;
var bool bDilateSound;
var transient bool bGenerateTutorialEvents;
var transient bool bShowSquadScreenMessageBoxes;
var config bool bPerfProto;

public final native function AddCoverDecay(CoverSlotMarker CoverMarker, int Amount);

public final function CombatEnded()
{
    if (SFXGRI(WorldInfo.GRI).bInCombat && SFXGRI(WorldInfo.GRI).bForceCombat == FALSE)
    {
        SetTimer(2.0, FALSE, 'OnCombatEnd', );
    }
    SFXGRI(WorldInfo.GRI).bInCombat = FALSE;
}
public static final native function CopyAndUpdateME2ImportData(SFXSaveGame SaveTo, SFXSaveGame SaveFrom, PlayerInfoEx PlayerDataOverrides);

public static final native function CopyAndUpdateNewGamePlusData(SFXSaveGame SaveTo, SFXSaveGame SaveFrom, PlayerInfoEx PlayerDataOverrides);

public function GameEnding()
{
    local BioWorldInfo BWI;
    local BioPlayerController PC;
    local SFXModule_DamagePlayer PlayerDamageModule;
    
    BWI = BioWorldInfo(WorldInfo);
    if (BWI != None)
    {
        PC = BWI.GetLocalPlayerController();
        if (PC != None && PC.Pawn != None)
        {
            Super.GameEnding();
            PlayerDamageModule = PC.Pawn.GetModule(Class'SFXModule_DamagePlayer');
            if (PlayerDamageModule != None && PlayerDamageModule.CurrentBleedoutState != EBleedoutState.BleedOutState_None)
            {
                PlayerDamageModule.RecoverFromBleedout();
            }
        }
    }
}
public final function Class<SFXPawn_Player> GetCharacterClassByName(coerce string className)
{
    if (className == "Adept")
    {
        return Class'SFXPawn_PlayerAdept';
    }
    else if (className == "Infiltrator")
    {
        return Class'SFXPawn_PlayerInfiltrator';
    }
    else if (className == "Engineer")
    {
        return Class'SFXPawn_PlayerEngineer';
    }
    else if (className == "Vanguard")
    {
        return Class'SFXPawn_PlayerVanguard';
    }
    else if (className == "Sentinel")
    {
        return Class'SFXPawn_PlayerSentinel';
    }
    return Class'SFXPawn_PlayerSoldier';
}
public static event function int GetCurrentMusicPlotStateIndex()
{
    return 10251;
}
public static final native function float GetMipFadingValue();

public function int GetPlayerCount()
{
    local SFXPlayerController PC;
    local int PlayerCount;
    
    foreach WorldInfo.AllControllers(Class'SFXPlayerController', PC)
    {
        PlayerCount++;
    }
    return PlayerCount;
}
public static final native function string GetSimpleString(stringref StrRef, optional bool bParse = FALSE);

public static final native function LoadPackage(string PackageName);

public final native function NotifyStartMatchForTests();

public delegate function OnJoinInProgress();

public event function PostBeginPlay()
{
    local BioGlobalVariableTable VarTable;
    local int idx;
    
    Super.PostBeginPlay();
    if (WorldInfo.IsConsoleBuild() || SFXGRI(WorldInfo.GRI).gameconfig.bUseConsoleControls)
    {
        WorldInfo.bUseConsoleInput = TRUE;
    }
    VarTable = BioWorldInfo(WorldInfo).GetGlobalVariables();
    if (VarTable != None)
    {
        for (idx = 0; idx < ReputationThresholds.Length; idx++)
        {
            VarTable.SetInt(ReputationThresholds[idx].PlotStateID, ReputationThresholds[idx].Threshold);
        }
    }
}
public event function PreBeginPlay()
{
    Super.PreBeginPlay();
    if (WorldInfo.NetMode != ENetMode.NM_Client && WorldInfo.bIsUIWorld == FALSE)
    {
        PerceptionManager = Spawn(Class'SFXAIPerceptionManager');
    }
}
public final native function ProbeOnCombatBegin();

public final native function ProbeOnCombatEnd();

public function Reset()
{
    Super.Reset();
    TimeDilationCurves.Length = 0;
    GotoState('PendingMatch', , , );
}
public static final native function SetMipFadingValue(float fNewMipValue);

public static final native function SortActorsByAngle(out array<Actor> List, Vector RefLocation, Rotator RefRotation, bool bPreferBioPawns);

public event function SpawnPlayerForResume(Controller LocalPlayer)
{
    local BioWorldInfo oBWI;
    local BioPlayerController PC;
    
    PC = SFXPlayerController(LocalPlayer);
    oBWI = BioWorldInfo(WorldInfo);
    if (SFXPlayerCamera(PC.PlayerCamera) != None)
    {
        SFXPlayerCamera(PC.PlayerCamera).CurrentCameraMode = None;
    }
    if (oBWI != None && oBWI.m_playerSquad != None)
    {
        PC.ResetInitialPlayerPawn(BioPlayerSquad(oBWI.m_playerSquad));
    }
    PC.bProfileSettingsUpdated = TRUE;
    RestartPlayer(LocalPlayer);
}
public function Tick(float TimeDelta)
{
    local float SlowestDilation;
    
    SlowestDilation = UpdateTimeDilationArray(TimeDelta);
    if (TimeDilationOverride != float(1))
    {
        SlowestDilation = TimeDilationOverride;
    }
    if (WorldInfo.TimeDilation != SlowestDilation)
    {
        OnTimeDilationChange(SlowestDilation);
    }
}
public static final native function UpdateResourceStreaming(float fTime, optional bool bProcessEverything = FALSE);

public final native function float UpdateTimeDilationArray(float TimeDelta);

public function bool AllowCheats(PlayerController P)
{
    if (Class'Engine'.static.IsShip() == FALSE)
    {
        return TRUE;
    }
    else
    {
        return WorldInfo.NetMode == ENetMode.NM_Standalone;
    }
}
public function int CalculatedNetSpeed()
{
    return Clamp(TotalNetBandwidth / Max(NumPlayers - 1, 1), MinDynamicBandwidth, MaxDynamicBandwidth);
}
public function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    if (Teams.Length < 4)
    {
        InitializeTeams();
    }
    if (Other != None && Other.PlayerReplicationInfo != None)
    {
        if (N == 255 || Other.PlayerReplicationInfo.Team == None || Other.PlayerReplicationInfo.Team != Teams[N])
        {
            if (N < 255)
            {
                Other.PlayerReplicationInfo.SetPlayerTeam(Teams[N]);
                return TRUE;
            }
            else
            {
                if (Other.PlayerReplicationInfo.Team != None)
                {
                    Other.PlayerReplicationInfo.SetPlayerTeam(None);
                }
                Other.PlayerReplicationInfo.Team = None;
                return TRUE;
            }
        }
        else
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, Class<DamageType> DamageType)
{
    local BioRemoteLogger GLogger;
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    Super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        Engine = SFXEngine(PC.Player.Outer);
        if (Engine != None && KilledPawn.GetNetIndex() != -1 && SFXPawn_Henchman(KilledPawn) == None)
        {
            Engine.DeadPawnList.AddItem(BioPawn(KilledPawn).MyGuid);
            break;
        }
    }
    if (Killer != None && (Killer.bIsPlayer || SFXPawn_Player(Killer.Instigator) != None))
    {
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            GLogger.SendPlayerEvent(57, string(DamageType), string(KilledPawn.Name), string(KilledPawn.Tag), "", int(VSize(Killer.Pawn.location - KilledPawn.location)), 0, 0, int(BioPlayerController(Killer).GetBioPawn().IsInCover()));
        }
        foreach LocalPlayerControllers(Class'BioPlayerController', PC)
        {
            if (PC.IsLocalPlayerController())
            {
                PC.HintSystem.HintEvent('PlayerKill');
            }
        }
        if (Killer.Instigator != None)
        {
            Killer = Killer.Instigator.Controller;
        }
        if (KilledPawn != None && SFXPawn(KilledPawn).bIsPet == FALSE)
        {
            BioPlayerController(Killer).UpdateAccomplishmentProgression('KILLCOUNT');
        }
    }
}
public function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn);

public function PerformEndGameHandling()
{
    if (GameInterface != None)
    {
        WriteOnlinePlayerScores();
        EndOnlineGame();
        if (bUsingArbitration)
        {
            PendingArbitrationPCs.Length = 0;
            ArbitrationPCs.Length = 0;
            NotifyArbitratedMatchEnd();
        }
    }
}
public function bool PreventDeath(Pawn KilledPawn, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
    local BioPawn BP;
    
    if (KilledPawn != None)
    {
        BP = BioPawn(KilledPawn);
        if (BP != None && BP.m_bMin1Health)
        {
            return TRUE;
        }
    }
    return Super.PreventDeath(KilledPawn, Killer, DamageType, HitLocation);
}
public function RestartPlayer(Controller NewPlayer)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    if (!Class'WorldInfo'.static.IsMenuLevel())
    {
        Super.RestartPlayer(NewPlayer);
    }
    Engine.bGameInProgress = TRUE;
}
public function SetGameSpeed(float T)
{
    local SFXMutator mut;
    
    mut = SFXMutator(BaseMutator);
    if (mut != None)
    {
        mut.SetGameSpeed(T);
    }
    Super.SetGameSpeed(T);
}
public function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot, optional bool bNoCollisionFail = FALSE)
{
    local Vector StartLocation;
    local Rotator StartRotation;
    local SFXEngine Engine;
    local int CasualAppearance;
    local bool bIsFemale;
    local bool bStartedGame;
    local bool bUseCasualAppearance;
    local bool bSpawnWeapons;
    local bool bLoadedPlayer;
    local int IsFemale;
    local int SpawnCombatPawn;
    local int SpawnInjuredPawn;
    local int ForcedAppearance;
    local Class<SFXPawn_Player> CharacterClass;
    local string firstName;
    local EOriginType Origin;
    local ENotorietyType Notoriety;
    local Name BonusTalent;
    local string faceCode;
    local BioMorphFace NewMorphHead;
    local SFXPawn_Player ResultPawn;
    local PlayerInfoEx PlayerInfo;
    local PlayerInfoEx ResetPlayerInfoEx;
    local Pawn PlayerArchetype;
    local BioWorldInfo BWI;
    local bool bSpawnCombatPawn;
    local bool bLoadingFromSaveGame;
    local bool bSpawnInjuredPawn;
    local Guid CharacterGUID;
    
    if (StartSpot != None)
    {
        StartLocation = StartSpot.location;
        StartRotation.Yaw = StartSpot.Rotation.Yaw;
    }
    Engine = SFXEngine(PlayerController(NewPlayer).Player.Outer);
    if (Engine != None)
    {
        PlayerInfo = Engine.CurrentPlayerInfo();
        BonusTalent = PlayerInfo.BonusTalentClass;
    }
    bStartedGame = WorldInfo.IsPlayInEditor() == FALSE && Engine.bGameInProgress;
    ForcedAppearance = -1;
    if (!bStartedGame)
    {
        bUseCasualAppearance = FALSE;
        if (Engine != None)
        {
            bIsFemale = PlayerInfo.bIsFemale;
            CharacterClass = PlayerInfo.CharacterClass;
            firstName = PlayerInfo.firstName;
            Origin = PlayerInfo.Origin;
            Notoriety = PlayerInfo.Notoriety;
            BonusTalent = PlayerInfo.BonusTalentClass;
            faceCode = PlayerInfo.faceCode;
            CharacterGUID = PlayerInfo.CharacterGUID;
            BWI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
            if (BWI != None)
            {
                bSpawnCombatPawn = BWI.bCombatLevel;
                if (!bSpawnCombatPawn)
                {
                    bSpawnWeapons = BWI.bCreateAndShowWeapons;
                }
                bUseCasualAppearance = BWI.bUseCasualAppearance;
                if (bUseCasualAppearance)
                {
                    ForcedAppearance = BWI.ForcedCasualAppearanceID;
                }
            }
        }
        else
        {
            bIsFemale = Class'SFXEngine'.default.DefaultPlayer.bIsFemale;
            CharacterClass = Class'SFXEngine'.default.DefaultPlayer.CharacterClass;
            firstName = Class'SFXEngine'.default.DefaultPlayer.firstName;
            Origin = Class'SFXEngine'.default.DefaultPlayer.Origin;
            Notoriety = Class'SFXEngine'.default.DefaultPlayer.Notoriety;
            BonusTalent = Class'SFXEngine'.default.DefaultPlayer.BonusTalentClass;
            faceCode = Class'SFXEngine'.default.DefaultPlayer.faceCode;
            CharacterGUID = Class'SFXEngine'.static.CreateGUID();
        }
    }
    else if (Engine != None)
    {
        Engine.CurrentSaveGame.GetSpawnData(IsFemale, CharacterClass, firstName, Origin, Notoriety, SpawnCombatPawn, SpawnInjuredPawn, CasualAppearance);
        faceCode = Engine.CurrentSaveGame.PlayerRecord.faceCode;
        CharacterGUID = Engine.CurrentSaveGame.PlayerRecord.CharacterGUID;
        bIsFemale = IsFemale == 0 ? FALSE : TRUE;
        if (Engine.bPlayerLoadPosition)
        {
            bLoadingFromSaveGame = TRUE;
            bSpawnCombatPawn = SpawnCombatPawn == 0 ? FALSE : TRUE;
            bSpawnInjuredPawn = SpawnInjuredPawn == 0 ? FALSE : TRUE;
            bUseCasualAppearance = CasualAppearance == 0 ? FALSE : TRUE;
            BWI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
            if (BWI != None)
            {
                if (!bSpawnCombatPawn)
                {
                    bSpawnWeapons = BWI.bCreateAndShowWeapons;
                }
                if (bUseCasualAppearance)
                {
                    ForcedAppearance = BWI.ForcedCasualAppearanceID;
                }
            }
        }
        else
        {
            BWI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
            if (BWI != None)
            {
                bSpawnCombatPawn = BWI.bCombatLevel;
                if (!bSpawnCombatPawn)
                {
                    bSpawnWeapons = BWI.bCreateAndShowWeapons;
                }
                bUseCasualAppearance = BWI.bUseCasualAppearance;
                if (bUseCasualAppearance)
                {
                    ForcedAppearance = BWI.ForcedCasualAppearanceID;
                }
            }
        }
    }
    if (Engine.bNewPlayer)
    {
        NewMorphHead = Engine.NewPlayer.MorphHead;
    }
    if (!bSpawnCombatPawn)
    {
        PlayerArchetype = GetPlayerNonCombatArchetype(CharacterClass, bIsFemale);
    }
    else if (bSpawnInjuredPawn)
    {
        PlayerArchetype = GetPlayerInjuredArchetype(CharacterClass, bIsFemale);
    }
    else
    {
        PlayerArchetype = GetPlayerCombatArchetype(CharacterClass, bIsFemale);
    }
    ResultPawn = SFXPawn_Player(Spawn(PlayerArchetype.Class, , 'Player', StartLocation, StartRotation, PlayerArchetype, TRUE, TRUE));
    HandleBonusPowers(ResultPawn, BonusTalent);
    ResultPawn.firstName = firstName;
    ResultPawn.Origin = Origin;
    ResultPawn.Notoriety = Notoriety;
    ResultPawn.faceCode = faceCode;
    ResultPawn.CharacterGUID = CharacterGUID;
    NewPlayer.Pawn = ResultPawn;
    ResultPawn.Controller = NewPlayer;
    UpdatePlotVariables(ResultPawn);
    if (Engine != None)
    {
        if (Engine.bGameInProgress == TRUE)
        {
            Engine.LoadPlayer();
            bLoadedPlayer = TRUE;
        }
        Engine.bGameInProgress = TRUE;
    }
    if (NewMorphHead != None)
    {
        ResultPawn.EnqueueExistingMorphHead(NewMorphHead);
    }
    else if (!bLoadedPlayer)
    {
        ResultPawn.EnqueueIconicHeadForLoad();
    }
    if (bUseCasualAppearance)
    {
        ResultPawn.bUseCasualAppearance = TRUE;
        if (ForcedAppearance != -1)
        {
            ResultPawn.OverrideCasualID = ForcedAppearance;
        }
    }
    ResultPawn.UpdateAppearance();
    if (bSpawnCombatPawn || bSpawnWeapons)
    {
        ResultPawn.AddPlayerInventory();
        if (bLoadedPlayer && bLoadingFromSaveGame == TRUE)
        {
            Engine.LoadPlayerWeapons();
        }
    }
    Class'BioLevelUpSystem'.static.VerifyPlayerTalentPoints(ResultPawn);
    if (bStartedGame == FALSE && Engine != None)
    {
        Engine.CurrentSaveGame.SavePlayer(Engine.GetLocalPlayerControllerId());
    }
    if (Engine.bNewPlayer)
    {
        Engine.NewPlayer = ResetPlayerInfoEx;
        Engine.bNewPlayer = FALSE;
    }
    if (Engine != None)
    {
        if (BWI != None)
        {
            Engine.SetPlotFlagsViaEntitlements(BWI.GetGlobalVariables());
        }
        Engine.SetPlayerVariableViaEntitlements();
    }
    return ResultPawn;
}
public function StartMatch()
{
    Super.StartMatch();
    BioWorldInfo(WorldInfo).StartMatch();
    NotifyStartMatchForTests();
}
public function bool AwardCreditPercent(float fAmount, optional string Level = "", optional bool bShowNotifications = TRUE);

public function bool AwardCredits(int Amount, optional string Level = "", optional bool bShowNotification = TRUE);

public function bool AwardItem(Name ItemName, optional string Level = "");

public function bool AwardXP(int Amount, optional string Level = "", optional bool bShowNotifications = TRUE);

public function CancelTimeDilation(Name Identifier)
{
    local int idx;
    
    for (idx = TimeDilationCurves.Length - 1; idx >= 0; idx--)
    {
        if (TimeDilationCurves[idx].Identifier == Identifier)
        {
            TimeDilationCurves.Remove(idx, 1);
        }
    }
}
public function bool CheckGameOver()
{
    local BioPlayerController C;
    
    foreach WorldInfo.AllControllers(Class'BioPlayerController', C)
    {
        if (!C.IsDead() && !C.Pawn.IsInState('Downed', ))
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function ClearCrossLevelReferences();

public final function CombatStarted()
{
    if (SFXGRI(WorldInfo.GRI).bInCombat == FALSE)
    {
        OnCombatStart();
    }
    SFXGRI(WorldInfo.GRI).bInCombat = TRUE;
}
public function int GetDownedPlayerCount()
{
    local SFXPlayerController C;
    local int NumDownedPlayers;
    
    foreach WorldInfo.AllControllers(Class'SFXPlayerController', C)
    {
        if (C.IsDead() || C.Pawn.IsInState('Dying', ) || C.Pawn.IsInState('Downed', ))
        {
            NumDownedPlayers++;
        }
    }
    return NumDownedPlayers;
}
public final function ECharacterClass GetIDByClass(Class<Pawn> PlayerClass)
{
    if (Class<SFXPawn_PlayerAdept>(PlayerClass) != None || Class<SFXPawn_PlayerAdeptNonCombat>(PlayerClass) != None)
    {
        return ECharacterClass.ClassType_Adept;
    }
    else if (Class<SFXPawn_PlayerInfiltrator>(PlayerClass) != None || Class<SFXPawn_PlayerInfiltratorNonCombat>(PlayerClass) != None)
    {
        return ECharacterClass.ClassType_Infiltrator;
    }
    else if (Class<SFXPawn_PlayerEngineer>(PlayerClass) != None || Class<SFXPawn_PlayerEngineerNonCombat>(PlayerClass) != None)
    {
        return ECharacterClass.ClassType_Engineer;
    }
    else if (Class<SFXPawn_PlayerVanguard>(PlayerClass) != None || Class<SFXPawn_PlayerVanguardNonCombat>(PlayerClass) != None)
    {
        return ECharacterClass.ClassType_Vanguard;
    }
    else if (Class<SFXPawn_PlayerSentinel>(PlayerClass) != None || Class<SFXPawn_PlayerSentinelNonCombat>(PlayerClass) != None)
    {
        return ECharacterClass.ClassType_Sentinel;
    }
    return ECharacterClass.ClassType_Soldier;
}
public function int GetME2ParagonPoints()
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return 0;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return 0;
    }
    return oVariables.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_ME2Paragon);
}
public function int GetME2RenegadePoints()
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return 0;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return 0;
    }
    return oVariables.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_ME2Renegade);
}
public function int GetParagonPoints()
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return 0;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return 0;
    }
    return oVariables.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Paragon);
}
public final function SFXPawn_Player GetPlayer(int ControllerId)
{
    local BioPlayerController PC;
    local LocalPlayer LP;
    
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        LP = LocalPlayer(PC.Player);
        if (LP != None && LP.ControllerId == ControllerId)
        {
            return SFXPawn_Player(PC.Pawn);
        }
    }
    return None;
}
public final function Pawn GetPlayerCombatArchetype(Class<Pawn> CharacterClass, bool bIsFemale)
{
    local ECharacterClass ClassType;
    local string ArchetypeName;
    local Pawn PawnArchetype;
    
    ClassType = GetIDByClass(CharacterClass);
    switch (ClassType)
    {
        case ECharacterClass.ClassType_Adept:
            ArchetypeName = bIsFemale ? FAdeptArchName : MAdeptArchName;
            break;
        case ECharacterClass.ClassType_Engineer:
            ArchetypeName = bIsFemale ? FEngineerArchName : MEngineerArchName;
            break;
        case ECharacterClass.ClassType_Infiltrator:
            ArchetypeName = bIsFemale ? FInfiltratorArchName : MInfiltratorArchName;
            break;
        case ECharacterClass.ClassType_Sentinel:
            ArchetypeName = bIsFemale ? FSentinelArchName : MSentinelArchName;
            break;
        case ECharacterClass.ClassType_Soldier:
            ArchetypeName = bIsFemale ? FSoldierArchName : MSoldierArchName;
            break;
        case ECharacterClass.ClassType_Vanguard:
            ArchetypeName = bIsFemale ? FVanguardArchName : MVanguardArchName;
            break;
        default:
    }
    PawnArchetype = Pawn(Class'SFXEngine'.static.GetSeekFreeObject(ArchetypeName, Class'SFXPawn_Player'));
    return PawnArchetype;
}
public final function Pawn GetPlayerInjuredArchetype(Class<Pawn> CharacterClass, bool bIsFemale)
{
    local ECharacterClass ClassType;
    local string ArchetypeName;
    local Pawn PawnArchetype;
    
    ClassType = GetIDByClass(CharacterClass);
    switch (ClassType)
    {
        case ECharacterClass.ClassType_Adept:
            ArchetypeName = bIsFemale ? FAdeptInjuredArchName : MAdeptInjuredArchName;
            break;
        case ECharacterClass.ClassType_Engineer:
            ArchetypeName = bIsFemale ? FEngineerInjuredArchName : MEngineerInjuredArchName;
            break;
        case ECharacterClass.ClassType_Infiltrator:
            ArchetypeName = bIsFemale ? FInfiltratorInjuredArchName : MInfiltratorInjuredArchName;
            break;
        case ECharacterClass.ClassType_Sentinel:
            ArchetypeName = bIsFemale ? FSentinelInjuredArchName : MSentinelInjuredArchName;
            break;
        case ECharacterClass.ClassType_Soldier:
            ArchetypeName = bIsFemale ? FSoldierInjuredArchName : MSoldierInjuredArchName;
            break;
        case ECharacterClass.ClassType_Vanguard:
            ArchetypeName = bIsFemale ? FVanguardInjuredArchName : MVanguardInjuredArchName;
            break;
        default:
    }
    PawnArchetype = Pawn(Class'SFXEngine'.static.GetSeekFreeObject(ArchetypeName, Class'SFXPawn_Player'));
    return PawnArchetype;
}
public final function Pawn GetPlayerNonCombatArchetype(Class<Pawn> CharacterClass, bool bIsFemale)
{
    local ECharacterClass ClassType;
    local string ArchetypeName;
    local Pawn PawnArchetype;
    
    ClassType = GetIDByClass(CharacterClass);
    switch (ClassType)
    {
        case ECharacterClass.ClassType_Adept:
            ArchetypeName = bIsFemale ? FAdeptNCArchName : MAdeptNCArchName;
            break;
        case ECharacterClass.ClassType_Engineer:
            ArchetypeName = bIsFemale ? FEngineerNCArchName : MEngineerNCArchName;
            break;
        case ECharacterClass.ClassType_Infiltrator:
            ArchetypeName = bIsFemale ? FInfiltratorNCArchName : MInfiltratorNCArchName;
            break;
        case ECharacterClass.ClassType_Sentinel:
            ArchetypeName = bIsFemale ? FSentinelNCArchName : MSentinelNCArchName;
            break;
        case ECharacterClass.ClassType_Soldier:
            ArchetypeName = bIsFemale ? FSoldierNCArchName : MSoldierNCArchName;
            break;
        case ECharacterClass.ClassType_Vanguard:
            ArchetypeName = bIsFemale ? FVanguardNCArchName : MVanguardNCArchName;
            break;
        default:
    }
    PawnArchetype = Pawn(Class'SFXEngine'.static.GetSeekFreeObject(ArchetypeName, Class'SFXPawn_PlayerNonCombat'));
    return PawnArchetype;
}
public final function GetPlayerSpawnArchetype(bool bCombatPawn, bool bInjuredPawn, out Pawn PlayerArchetype, out string firstName, out EOriginType Origin, out ENotorietyType Notoriety, out string faceCode, out Guid CharacterGUID)
{
    local SFXEngine Engine;
    local Class<SFXPawn_Player> CharacterClass;
    local bool bIsFemale;
    local int IsFemale;
    local int SpawnCombatPawn;
    local int SpawnInjuredPawn;
    local int CasualAppearance;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine != None && Engine.CurrentSaveGame != None)
    {
        Engine.CurrentSaveGame.GetSpawnData(IsFemale, CharacterClass, firstName, Origin, Notoriety, SpawnCombatPawn, SpawnInjuredPawn, CasualAppearance);
        faceCode = Engine.CurrentSaveGame.PlayerRecord.faceCode;
        CharacterGUID = Engine.CurrentSaveGame.PlayerRecord.CharacterGUID;
        bIsFemale = IsFemale == 0 ? FALSE : TRUE;
    }
    if (!bCombatPawn)
    {
        PlayerArchetype = GetPlayerNonCombatArchetype(CharacterClass, bIsFemale);
    }
    else if (bInjuredPawn)
    {
        PlayerArchetype = GetPlayerInjuredArchetype(CharacterClass, bIsFemale);
    }
    else
    {
        PlayerArchetype = GetPlayerCombatArchetype(CharacterClass, bIsFemale);
    }
}
public function int GetRenegadePoints()
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return 0;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return 0;
    }
    return oVariables.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Renegade);
}
public function int GetReputationPoints()
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return 0;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return 0;
    }
    return oVariables.GetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_ReputationPoints);
}
public final function HandleBonusPowers(SFXPawn NewPawn, Name BonusTalent)
{
    local bool bHadBonusPower;
    local int idx;
    local array<SFXPowerCustomActionBase> Powers;
    local SFXPowerCustomActionBase Power;
    local float Rank;
    local float Rank1Cost;
    local int Refund;
    local bool bLastBonusHadRanks;
    
    if (BonusTalent != 'None')
    {
        Powers = NewPawn.PowerManager.Powers;
        for (idx = Powers.Length - 1; idx >= 0; idx--)
        {
            Power = Powers[idx];
            if (Power != None)
            {
                if (Power.IsBonusPower)
                {
                    bHadBonusPower = TRUE;
                    if (Power.Rank > Rank)
                    {
                        bLastBonusHadRanks = TRUE;
                        Rank = Power.Rank;
                        Refund = Class'SFXPowerManager'.static.GetRefundAmount(Power.Class, int(Power.Rank));
                        if (Power.RankCosts.Length > 0)
                        {
                            Rank1Cost = float(Power.RankCosts[0]);
                        }
                        else
                        {
                            Rank1Cost = 1.0;
                        }
                        Refund -= int(Rank1Cost);
                    }
                    NewPawn.PowerManager.RemovePower(Power.Class);
                }
            }
        }
        Power = NewPawn.PowerManager.AddPowerByClassName(BonusTalent);
        if (Power != None)
        {
            if (Refund > 0)
            {
                NewPawn.AddTalentPoints(Refund);
            }
            if (bHadBonusPower)
            {
                if (bLastBonusHadRanks)
                {
                    Power.Rank = 1.0;
                }
            }
            else
            {
                Power.Rank = 1.0;
            }
        }
    }
}
public function InitializeTeams()
{
    local int idx;
    
    for (idx = 0; idx < 4; idx++)
    {
        Teams[idx] = Spawn(Class'SFXTeamInfo', Self);
        Teams[idx].TeamIndex = idx;
        GameReplicationInfo.SetTeam(idx, Teams[idx]);
    }
}
private final function OnCombatEnd()
{
    local BioPlayerController PC;
    local array<SequenceObject> SeqObjs;
    local SequenceObject Sequence;
    local BioPawn Pawn;
    local SFXModule_GameEffectManager EffectManager;
    
    ProbeOnCombatEnd();
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        if (PC.IsLocalPlayerController())
        {
            PC.HintSystem.HintEvent('LeaveCombat');
        }
    }
    WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SFXSeqEvt_CombatEnded', TRUE, SeqObjs);
    foreach SeqObjs(Sequence, )
    {
        if (SFXSeqEvt_CombatEnded(Sequence) != None)
        {
            SFXSeqEvt_CombatEnded(Sequence).CheckActivate(Self, Self);
        }
    }
    foreach WorldInfo.AllPawns(Class'BioPawn', Pawn)
    {
        EffectManager = Pawn.GetModule(Class'SFXModule_GameEffectManager');
        if (EffectManager != None)
        {
            EffectManager.OnCombatEnd();
        }
    }
    SFXGRI(WorldInfo.GRI).ObjectPool.CleanUpPools(FALSE, FALSE);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().CleanUpPools();
    Class'WwiseAudioComponent'.static.StaticPostGlobalEventFromScript('COMBAT_END');
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Is_In_Combat", 0.0);
    WorldInfo.RescheduleGarbageCollectionTimer(2.0);
}
private final function OnCombatStart()
{
    local BioPlayerController PC;
    local array<SequenceObject> SeqObjs;
    local SequenceObject Sequence;
    local BioPawn PlayerPawn;
    local Pawn SquadPawn;
    local BioAiController SquadAI;
    
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        if (PC.Pawn == None)
        {
            SetTimer(0.25, FALSE, 'OnCombatStart', );
            return;
        }
    }
    ProbeOnCombatBegin();
    WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SFXSeqEvt_CombatStarted', TRUE, SeqObjs);
    foreach SeqObjs(Sequence, )
    {
        if (SFXSeqEvt_CombatStarted(Sequence) != None)
        {
            SFXSeqEvt_CombatStarted(Sequence).CheckActivate(Self, Self);
        }
    }
    foreach LocalPlayerControllers(Class'BioPlayerController', PC)
    {
        if (PC.Pawn != None)
        {
            if (!BioPawn(PC.Pawn).bCombatPawn)
            {
                continue;
            }
            PlayerPawn = BioPawn(PC.Pawn);
            if (PlayerPawn != None && PlayerPawn.Squad != None)
            {
                foreach PlayerPawn.Squad.SquadMembers(SquadAI)
                {
                    if (SFXAI_Henchman(SquadAI) != None)
                    {
                        SFXAI_Henchman(SquadAI).OnCombatStart();
                    }
                }
                foreach PlayerPawn.Squad.Members(SquadPawn, )
                {
                    if (SFXPawn_Henchman(SquadPawn) != None)
                    {
                        SFXPawn_Henchman(SquadPawn).InstancePrecacheVFX(SFXGRI(WorldInfo.GRI).ObjectPool, Class'RvrClientEffectManager'.static.GetClientEffectManager());
                    }
                    else if (SFXPawn_Player(SquadPawn) != None)
                    {
                        SFXPawn_Player(SquadPawn).InstancePrecacheVFX(SFXGRI(WorldInfo.GRI).ObjectPool, Class'RvrClientEffectManager'.static.GetClientEffectManager());
                    }
                }
            }
        }
    }
    Class'WwiseAudioComponent'.static.StaticPostGlobalEventFromScript('COMBAT_START');
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Is_In_Combat", 1.0);
    StartFirstUsePowerDelay();
    if (IsTimerActive('OnCombatEnd'))
    {
        ClearTimer('OnCombatEnd');
    }
}
public function OnGameCompleted(int nEndID)
{
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    local array<TelemetryAttribute> aTelAttribs;
    local string sTelAttVal;
    
    if (WorldInfo != None)
    {
        PC = WorldInfo.GetALocalPlayerController();
        if (PC != None)
        {
            pPawn = SFXPawn_Player(PC.Pawn);
        }
    }
    aTelAttribs.Add(6);
    sTelAttVal = "gend";
    aTelAttribs[0].Type = ETelemetryAttributeType.AttributeType_String;
    aTelAttribs[0].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[0].sData = pPawn.bIsFemale ? "F" : "M";
    sTelAttVal = "parg";
    aTelAttribs[1].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[1].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[1].nData = GetParagonPoints();
    sTelAttVal = "mpar";
    aTelAttribs[2].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[2].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[2].nData = pPawn.GetCharmSkill();
    sTelAttVal = "rene";
    aTelAttribs[3].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[3].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[3].nData = GetRenegadePoints();
    sTelAttVal = "mren";
    aTelAttribs[4].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[4].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[4].nData = pPawn.GetIntimidateSkill();
    sTelAttVal = "endi";
    aTelAttribs[5].Type = ETelemetryAttributeType.AttributeType_Int;
    aTelAttribs[5].Key = Class'SFXTelemetry'.static.FStringToFourCC(sTelAttVal);
    aTelAttribs[5].nData = nEndID;
    Class'SFXTelemetry'.static.SendArray('TelemetryHook_CompleteGame', aTelAttribs);
    Class'BioSFHandler_Options'.static.SendTelemetryDump('TelemetryHook_Option_GameCompletion');
}
public function OnPlayerSquadDeath()
{
    SignalEndGame();
}
public function OnTimeDilationChange(float NewTimeDilation)
{
    if (bDilateSound)
    {
        if (NewTimeDilation < float(1))
        {
            SFXGRI(GameReplicationInfo).PlayTransientSound(StartSlowEvent, vect(0.0, 0.0, 0.0));
        }
        else
        {
            SFXGRI(GameReplicationInfo).PlayTransientSound(StopSlowEvent, vect(0.0, 0.0, 0.0));
        }
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Time_Scale", NewTimeDilation);
    }
    SetGameSpeed(NewTimeDilation);
}
public function PostMakeLevelLive()
{
    local SFXModule_DamagePlayer DmgMod;
    
    DmgMod = SFXPawn_Player(GetALocalPlayerController().Pawn).GetModule(Class'SFXModule_DamagePlayer');
    if (DmgMod != None)
    {
        DmgMod.ApplySavedHealth();
    }
}
public function bool PreventPermanentDeath(BioPawn KilledPawn)
{
    local SFXModule_Gestures GesturesModule;
    local SFXPawn ChkPawn;
    
    if (SFXPawn_Henchman(KilledPawn) != None)
    {
        return TRUE;
    }
    else if (SFXPawn_Player(KilledPawn) != None)
    {
        return !CheckGameOver();
    }
    GesturesModule = KilledPawn.GetModule(Class'SFXModule_Gestures');
    if (KilledPawn.Physics == EPhysics.PHYS_Interpolating || GesturesModule != None && GesturesModule.m_bInMatinee)
    {
        return FALSE;
    }
    ChkPawn = SFXPawn(KilledPawn);
    if (ChkPawn != None && ChkPawn.bRecentlyDeceased && ChkPawn.bTearOff == FALSE && CurrentCannibalCount > 0 && ChkPawn.bCanBeEaten)
    {
        return TRUE;
    }
    return FALSE;
}
public static final function ReCalculate(out ScaledFloat F)
{
    local SFXGameEffect GE;
    local float DynamicBonus;
    
    DynamicBonus = 1.0;
    foreach F.Bonuses(GE, )
    {
        switch (GE.Class.default.BonusFormula)
        {
            case EBonusFormula.BonusFormula_Add:
                DynamicBonus += GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_Substract:
                DynamicBonus -= GE.EffectValue;
                break;
            case EBonusFormula.BonusFormula_LargestValue:
                if (GE.EffectValue > DynamicBonus)
                {
                    DynamicBonus = GE.EffectValue;
                }
                break;
            case EBonusFormula.BonusFormula_Custom:
                GE.ComputeCustomEffectValue(DynamicBonus);
                break;
            default:
        }
    }
    F.Value = Lerp(F.X, F.Y, float(F.Level) / float(F.MaxLevel)) * (F.StaticBonus + DynamicBonus - 1.0);
}
public function RegisterJoinInProgressDelegate(delegate<OnJoinInProgress> NewDelegate);

public function RequestTimeDilation(InterpCurveFloat Curve, float TotalTime, optional Name Identifier)
{
    local TimeDilationStruct Dilation;
    
    Dilation.Identifier = Identifier;
    Dilation.Curve = Curve;
    Dilation.TotalTime = TotalTime;
    Dilation.Time = 0.0;
    TimeDilationCurves.AddItem(Dilation);
}
public function RestartFromWave(int NewWave, optional string WaveType);

public function SetParagonPoints(int nPoints)
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return;
    }
    oVariables.SetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Paragon, nPoints);
}
public function SetRenegadePoints(int nPoints)
{
    local BioWorldInfo oWorldInfo;
    local BioGlobalVariableTable oVariables;
    
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None)
    {
        return;
    }
    oVariables = oWorldInfo.GetGlobalVariables();
    if (oVariables == None)
    {
        return;
    }
    oVariables.SetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Renegade, nPoints);
}
public function SignalEndGame(optional stringref GameOverString)
{
    local BioWorldInfo BWI;
    local BioPlayerController PC;
    
    BWI = BioWorldInfo(WorldInfo);
    PC = BWI.GetLocalPlayerController();
    Class'SFXGUIInteraction'.static.GetInstance().OnPlayerDeath(PC);
    WorldInfo.bPlayersOnly = FALSE;
    srGameOverString = GameOverString;
    if (BWI.m_fGameOverPauseTime == 0.0)
    {
        SpawnGameOverGUI();
    }
    else
    {
        SetTimer(BWI.m_fGameOverPauseTime, FALSE, 'SpawnGameOverGUI', );
    }
    foreach WorldInfo.AllControllers(Class'BioPlayerController', PC)
    {
        if (PC.GameModeManager2.IsActive(2))
        {
            PC.GameModeManager2.DisableMode(2);
        }
        PC.GameModeManager2.EnableMode(9);
    }
    BWI.PlayEndGameMusic();
    if (!WorldInfo.GRI.IsMultiplayerGame())
    {
        Class'SFXTelemetry'.static.SendVoid('TelemetryHook_Death');
    }
}
public function BioBaseSquad SpawnEnemySquad()
{
    return Spawn(Class'BioSquadCombat', WorldInfo, , , , , TRUE, FALSE);
}
public function SpawnGameOverGUI()
{
    local SFXGUIInteraction oGUI;
    local BioPlayerController pController;
    
    pController = BioWorldInfo(WorldInfo).GetLocalPlayerController();
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGUI != None)
    {
        oGUI.ShowGameOverGui(srGameOverString, pController);
        oGUI.CancelHint(pController);
    }
}
public final function Pawn SpawnNewPlayerPawn(bool bCombatPawn, bool bInjuredPawn, bool bUseCasualAppearance, int ForcedCasualID, bool bCreateAndShowWeapons, BioPlayerController PC, Vector SpawnLocation, Rotator SpawnRotation)
{
    local SFXEngine Engine;
    local string firstName;
    local EOriginType Origin;
    local ENotorietyType Notoriety;
    local SFXPawn_Player ResultPawn;
    local Pawn PlayerArchetype;
    local string faceCode;
    local Guid CharacterGUID;
    
    GetPlayerSpawnArchetype(bCombatPawn, bInjuredPawn, PlayerArchetype, firstName, Origin, Notoriety, faceCode, CharacterGUID);
    ResultPawn = SFXPawn_Player(Spawn(PlayerArchetype.Class, , 'Player', SpawnLocation, SpawnRotation, PlayerArchetype, TRUE));
    ResultPawn.firstName = firstName;
    ResultPawn.Origin = Origin;
    ResultPawn.Notoriety = Notoriety;
    ResultPawn.faceCode = faceCode;
    ResultPawn.CharacterGUID = CharacterGUID;
    PC.Possess(ResultPawn, FALSE);
    UpdatePlotVariables(ResultPawn);
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine != None)
    {
        Engine.LoadPlayer();
    }
    if (bUseCasualAppearance)
    {
        ResultPawn.bUseCasualAppearance = TRUE;
        if (ForcedCasualID != -1)
        {
            ResultPawn.OverrideCasualID = ForcedCasualID;
        }
    }
    ResultPawn.UpdateAppearance();
    if (bCombatPawn || bCreateAndShowWeapons)
    {
        ResultPawn.AddPlayerInventory();
        Engine.LoadPlayerWeapons();
    }
    return ResultPawn;
}
public final function StartFirstUsePowerDelay()
{
    local BioAiController AI;
    local BioPawn Pawn;
    
    if (WorldInfo != None)
    {
        foreach WorldInfo.AllControllers(Class'BioAiController', AI)
        {
            if (AI != None)
            {
                Pawn = BioPawn(AI.Pawn);
                if (Pawn != None && Pawn.PowerManager != None)
                {
                    Pawn.PowerManager.StartFirstTimeDelay();
                }
            }
        }
    }
}
public final function ToggleCombatOverride(bool bCombatOverride)
{
    local bool bWasInCombat;
    local bool bNowInCombat;
    local SFXGRI GRI;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI == None)
    {
        return;
    }
    bWasInCombat = GRI.InCombat();
    GRI.bForceCombat = bCombatOverride;
    bNowInCombat = GRI.InCombat();
    if (bNowInCombat && !bWasInCombat)
    {
        OnCombatStart();
    }
    else if (bWasInCombat && !bNowInCombat)
    {
        SetTimer(2.0, FALSE, 'OnCombatEnd', );
    }
}
public function UnRegisterJoinInProgressDelegate(delegate<OnJoinInProgress> DelegateToRemove);

public final function UpdatePlotStateRTPCs(BioGlobalVariableTable VarTable, SFXPawn_Player Player)
{
    local int CurrentMusicVal;
    local int CurrentParagonVal;
    local int CurrentRenegadeVal;
    local WwiseAudioComponent WorldAudioComponent;
    
    if (Player != None)
    {
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Player_Gender", float(Player.bIsFemale ? 2 : 1));
    }
    CurrentParagonVal = GetParagonPoints();
    CurrentRenegadeVal = GetRenegadePoints();
    Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Player_Para_Rene_State", float(CurrentParagonVal - CurrentRenegadeVal));
    if (VarTable != None)
    {
        CurrentMusicVal = VarTable.GetInt(GetCurrentMusicPlotStateIndex());
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript("Music_Current_Plot_State", float(CurrentMusicVal));
        WorldAudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(WorldInfo);
        if (WorldAudioComponent != None)
        {
            WorldAudioComponent.SetWwiseRTPC("Music_Current_Plot_State", float(CurrentMusicVal));
        }
    }
}
public final function UpdatePlotVariables(SFXPawn_Player Player)
{
    local BioGlobalVariableTable VarTable;
    
    VarTable = BioWorldInfo(WorldInfo).GetGlobalVariables();
    if (VarTable != None && Player != None)
    {
        VarTable.SetBool(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Female_Player, Player.bIsFemale);
        VarTable.SetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Character_Class, int(GetIDByClass(Player.Class)));
        VarTable.SetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Childhood, int(Player.Origin));
        VarTable.SetInt(Class'BioGlobalVariableTable'.default.ME3_Plots_Utility_Player_Info_Reputation, int(Player.Notoriety));
    }
    BioWorldInfo(WorldInfo).SetGlobalTlk(!Player.bIsFemale);
    UpdatePlotStateRTPCs(VarTable, Player);
}

auto state PendingMatch 
{
    
Begin:
    StartMatch();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TreasureClassName = "SFXGameContent.SFXTreasureDataLive"
    NewGamePlusPlayerVariables = ("SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleForce", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", 
                                  "SFXGameContent.SFXWeaponMod_AssaultRifleStability", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleDamage", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_ShotgunStability", 
                                  "SFXGameContent.SFXWeaponMod_PistolAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_PistolDamage", 
                                  "SFXGameContent.SFXWeaponMod_PistolMagSize", 
                                  "SFXGameContent.SFXWeaponMod_PistolReloadSpeed", 
                                  "SFXGameContent.SFXWeaponMod_PistolStability", 
                                  "SFXGameContent.SFXWeaponMod_SMGAccuracy", 
                                  "SFXGameContent.SFXWeaponMod_SMGConstraintDamage", 
                                  "SFXGameContent.SFXWeaponMod_SMGDamage", 
                                  "SFXGameContent.SFXWeaponMod_SMGMagSize", 
                                  "SFXGameContent.SFXWeaponMod_SMGStability", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Avenger", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Cobra", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Collector", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Falcon", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Geth", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Mattock", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Revenant", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Saber", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Vindicator", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Argus", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Reckoning", 
                                  "SFXGameContent.SFXWeapon_AssaultRifle_Valkyrie", 
                                  "SFXGameContent.SFXWeapon_Pistol_Carnifex", 
                                  "SFXGameContent.SFXWeapon_Pistol_Ivory", 
                                  "SFXGameContent.SFXWeapon_Pistol_Phalanx", 
                                  "SFXGameContent.SFXWeapon_Pistol_Predator", 
                                  "SFXGameContent.SFXWeapon_Pistol_Scorpion", 
                                  "SFXGameContent.SFXWeapon_Pistol_Talon", 
                                  "SFXGameContent.SFXWeapon_Pistol_Thor", 
                                  "SFXGameContent.SFXWeapon_Pistol_Eagle", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Claymore", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Disciple", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Eviscerator", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Geth", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Graal", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Katana", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Scimitar", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Striker", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Crusader", 
                                  "SFXGameContent.SFXWeapon_Shotgun_Raider", 
                                  "SFXGameContent.SFXWeapon_SMG_Hornet", 
                                  "SFXGameContent.SFXWeapon_SMG_Locust", 
                                  "SFXGameContent.SFXWeapon_SMG_Shuriken", 
                                  "SFXGameContent.SFXWeapon_SMG_Tempest", 
                                  "SFXGameContent.SFXWeapon_SMG_Hurricane", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_BlackWidow", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Incisor", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Javelin", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Mantis", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Raptor", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Viper", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Widow", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Indra", 
                                  "SFXGameContent.SFXWeapon_SniperRifle_Valiant"
                                 )
    MAdeptArchName = "BioChar_Player.Archetypes.Adept.MaleShepard_Adept"
    MEngineerArchName = "BioChar_Player.Archetypes.Engineer.MaleShepard_Engineer"
    MInfiltratorArchName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_Infiltrator"
    MSentinelArchName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_Sentinel"
    MSoldierArchName = "BioChar_Player.Archetypes.Soldier.MaleShepard_Soldier"
    MVanguardArchName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_Vanguard"
    MAdeptNCArchName = "BioChar_Player.Archetypes.Adept.MaleShepard_AdeptNonCombat"
    MEngineerNCArchName = "BioChar_Player.Archetypes.Engineer.MaleShepard_EngineerNonCombat"
    MInfiltratorNCArchName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_InfiltratorNonCombat"
    MSentinelNCArchName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_SentinelNonCombat"
    MSoldierNCArchName = "BioChar_Player.Archetypes.Soldier.MaleShepard_SoldierNonCombat"
    MVanguardNCArchName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_VanguardNonCombat"
    MAdeptInjuredArchName = "BioChar_Player.Archetypes.Adept.MaleShepard_AdeptInjured"
    MEngineerInjuredArchName = "BioChar_Player.Archetypes.Engineer.MaleShepard_EngineerInjured"
    MInfiltratorInjuredArchName = "BioChar_Player.Archetypes.Infiltrator.MaleShepard_InfiltratorInjured"
    MSentinelInjuredArchName = "BioChar_Player.Archetypes.Sentinel.MaleShepard_SentinelInjured"
    MSoldierInjuredArchName = "BioChar_Player.Archetypes.Soldier.MaleShepard_SoldierInjured"
    MVanguardInjuredArchName = "BioChar_Player.Archetypes.Vanguard.MaleShepard_VanguardInjured"
    MCharCreationArchName = "BioChar_Player.Archetypes.UIWorld.MaleShepard_CharCreation"
    FAdeptArchName = "BioChar_Player.Archetypes.Adept.FemaleShepard_Adept"
    FEngineerArchName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_Engineer"
    FInfiltratorArchName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_Infiltrator"
    FSentinelArchName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_Sentinel"
    FSoldierArchName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_Soldier"
    FVanguardArchName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_Vanguard"
    FAdeptNCArchName = "BioChar_Player.Archetypes.Adept.FemaleShepard_AdeptNonCombat"
    FEngineerNCArchName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_EngineerNonCombat"
    FInfiltratorNCArchName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_InfiltratorNonCombat"
    FSentinelNCArchName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_SentinelNonCombat"
    FSoldierNCArchName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_SoldierNonCombat"
    FVanguardNCArchName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_VanguardNonCombat"
    FAdeptInjuredArchName = "BioChar_Player.Archetypes.Adept.FemaleShepard_AdeptInjured"
    FEngineerInjuredArchName = "BioChar_Player.Archetypes.Engineer.FemaleShepard_EngineerInjured"
    FInfiltratorInjuredArchName = "BioChar_Player.Archetypes.Infiltrator.FemaleShepard_InfiltratorInjured"
    FSentinelInjuredArchName = "BioChar_Player.Archetypes.Sentinel.FemaleShepard_SentinelInjured"
    FSoldierInjuredArchName = "BioChar_Player.Archetypes.Soldier.FemaleShepard_SoldierInjured"
    FVanguardInjuredArchName = "BioChar_Player.Archetypes.Vanguard.FemaleShepard_VanguardInjured"
    FCharCreationArchName = "BioChar_Player.Archetypes.UIWorld.FemaleShepard_CharCreation"
    ReputationThresholds = ({PlotStateID = 10640, Threshold = 210}, 
                            {PlotStateID = 10641, Threshold = 420}, 
                            {PlotStateID = 10642, Threshold = 630}, 
                            {PlotStateID = 10643, Threshold = 840}, 
                            {PlotStateID = 10644, Threshold = 1050}
                           )
    fAutoUnlitDownsizeThreshold = 1.5
    TimeDilationOverride = 1.0
    AdjacentDecayMult = 0.5
    DecayRecoveryPerSecond = 200
    MaxSmokeCount = 2.0
    bEnableLowDetailProxySilhouettes = TRUE
    bDilateSound = TRUE
    DefaultPawnClass = Class'BioPawn'
    HUDType = Class'BioHUD'
    PlayerControllerClass = Class'SFXPlayerController'
    PlayerReplicationInfoClass = Class'SFXPRI'
    GameReplicationInfoClass = Class'SFXGRI'
    MaxPlayersAllowed = 1
    bRestartLevel = FALSE
}
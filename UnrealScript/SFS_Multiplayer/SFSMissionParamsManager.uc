Class SFSMissionParamsManager extends SFSManager within SFXPawn;

struct SavedOperationWave 
{
    var int WaveNumber;
    var float CreditScale;
};

var SFSMissionSettingsService SettingsService;
var SFXWaveCoordinator_HordeOperation WaveCoordinator;
var array<SavedOperationWave> SavedOperationWaves;
var int LastKnownWaveNumber;
var bool bBypassActive;
var int PendingMaxEnemies;
var int PendingMaxEnemiesPerSpawnPoint;
var int PendingStartWave;
var array<string> PendingEnabledEnemyArchetypes;
var array<int> PendingEnabledEnemyRatios;
var bool PendingCrossFactionEnemies;

public event simulated function ApplyMissionSettings()
{
    SettingsService = Outer.GetModule(Class'SFSMissionSettingsService');
    if (SettingsService != None && !Class'Engine'.static.GetCurrentWorldInfo().bIsLobbyLevel)
    {
        SettingsService.RetrieveSettings(OnSettingsRetrieved);
    }
    else
    {
        log(Self.Name, "SFSMissionSettingsService not found ? mission params inactive", Outer);
    }
}
function OnSettingsRetrieved(SFSMissionSettingsStruct Settings, bool bSuccess)
{
    if (!bSuccess)
    {
        log(Self.Name, "Failed to retrieve mission settings ? using defaults", Outer);
        return;
    }
    log(Self.Name, "Mission settings received. DisableObjectiveWaves=" $ Settings.bDisableObjectiveWaves, Outer);
    if (Settings.bDisableObjectiveWaves)
    {
        ApplyObjectiveWaveBypass();
    }
    if (Settings.MaxEnemies > 0 || Settings.MaxEnemiesPerSpawnPoint > 0 || Settings.StartWave > 1 || Settings.EnabledEnemyArchetypes.Length > 0)
    {
        PendingMaxEnemies = Settings.MaxEnemies;
        PendingMaxEnemiesPerSpawnPoint = Settings.MaxEnemiesPerSpawnPoint;
        PendingStartWave = Settings.StartWave;
        PendingEnabledEnemyArchetypes = Settings.EnabledEnemyArchetypes;
        PendingEnabledEnemyRatios = Settings.EnabledEnemyRatios;
        PendingCrossFactionEnemies = Settings.bCrossFactionEnemies;
        ApplyHordeWaveSettings();
    }
    // Add handlers for future flags here.
}
function ApplyHordeWaveSettings()
{
    local BioWorldInfo World;
    local array<Actor> Coordinators;
    local Actor CoordActor;
    local SFXWaveCoordinator_HordeOperation Coord;
    local int WaveIdx;
    local int ArchIdx;
    local int ListIdx;
    local int DiffIdx;
    local int EnemyIdx;
    local int SquadIdx;
    local int TypeIdx;
    local SFXWave_Horde HordeWave;
    local bool bIsEnabled;
    local bool bFound;
    local EnemyWaveInfo InjectedEnemy;
    local int RatioVal;
    local int CopyIdx;
    
    if (WaveCoordinator == None)
    {
        World = Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo();
        World.FindActorsOfClass(Class'SFXWaveCoordinator_HordeOperation', Coordinators);
        foreach Coordinators(CoordActor, )
        {
            Coord = SFXWaveCoordinator_HordeOperation(CoordActor);
            if (Coord != None)
            {
                WaveCoordinator = Coord;
                break;
            }
        }
    }
    if (WaveCoordinator == None)
    {
        log(Self.Name, "WaveCoordinator not found yet - retrying in 1s", Outer);
        Outer.SetTimer(1.0, FALSE, 'ApplyHordeWaveSettings', Self);
        return;
    }
    if (WaveCoordinator.HordeManager == None || WaveCoordinator.HordeManager.PotentialWaves.Length == 0)
    {
        log(Self.Name, "HordeManager not ready yet - retrying in 1s", Outer);
        Outer.SetTimer(1.0, FALSE, 'ApplyHordeWaveSettings', Self);
        return;
    }
    for (WaveIdx = 0; WaveIdx < WaveCoordinator.HordeManager.PotentialWaves.Length; WaveIdx++)
    {
        HordeWave = SFXWave_Horde(WaveCoordinator.HordeManager.PotentialWaves[WaveIdx]);
        if (HordeWave == None)
        {
            continue;
        }
        // --- Spawn limits ---
        if (PendingMaxEnemies > 0)
        {
            HordeWave.MaxEnemies = PendingMaxEnemies;
        }
        if (PendingMaxEnemiesPerSpawnPoint > 0)
        {
            HordeWave.MaxEnemiesPerSpawnPoint = PendingMaxEnemiesPerSpawnPoint;
        }
        // --- Enemy filter (enabled whitelist) ---
        // If non-empty, only the listed types may spawn; everything else is removed.
        // Enabled types not already in a wave's difficulty array are injected.
        // When cross-faction is disabled, skip waves whose pool shares no overlap
        // with the enabled list (i.e. off-faction waves are left untouched).
        if (PendingEnabledEnemyArchetypes.Length > 0)
        {
            if (!PendingCrossFactionEnemies)
            {
                bIsEnabled = FALSE;
                for (ListIdx = 0; ListIdx < HordeWave.EnemyList.Length; ListIdx++)
                {
                    for (ArchIdx = 0; ArchIdx < PendingEnabledEnemyArchetypes.Length; ArchIdx++)
                    {
                        if (GetLastDotSegment(HordeWave.EnemyList[ListIdx].EnemyArchetypeName) == GetLastDotSegment(PendingEnabledEnemyArchetypes[ArchIdx]))
                        {
                            bIsEnabled = TRUE;
                            break;
                        }
                    }
                    if (bIsEnabled)
                    {
                        break;
                    }
                }
                if (!bIsEnabled)
                {
                    // No enabled enemy belongs to this wave's faction pool - skip it.
                    log(Self.Name, "Skipping off-faction wave " $ WaveIdx $ " (cross-faction disabled)", Outer);
                    continue;
                }
            }
            for (ListIdx = 0; ListIdx < HordeWave.EnemyList.Length; ListIdx++)
            {
                bIsEnabled = FALSE;
                for (ArchIdx = 0; ArchIdx < PendingEnabledEnemyArchetypes.Length; ArchIdx++)
                {
                    if (GetLastDotSegment(HordeWave.EnemyList[ListIdx].EnemyArchetypeName) == GetLastDotSegment(PendingEnabledEnemyArchetypes[ArchIdx]))
                    {
                        bIsEnabled = TRUE;
                        break;
                    }
                }
                if (!bIsEnabled)
                {
                    // Not in the enabled list - remove from all difficulty arrays.
                    for (DiffIdx = 0; DiffIdx < HordeWave.Enemies.Length; DiffIdx++)
                    {
                        for (EnemyIdx = HordeWave.Enemies[DiffIdx].Enemies.Length - 1; EnemyIdx >= 0; EnemyIdx--)
                        {
                            if (HordeWave.Enemies[DiffIdx].Enemies[EnemyIdx].EnemyType == HordeWave.EnemyList[ListIdx].EnemyType)
                            {
                                HordeWave.Enemies[DiffIdx].Enemies.Remove(EnemyIdx, 1);
                            }
                        }
                    }
                    // Remove from squad type lists; disable fully-empty squads.
                    for (SquadIdx = 0; SquadIdx < HordeWave.EnemySquadList.Length; SquadIdx++)
                    {
                        for (TypeIdx = HordeWave.EnemySquadList[SquadIdx].EnemyTypes.Length - 1; TypeIdx >= 0; TypeIdx--)
                        {
                            if (HordeWave.EnemySquadList[SquadIdx].EnemyTypes[TypeIdx] == HordeWave.EnemyList[ListIdx].EnemyType)
                            {
                                HordeWave.EnemySquadList[SquadIdx].EnemyTypes.Remove(TypeIdx, 1);
                            }
                        }
                        if (HordeWave.EnemySquadList[SquadIdx].EnemyTypes.Length == 0)
                        {
                            HordeWave.EnemySquadList[SquadIdx].WaveCost = 999999;
                        }
                    }
                    log(Self.Name, "Removed type=" $ HordeWave.EnemyList[ListIdx].EnemyType $ " (not enabled) from wave " $ WaveIdx, Outer);
                    continue;
                }
                // Enabled: purge ALL existing copies then re-add RatioVal copies
                // so the selection weight reflects the configured ratio.
                RatioVal = PendingEnabledEnemyRatios[ArchIdx];
                if (RatioVal < 1)
                {
                    RatioVal = 1;
                }
                for (DiffIdx = 0; DiffIdx < HordeWave.Enemies.Length; DiffIdx++)
                {
                    // Remove all existing copies.
                    for (EnemyIdx = HordeWave.Enemies[DiffIdx].Enemies.Length - 1; EnemyIdx >= 0; EnemyIdx--)
                    {
                        if (HordeWave.Enemies[DiffIdx].Enemies[EnemyIdx].EnemyType == HordeWave.EnemyList[ListIdx].EnemyType)
                        {
                            HordeWave.Enemies[DiffIdx].Enemies.Remove(EnemyIdx, 1);
                        }
                    }
                    // Add RatioVal copies.
                    InjectedEnemy.EnemyType = HordeWave.EnemyList[ListIdx].EnemyType;
                    InjectedEnemy.MinCount = 0;
                    InjectedEnemy.MaxCount = 0;
                    InjectedEnemy.MaxPerWave = 0;
                    for (CopyIdx = 0; CopyIdx < RatioVal; CopyIdx++)
                    {
                        HordeWave.Enemies[DiffIdx].Enemies.AddItem(InjectedEnemy);
                    }
                }
                log(Self.Name, "Set type=" $ HordeWave.EnemyList[ListIdx].EnemyType $ " ratio=" $ RatioVal $ " in wave " $ WaveIdx, Outer);
            }
        }
    }
    // --- Start wave ---
    // StartWave is 1-based (UI); GoToWave expects 0-based. Only act when > 1.
    if (PendingStartWave > 1)
    {
        WaveCoordinator.GoToWave(PendingStartWave - 1);
        log(Self.Name, "GoToWave(" $ PendingStartWave - 1 $ ") called for StartWave=" $ PendingStartWave, Outer);
    }
    log(Self.Name, "Horde wave settings applied.", Outer);
}
private final function string GetLastDotSegment(string S)
{
    local int DotPos;
    
    DotPos = InStr(S, ".", TRUE, , );
    if (DotPos >= 0)
    {
        return Mid(S, DotPos + 1, );
    }
    return S;
}
function ApplyObjectiveWaveBypass()
{
    local BioWorldInfo World;
    local array<Actor> Coordinators;
    local Actor CoordActor;
    local SFXWaveCoordinator_HordeOperation Coord;
    local int i;
    local SavedOperationWave SavedWave;
    
    World = Class'SFXEngine'.static.GetSFXEngine().GetRealWorldInfo();
    World.FindActorsOfClass(Class'SFXWaveCoordinator_HordeOperation', Coordinators);
    foreach Coordinators(CoordActor, )
    {
        Coord = SFXWaveCoordinator_HordeOperation(CoordActor);
        if (Coord != None)
        {
            WaveCoordinator = Coord;
            break;
        }
    }
    if (WaveCoordinator == None)
    {
        log(Self.Name, "WaveCoordinator not found yet ? retrying in 1s", Outer);
        Outer.SetTimer(1.0, FALSE, 'ApplyObjectiveWaveBypass', Self);
        return;
    }
    if (WaveCoordinator.OperationManager == None)
    {
        log(Self.Name, "OperationManager not ready yet ? retrying in 1s", Outer);
        Outer.SetTimer(1.0, FALSE, 'ApplyObjectiveWaveBypass', Self);
        return;
    }
    // Snapshot the credit schedule for all non-extraction entries.
    // The LAST entry is the extraction wave ? we leave it untouched so the
    // end-of-match extraction still fires normally.
    for (i = 0; i < WaveCoordinator.OperationWaves.Length - 1; i++)
    {
        SavedWave.WaveNumber = WaveCoordinator.OperationWaves[i].WaveNumber;
        SavedWave.CreditScale = WaveCoordinator.OperationWaves[i].CreditScale;
        SavedOperationWaves.AddItem(SavedWave);
        log(Self.Name, "Saved op-wave entry: wave=" $ SavedWave.WaveNumber $ " creditScale=" $ SavedWave.CreditScale, Outer);
    }
    log(Self.Name, "Preserving extraction entry (last OperationWave, wave=" $ WaveCoordinator.OperationWaves[WaveCoordinator.OperationWaves.Length - 1].WaveNumber $ ")", Outer);
    // Remove all objective wave entries while keeping the last (extraction).
    // Remove(startIndex, count) ? drop everything before the final entry.
    WaveCoordinator.OperationWaves.Remove(0, WaveCoordinator.OperationWaves.Length - 1);
    // Begin polling so we can grant credit compensation when a wave that
    // *would have been* an operation wave completes.
    bBypassActive = TRUE;
    LastKnownWaveNumber = WaveCoordinator.CurrentWaveNumber;
    Outer.SetTimer(0.5, TRUE, 'PollWaveNumber', Self);
    log(Self.Name, "Objective-wave bypass active. Monitoring wave progression.", Outer);
}
function PollWaveNumber()
{
    local int CurrentWave;
    
    if (WaveCoordinator == None || !bBypassActive)
    {
        Outer.ClearTimer('PollWaveNumber', Self);
        return;
    }
    CurrentWave = WaveCoordinator.CurrentWaveNumber;
    if (CurrentWave != LastKnownWaveNumber)
    {
        // The coordinator advanced ? the wave that just finished is LastKnownWaveNumber.
        OnWaveCompleted(LastKnownWaveNumber);
        LastKnownWaveNumber = CurrentWave;
    }
}
function OnWaveCompleted(int CompletedWaveNumber)
{
    local int i;
    local float BaseReward;
    local SFXScoreManager ScoreManager;
    local SFXPlayerController PC;
    
    // Check whether this wave number was scheduled as an operation wave.
    for (i = 0; i < SavedOperationWaves.Length; i++)
    {
        if (SavedOperationWaves[i].WaveNumber == CompletedWaveNumber && SavedOperationWaves[i].CreditScale > 0.0)
        {
            break;
        }
        if (i == SavedOperationWaves.Length - 1)
        {
            return;
        }
    }
    // Replicate SFXWave_Operation.GetCreditsReward() ? DistributeObjectiveScore().
    BaseReward = SFXGRI(Outer.WorldInfo.GRI).DifficultyHandler.GetMinFloat('ObjectiveCreditsReward', 'MPGlobal');
    BaseReward *= SavedOperationWaves[i].CreditScale;
    // Round down to the nearest 25 (vanilla behaviour).
    BaseReward = float(int(BaseReward) - int(BaseReward) % 25);
    log(Self.Name, "Granting bypass credits for op-wave " $ CompletedWaveNumber $ ": " $ BaseReward $ " credits", Outer);
    foreach Outer.WorldInfo.AllControllers(Class'SFXPlayerController', PC)
    {
        if (PC.PlayerReplicationInfo != None)
        {
            SFXPRI(PC.PlayerReplicationInfo).AddCredits(BaseReward);
        }
    }
    foreach Outer.WorldInfo.AllControllers(Class'SFXPlayerController', PC)
    {
        if (PC.IsLocalPlayerController())
        {
            PC.HintSystem.AddNotification_CreditRecovery(int(BaseReward));
            ScoreManager = SFXGRI(Outer.WorldInfo.GRI).GetScoreManager();
            if (ScoreManager != None)
            {
                ScoreManager.LastCreditsEarned = int(BaseReward);
                ScoreManager.ShowCreditsEarnedMessage();
            }
            break;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
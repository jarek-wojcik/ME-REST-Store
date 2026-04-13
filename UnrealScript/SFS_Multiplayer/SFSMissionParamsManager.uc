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

public event simulated function HandlePostAdd()
{
    SettingsService = Outer.GetModule(Class'SFSMissionSettingsService');
    if (SettingsService != None)
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
    // Add handlers for future flags here, e.g.:
    //   if (Settings.bDisableHazards) { ApplyHazardBypass(); }
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
    local BioCheatManagerNonNative CheatManager;
    
    // Check whether this wave number was scheduled as an operation wave.
    for (i = 0; i < SavedOperationWaves.Length; i++)
    {
        if (SavedOperationWaves[i].WaveNumber == CompletedWaveNumber && SavedOperationWaves[i].CreditScale > 0.0)
        {
            break;
        }
        // Not the droids we're looking for ? keep searching / fall through.
        if (i == SavedOperationWaves.Length - 1)
        {
            return;
            // No matching op-wave credit entry.
        }
    }
    // Replicate SFXWave_Operation.GetCreditsReward() ? DistributeObjectiveScore().
    BaseReward = SFXGRI(Outer.WorldInfo.GRI).DifficultyHandler.GetMinFloat('ObjectiveCreditsReward', 'MPGlobal');
    BaseReward *= SavedOperationWaves[i].CreditScale;
    // Round down to the nearest 25 (vanilla behaviour).
    BaseReward = float(int(BaseReward) - int(BaseReward) % 25);
    log(Self.Name, "Granting bypass credits for op-wave " $ CompletedWaveNumber $ ": " $ BaseReward $ " credits", Outer);
    // Grant credits via the local player's cheat manager ? same path as GrantMPCredits.
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
            CheatManager = BioCheatManagerNonNative(PC.CheatManager);
            if (CheatManager != None)
            {
                //CheatManager.GrantMPCredits(int(BaseReward));
            }
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
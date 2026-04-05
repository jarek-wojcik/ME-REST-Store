Class SFXWaveCoordinator extends Actor
    abstract
    transient
    config(Game);

struct WaveEventInfo 
{
    var Class<SFXWave> HordeWaveType;
    var int Trigger;
    var int WaveNumber;
    var int HordeWaveIndex;
    var int OperationWaveIndex;
    var int SupplyDropWaveIndex;
    var bool WavesAreLoading;
    var EWaveCoordinator_HordeOpEvent WaveEvent;
};
enum EWaveCoordinator_HordeOpEvent
{
    EW_StartWaves,
    EW_BeginWave,
    EW_BeginSupplyWave,
    EW_FinishWave,
    EW_JoinInProgress,
};

var protectedwrite array<SFXWave> ActiveWaves;
var config float PostLoadDelay;
var privatewrite bool WavesAreLoading;

public simulated function PawnDied(BioPawn Pawn, optional BioPawn Killer = None)
{
    local SFXWave WaveIter;
    
    foreach ActiveWaves(WaveIter, )
    {
        WaveIter.PawnDied(Pawn, Killer);
    }
}
protected simulated function BeginWaveLoading()
{
    local SFXWave WaveIter;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        foreach ActiveWaves(WaveIter, )
        {
            WaveIter.BeginLoading();
        }
        WavesAreLoading = TRUE;
    }
    SetTimer(0.200000003, TRUE, 'UpdateWaveLoading', );
    UpdateWaveLoading();
}
public function EndWaves()
{
    FinishActiveWaves();
}
public simulated function FinishActiveWaves()
{
    local int Index;
    local array<SFXWave> ActiveWavesCopy;
    
    ActiveWavesCopy = ActiveWaves;
    for (Index = 0; Index < ActiveWavesCopy.Length; Index++)
    {
        ActiveWavesCopy[Index].FinishWave();
    }
}
public simulated function float GetEnemyScoreBudget();

public simulated function int GetFriendlyCurrentWaveNumber();

public simulated function float GetObjectiveCreditBudget();

public simulated function float GetObjectiveScoreBudget();

public simulated function float GetPercentOfWavesCompleted()
{
    return 0.0;
}
public simulated function SFXWave GetWaveOfType(Name WaveClassName)
{
    local SFXWave WaveIter;
    
    foreach ActiveWaves(WaveIter, )
    {
        if (WaveIter.IsA(WaveClassName))
        {
            return WaveIter;
        }
    }
    return None;
}
public function HandleHostMigration();

protected simulated function OnAllWavesFinished()
{
    local int Index;
    local BioWorldInfo oWorldInfo;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
        {
            if (!WorldInfo.GRI.PRIArray[Index].bBot)
            {
                SFXPRI(WorldInfo.GRI.PRIArray[Index]).ReplicateScoreInfo();
                SFXPRI(WorldInfo.GRI.PRIArray[Index]).bForceNetUpdate = TRUE;
            }
        }
    }
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo != None)
    {
        if (oWorldInfo.GRI != None)
        {
            if (SFXGRI(oWorldInfo.GRI).ObjectPool != None)
            {
                SFXGRI(oWorldInfo.GRI).ObjectPool.CleanUpPools(FALSE);
                Class'RvrClientEffectManager'.static.GetClientEffectManager().CleanUpPools();
                oWorldInfo.RescheduleGarbageCollectionTimer(2.0);
            }
        }
    }
}
protected function OnAllWavesFinishedLoading()
{
    WavesAreLoading = FALSE;
}
public simulated function OnWaveFinished(SFXWave Wave)
{
    local int Index;
    
    Index = ActiveWaves.Find(Wave);
    if (Index == -1)
    {
        return;
    }
    ClearAllTimers(Wave);
    ActiveWaves.Remove(Index, 1);
    if (ActiveWaves.Length == 0)
    {
        OnAllWavesFinished();
    }
}
public simulated function PawnDowned(BioPawn Pawn)
{
    local SFXWave WaveIter;
    
    foreach ActiveWaves(WaveIter, )
    {
        WaveIter.PawnDowned(Pawn);
    }
}
public simulated function PawnRevived(BioPawn Pawn)
{
    local SFXWave WaveIter;
    
    foreach ActiveWaves(WaveIter, )
    {
        WaveIter.PawnRevived(Pawn);
    }
}
public simulated function PawnSpawned(BioPawn Pawn)
{
    local SFXWave WaveIter;
    
    foreach ActiveWaves(WaveIter, )
    {
        WaveIter.PawnSpawned(Pawn);
    }
}
protected simulated function StartNewWave();

public simulated function StartWaves();

public simulated function SyncClientMatchTimer(float OperationTime);

public simulated function UpdateWaveLoading()
{
    local SFXWave WaveIter;
    local bool AllWavesFinishedLoading;
    
    AllWavesFinishedLoading = TRUE;
    foreach ActiveWaves(WaveIter, )
    {
        WaveIter.UpdateLoading();
        if (!WaveIter.IsFinishedLoading())
        {
            AllWavesFinishedLoading = FALSE;
        }
    }
    if (AllWavesFinishedLoading)
    {
        SetTimer(PostLoadDelay, FALSE, 'OnAllWavesFinishedLoading', );
        ClearTimer('UpdateWaveLoading');
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PostLoadDelay = 1.0
    NetPriority = 3.0
    bAlwaysRelevant = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}
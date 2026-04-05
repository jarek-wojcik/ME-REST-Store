Class SFXWave;

struct SFXWaveAssetLoadData 
{
    var string AssetToLoad;
    var Object LoadedAsset;
    var EAsyncLoadStatus AssetLoadStatus;
};

var transient array<SFXWaveAssetLoadData> AssetLoadData;
var protectedwrite transient BioWorldInfo BioWorldInfo;
var transient SFXPlayerController LocalPlayerController;
var protectedwrite transient SFXWaveManager WaveManager;
var protectedwrite transient SFXWaveCoordinator WaveCoordinator;
var privatewrite transient bool IsLoading;
var privatewrite transient bool IsActive;

public function PawnDied(BioPawn Pawn, optional BioPawn Killer = None);

private final function EAsyncLoadStatus AggregateAssetLoadStatus()
{
    local EAsyncLoadStatus ToReturn;
    local SFXWaveAssetLoadData AssetLoadDataIter;
    
    ToReturn = EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
    foreach AssetLoadData(AssetLoadDataIter, )
    {
        if (int(AssetLoadDataIter.AssetLoadStatus) < int(ToReturn))
        {
            ToReturn = AssetLoadDataIter.AssetLoadStatus;
        }
        if (ToReturn == EAsyncLoadStatus.ASYNC_LOAD_ERROR)
        {
            break;
        }
    }
    return ToReturn;
}
public final function BeginLoading()
{
    local SFXWaveAssetLoadData AssetLoadDataIter;
    local int AssetIndex;
    
    IsLoading = TRUE;
    foreach AssetLoadData(AssetLoadDataIter, AssetIndex)
    {
        AssetLoadDataIter.LoadedAsset = Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AssetLoadDataIter.AssetToLoad, Class'Object', AssetLoadDataIter.AssetLoadStatus);
        AssetLoadData[AssetIndex] = AssetLoadDataIter;
    }
}
public function bool BeginWave()
{
    if (!IsFinishedLoading())
    {
        WaveCoordinator.SetTimer(0.100000001, FALSE, 'BeginWave', Self);
        return FALSE;
    }
    IsActive = TRUE;
    return TRUE;
}
public function FinishWave()
{
    local SFXWaveAssetLoadData AssetLoadDataIter;
    local int idx;
    
    foreach AssetLoadData(AssetLoadDataIter, idx)
    {
        AssetLoadDataIter.LoadedAsset = None;
        AssetLoadDataIter.AssetLoadStatus = EAsyncLoadStatus.ASYNC_LOAD_ERROR;
        Class'SFXEngine'.static.ReleaseSeekFreeObject(AssetLoadDataIter.AssetToLoad);
        AssetLoadData[idx] = AssetLoadDataIter;
    }
    IsActive = FALSE;
    IsLoading = FALSE;
    WaveCoordinator.OnWaveFinished(Self);
}
public function InitializeWave(SFXWaveManager NewWaveManager)
{
    BioWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    LocalPlayerController = SFXPlayerController(BioWorldInfo.GetLocalPlayerController());
    WaveManager = NewWaveManager;
}
public final function bool IsFinishedLoading()
{
    return int(AggregateAssetLoadStatus()) == 3;
}
public simulated function PawnDowned(BioPawn Pawn);

public function PawnRevived(BioPawn Pawn);

public function PawnSpawned(BioPawn Pawn);

public function SetWaveCoordinator(SFXWaveCoordinator OwnerCoordinator)
{
    WaveCoordinator = OwnerCoordinator;
}
public final function UpdateLoading()
{
    local SFXWaveAssetLoadData AssetLoadDataIter;
    local int AssetIndex;
    
    foreach AssetLoadData(AssetLoadDataIter, AssetIndex)
    {
        if (AssetLoadDataIter.LoadedAsset != None)
        {
            continue;
        }
        AssetLoadDataIter.LoadedAsset = Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AssetLoadDataIter.AssetToLoad, Class'Object', AssetLoadDataIter.AssetLoadStatus);
        AssetLoadData[AssetIndex] = AssetLoadDataIter;
    }
    if (IsFinishedLoading())
    {
        IsLoading = FALSE;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
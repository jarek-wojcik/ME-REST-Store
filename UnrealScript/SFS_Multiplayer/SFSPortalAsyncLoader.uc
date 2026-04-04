Class SFSPortalAsyncLoader extends SFSManager within SFXPawn;

var array<SFSGenericAsyncLoad> AsyncLoads;
var float CheckDelay;
var int maxRetries;
var bool bDebugLogging;

public event simulated function HandlePostAdd()
{
    log(Self.Name, "Added SFSPortalAsyncLoader to " $ Outer, Outer);
}
public function HandleEvent(SFSEvent E)
{
}
public function LoadAsync(string AssetPath, EAsyncLoadType LoadType, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, LoadType, Callback);
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
private final function SFSGenericAsyncLoad CreateAsyncLoad(string AssetPath, EAsyncLoadType LoadType, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = new (Self) Class'SFSGenericAsyncLoad';
    AsyncLoad.AssetToLoad = AssetPath;
    AsyncLoad.LoadType = LoadType;
    AsyncLoad.OnAssetLoaded = Callback;
    AsyncLoad.retries = 0;
    AsyncLoad.isLoaded = FALSE;
    return AsyncLoad;
}
private final function StartCheckTimer()
{
    if (!Outer.IsTimerActive('CheckAsyncLoads', Self))
    {
        Outer.SetTimer(CheckDelay, TRUE, 'CheckAsyncLoads', Self);
    }
}
public function CheckAsyncLoads()
{
    local SFSGenericAsyncLoad AsyncLoad;
    local int i;
    
    if (AsyncLoads.Length == 0)
    {
        Outer.ClearTimer('CheckAsyncLoads', Self);
        return;
    }
    for (i = AsyncLoads.Length - 1; i >= 0; i--)
    {
        AsyncLoad = AsyncLoads[i];
        PollLoadStatus(AsyncLoad);
        if (AsyncLoad.isLoaded)
        {
            log(Self.Name, "Asset loaded: " $ AsyncLoad.AssetToLoad, Outer);
            AsyncLoad.OnAssetLoaded(AsyncLoad, Outer);
            AsyncLoads.Remove(i, 1);
            continue;
        }
        AsyncLoad.retries = AsyncLoad.retries + 1;
        if (AsyncLoad.retries >= maxRetries)
        {
            log(Self.Name, "Max retries reached for: " $ AsyncLoad.AssetToLoad, Outer);
            AsyncLoads.Remove(i, 1);
            continue;
        }
        AsyncLoads[i] = AsyncLoad;
    }
}
private final function PollLoadStatus(out SFSGenericAsyncLoad AsyncLoad)
{
    switch (AsyncLoad.LoadType)
    {
        case EAsyncLoadType.ALT_PlayerMP:
            AsyncLoad.LoadedPlayerMP = SFXPawn_PlayerMP(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXPawn_PlayerMP', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Pawn:
            AsyncLoad.LoadedPawn = SFXPawn(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXPawn', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Henchman:
            AsyncLoad.LoadedHenchman = SFXPawn_Henchman(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXPawn_Henchman', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Weapon:
            AsyncLoad.LoadedWeapon = SFXWeapon(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXWeapon', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Power:
            AsyncLoad.LoadedPower = SFXPowerCustomAction(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXPowerCustomAction', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_WeaponMod:
            AsyncLoad.LoadedWeaponMod = SFXWeaponMod(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXWeaponMod', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Consumable:
            AsyncLoad.LoadedConsumable = SFXGameEffect_MatchConsumableBase(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'SFXGameEffect_MatchConsumableBase', AsyncLoad.LoadStatus));
            break;
        default:
    }
    AsyncLoad.isLoaded = AsyncLoad.LoadStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CheckDelay = 1.0
    maxRetries = 10
    bDebugLogging = FALSE
}
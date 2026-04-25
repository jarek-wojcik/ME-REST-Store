Class SFSPortalAsyncLoader extends SFSManager within SFXPawn;

var array<SFSGenericAsyncLoad> AsyncLoads;
var float CheckDelay;
var int maxRetries;

public function LoadAsync(string AssetPath, EAsyncLoadType LoadType, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, LoadType, Callback);
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
public function LoadAppearanceAsync(string AssetPath, bool bUsesHelmet, bool bUsesHeadgear, EAsyncLoadType LoadType, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, LoadType, Callback);
    AsyncLoad.bUsesHelmet = bUsesHelmet;
    AsyncLoad.bUsesHeadgear = bUsesHeadgear;
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
public function LoadWeaponAsync(string AssetPath, string Mod1ID, string Mod2ID, string WeaponFireMode, bool bRemoveScope, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, 3, Callback);
    AsyncLoad.Mod1ID = Mod1ID;
    AsyncLoad.Mod2ID = Mod2ID;
    AsyncLoad.WeaponFireMode = WeaponFireMode;
    AsyncLoad.bRemoveScope = bRemoveScope;
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
public function LoadModAsync(string AssetPath, SFXWeapon targetWeapon, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, 4, Callback);
    AsyncLoad.targetWeapon = targetWeapon;
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
public function LoadPowerClassAsync(string AssetPath, SFSPowerModelStruct PowerModel, int SlotIndex, bool bIsBorrowedPower, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = CreateAsyncLoad(AssetPath, 6, Callback);
    AsyncLoad.PowerModel = PowerModel;
    AsyncLoad.SlotIndex = SlotIndex;
    AsyncLoad.bIsBorrowedPower = bIsBorrowedPower;
    PollLoadStatus(AsyncLoad);
    AsyncLoads.AddItem(AsyncLoad);
    StartCheckTimer();
}
public function LoadPowerClassBlocking(string AssetPath, SFSPowerModelStruct PowerModel, int SlotIndex, bool bIsBorrowedPower, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    // Prime the DLC seek-free package by loading the source character's kit
    // archetype first. This forces the package stream so that the power class
    // (which lives in the same DLC package) can be found by LoadSeekFreeObjectBlocking.
    if (PowerModel.KitID != "")
    {
        log(Self.Name, "LoadPowerClassBlocking: Priming DLC via kit: " $ PowerModel.KitID, Outer);
        Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(PowerModel.KitID, Class'SFXPawn_PlayerMP');
        log(Self.Name, "LoadPowerClassBlocking: DLC primed for kit: " $ PowerModel.KitID, Outer);
    }
    log(Self.Name, "LoadPowerClassBlocking: " $ AssetPath, Outer);
    AsyncLoad = CreateAsyncLoad(AssetPath, 6, Callback);
    AsyncLoad.PowerModel = PowerModel;
    AsyncLoad.SlotIndex = SlotIndex;
    AsyncLoad.bIsBorrowedPower = bIsBorrowedPower;
    AsyncLoad.LoadedPowerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(AssetPath, Class'Class'));
    if (AsyncLoad.LoadedPowerClass != None)
    {
        log(Self.Name, "LoadPowerClassBlocking: Loaded " $ AsyncLoad.LoadedPowerClass, Outer);
        Callback(AsyncLoad, Outer);
    }
    else
    {
        log(Self.Name, "LoadPowerClassBlocking: Failed to load " $ AssetPath, Outer);
    }
}
private final function SFSGenericAsyncLoad CreateAsyncLoad(string AssetPath, EAsyncLoadType LoadType, delegate<SFSGenericAsyncLoad.OnAssetLoaded> Callback)
{
    local SFSGenericAsyncLoad AsyncLoad;
    
    AsyncLoad = new (Self) Class'SFSGenericAsyncLoad';
    AsyncLoad.AssetToLoad = AssetPath;
    AsyncLoad.LoadType = LoadType;
    AsyncLoad.onAssetLoadedCallback = Callback;
    AsyncLoad.retries = 0;
    AsyncLoad.isLoaded = FALSE;
    log(Self.Name, "Created SFSGenericAsyncLoad for asset: " $ AssetPath $ " with asyncLoadType: " $ LoadType, Outer);
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
    
    log(Self.Name, "CheckAsyncLoads()", Outer);
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
            AsyncLoad.onAssetLoadedCallback(AsyncLoad, Outer);
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
            AsyncLoad.LoadedWeapon = Class<SFXWeapon>(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'Class', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_WeaponMod:
            AsyncLoad.LoadedWeaponMod = Class<SFXWeaponMod>(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'Class', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_Consumable:
            AsyncLoad.LoadedConsumable = Class<SFXGameEffect_MatchConsumableBase>(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'Class', AsyncLoad.LoadStatus));
            break;
        case EAsyncLoadType.ALT_PowerClass:
            log(Self.Name, "DEBUGGING POWER ASSET NAMES: " $ AsyncLoad.AssetToLoad, Outer);
            AsyncLoad.LoadedPowerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncLoad.AssetToLoad, Class'Class', AsyncLoad.LoadStatus));
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
    bDebug = TRUE
}
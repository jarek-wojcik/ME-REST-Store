Class SFXAsyncAssetLoader
    native
    transient;

struct native SFXAsyncLoadGroupCallback 
{
    var delegate<OnAsyncGroupLoaded> Callback;
    var Name AsyncLoadGroup;
};
struct native SFXAsyncPackageRequest 
{
    var array<SFXAsyncAssetRequest> AssetRequests;
    var Name PackageName;
    var Name AsyncLoadGroup;
};
struct native SFXAsyncAssetRequest 
{
    var string FullAssetPath;
    var Class<Object> AssetClass;
    var Name AltCookedPackageName;
    var Object AssetReference;
};

var const native noexport Pointer VfTable_FTickableObject;
var array<SFXAsyncPackageRequest> m_aPackageRequests;
var array<SFXAsyncLoadGroupCallback> m_OnGroupLoadedCallbacks;
var delegate<OnAsyncGroupLoaded> __OnAsyncGroupLoaded__Delegate;

public final simulated native function AsyncLoadAssets(Name nmAsyncGroupTag, const out array<SFXAsyncAssetRequest> Assets, optional delegate<OnAsyncGroupLoaded> AsyncGroupLoaded);

public final simulated native function ClearAsyncGroup(Name nmAsyncGroupTag);

public final simulated native function bool GetAssetsForGroup(Name nmAsyncGroupTag, out array<Object> oAssets);

public final simulated native function bool IsAsyncGroupLoaded(Name nmAsyncGroupTag);

public delegate function OnAsyncGroupLoaded();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
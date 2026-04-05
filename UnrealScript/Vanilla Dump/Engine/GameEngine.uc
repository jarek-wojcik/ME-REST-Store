Class GameEngine extends Engine
    native
    transient
    config(Engine);

struct native NamedNetDriver 
{
    var const native Pointer NetDriver;
    var Name NetDriverName;
};
struct native FullyLoadedPackagesInfo 
{
    var string Tag;
    var array<Name> PackagesToLoad;
    var array<Object> LoadedObjects;
    var EFullyLoadPackageType FullyLoadType;
};
enum EFullyLoadPackageType
{
    FULLYLOAD_Map,
    FULLYLOAD_Game_PreLoadClass,
    FULLYLOAD_Game_PostLoadClass,
    FULLYLOAD_Always,
    FULLYLOAD_Mutator,
};
struct native LevelStreamingStatus 
{
    var Name PackageName;
    var bool bShouldBeLoaded;
    var bool bShouldBeVisible;
};
struct native transient URL 
{
    var init string Protocol;
    var init string Host;
    var init string Map;
    var init array<string> Op;
    var init string Portal;
    var init int Port;
    var init int Valid;
};

var URL LastURL;
var URL LastRemoteURL;
var config string PendingLevelPlayerControllerClassName;
var config array<string> ServerActors;
var string TravelURL;
var const array<Name> LevelsToLoadForPendingMapChange;
var const array<Level> LoadedLevelsForPendingMapChange;
var const string PendingMapChangeFailureDescription;
var const array<LevelStreamingStatus> PendingLevelStreamingStatusUpdates;
var const array<ObjectReferencer> ObjectReferencers;
var array<FullyLoadedPackagesInfo> PackagesToFullyLoad;
var const transient array<NamedNetDriver> NamedNetDrivers;
var PendingLevel GPendingLevel;
var OnlineSubsystem OnlineSubsystem;
var config float MaxDeltaTime;
var int m_nSkipFrames;
var const transient int NumPendingNonLatentOcclusionFrames;
var const transient bool bWorldWasLoadedThisTick;
var const bool bShouldCommitPendingMapChange;
var config bool bClearAnimSetLinkupCachesOnLoadMap;
var byte TravelType;

public final native function bool CreateNamedNetDriver(Name NetDriverName);

public final native function DestroyNamedNetDriver(Name NetDriverName);

public static native function string GetDefaultLobbyMap();

public native function string GetDisconnectFallbackMap();

public static final native function OnlineSubsystem GetOnlineSubsystem();

public native function bool ShouldUseNonLatentOcclusion();

public native function SkipFrames(int nFrames);

public native function TriggerLargeOcclusionChange();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LastURL = {
               Protocol = "", 
               Host = "", 
               Map = "", 
               Op = (), 
               Portal = "", 
               Port = 0, 
               Valid = 1
              }
    LastRemoteURL = {
                     Protocol = "", 
                     Host = "", 
                     Map = "", 
                     Op = (), 
                     Portal = "", 
                     Port = 0, 
                     Valid = 1
                    }
}
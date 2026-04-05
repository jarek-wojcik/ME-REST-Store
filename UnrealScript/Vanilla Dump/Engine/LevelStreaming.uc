Class LevelStreaming
    native
    editinlinenew
    abstract;

var(LevelStreaming) const editconst array<LevelStreamingVolume> EditorStreamingVolumes;
var array<string> Keywords;
var(LevelStreaming) const Vector Offset;
var const Vector OldOffset;
var(LevelStreaming) const editconst Name PackageName;
var transient Name OwningWorldName;
var transient Name VirtualChunkName;
var const transient Level LoadedLevel;
var transient int Priority;
var transient int Tier;
var(LevelStreaming) const Color DrawColor;
var(LevelStreaming) float MinTimeBetweenVolumeUnloadRequests;
var const transient float LastVolumeUnloadRequestTime;
var const transient bool bIsVisible;
var transient bool bHasCookingErrors;
var const transient bool bHasLoadRequestPending;
var const transient bool bHasUnloadRequestPending;
var(LevelStreaming) const bool bShouldBeVisibleInEditor;
var const bool bBoundingBoxVisible;
var(LevelStreaming) const bool bLocked;
var(LevelStreaming) const bool bIsFullyStatic;
var(LevelStreaming) const bool bNeedFullReload;
var const transient bool bShouldBeLoaded;
var const transient bool bShouldBeVisible;
var transient bool bShouldBlockOnLoad;
var(LevelStreaming) bool bDrawOnLevelStatusMap;
var const transient bool bIsRequestingUnloadAndRemoval;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Priority = 9999
    Tier = -1
    DrawColor = {B = 255, G = 255, R = 255, A = 255}
    MinTimeBetweenVolumeUnloadRequests = 2.0
    bShouldBeVisibleInEditor = TRUE
    bDrawOnLevelStatusMap = TRUE
}
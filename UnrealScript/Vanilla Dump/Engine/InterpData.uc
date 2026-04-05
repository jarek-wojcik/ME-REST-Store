Class InterpData extends SequenceVariable
    native;

struct native BioResourcePreloadItem 
{
    var transient BioBinkAsyncPreloader BinkPreloader;
    var Object pObject;
    var int nKeyIndex;
    var float fTime;
    var transient bool bPreloadFired;
};
struct native BioBinkAsyncPreloader 
{
    var Pointer Callback;
    var Pointer Context;
    var transient int PreloadMovieHandle;
    var transient EBioBinkAsyncState CurrentState;
};
enum EBioBinkAsyncState
{
    BioBinkAsync_Closed,
    BioBinkAsync_Preloading,
    BioBinkAsync_PreloadComplete,
    BioBinkAsync_Running,
};

var export array<InterpGroup> InterpGroups;
var array<BioResourcePreloadItem> m_aBioPreloadData;
var float InterpLength;
var float PathBuildTime;
var export InterpCurveEdSetup CurveEdSetup;
var float EdSectionStart;
var float EdSectionEnd;
var(InterpData) editconst int m_nBioCutSceneVersion;
var SFXSceneShopGameData m_pSFXSceneData;
var(InterpData) bool bShouldBakeAndPrune;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InterpLength = 5.0
    EdSectionStart = 1.0
    EdSectionEnd = 2.0
    m_nBioCutSceneVersion = -1
}
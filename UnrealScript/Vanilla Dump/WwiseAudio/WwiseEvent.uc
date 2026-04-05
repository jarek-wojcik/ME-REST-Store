Class WwiseEvent extends WwiseBaseSoundObject
    native;

enum WwiseEventPrepareState
{
    WwiseEvent_Unprepared,
    WwiseEvent_Preparing,
    WwiseEvent_PrepareSuccess,
    WwiseEvent_PrepareFailed,
    WwiseEvent_UnPrepareFailed,
};
struct native WwisePlatformRelationships 
{
    var(WwisePlatformRelationships) const editconst WwiseRelationships Relationships;
    var(WwisePlatformRelationships) const editconst int Platform;
};
struct native WwiseRelationships 
{
    var(WwiseRelationships) const editconst native array<WwiseStream> Streams;
    var(WwiseRelationships) WwiseBank Bank;
};
struct native WwiseEventInstance extends WwiseEventPair 
{
    var(WwiseEventInstance) int WwisePlayingID;
};
struct native WwiseEventPair 
{
    var(WwiseEventPair) WwiseEvent Play;
    var(WwiseEventPair) WwiseEvent Stop;
};

var(WwiseEvent) WwiseRelationships Relationships;
var(WwiseEvent) const editconst string Notes;
var(WwiseEvent) const editconst int Id;
var(WwiseEvent) const editconst float DurationMilliseconds;
var(WwiseEvent) const editconst transient int PrepareState;
var transient float m_fMaxAudible3DSoundDistance;
var transient int m_nNumberOf3DSoundsPlaying;
var transient int m_nNumberOfSoundsUseAttenuation;
var transient int m_nNumberOfSoundsWithUserDefinedPositioning;
var(WwiseEvent) const editconst bool IsLocalised;
var transient bool bIsSetup;
var(WwiseEvent) bool bUsesOrientationRTPC;
var(WwiseEvent) bool bUsesDistanceRTPC;
var transient bool m_bHasEnvironmentalSettings;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUsesOrientationRTPC = TRUE
    bUsesDistanceRTPC = TRUE
}
Class InterpTrackDirector extends InterpTrack
    native
    collapsecategories;

struct native DirectorTrackCut 
{
    var(DirectorTrackCut) Name TargetCamGroup;
    var float Time;
    var float TransitionTime;
    var bool bSkipCameraReset;
};

var array<DirectorTrackCut> CutTrack;
var(InterpTrackDirector) bool bSimulateCameraCutsOnClients;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bSimulateCameraCutsOnClients = TRUE
    TrackInstClass = Class'InterpTrackInstDirector'
    TrackTitle = "Director"
    bOnePerGroup = TRUE
    bDirGroupOnly = TRUE
}
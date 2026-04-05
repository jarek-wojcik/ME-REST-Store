Class InterpTrackFade extends InterpTrackFloatBase
    native
    collapsecategories;

var(InterpTrackFade) bool bPersistFade;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstFade'
    TrackTitle = "Fade"
    bOnePerGroup = TRUE
    bDirGroupOnly = TRUE
}
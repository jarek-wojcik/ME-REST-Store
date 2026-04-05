Class BioScalarParameterTrack extends InterpTrackFloatBase
    native
    collapsecategories;

var(BioScalarParameterTrack) Name PropertyName;
var float InterpValue;
var Object m_pParentEffect;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'BioScalarParameterInstTrack'
    TrackTitle = "Scalar Parameter"
}
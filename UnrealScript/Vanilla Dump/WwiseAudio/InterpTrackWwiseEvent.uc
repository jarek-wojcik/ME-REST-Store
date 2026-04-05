Class InterpTrackWwiseEvent extends InterpTrack
    native
    collapsecategories;

struct native WwiseEventTrackKey 
{
    var float Time;
    var(WwiseEventTrackKey) WwiseEvent Event;
};

var array<WwiseEventTrackKey> WwiseEvents;
var transient bool m_bRequiresPreload;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bRequiresPreload = TRUE
    TrackInstClass = Class'InterpTrackInstWwiseEvent'
    TrackTitle = "Wwise Event"
}
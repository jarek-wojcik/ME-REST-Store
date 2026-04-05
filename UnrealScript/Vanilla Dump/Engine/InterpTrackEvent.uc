Class InterpTrackEvent extends InterpTrack
    native
    collapsecategories;

struct native EventTrackKey 
{
    var(EventTrackKey) Name EventName;
    var float Time;
};

var array<EventTrackKey> EventTrack;
var(InterpTrackEvent) bool bFireEventsWhenForwards;
var(InterpTrackEvent) bool bFireEventsWhenBackwards;
var(InterpTrackEvent) bool bFireEventsWhenJumpingForwards;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFireEventsWhenForwards = TRUE
    bFireEventsWhenBackwards = TRUE
    TrackInstClass = Class'InterpTrackInstEvent'
    TrackTitle = "Event"
}
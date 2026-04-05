Class InterpTrackVisibility extends InterpTrack
    native
    collapsecategories;

struct native VisibilityTrackKey 
{
    var float Time;
    var(VisibilityTrackKey) EVisibilityTrackAction Action;
    var EVisibilityTrackCondition ActiveCondition;
};
enum EVisibilityTrackCondition
{
    EVTC_Always,
    EVTC_GoreEnabled,
    EVTC_GoreDisabled,
};
enum EVisibilityTrackAction
{
    EVTA_Hide,
    EVTA_Show,
    EVTA_Toggle,
};

var array<VisibilityTrackKey> VisibilityTrack;
var(InterpTrackVisibility) bool bFireEventsWhenForwards;
var(InterpTrackVisibility) bool bFireEventsWhenBackwards;
var(InterpTrackVisibility) bool bFireEventsWhenJumpingForwards;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFireEventsWhenForwards = TRUE
    bFireEventsWhenBackwards = TRUE
    bFireEventsWhenJumpingForwards = TRUE
    TrackInstClass = Class'InterpTrackInstVisibility'
    TrackTitle = "Visibility"
}
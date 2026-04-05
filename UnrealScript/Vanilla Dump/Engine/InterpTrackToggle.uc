Class InterpTrackToggle extends InterpTrack
    native
    collapsecategories;

struct native ToggleTrackKey 
{
    var float Time;
    var(ToggleTrackKey) ETrackToggleAction ToggleAction;
};
enum ETrackToggleAction
{
    ETTA_Off,
    ETTA_On,
    ETTA_Toggle,
    ETTA_Trigger,
};

var array<ToggleTrackKey> ToggleTrack;
var(InterpTrackToggle) bool bActivateSystemEachUpdate;
var(InterpTrackToggle) bool bFireEventsWhenForwards;
var(InterpTrackToggle) bool bFireEventsWhenBackwards;
var(InterpTrackToggle) bool bFireEventsWhenJumpingForwards;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFireEventsWhenForwards = TRUE
    bFireEventsWhenBackwards = TRUE
    bFireEventsWhenJumpingForwards = TRUE
    TrackInstClass = Class'InterpTrackInstToggle'
    TrackTitle = "Toggle"
}
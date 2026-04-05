Class InterpTrackAnimControl extends InterpTrackFloatBase
    native
    collapsecategories;

struct native AnimControlTrackKey 
{
    var Name AnimSeqName;
    var float StartTime;
    var float AnimStartOffset;
    var float AnimEndOffset;
    var float AnimPlayRate;
    var bool bLooping;
    var bool bReverse;
};

var array<AnimControlTrackKey> AnimSeqs;
var(InterpTrackAnimControl) Name SlotName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstAnimControl'
    TrackTitle = "Anim"
    bIsAnimControlTrack = TRUE
}
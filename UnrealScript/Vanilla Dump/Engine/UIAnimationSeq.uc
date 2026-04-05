Class UIAnimationSeq extends UIAnimation
    native;

var array<UIAnimTrack> Tracks;
var Name SeqName;
var EUIAnimationLoopMode LoopMode;

public final native function bool GetFrameLength(int TrackIndex, int FrameIndex, out float out_FrameLength);

public final native function float GetSequenceLength();

public final native function bool GetTrackLength(int TrackIndex, out float out_TrackLength);

public final native function bool IsValidFrameIndex(int TrackIndex, int FrameIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
Class SoundCue extends WwiseBaseSoundObject
    native
    transient;

struct native export SoundNodeEditorData 
{
    var const native int NodePosX;
    var const native int NodePosY;
};

var(SoundCue) string FaceFXGroupName;
var(SoundCue) string FaceFXAnimName;
var const native Object EditorData;
var(SoundCue) editconst Name SoundClass;
var SoundNode FirstNode;
var transient float MaxAudibleDistance;
var(SoundCue) float VolumeMultiplier;
var(SoundCue) float PitchMultiplier;
var float Duration;
var(SoundCue) FaceFXAnimSet FaceFXAnimSetRef;
var(SoundCue) int MaxConcurrentPlayCount;
var const transient duplicatetransient int CurrentPlayCount;

public native function float GetCueDuration();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VolumeMultiplier = 0.75
    PitchMultiplier = 1.0
    MaxConcurrentPlayCount = 16
}
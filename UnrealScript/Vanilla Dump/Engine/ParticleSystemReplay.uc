Class ParticleSystemReplay
    native;

struct native ParticleSystemReplayFrame 
{
    var const native array<ParticleEmitterReplayFrame> Emitters;
};
struct native ParticleEmitterReplayFrame 
{
    var const native Pointer FrameState;
    var const native int EmitterType;
    var const native int OriginalEmitterIndex;
};

var const native array<ParticleSystemReplayFrame> Frames;
var(ParticleSystemReplay) native int ClipIDNumber;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}
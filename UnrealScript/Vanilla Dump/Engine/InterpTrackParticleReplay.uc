Class InterpTrackParticleReplay extends InterpTrack
    native
    collapsecategories;

struct native ParticleReplayTrackKey 
{
    var float Time;
    var(ParticleReplayTrackKey) float Duration;
    var(ParticleReplayTrackKey) int ClipIDNumber;
};

var array<ParticleReplayTrackKey> TrackKeys;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstParticleReplay'
    TrackTitle = "Particle Replay"
}
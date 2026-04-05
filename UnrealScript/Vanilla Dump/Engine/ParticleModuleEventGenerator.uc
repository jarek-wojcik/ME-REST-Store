Class ParticleModuleEventGenerator extends ParticleModuleEventBase
    native
    editinlinenew;

struct native ParticleEvent_GenerateInfo 
{
    var(ParticleEvent_GenerateInfo) array<ParticleModuleEventSendToGame> ParticleModuleEventsToSendToGame;
    var(ParticleEvent_GenerateInfo) Name CustomName;
    var(ParticleEvent_GenerateInfo) int Frequency;
    var(ParticleEvent_GenerateInfo) int LowFreq;
    var(ParticleEvent_GenerateInfo) int ParticleFrequency;
    var(ParticleEvent_GenerateInfo) bool FirstTimeOnly;
    var(ParticleEvent_GenerateInfo) bool LastTimeOnly;
    var(ParticleEvent_GenerateInfo) bool UseReflectedImpactVector;
    var(ParticleEvent_GenerateInfo) EParticleEventType Type;
    
    structdefaultproperties
    {
        LowFreq = -1
    }
};

var(Events) export noclear array<ParticleEvent_GenerateInfo> Events;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
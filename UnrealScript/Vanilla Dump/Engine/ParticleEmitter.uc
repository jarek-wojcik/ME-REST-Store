Class ParticleEmitter
    native
    editinlinenew
    abstract;

struct native AutoGenLODParam 
{
    var int nLabel;
    var float fPercentage;
    var float fDistance;
};
enum EEmitterRenderMode
{
    ERM_Normal,
    ERM_Point,
    ERM_Cross,
    ERM_None,
};
enum EParticleSubUVInterpMethod
{
    PSUVIM_None,
    PSUVIM_Linear,
    PSUVIM_Linear_Blend,
    PSUVIM_Random,
    PSUVIM_Random_Blend,
};
struct native ParticleBurst 
{
    var(ParticleBurst) int Count;
    var(ParticleBurst) int CountLow;
    var(ParticleBurst) float Time;
    
    structdefaultproperties
    {
        CountLow = -1
    }
};
enum EParticleBurstMethod
{
    EPBM_Instant,
    EPBM_Interpolated,
};

var native array<ParticleModule> SpawnRateModules;
var export array<ParticleLODLevel> LODLevels;
var(Particle) Name EmitterName;
var transient int SubUVDataOffset;
var int PeakActiveParticles;
var(Particle) int InitialAllocationCount;
var bool ConvertedModules;
var transient bool bIsSoloing;
var bool bCookedOut;
var(Cascade) EEmitterRenderMode EmitterRenderMode;

public native function float GetMaxLifespan(float InComponentDelay);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EmitterName = 'Particle Emitter'
    ConvertedModules = TRUE
}
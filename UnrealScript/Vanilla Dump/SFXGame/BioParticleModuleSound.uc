Class BioParticleModuleSound extends BioParticleModuleBase
    native
    editinlinenew
    collapsecategories;

enum EInstanceVersion
{
    ParticleModSound_OriginalVer,
    ParticleModSound_PerParticleVer,
    ParticleModSound_MaxVer,
};

var(BioParticleModuleSound) export noclear WwiseBaseSoundObject oWwiseEvent;
var(BioParticleModuleSound) float m_DuckDistanceThreshold;
var(BioParticleModuleSound) WwiseEvent WwiseDuckEvent;
var transient float m_fLastEmitterPlayTime;
var int ObjInstanceVersion;
var(BioParticleModuleSound) bool bNoRetriggerWhileSoundPlaying;
var(BioParticleModuleSound) bool bPerParticle;
var(BioParticleModuleSound) bool m_bDuck;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_DuckDistanceThreshold = 3000.0
    WwiseDuckEvent = None
    m_fLastEmitterPlayTime = -1.0
    ObjInstanceVersion = 1
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
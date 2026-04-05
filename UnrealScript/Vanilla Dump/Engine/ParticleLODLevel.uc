Class ParticleLODLevel
    native
    editinlinenew
    collapsecategories;

var native array<ParticleModuleSpawnBase> SpawningModules;
var native array<ParticleModule> SpawnModules;
var native array<ParticleModule> UpdateModules;
var native array<ParticleModuleOrbit> OrbitModules;
var native array<ParticleModuleEventReceiverBase> EventReceiverModules;
var native array<ParticleModule> SpawnRateModules;
var export array<ParticleModule> Modules;
var transient native Object ModuleOffsetMap;
var transient native Object ModuleInstanceOffsetMap;
var const int Level;
var export ParticleModule TypeDataModule;
var export ParticleModuleSpawn SpawnModule;
var export ParticleModuleEventGenerator EventGenerator;
var int PeakActiveParticles;
var transient native int ModuleMapsInstanceSize;
var transient native int ModuleMapsParticleSize;
var transient native int ModuleMapsTypeDataOffset;
var transient native int ModuleMapsTypeDataInstanceOffset;
var export ParticleModuleRequired RequiredModule;
var bool bEnabled;
var bool ConvertedModules;
var transient native bool ModuleMapsCreated;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    ConvertedModules = TRUE
}
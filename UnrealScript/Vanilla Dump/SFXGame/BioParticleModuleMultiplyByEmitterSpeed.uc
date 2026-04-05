Class BioParticleModuleMultiplyByEmitterSpeed extends BioParticleModuleBase
    native
    editinlinenew
    collapsecategories;

enum MultiplyByEmitterSpeedProperty
{
    MESProperty_SpawnRate,
};

var(BioParticleModuleMultiplyByEmitterSpeed) const export noclear float MinUsedSpeed;
var(BioParticleModuleMultiplyByEmitterSpeed) const export noclear float MaxUsedSpeed;
var(BioParticleModuleMultiplyByEmitterSpeed) const export noclear float MultiplierAtMin;
var(BioParticleModuleMultiplyByEmitterSpeed) const export noclear float MultiplierAtMax;
var(BioParticleModuleMultiplyByEmitterSpeed) const export noclear MultiplyByEmitterSpeedProperty MultipliedProperty;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MultiplierAtMin = 1.0
    MultiplierAtMax = 1.0
    bUpdateModule = TRUE
    bSpawnRateModule = TRUE
}
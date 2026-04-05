Class ParticleModuleLocationEmitter extends ParticleModuleLocationBase
    native
    editinlinenew;

enum ELocationEmitterSelectionMethod
{
    ELESM_Random,
    ELESM_Sequential,
};

var(location) export noclear Name EmitterName;
var(location) float InheritSourceVelocityScale;
var(location) float InheritSourceRotationScale;
var(location) bool InheritSourceVelocity;
var(location) bool bInheritSourceRotation;
var(location) ELocationEmitterSelectionMethod SelectionMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    InheritSourceVelocityScale = 1.0
    InheritSourceRotationScale = 1.0
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
}
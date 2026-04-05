Class ParticleModuleLocationBase extends ParticleModule
    native
    editinlinenew
    abstract;

var(BioLocation) editinline export DistributionFloatParticleParameter m_Seed;
var(BioLocation) bool m_bUseSeed;
var(BioLocation) bool m_bUpdateSeed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Object
    m_Seed = DistributionSeed
}
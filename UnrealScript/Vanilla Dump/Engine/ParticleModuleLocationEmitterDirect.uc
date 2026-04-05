Class ParticleModuleLocationEmitterDirect extends ParticleModuleLocationBase
    native
    editinlinenew;

var(location) export noclear Name EmitterName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}
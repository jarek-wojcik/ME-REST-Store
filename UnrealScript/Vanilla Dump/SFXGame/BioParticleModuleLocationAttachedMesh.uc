Class BioParticleModuleLocationAttachedMesh extends ParticleModuleLocationBase
    native
    editinlinenew;

enum EmissionAreaSpecificationType
{
    EAST_UniformDensityPerVertex,
    EAST_UniformDensityPerBone,
    EAST_WeightedDensityPerBone,
    EAST_WeightedDensityPerEmissionArea,
    EAST_UniformDensityPerEmissionArea,
};
struct native EmissionAreaWeight 
{
    var(EmissionAreaWeight) Name AreaTag;
    var(EmissionAreaWeight) float Weight;
};

var(BioParticleModuleLocationAttachedMesh) array<EmissionAreaWeight> m_EmissionAreaWeights;
var array<Name> m_ValidEmissionSet;
var(BioParticleModuleLocationAttachedMesh) BioEmissionAreaList m_EmissionAreaList;
var const transient int BoneUpdateTickTag;
var bool m_bCheckAgainstValidEmissionSet;
var(BioParticleModuleLocationAttachedMesh) bool bUseAttachedLocalSpace;
var(BioParticleModuleLocationAttachedMesh) bool bUseRenderMeshAsSource;
var(BioParticleModuleLocationAttachedMesh) EmissionAreaSpecificationType m_SpecificationType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    BoneUpdateTickTag = 1
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
    bUpdateModule = TRUE
    bFinalUpdateModule = TRUE
}
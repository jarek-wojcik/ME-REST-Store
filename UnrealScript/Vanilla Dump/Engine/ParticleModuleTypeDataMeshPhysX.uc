Class ParticleModuleTypeDataMeshPhysX extends ParticleModuleTypeDataMesh
    native
    editinlinenew
    collapsecategories;

enum EPhysXMeshRotationMethod
{
    PMRM_Disabled,
    PMRM_Spherical,
    PMRM_Box,
    PMRM_LongBox,
    PMRM_FlatBox,
    PMRM_Velocity,
};

var native Pointer RenderInstance;
var(PhysXEmitter) PhysXEmitterVerticalLodProperties VerticalLod;
var(PhysXEmitter) PhysXParticleSystem PhysXParSys;
var(PhysXEmitter) float FluidRotationCoefficient;
var(PhysXEmitter) EPhysXMeshRotationMethod PhysXRotationMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VerticalLod = {WeightForFifo = 1.0, WeightForSpawnLod = 1.0, SpawnLodRateVsLifeBias = 1.0, RelativeFadeoutTime = 0.0}
    FluidRotationCoefficient = 5.0
    PhysXRotationMethod = EPhysXMeshRotationMethod.PMRM_Spherical
}
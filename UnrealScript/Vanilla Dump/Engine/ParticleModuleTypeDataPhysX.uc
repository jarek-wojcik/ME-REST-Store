Class ParticleModuleTypeDataPhysX extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories;

struct native PhysXEmitterVerticalLodProperties 
{
    var(PhysXEmitterVerticalLodProperties) float WeightForFifo;
    var(PhysXEmitterVerticalLodProperties) float WeightForSpawnLod;
    var(PhysXEmitterVerticalLodProperties) float SpawnLodRateVsLifeBias;
    var(PhysXEmitterVerticalLodProperties) float RelativeFadeoutTime;
    
    structdefaultproperties
    {
        WeightForFifo = 1.0
        WeightForSpawnLod = 1.0
        SpawnLodRateVsLifeBias = 1.0
    }
};

var(PhysXEmitter) PhysXEmitterVerticalLodProperties VerticalLod;
var(PhysXEmitter) PhysXParticleSystem PhysXParSys;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VerticalLod = {WeightForFifo = 1.0, WeightForSpawnLod = 1.0, SpawnLodRateVsLifeBias = 1.0, RelativeFadeoutTime = 0.0}
}
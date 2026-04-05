Class ParticleModuleTrailSpawn extends ParticleModuleTrailBase
    native
    editinlinenew;

enum ETrail2SpawnMethod
{
    PET2SM_Emitter,
    PET2SM_Velocity,
    PET2SM_Distance,
};

var(Spawn) editinline export noclear DistributionFloatParticleParameter SpawnDistanceMap;
var(Spawn) float MinSpawnVelocity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatParticleParameter Name=DistributionSpawnDistanceMap
        MinInput = 10.0
        MaxInput = 100.0
        MinOutput = 1.0
        MaxOutput = 5.0
        Constant = 1.0
    End Object
    SpawnDistanceMap = DistributionSpawnDistanceMap
}
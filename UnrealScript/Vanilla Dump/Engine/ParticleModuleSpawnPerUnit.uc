Class ParticleModuleSpawnPerUnit extends ParticleModuleSpawnBase
    native
    editinlinenew;

var(Spawn) editinline RawDistributionFloat SpawnPerUnit;
var(Spawn) float UnitScalar;
var(Spawn) float MovementTolerance;
var(Spawn) bool bIgnoreSpawnRateWhenMoving;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=RequiredDistributionSpawnPerUnit
    End Object
    SpawnPerUnit = {
                    Distribution = RequiredDistributionSpawnPerUnit, 
                    Type = 0, 
                    Op = 1, 
                    LookupTableNumElements = 1, 
                    LookupTableChunkSize = 1, 
                    LookupTable = (0.0, 0.0, 0.0, 0.0), 
                    LookupTableTimeScale = 0.0, 
                    LookupTableStartTime = 0.0
                   }
    UnitScalar = 50.0
    MovementTolerance = 0.100000001
    bSpawnModule = TRUE
}
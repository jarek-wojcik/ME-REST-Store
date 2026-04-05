Class ParticleModuleCollision extends ParticleModuleCollisionBase
    native
    editinlinenew;

var(Collision) editinline BioRawDistributionRwVector3 DampingFactorRw;
var(Collision) editinline BioRawDistributionRwVector3 DampingFactorRotationRw;
var(Collision) editinline RawDistributionFloat MaxCollisions;
var(Collision) editinline RawDistributionFloat ParticleMass;
var(Collision) editinline RawDistributionFloat DelayAmount;
var(Collision) float DirScalar;
var(Collision) float VerticalFudgeFactor;
var(Collision) bool bApplyPhysics;
var(Collision) bool bCollidePawns;
var(Collision) bool bPawnsDoNotDecrementCount;
var(Collision) bool bOnlyVerticalNormalsDecrementCount;
var(Performance) bool bDropDetail;
var(Collision) EParticleCollisionComplete CollisionCompletionOption;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionDelayAmount
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionParticleMass
        Constant = 0.100000001
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionMaxCollisions
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionDampingFactorRotation
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionDampingFactorRotationRw
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionDampingFactor
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionDampingFactorRw
    End Object
    DampingFactorRw = {
                       Distribution = DistributionDampingFactorRw, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTableMinOut = 0.0, 
                       LookupTableMaxOut = 0.0, 
                       LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}
                                     ), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    DampingFactorRotationRw = {
                               Distribution = DistributionDampingFactorRotationRw, 
                               Type = 0, 
                               Op = 1, 
                               LookupTableNumElements = 1, 
                               LookupTableChunkSize = 1, 
                               LookupTableMinOut = 1.0, 
                               LookupTableMaxOut = 1.0, 
                               LookupTable = ({X = 1.0, Y = 1.0, Z = 1.0}
                                             ), 
                               LookupTableTimeScale = 0.0, 
                               LookupTableStartTime = 0.0
                              }
    MaxCollisions = {
                     Distribution = DistributionMaxCollisions, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 1, 
                     LookupTable = (0.0, 0.0, 0.0, 0.0), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    ParticleMass = {
                    Distribution = DistributionParticleMass, 
                    Type = 0, 
                    Op = 1, 
                    LookupTableNumElements = 1, 
                    LookupTableChunkSize = 1, 
                    LookupTable = (0.100000001, 0.100000001, 0.100000001, 0.100000001), 
                    LookupTableTimeScale = 0.0, 
                    LookupTableStartTime = 0.0
                   }
    DelayAmount = {
                   Distribution = DistributionDelayAmount, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (0.0, 0.0, 0.0, 0.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    DirScalar = 3.5
    VerticalFudgeFactor = 0.100000001
    bCollidePawns = TRUE
    bPawnsDoNotDecrementCount = TRUE
    bDropDetail = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
    LODDuplicate = FALSE
}
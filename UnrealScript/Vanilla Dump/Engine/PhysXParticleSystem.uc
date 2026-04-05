Class PhysXParticleSystem
    native;

enum EPacketSizeMultiplier
{
    EPSM_4,
    EPSM_8,
    EPSM_16,
    EPSM_32,
    EPSM_64,
    EPSM_128,
};
enum ESimulationMethod
{
    ESM_SPH,
    ESM_NO_PARTICLE_INTERACTION,
    ESM_MIXED_MODE,
};

var native Pointer CascadeScene;
var native Pointer PSys;
var(Dynamics) Vector ExternalAcceleration;
var(Buffer) int MaxParticles;
var(Collision) const RBCollisionChannelContainer RBCollideWithChannels;
var(Collision) float CollisionDistance;
var(Collision) float RestitutionWithStaticShapes;
var(Collision) float RestitutionWithDynamicShapes;
var(Collision) float FrictionWithStaticShapes;
var(Collision) float FrictionWithDynamicShapes;
var(Dynamics) float MaxMotionDistance;
var(Dynamics) float Damping;
var(SdkExpert) float RestParticleDistance;
var(SdkExpert) float RestDensity;
var(SdkExpert) float KernelRadiusMultiplier;
var(SdkExpert) float Stiffness;
var(SdkExpert) float Viscosity;
var(SdkExpert) float CollisionResponseCoefficient;
var(Collision) bool bDynamicCollision;
var(Dynamics) bool bDisableGravity;
var(SdkExpert) bool bStaticCollision;
var(SdkExpert) bool bTwoWayCollision;
var transient bool bDestroy;
var transient bool bSyncFailed;
var transient bool bIsInGame;
var(Collision) const ERBCollisionChannel RBChannel;
var(SdkExpert) ESimulationMethod SimulationMethod;
var(SdkExpert) EPacketSizeMultiplier PacketSizeMultiplier;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxParticles = 32767
    RBCollideWithChannels = {
                             Default = TRUE, 
                             Nothing = FALSE, 
                             Pawn = FALSE, 
                             Vehicle = FALSE, 
                             Water = FALSE, 
                             GameplayPhysics = TRUE, 
                             EffectPhysics = FALSE, 
                             Untitled1 = FALSE, 
                             Untitled2 = FALSE, 
                             Untitled3 = FALSE, 
                             Untitled4 = FALSE, 
                             Cloth = FALSE, 
                             FluidDrain = TRUE, 
                             SoftBody = FALSE, 
                             FracturedMeshPart = FALSE, 
                             BlockingVolume = FALSE, 
                             DeadPawn = FALSE
                            }
    CollisionDistance = 10.0
    RestitutionWithStaticShapes = 0.5
    RestitutionWithDynamicShapes = 0.5
    FrictionWithStaticShapes = 0.0500000007
    FrictionWithDynamicShapes = 0.5
    MaxMotionDistance = 64.0
    RestParticleDistance = 64.0
    RestDensity = 1000.0
    KernelRadiusMultiplier = 2.0
    Stiffness = 20.0
    Viscosity = 6.0
    CollisionResponseCoefficient = 0.200000003
    bDynamicCollision = TRUE
    bStaticCollision = TRUE
    RBChannel = ERBCollisionChannel.RBCC_EffectPhysics
    SimulationMethod = ESimulationMethod.ESM_NO_PARTICLE_INTERACTION
    PacketSizeMultiplier = EPacketSizeMultiplier.EPSM_16
}
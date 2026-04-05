Class ActorFactoryRigidBody extends ActorFactoryDynamicSM
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryRigidBody) Vector InitialVelocity;
var(ActorFactoryRigidBody) editinline export DistributionVector AdditionalVelocity;
var(ActorFactoryRigidBody) editinline export DistributionVector InitialAngularVelocity;
var(ActorFactoryRigidBody) float StayUprightTorqueFactor;
var(ActorFactoryRigidBody) float StayUprightMaxTorque;
var(ActorFactoryRigidBody) bool bStartAwake;
var(ActorFactoryRigidBody) bool bDamageAppliesImpulse;
var(ActorFactoryRigidBody) bool bLocalSpaceInitialVelocity;
var(ActorFactoryRigidBody) bool bEnableStayUprightSpring;
var(ActorFactoryRigidBody) ERBCollisionChannel RBChannel;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StayUprightTorqueFactor = 1000.0
    StayUprightMaxTorque = 1500.0
    bStartAwake = TRUE
    bDamageAppliesImpulse = TRUE
    RBChannel = ERBCollisionChannel.RBCC_GameplayPhysics
    bNoEncroachCheck = TRUE
    bBlockRigidBody = TRUE
    CollisionType = ECollisionType.COLLIDE_BlockAll
    MenuName = "Add RigidBody"
    GameplayActorClass = Class'KActorSpawnable'
    NewActorClass = Class'KActor'
    MenuPriority = 15
    AlternateMenuPriority = 15
}
Class ActorFactoryPhysicsAsset extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryPhysicsAsset) Vector InitialVelocity;
var(ActorFactoryPhysicsAsset) Vector DrawScale3D;
var(ActorFactoryPhysicsAsset) PhysicsAsset PhysicsAsset;
var(ActorFactoryPhysicsAsset) SkeletalMesh SkeletalMesh;
var(ActorFactoryPhysicsAsset) bool bStartAwake;
var(ActorFactoryPhysicsAsset) bool bDamageAppliesImpulse;
var(ActorFactoryPhysicsAsset) bool bNotifyRigidBodyCollision;
var(ActorFactoryPhysicsAsset) bool bUseCompartment;
var(ActorFactoryPhysicsAsset) bool bCastDynamicShadow;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    bStartAwake = TRUE
    bDamageAppliesImpulse = TRUE
    bCastDynamicShadow = TRUE
    MenuName = "Add PhysicsAsset"
    GameplayActorClass = Class'KAssetSpawnable'
    NewActorClass = Class'KAsset'
}
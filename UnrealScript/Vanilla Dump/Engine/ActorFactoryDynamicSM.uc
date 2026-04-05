Class ActorFactoryDynamicSM extends ActorFactory
    native
    editinlinenew
    abstract
    config(Editor)
    collapsecategories;

var(ActorFactoryDynamicSM) Vector DrawScale3D;
var(ActorFactoryDynamicSM) StaticMesh StaticMesh;
var(ActorFactoryDynamicSM) bool bNoEncroachCheck;
var(ActorFactoryDynamicSM) bool bNotifyRigidBodyCollision;
var(ActorFactoryDynamicSM) bool bBlockRigidBody;
var(ActorFactoryDynamicSM) bool bUseCompartment;
var(ActorFactoryDynamicSM) bool bCastDynamicShadow;
var(ActorFactoryDynamicSM) ECollisionType CollisionType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DrawScale3D = {X = 1.0, Y = 1.0, Z = 1.0}
    bCastDynamicShadow = TRUE
    CollisionType = ECollisionType.COLLIDE_NoCollision
}
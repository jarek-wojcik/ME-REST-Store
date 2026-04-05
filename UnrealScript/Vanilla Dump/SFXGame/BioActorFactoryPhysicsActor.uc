Class BioActorFactoryPhysicsActor extends SFXActorFactoryRigidBody
    native
    editinlinenew
    config(Editor)
    collapsecategories;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDamageAppliesImpulse = FALSE
    RBChannel = ERBCollisionChannel.RBCC_Untitled3
    bCastDynamicShadow = FALSE
    MenuName = "Add BioPhysicsActor"
    GameplayActorClass = Class'BioPhysicsActor'
    NewActorClass = Class'BioPhysicsActor'
}
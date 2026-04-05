Class SFXActorFactoryPhysicsAsset extends ActorFactoryPhysicsAsset
    editinlinenew
    config(Editor)
    collapsecategories;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bNotifyRigidBodyCollision = TRUE
    MenuName = "Add SFXPhysicsAsset"
    GameplayActorClass = Class'SFXKAssetSpawnable'
    NewActorClass = Class'SFXKAsset'
}
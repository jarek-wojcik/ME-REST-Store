Class ActorFactoryDecal extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryDecal) MaterialInterface DecalMaterial;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add Decal"
    NewActorClass = Class'DecalActor'
    MenuPriority = 15
    AlternateMenuPriority = 15
}
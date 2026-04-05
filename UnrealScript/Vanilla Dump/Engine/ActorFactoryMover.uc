Class ActorFactoryMover extends ActorFactoryDynamicSM
    native
    editinlinenew
    config(Editor)
    collapsecategories;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add InterpActor"
    NewActorClass = Class'InterpActor'
    MenuPriority = 25
    AlternateMenuPriority = 25
}
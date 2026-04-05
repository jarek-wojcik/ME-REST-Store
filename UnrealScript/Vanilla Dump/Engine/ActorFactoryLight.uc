Class ActorFactoryLight extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add Light (Point)"
    NewActorClass = Class'PointLight'
    MenuPriority = 20
    AlternateMenuPriority = 20
}
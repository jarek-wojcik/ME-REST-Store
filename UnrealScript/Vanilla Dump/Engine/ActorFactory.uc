Class ActorFactory
    native
    editinlinenew
    abstract
    config(Editor)
    collapsecategories;

var string MenuName;
var Class<Actor> GameplayActorClass;
var Class<Actor> NewActorClass;
var config int MenuPriority;
var config int AlternateMenuPriority;
var bool bPlaceable;
var bool m_bNoCollisionFail;

public event simulated function PostCreateActor(Actor NewActor);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add Actor"
    NewActorClass = Class'Actor'
    MenuPriority = 10
    AlternateMenuPriority = 10
    bPlaceable = TRUE
}
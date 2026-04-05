Class ActorFactoryAI extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryAI) string PawnName;
var(ActorFactoryAI) array<Class<Inventory>> InventoryList;
var(ActorFactoryAI) Class<AIController> ControllerClass;
var(ActorFactoryAI) Class<Pawn> PawnClass;
var(ActorFactoryAI) int TeamIndex;
var(ActorFactoryAI) bool bGiveDefaultInventory;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ControllerClass = Class'AIController'
    TeamIndex = 255
    bPlaceable = FALSE
}
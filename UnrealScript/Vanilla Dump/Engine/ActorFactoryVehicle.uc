Class ActorFactoryVehicle extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var(ActorFactoryVehicle) Class<Vehicle> VehicleClass;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VehicleClass = Class'Vehicle'
    bPlaceable = FALSE
}
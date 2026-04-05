Class ActorFactoryFogVolumeConstantDensityInfo extends ActorFactory
    native
    editinlinenew
    config(Editor)
    collapsecategories;

var MaterialInterface SelectedMaterial;
var bool bNothingSelected;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MenuName = "Add FogVolumeConstantDensityInfo"
    NewActorClass = Class'FogVolumeConstantDensityInfo'
}
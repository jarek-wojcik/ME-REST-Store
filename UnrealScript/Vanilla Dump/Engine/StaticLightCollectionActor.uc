Class StaticLightCollectionActor extends Light
    native
    placeable
    config(Engine);

var const editinline export array<LightComponent> LightComponents;
var config int MaxLightComponents;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxLightComponents = 100
    Components = ()
}
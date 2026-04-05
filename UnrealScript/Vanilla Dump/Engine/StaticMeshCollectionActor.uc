Class StaticMeshCollectionActor extends StaticMeshActorBase
    native
    placeable
    config(Engine);

var const editinline export array<StaticMeshComponent> StaticMeshComponents;
var config int MaxStaticMeshComponents;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxStaticMeshComponents = 100
}
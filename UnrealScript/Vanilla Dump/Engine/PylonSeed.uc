Class PylonSeed extends Actor
    implements(Interface_NavMeshPathObject)
    native
    placeable;

var const native noexport Pointer VfTable_IInterface_NavMeshPathObject;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 50.0
        CollisionRadius = 50.0
        ReplacementPrimitive = None
    End Object
    Components = (CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
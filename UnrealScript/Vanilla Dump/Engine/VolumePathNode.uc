Class VolumePathNode extends PathNode
    native
    placeable;

var(VolumePathNode) float StartingRadius;
var(VolumePathNode) float StartingHeight;
var(VolumePathNode) bool bManualSizing;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    StartingRadius = 2000.0
    StartingHeight = 2000.0
    CylinderComponent = CollisionCylinder
    bNoAutoConnect = TRUE
    bNotBased = TRUE
    bFlyingPreferred = TRUE
    bVehicleDestination = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
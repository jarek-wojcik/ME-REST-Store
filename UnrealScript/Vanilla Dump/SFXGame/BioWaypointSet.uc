Class BioWaypointSet extends Actor
    native
    placeable
    collapsecategories;

var(BioWaypointSet) array<ActorReference> WaypointReferences;
var(BioWaypointSet) bool AlwaysShow;

public native function int FindNearestPoint(Vector vLoc);

public native function NavigationPoint GetWaypoint(int nIdx);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 50.0
        CollisionRadius = 10.0
        ReplacementPrimitive = None
    End Object
    Components = (None, None, CollisionCylinder)
    Group = 'Waypoints'
    DrawScale = 1.5
    CollisionComponent = CollisionCylinder
    bStatic = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}
Class BioPathPoint extends NavigationPoint
    native
    placeable;

var(NavigationPoint) bool bEnabled;
var(NavigationPoint) bool bAlwaysReachable;

public function bool OnCreatureReachedWayPoint(Pawn PathFindingCreature)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    bEnabled = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    Group = 'BioWaypoints'
    CollisionComponent = CollisionCylinder
}
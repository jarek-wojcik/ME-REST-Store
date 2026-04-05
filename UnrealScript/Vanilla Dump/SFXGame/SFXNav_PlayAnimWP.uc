Class SFXNav_PlayAnimWP extends SFXNav_WayPoint
    placeable;

var(Waypoint) Name AnimName;
var(Waypoint) EBodyStance eStance;

public function bool OnPawnReachedWayPoint(Pawn oPawn)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_bMaintainVelocity = FALSE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    CollisionComponent = CollisionCylinder
}
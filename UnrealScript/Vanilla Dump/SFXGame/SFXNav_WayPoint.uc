Class SFXNav_WayPoint extends NavigationPoint
    placeable;

var(Waypoint) float m_fDelay;
var(Waypoint) float m_fMoveOffset;
var(Waypoint) bool m_bPrecisionMovement;
var(Waypoint) bool m_bMaintainVelocity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_bMaintainVelocity = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    CollisionComponent = CollisionCylinder
}
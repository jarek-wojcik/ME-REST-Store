Class SFXNav_ActionStationWP extends SFXNav_WayPoint
    placeable;

public function bool OnPawnReachedWayPoint(Pawn oPawn)
{
    local Vector vDiff;
    local Rotator RDiff;
    
    vDiff = oPawn.location - location;
    RDiff = oPawn.Rotation - Rotation;
    if (Abs(vDiff.X) > float(2) || Abs(vDiff.Y) > float(2))
    {
    }
    RDiff = Normalize(RDiff);
    if (Abs(float(RDiff.Yaw)) > float(100))
    {
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_bPrecisionMovement = TRUE
    m_bMaintainVelocity = FALSE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None, None)
    CollisionComponent = CollisionCylinder
}
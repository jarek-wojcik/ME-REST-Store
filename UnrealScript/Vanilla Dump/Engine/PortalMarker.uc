Class PortalMarker extends NavigationPoint
    native;

var PortalTeleporter MyPortal;

public native function bool CanTeleport(Actor A);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bCollideWhenPlacing = FALSE
    bHiddenEd = TRUE
}
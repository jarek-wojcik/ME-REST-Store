Class MantleMarker extends NavigationPoint
    native;

var(MantleMarker) editconst CoverInfo OwningSlot;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 40.0
        CollisionRadius = 40.0
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    Components = (None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bCollideWhenPlacing = FALSE
}
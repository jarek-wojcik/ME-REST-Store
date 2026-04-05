Class SFXNav_LeapNodeBase extends SFXNav_BlockingPathNode
    native
    placeable
    abstract;

var(SFXNav_LeapNodeBase) array<NavigationPoint> LeapDest;
var(SFXNav_LeapNodeBase) Vector LandingOffset;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    LandingOffset = {X = 50.0, Y = 0.0, Z = 0.0}
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
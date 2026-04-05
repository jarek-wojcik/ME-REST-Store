Class SFXNav_JumpNode extends SFXNav_BlockingPathNode
    native
    placeable;

var(SFXNav_JumpNode) array<NavigationPoint> JumpDest;
var(SFXNav_JumpNode) Vector LandingOffset;
var(SFXNav_JumpNode) editinline export CylinderComponent TouchingCylinder;
var(SFXNav_JumpNode) float JumpDist;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Object Class=CylinderComponent Name=TouchCylinder
        CollisionHeight = 90.0
        CollisionRadius = 100.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockZeroExtent = FALSE
        CanBlockCamera = FALSE
    End Object
    LandingOffset = {X = 50.0, Y = 0.0, Z = 0.0}
    TouchingCylinder = CollisionCylinder
    JumpDist = 600.0
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None, TouchCylinder)
    CollisionComponent = CollisionCylinder
    bCollideActors = TRUE
}
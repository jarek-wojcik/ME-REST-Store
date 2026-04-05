Class SFXNav_JumpDownNode extends SFXNav_BlockingPathNode
    native
    placeable;

var(SFXNav_JumpDownNode) NavigationPoint JumpDownDest;
var(SFXNav_JumpDownNode) editinline export CylinderComponent TouchingCylinder;
var(SFXNav_JumpDownNode) float JumpDownDistX;
var(SFXNav_JumpDownNode) float JumpDownDistZ;
var(SFXNav_JumpDownNode) bool bTopNode;

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
    TouchingCylinder = CollisionCylinder
    JumpDownDistX = 300.0
    JumpDownDistZ = 180.0
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None, TouchCylinder)
    CollisionComponent = CollisionCylinder
    bCollideActors = TRUE
}
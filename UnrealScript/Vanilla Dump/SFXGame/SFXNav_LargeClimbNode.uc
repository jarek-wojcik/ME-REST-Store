Class SFXNav_LargeClimbNode extends PathNode
    native
    placeable;

var(SFXNav_LargeClimbNode) NavigationPoint ClimbDest;
var(SFXNav_LargeClimbNode) bool bTopNode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
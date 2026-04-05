Class SFXNav_LargeMantleNode extends PathNode
    native
    placeable;

var(SFXNav_LargeMantleNode) NavigationPoint MantleDest;

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
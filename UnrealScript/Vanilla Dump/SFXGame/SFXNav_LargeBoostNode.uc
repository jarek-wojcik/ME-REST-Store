Class SFXNav_LargeBoostNode extends SFXNav_BlockingPathNode
    native
    placeable;

var(SFXNav_LargeBoostNode) NavigationPoint BoostDest;
var(SFXNav_LargeBoostNode) float BoostDistX;
var(SFXNav_LargeBoostNode) float BoostDistZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    BoostDistX = 300.0
    BoostDistZ = 300.0
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
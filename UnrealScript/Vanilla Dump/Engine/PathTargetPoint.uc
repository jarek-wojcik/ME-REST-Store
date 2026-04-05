Class PathTargetPoint extends Keypoint
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 50.0
        CollisionRadius = 50.0
        ReplacementPrimitive = None
    End Object
    Components = (None, None, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
    bHidden = FALSE
    bNoDelete = TRUE
}
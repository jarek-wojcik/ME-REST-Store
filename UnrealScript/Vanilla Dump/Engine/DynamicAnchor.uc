Class DynamicAnchor extends NavigationPoint
    native;

var Controller CurrentUser;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
    bStatic = FALSE
    bNoDelete = FALSE
    bCollideWhenPlacing = FALSE
}
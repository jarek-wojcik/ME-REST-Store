Class PathNode extends NavigationPoint
    native
    placeable;

public event simulated function string GetDebugAbbrev()
{
    return "PN";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    Group = 'BaseNavigationNodes'
    CollisionComponent = CollisionCylinder
}
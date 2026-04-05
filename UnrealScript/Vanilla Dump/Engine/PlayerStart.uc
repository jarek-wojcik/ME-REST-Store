Class PlayerStart extends NavigationPoint
    native
    placeable;

var(PlayerStart) int TeamIndex;
var(PlayerStart) bool bEnabled;
var(PlayerStart) bool bPrimaryStart;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius = 40.0
        ReplacementPrimitive = None
    End Template
    bEnabled = TRUE
    bPrimaryStart = TRUE
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}
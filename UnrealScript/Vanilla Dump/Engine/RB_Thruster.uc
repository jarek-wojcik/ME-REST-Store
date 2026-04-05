Class RB_Thruster extends RigidBodyBase
    native
    placeable;

var(RB_Thruster) interp float ThrustStrength;
var(RB_Thruster) bool bThrustEnabled;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bThrustEnabled = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bThrustEnabled = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bThrustEnabled = !bThrustEnabled;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ThrustStrength = 100.0
    Components = (None, None)
    bHardAttach = TRUE
    bEdShouldSnap = TRUE
}
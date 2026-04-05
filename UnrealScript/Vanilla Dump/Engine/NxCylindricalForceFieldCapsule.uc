Class NxCylindricalForceFieldCapsule extends NxCylindricalForceField
    native
    placeable;

var(NxCylindricalForceFieldCapsule) editinline export DrawCapsuleComponent RenderComponent;

public native function DoInitRBPhys();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawCapsuleComponent Name=DrawCapsule0
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawCapsule0
    ForceHeight = 200.0
    Components = (DrawCapsule0, None)
}
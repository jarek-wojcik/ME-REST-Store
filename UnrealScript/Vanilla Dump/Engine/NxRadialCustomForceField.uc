Class NxRadialCustomForceField extends NxRadialForceField
    native
    placeable;

var const transient native Pointer Kernel;
var(NxRadialCustomForceField) interp float SelfRotationStrength;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DrawSphereComponent Name=DrawSphere0
        ReplacementPrimitive = None
    End Template
    RenderComponent = DrawSphere0
    Components = (DrawSphere0, None)
}